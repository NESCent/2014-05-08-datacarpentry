---
layout: lesson
root: ../..
title: Shell Scripts
---

#### Objectives
*   Write a shell script that runs a command or series of commands for a fixed set of files.
*   Run a shell script from the command line.
*   Write a shell script that operates on a set of files defined by the user on the command line.
*   Create pipelines that include user-written shell scripts.

We are finally ready to see what makes the shell such a powerful
environment for data wrangling. It allows us to take the commands we
repeat frequently and save them in files so that we can re-run all
those operations again later by typing a single command.

For historical reasons, a bunch of commands saved in a file is usually
called a [shell script](../../gloss.html#shell-script), but make no
mistake: these are actually small programs.

To learn how shell scripts are built and how they work, let's build a
shell script that takes as input a list of file names on the command
line, and assuming that each file is in comma-delimited value (CSV)
format, counts the number of columns and prints them to the terminal.

Generally speaking, the best way to build a shell script is
incrementally, one command at a time, and by figuring out how to
accomplish the desired task on a single given file first. This can
typically be done on the command line interactively.

So let's see how can count the number of columns in the file
`surveys.csv`. First, intuitively the line with the column names also
contains the information about the number of columns:

~~~
$ head -n 1 surveys.csv
~~~

If we could count the number of commas in this line, we'd (almost) have the number of columns. The tool `wc` can count characters:

~~~
$ echo ",,," | wc -c
~~~ 

> Question: Why does this show one more than the number of commas?

If we could delete everything but the commas, we would have the desired input to `wc -c`. The tool `tr` (translate characters in one set to those in another) has a mode to accomplish this: with the `-d` switch it doesn't translate, but deletes the characters in the specified set from the input. We want to delete everything but commas. Instead of enumerating all characters that aren't comma, `tr` with the `-c` option allows us to say _"delete the complement of this set"_. Then our set of which to take the complement is the comma:

~~~
$ echo "12345abcde," | tr -c -d ,
~~~

> Question: Why is the result of enumerating all characters other than
> the comma slightly different from taking the complement of a comma?
>
> ~~~
> # taking the complement of comma:
> $ echo "12345abcde," | tr -c -d ,
> # expressly enumerate all characters to be deleted
> $ echo "12345abcde," | tr -d 12345abcde
> ~~~

Now we can put the command together:

~~~
$ head -n 1 surveys.csv | tr -c -d , | wc -c
~~~

To get the actual number of columns, we only need to add 1. This can
be accomplished using the `expr` command (which is built into bash):

~~~
$ expr `head -n 1 surveys.csv | tr -c -d , | wc -c` + 1
~~~

Now that we have the command working for one file, we can put it into
a shell script. A shell script is essentially a text file of shell
commands. Let's create open a new file in a text editor, put this one
line into it, and save it as `numcols.sh`. 

> #### Text vs. Whatever
>
> We usually call programs like Microsoft Word or LibreOffice Writer "text
> editors", but we need to be a bit more careful when it comes to
> programming. By default, Microsoft Word uses `.docx` files to store not
> only text, but also formatting information about fonts, headings, and so
> on. This extra information isn't stored as characters, and doesn't mean
> anything to tools like `head`: they expect input files to contain
> nothing but the letters, digits, and punctuation on a standard computer
> keyboard. When editing programs, therefore, you must either use a plain
> text editor, or be careful to save files as plain text.

We can now run this file as a shell script by passing it as an
argument to `bash`, our shell:

~~~
$ bash numcols.sh
~~~

Sure enough, our script's output is exactly what we would get if we ran
that pipeline directly.

> ### Execution permission and search path
>
> 'Normal' commandline programs (like `wc`, `ls`, etc) aren't executed
>  by being passed to as an argument to the shell. Shouldn't this work
>  for shell scripts, too, if they are programs like any other?
>  The answer is it does, but some prerequisites have to be met (that
>  for pre-installed programs we never have to worry about):
>
> 1. The shell needs to be able to find a program it is asked to
>    execute. This is achieved by either putting the program into one
>    of the directories listed in the `PATH` environment variable (or
>    adding the directory in which the program is to the `PATH`), or
>    by giving the full path to the program (even if it is in the
>    current directory).
>         ~~~
>         $ ./numcols.sh
>         ~~~
>
> 2. The program needs to be permitted to be executed by the
>    user. Compare the following two:
>
>         ~~~
>         $ ls -l /bin/ls
>         $ ls -l numcols.sh
>         ~~~ 
>
>    The permissions of a file are changed with `chmod`:
>
>         ~~~
>         $ chmod ugo+x numcols.sh
>         ~~~
>
> 3. The shell needs to know how to execute a program that is a
>    script, i.e., it needs to know which interpreter to invoke for
>    the script. The shell obtains this from the "hashbang" line,
>    which must be the first non-comment, non-empty line in the
>    script. The line starts with `#!` (hence the name) followed
>    (without space) by the path to the program to invoke as
>    interpreter, here `/bin/bash`: `#!/bin/bash`. We can add this
>    line to the top of the file using a text editor.

What if we want to count columns in an arbitrary file? We could edit
`numcols.sh` each time to change the filename, but that would probably
take longer than just retyping the command. Instead, let's edit
`numcol.sh` and replace `surveys.csv` with a special variable
called `$1`:

~~~
expr `head -n 1 $1 | tr -c -d , | wc -c` + 1
~~~

Inside a shell script, `$1` means "the first parameter on the command
line".  We can now run our script like this:

~~~
$ bash numcols.sh surveys.csv
$ bash numcols.sh plots.csv
$ bash numcols.sh species.csv
~~~

This is already much better - we don't have to edit the script
anymore. What if the script could take any number of files as
parameters, and execute the column counting pipeline for each of them?
This is concept of looping, one of the concepts that make scripts
truly powerful.

> ### Commenting scripts
> It may take the next person who reads `numcols.sh` a moment to
> figure out what it does.  We can improve our script by adding some
> [comments](../../gloss.html#comment) at the top. A comment starts
> with a `#` character and runs to the end of the line.  The computer
> ignores comments, but they're invaluable for helping people
> understand and use scripts.

What if we want to process many files in a single pipeline?
For example, if we want to sort our `.pdb` files by length, we would type:

~~~
$ wc -l *.pdb | sort -n
~~~
{:class="in"}

because `wc -l` lists the number of lines in the files
and `sort -n` sorts things numerically.
We could put this in a file,
but then it would only ever sort a list of `.pdb` files in the current directory.
If we want to be able to get a sorted list of other kinds of files,
we need a way to get all those names into the script.
We can't use `$1`, `$2`, and so on
because we don't know how many files there are.
Instead, we use the special variable `$*`,
which means,
"All of the command-line parameters to the shell script."
Here's an example:

~~~
$ cat sorted.sh
~~~
{:class="in"}
~~~
wc -l $* | sort -n
~~~
{:class="out"}
~~~
$ bash sorted.sh *.dat backup/*.dat
~~~
{:class="in"}
~~~
      29 chloratin.dat
      89 backup/chloratin.dat
      91 sphagnoi.dat
     156 sphag2.dat
     172 backup/sphag-merged.dat
     182 girmanis.dat
~~~
{:class="out"}

> #### Why Isn't It Doing Anything?
>
> What happens if a script is supposed to process a bunch of files, but we
> don't give it any filenames? For example, what if we type:
>
>     $ bash sorted.sh
>
> but don't say `*.dat` (or anything else)? In this case, `$*` expands to
> nothing at all, so the pipeline inside the script is effectively:
>
>     wc -l | sort -n
>
> Since it doesn't have any filenames, `wc` assumes it is supposed to
> process standard input, so it just sits there and waits for us to give
> it some data interactively. From the outside, though, all we see is it
> sitting there: the script doesn't appear to do anything.

We have two more things to do before we're finished with our simple shell scripts.
If you look at a script like:

<div class="file" markdown="1">
~~~
wc -l $* | sort -n
~~~
</div>

you can probably puzzle out what it does.
On the other hand,
if you look at this script:

<div class="file" markdown="1">
~~~
# List files sorted by number of lines.
wc -l $* | sort -n
~~~
</div>

you don't have to puzzle it out&mdash;the comment at the top tells you what it does.
A line or two of documentation like this make it much easier for other people
(including your future self)
to re-use your work.
The only caveat is that each time you modify the script,
you should check that the comment is still accurate:
an explanation that sends the reader in the wrong direction is worse than none at all.

In practice, most people develop shell scripts by running commands at the shell prompt a few times
to make sure they're doing the right thing,
then saving them in a file for re-use.
This style of work allows people to recycle
what they discover about their data and their workflow with one call to `history`
and a bit of editing to clean up the output
and save it as a shell script.

#### Nelle's Pipeline: Creating a Script

An off-hand comment from her supervisor has made Nelle realize that
she should have provided a couple of extra parameters to `goostats` when she processed her files.
This might have been a disaster if she had done all the analysis by hand,
but thanks to for loops,
it will only take a couple of hours to re-do.

But experience has taught her that if something needs to be done twice,
it will probably need to be done a third or fourth time as well.
She runs the editor and writes the following:

<div class="file" markdown="1">
~~~
# Calculate reduced stats for data files at J = 100 c/bp.
for datafile in $*
do
    echo $datafile
    goostats -J 100 -r $datafile stats-$datafile
done
~~~
</div>

(The parameters `-J 100` and `-r` are the ones her supervisor said she should have used.)
She saves this in a file called `do-stats.sh`
so that she can now re-do the first stage of her analysis by typing:

~~~
$ bash do-stats.sh *[AB].txt
~~~
{:class="in"}

She can also do this:

~~~
$ bash do-stats.sh *[AB].txt | wc -l
~~~
{:class="in"}

so that the output is just the number of files processed
rather than the names of the files that were processed.

One thing to note about Nelle's script is that
it lets the person running it decide what files to process.
She could have written it as:

<div class="file" markdown="1">
~~~
# Calculate reduced stats for  A and Site B data files at J = 100 c/bp.
for datafile in *[AB].txt
do
    echo $datafile
    goostats -J 100 -r $datafile stats-$datafile
done
~~~
</div>

The advantage is that this always selects the right files:
she doesn't have to remember to exclude the 'Z' files.
The disadvantage is that it *always* selects just those files&mdash;she can't run it on all files
(including the 'Z' files),
or on the 'G' or 'H' files her colleagues in Antarctica are producing,
without editing the script.
If she wanted to be more adventurous,
she could modify her script to check for command-line parameters,
and use `*[AB].txt` if none were provided.
Of course, this introduces another tradeoff between flexibility and complexity.

<div class="keypoints" markdown="1">

#### Key Points
*   Save commands in files (usually called shell scripts) for re-use.
*   `bash filename` runs the commands saved in a file.
*   `$*` refers to all of a shell script's command-line parameters.
*   `$1`, `$2`, etc., refer to specified command-line parameters.
*   Letting users decide what files to process is more flexible and more
    consistent with built-in Unix commands.

#### Challenges

1.  Leah has several hundred data files, each of which is formatted like this:

    ~~~
    2013-11-05,deer,5
    2013-11-05,rabbit,22
    2013-11-05,raccoon,7
    2013-11-06,rabbit,19
    2013-11-06,deer,2
    2013-11-06,fox,1
    2013-11-07,rabbit,18
    2013-11-07,bear,1
    ~~~

    Write a shell script called `species.sh` that takes any number of
    filenames as command-line parameters, and uses `cut`, `sort`, and
    `uniq` to print a list of the unique species appearing in each of
    those files separately.

2.  Write a shell script called `longest.sh` that takes the name of a
    directory and a filename extension as its parameters, and prints
    out the name of the file with the most lines in that directory
    with that extension. For example:

    ~~~
    $ bash longest.sh /tmp/data pdb
    ~~~

    would print the name of the `.pdb` file in `/tmp/data` that has
    the most lines.
