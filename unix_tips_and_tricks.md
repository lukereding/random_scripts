# useful unix commands and tricks

based on William Shotts _The Linux Command line_

## navigation and really general commands

`cd`, `pwd`, `ls`, `mv`, `cp`, `mkdir`, `rm`

To create symbolic links: `ln -s fun fun-sym`

### useful character classes:

[:alnum:], [:alpha:], [:digit:], [:lower:], [:upper:]

__e.g.__ `*[[:lower:]123]`:Any file ending with a lowercase letter or the numerals “1”, “2”, or “3”
`[![:digit:]]*` : Any file not beginning with a numeral
`[[:upper:]]*`: Any file beginning with an uppercase letter

### other general use commands

A _command_ can be (1) an executable program (2) a shell builtin (like `cd`), (3) a shell function, or (4) an alias. Use `type` to figure out which one a given command is. For example, on my system `type ll` yeilds `ll is aliased to ls -laGtr'`. 

`which` shows the location of a command

Example command to create an alias, which can be stored in your `~/.bash_profile` or `~/.bashrc`: `alias foo='cd /usr; ls; cd -'`

Use `less` to view text files. `less` is similar to `more` but it's better because it allows the user to scroll up and down, not just down.

`file`: determine the file type.

`wc`: print the number of characters, lines, and bytes in a file. It's an easy way to count the number of lines in a file with `wc -l filename`.

`head` and `tail` show the top and bottom lines of a file. `tail -f` is useful because it allows you to view files in realtime as they are updated.

## redirection

Use `cat` to concatenate files

### output streams: standard out and standard errors

Most Unix programs have two different types of output: normal output and error output (although a file might send output to additional file streams). Additionally, standard input (generally attached to the keyboard) forms an additional file stream. The _file descriptors_ for standard input, output, and error are 0, 1, and 2, resp. 

We can redirect standard output to a file using either `>` to write a new file or `>>` to append to an existing file. E.g., `ls -l /usr/bin > ls-output.txt; ls -l /usr/bin >> ls-output.txt`.

To redirect standard error, we have to refer to its file descriptor like this: `ls -l /bin/usr 2> ls-error.txt`.

To redirect _both_ standard output and error to a single file, we can use `ls -l /bin/usr > ls-output.txt 2>&1`. A more intuitive way to do this is to use `ls -l /bin/usr &> ls-output.txt` for creating a new file or `ls -l /bin/usr &>> ls-output.txt` for appending to an existing file.


## sorting

`uniq` extracts unique or repeated lines from a file. Use `uniq -d` to show the repeated lines instead of the unqiue lines.

## changing the prompt at the command lines

Check out the `$PS1` variable. Changing this will change the prompt. For example, I've changed mine to `\w: ` which just shows the full path of the directory I'm in, followed by a colon and a space.

## brace expansion

Particularly useful for renaming files without a lot of hassle: `echo Number_{1..5}` yeilds `Number_1 Number_2 Number_3 Number_4 Number_5`. To pad zeros for numbers, try `echo {01..15}`.

## command substitution

You can have bash evaluate some command and use it as input to some other command using either `$()` notation or backticks. E.g., `ls -l $(which cp)` will show you the contents of the directory that contains `cp`; you don't need to do `which cp` followed by `ls -l /bin/cp/`.

## escaping characters

Sometimes you want `$` to mean dollar, not some special meaning that bash assigns it. When this the case, escape the specialness of `$` by using a `\`: `\$`, for example. Note that `\a` is a bell or alert tone (try it out with `echo -e "\a"`)

## quoting

__double quotes:__ placing an expression in double quotes results in all special characters losing their meaning except for `$`, `\`, and the backtick. For example, `echo $USER` and `echo "$USER"` yield the same result. 
__single quotes:__ placing an expression in single quotes results in __all__ special characters to lose their meaning. Now `echo '$USER'` yeilds `$USER`. 

## locating files 




## manipulating text


 