import qualified System.Environment as SE
import qualified Data.ByteString.Lazy.Char8 as LC
import qualified Data.ByteString.Char8 as BC
import qualified Data.List as DL
import qualified Data.Map as DM
import qualified Data.Vector as DV
import qualified Statistics.Sample as SS
import qualified Statistics.Quantile as SQ
import Text.Printf

main :: IO()
main = do
    input <- LC.getContents
    output (nums $ LC.lines input)

-- clean input into a list of numbers 
nums :: [LC.ByteString] -> [Double]
nums llns = floats $ map BC.unpack $ slns llns
    where 
        slns = map (BC.concat . LC.toChunks)
        floats [] = []
        floats [x] = [read x :: Double]
        floats (x:xs) = [read x :: Double] ++ floats xs

-- | calculate the frequency of items in a set
-- [ [(number, frequency), ....
freqs xs = DM.toList $ DM.fromListWith (+) [(c, 1) | c <- xs]

-- | calculate the mode of a list of numbers
mode xs = (fst . DL.head) $ DL.sortBy sortGT $ freqs xs
    where 
        sortGT (a1, b1) (a2, b2)
            | b1 < b2 = GT
            | b1 > b2 = LT
            | b1 == b2 = compare b1 b2

-- | calculate a quantile point
qtile q t xs = (SQ.continuousBy SQ.medianUnbiased q t) $ DV.fromList xs

-- | calculate the midhinge
midhinge xs = (qtile 1 4 xs + qtile 3 4 xs) / 2

-- | calculate the trimean
trimean xs = (qtile 2 4 xs + midhinge xs) / 2

h :: (Floating a, Ord t) => [t] -> a 
-- | calculate Shannon Entropy
h xs = negate . sum . map (\(i,j) -> (p j xs) * (logBase 2 $ p j xs)) $ freqs xs
    where
        p n lst = (/) n tot_len
	tot_len = (fromIntegral $ length xs)

-- | string formatter: round to 4 decimal places
format f n = printf "%.4f" (f $ DV.fromList n)

-- | display output formatting
display xs = sequence_ [putStrLn (a++" : "++b) | (a,b) <- xs]

output :: [Double] -> IO ()
output xs = display table
    where table = [("Length", show $ length xs)
                  ,("Min", show $ minimum xs)
                  ,("Max", show $ maximum xs)
                  ,("Range", printf "%.4f" $ maximum xs - minimum xs)
                  ,("Q1", format (SQ.continuousBy SQ.medianUnbiased 1 4) xs)
                  ,("Q2", format (SQ.continuousBy SQ.medianUnbiased 2 4) xs)
                  ,("Q3", format (SQ.continuousBy SQ.medianUnbiased 3 4) xs)
                  ,("IQR", format (SQ.midspread SQ.medianUnbiased 4) xs)
                  ,("Trimean", printf "%.4f" $ trimean xs)
                  ,("Midhinge", printf "%.4f" $ midhinge xs)
                  ,("Mean", format SS.mean xs)
                  ,("Mode", show $ mode xs)
                  ,("Kurtosis", format SS.kurtosis xs)
                  ,("Skewness", format SS.skewness xs)
                  ,("Entropy", printf "%.4f" ((h xs) :: Float))]


