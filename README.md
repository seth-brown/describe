`describe`: an exploratory data analysis tool
=============================================

### Description:

`describe` is a simple command line utility written in Haskell for calculating common descriptive statistics on numerical data.

### Installation:

To install `describe`, follow these steps:

1. Download the haskell platform.  

	* On a Mac:  
	`$ brew install haskell-platform`

	* On Linux (Ubuntu):  
    `$ sudo apt-get install haskell-platform`

2. After successful installation, run the following commands to install the approporiate dependencies:  

	`$ cabal update`  
	`$ cabal install cabal-install`  
	`$ cabal install statistics`  

3. Next, compile `describe`:  

	`$ ghc -O2 describe.hs`

4. Place describe in your path:  

	`$ mv describe ~/bin/

5. Test that describe is working:

	`$ echo "1\n2\n3\n4" | ./describe`

### Usage:

`describe` accepts numerical data in column form, i.e. delimited by newline characters. 

As an example, consider the following data file with two columns of comma seperated values:

```
1e-10,3
1e-10,6
2.2345,2
3.4569,1
1e3,5
```

To analyze the first column of data:

`$ cut -f1 -d"," | describe | column -t`

This will print the following summary to the screen:

```
Length    :  5
Min       :  1.0e-10
Max       :  1000.0
Range     :  1000.0000
Q1        :  0.0000
Q2        :  2.2345
Q3        :  335.6379
IQR       :  335.6379
Trimean   :  85.0267
Midhinge  :  167.8190
Mean      :  201.1383
Mode      :  1.0e-10
Kurtosis  :  0.2499
Skewness  :  1.5000
Entropy   :  1.9219
```

Further information on how to work with rows and multiple columns can be found [in this blog post][1]:

[1]: http://www.drbunsen.org/explorations-in-unix/#describe
