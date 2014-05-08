

# Data Carpentry R materials - 
--------------------------------------------------

* Its really important that you know what you did. More journals/grants/etc. are also making it important for them to know what you did.
* A lot of scientific code is NOT reproducible.
* If you keep a lab notebook, why are we not as careful with our code. 
* We edit each others manuscripts, but we don't edit each other's code. 
* If you write your code with "future you" in mind, you will save yourself and others a lot of time.

# Very basics of R

R is a versatile, open source programming/scripting language that's useful both for statistics but also data science. Inspired by the programming language S.  

* Open source software under GPL.  
* Superior (if not just comparable) to commercial alternatives. R has over 5,000 user contributed packages at this time. It's widely used both in academia and industry.  
* Available on all platforms.  
* Not just for statistics, but also general purpose programming.  
* Is object oriented and functional.  
* Large and growing community of peers.  

__Commenting__

Use # signs to comment. Comment liberally in your R scripts. Anything to the right of a # is ignored by R.  

__Assignment operator__

`<-` is the assignment operator. Assigns values on the right to objects on the left. Mostly similar to `=` but not always. Learn to use `<-` as it is good programming practice. Using `=` in place of `<-` can lead to issues down the line.

__Package management__

`install.packages("package-name")` will download a package from one of the CRAN mirrors assuming that a binary is available for your operating system. If you have not set a preferred CRAN mirror in your options(), then a menu will pop up asking you to choose a location.

Use `old.packages()` to list all your locally installed packages that are now out of date. `update.packages()` will update all packages in the known libraries interactively. This can take a while if you haven't done it recently. To update everything without any user intervention, use the `ask = FALSE` argument.

In RStudio, you can also do package management through Tools -> Install Packages.

Updating packages can sometimes make changes, so if you already have a lot of code in R, don't run this now. Otherwise let's just go ahead and update our pacakges so things are up to date.



```r
update.packages(ask = FALSE)
```


## Introduction to R and RStudio

Let's start by learning about our tool.  

_Point out the different windows in R._ 
* Console, Scripts, Environments, Plots
* Avoid using shortcuts. 
* Code and workflow is more reproducible if we can document everything that we do.
* Our end goal is not just to "do stuff" but to do it in a way that anyone can easily and exactly replicate our workflow and results.

You can get output from R simply by typing in math
	

```r
3 + 5
12/7
```


or by typing words, with the command `print`


```r
print("hello world")
```


We can annotate our code (take notes) by typing "#". Everything to the right of # is ignored by R

Try it with and without the #


```r
# Print out hello world
print("hello world")
```


"hello world"

































































