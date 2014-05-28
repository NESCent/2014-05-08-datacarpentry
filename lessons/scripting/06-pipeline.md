---
layout: lesson
root: ../..
title: Data pipelining
---

#### Objectives
*   Automate data processing and analysis steps in the form of scripts.
*   Make data processing and analysis steps easily repeatable.
*   Create shell scripts that implement an executable and modifyable pipeline.

The Unix command shell is not the only command interpreter for which
sequences, loops, etc of commands can be scripted, and thereby made
executable as a unit. Unlike tools restricted to point-click-and-edit
user-interfaces, such as Excel, SQL databases can be scripted, too. So
can be nearly all environments for data processing, analysis, and
visualization that have a command prompt, such as R, from which they
receive instructions for which operations to execute.

More specifically, most tools that can be invoked on the command line
and that then read commands from the terminal can be scripted, simply
by using the shell to pipe commands to the tool (using something
similar to `cat file-with-commands | tool` or `echo "a command" |
tool`). For the tool, reading commands from the terminal prompt or
reading commands from a pipe is the same - namely reading from
"`standard input`". Some tools have additional commandline options to
adjust their behavior if commands get piped to them rather than typed
at the terminal. For example, there might be an option to suppress
certain greetings that a tool might print for a user on the
terminal. Or there might be an option to ensure that the tool
terminates once it reads the last command. But the principle is the
same.

We'll demonstrate here how this can be exploited for creating
automated, repeatable data pipelines. Our goal is to create a pipeline
script that is fully automated, from combining data, data subsetting,
all the way to data analysis and visualization. Once we have this, we
have a codified version of the sequence of steps from start to finish
that can be re-executed at any time, by anyone, and for which it is
easy to modify parts of it, whether subsetting, analysis parameters,
or the visualization. 

We'll demonstrate this by putting the final results of the SQL section
together with the final results of the R section.

We'll begin with the R part. Rather than typing in or copy&pasting the
commands we used for the data analysis and plotting steps we learned
during the section on data analysis in R, we want to execute a command
that does the whole sequence.

R has a command line interface (which RStudio packages into a nice
user-interface), and can be asked to read R commands from a file
instead of the terminal. We can test this with the most minimal R
script possible, an empty file:

~~~
$ touch test.R
$ cat test.R | R
Fatal error: you must specify '--save', '--no-save' or '--vanilla'
~~~

Why the error? When R exits, it needs to know whether or not to save
the history and current R environment into files that would be picked
up by the next invocation of R. We need to choose one or the other, or
specify with `--vanilla` that no such prior history and environment is
to be loaded at the beginning nor saved at the end. 

~~~
$ touch test.R
$ cat test.R | R --vanilla

R version 3.1.0 (2014-04-10) -- "Spring Dance"
Copyright (C) 2014 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin10.8.0 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
$
~~~

As we can see, R prints its whole initial greeting, then the command
prompt, reads the file for reading the command (which is empty), and
then terminates. It'd be better if the greeting and command prompt
didn't get printed to the terminal, because we already we won't be
typing anything at the prompt. In other words, we'd like R to be a
little "smarter" about reading commands from a file. For this, R has a
`BATCH` command mode:

~~~
$ R CMD BATCH test.R
~~~

There is no output to the terminal from this. However, R still
captures the whole terminal output, in a file with the same basename
as the script, but with extension `.Rout`:

~~~
$ R CMD BATCH test.R
$ cat test.Rout

R version 3.1.0 (2014-04-10) -- "Spring Dance"
Copyright (C) 2014 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin10.8.0 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
> proc.time()
   user  system elapsed 
  0.195   0.027   0.210 
$
~~~



#### Key Points
*   

#### Challenges

