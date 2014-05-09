---
layout: lesson
root: ../..
title: Loops
---

#### Objectives

*   Write a loop that applies one or more commands separately to each file in a set of files.
*   Trace the values taken on by a loop variable during execution of the loop.
*   Explain the difference between a variable's name and its value.
*   Explain why spaces and some punctuation characters shouldn't be used in files' names.
*   Demonstrate how to see what commands have recently been executed.
*   Re-run recently executed commands without retyping them.

As we've seen, wildcards and tab completion are two ways to reduce
typing (and mistakes from mistyping).  Shell history is a way to
re-execute commands executed previously, verbatim or in slight
variations. 

Another is to tell the shell to do something over and over again, such
as applying the same basic command to different files, or with
different parameters. This will involve loops, variables, and variable
substitution.

Suppose our collaborators have shared with us the latest trap survey
data with extension .xls and timestamp encoded in the filename. We
want to have file extensions actually mirror the filetype.

The key to building loops (and scripts) is to do it incrementally. The
first step is to contruct the inner block of the loop for one file (or
parameter, such that the file (or parameter) can change from one
execution of the loop to the next, without requiring hand-editing the
command.

Let's start. This is what we learned already:

~~~
$ mv plots-201405.xls plots-201405.csv
~~~

In this form, the filenames can't change without manual
intervention. Let's find a command that creates the target filename
from the source filename; once we have that, we don't have to manually
specify the target anymore.  Here, the target extension part is constant
(.csv), and the source name without extension doesn't change. Let's
extract the part without extension:

~~~
$ echo plots-201405.xls | cut -d . -f 1
~~~

We can use backquotes to capture the output from a command, and
exploit the shell's feature of stringing unseparated strings together:

~~~
$ echo `echo plots-201405.xls | cut -d . -f 1`".csv"
~~~

Now if we can make the name of the source file a variable that can
take on different values, we have the inner block of the
loop. Variables in bash are assigned values with the `=` symbol:

~~~
$ f=plots-201405.xls
~~~

The shell substitutes the value of a variable if the variable is
prefixed with `$`:

~~~
$ echo $f
$ echo `echo plots-201405.xls | cut -d . -f 1`".csv"
~~~

One of the most frequently used loops in bash is `for`. It loops over
a specified list of values:

~~~
$ for f in *.xls 
$  do
$   echo "mv $f "`echo $f | cut -d . -f 1`".csv"
$  done
~~~

> #### Measure Twice, Run Once
> 
> A loop is a way to do many things at once&mdash;or to make many mistakes at
> once if it does the wrong thing. One way to check what a loop *would* do
> is to echo the commands it would run instead of actually running them.

> #### Follow the Prompt
>
> The shell prompt changes from `$` to `>` and back again as we were
> typing in our loop. The second prompt, `>`, is different to remind
> us that we haven't finished typing a complete command yet.

Once we have convinced ourselves that the generated commands look correct,
we can execute them:

~~~
$ for f in *.xls 
$  do
$   mv $f `echo $f | cut -d . -f 1`".csv"
$  done
~~~

Exercise: remove the timestamp from the filename as well.

> #### Spaces in Names
> 
> Filename expansion in loops is another reason you should not use spaces in filenames.
> Suppose our data files are named:
> 
> ~~~
> plots 201405.xls
> surveys 201405.xls
> species 201405.xls
> ~~~
> 
> If we try to process them using:
> 
> ~~~
> for f in *.xls
> do
>     ls -l $f
> done
> ~~~
> 
> then with older versions of Bash, or most other shells,
> `f` will then be assigned the following values in turn:
> 
> ~~~
> plots
> 201405.xls
> surveys
> 201405.xls
> species
> 201405.xls
> ~~~
>
> That's a problem because there are no files named this way, and now
> the same "file" appears multiple times.

Group exercise: A slightly more complicated example. Let's say occasionally our
survey data are updated, and we'd like to be able to automatically generate
a quick data report so we can see important changes. Let's say we want for
each species how many rows there are with and without weight data.

#### Key Points
*   A `for` loop repeats commands once for every thing in a list.
*   Every `for` loop needs a variable to refer to the current "thing".
*   Use `$name` to expand a variable (i.e., get its value).
*   Do not use spaces, quotes, or wildcard characters such as '*' or '?' in
    filenames, as it complicates variable expansion.
*   Give files consistent names that are easy to match with wildcard patterns to
    make it easy to select them for looping.
*   Use the up-arrow key to scroll up through previous commands to edit and
    repeat them.

#### Challenges

1.  Suppose that `ls` initially displays:

    ~~~
    fructose.dat    glucose.dat   sucrose.dat
    ~~~

    What is the output of:

    ~~~
    for datafile in *.dat
    do
        ls *.dat
    done
    ~~~

2.  In the same directory, what is the effect of this loop?

    ~~~
    for sugar in *.dat
    do
        echo $sugar
        cat $sugar > xylose.dat
    done
    ~~~

    1.  Prints `fructose.dat`, `glucose.dat`, and `sucrose.dat`, and
        copies `sucrose.dat` to create `xylose.dat`.
    2.  Prints `fructose.dat`, `glucose.dat`, and `sucrose.dat`, and
        concatenates all three files to create `xylose.dat`.
    3.  Prints `fructose.dat`, `glucose.dat`, `sucrose.dat`, and
        `xylose.dat`, and copies `sucrose.dat` to create `xylose.dat`.
    4.  None of the above.

3.  The `expr` does simple arithmetic using command-line parameters:

    ~~~
    $ expr 3 + 5
    8
    $ expr 30 / 5 - 2
    4
    ~~~

    Given this, what is the output of:

    ~~~
    for left in 2 3
    do
        for right in $left
        do
            expr $left + $right
        done
    done
    ~~~

4.  Describe in words what the following loop does.

    ~~~
    for how in frog11 prcb redig
    do
        $how -limit 0.01 NENE01729B.txt
    done
    ~~~
