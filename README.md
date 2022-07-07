# YN_confirm.sh
Prompt/Ask/Question "Prompt text [y/n]" for POSIX sh. Different exit code for (cant read stdin) and (wrond input typed)

note: Instead of options this script uses complex matching <br>to first argument `$1` of (upper `Y|N` or lower case `y|n`) and (1 `y|n|''` letter or full `yes|no|maybe`).<br>
See [YN_confirm help message below](#help-message)

## How to use:
``` shell
$ if YN_confirm y 'My question?'
  then echo ok
  else exit code: $?
  fi
My question? [Y/n] 
(( when user accepts by typing: "yes"|"yNO"|Ynot|[Yy]* )): ok
(( when user rejects by typing: "no"|"nYES"|"Nu"|[Nn]* )): exit code: 3
(( when user stypes not valid input: "idk" )): exit code: 3
(( when cant reed input )): exit code: 5


$ if YN_confirm Yes 'Do you want to clear cache?'
  then echo will delete something un-needed from ~/.cache/...
  else echo exit code $?
  fi
Do you want to clear cache? [Y/n] 
(( when user types: "idk"|"" )): will delete something un-needed from ~/.cache/...
(( when can't read input )): will delete something un-needed from ~/.cache/...
(( and only when user types: "n"|[Nn]* )): exit code: 1

$ if YN_confirm n 'Do you want to delete something? you may need it'
  then echo will delete something
  else echo exit code $?
  fi
Do you want to delete something? you may need it [y/N] 
(( when user types: ""|"no"|[Nn]* )): exit code: 1
(( when user types: "idk" )): exit code: 3
(( when can't read input )): exit code: 5
(( only when user types: "yes"|[Yy]* )): will delete something
```

<!-- todo: consider adding usage for "maybe" option -->

note: exit code 4 is for error in arguments


## Help message:

    $ YN_confirm --help
    Usage: YN_confirm [-x|+x] [--stdin|-S] [--print-response] [default] [...prompt text]
    
    Options:
      --help            display this help message
      --help-long       display long help message with argument examples
      --stdin|-S        read response from standard input
      --print-response  print response after succsesful read
      -x|+x             debug, turn on/off xtrace on shell
    
    Arguments:
      [...prompt text]  is joined by $IFS (most likely a space)
      [default]:
        I. The length of [default] argument matters
        when `read` command failed
          (1 char)|'' => exit code 5
          (2+ chars)  => exit code 0
        II. The capitalization of [default] argument matters
        when input is not as expected
          (UPPER)    => exit code 0
          (lower)|'' => exit code 3
<span>

    $ YN_confirm --help-long
    Usage: YN_confirm [-x|+x] [--stdin|-S] [--print-response] [default] [...prompt text]
    
    Options:
      --help            display help message
      --help-long       display this long help message with argument examples
      --stdin|-S        read response from standard input
      --print-response  print response after succsesful read
      -x|+x             debug, turn on/off xtrace on shell
    
    Arguments:
      [...prompt text]  is joined by $IFS (most likely a space)
      [default]:
    
        I. The length of [default] argument matters
        when `read` command failed
          (1 char)|'' => exit code 5
          (2+ chars)  => exit code 0
    
          1. when `read` failed and [default] in [Yy]es    => exit code 0
          2. when `read` failed and [default] in [Nn]o     => exit code 0
          3. when `read` failed and [default] in [Mm]aybe  => exit code 0
          4. when `read` failed and [default] in ''        => exit code 5
          5. when `read` failed and [default] in [Yy]      => exit code 5
          6. when `read` failed and [default] in [Nn]      => exit code 5
    
        II. The capitalization of [default] argument matters
        when input is not as expected
          (UPPER)    => exit code 0
          (lower)|'' => exit code 3
    
          1. when $response not in [YyNn]*|'' and [default] in Y|Yes      => exit code 0
          2. when $response not in [YyNn]*|'' and [default] in N|No       => exit code 0
          3. when $response not in [YyNn]*|'' and [default] in Maybe      => exit code 0
          4. when $response not in [YyNn]*|'' and [default] in ''|maybe   => exit code 3
          5. when $response not in [YyNn]*|'' and [default] in y|yes      => exit code 3
          6. when $response not in [YyNn]*|'' and [default] in n|no       => exit code 3
    
        III. [y/n/''] matters, Examples for empty input:
          1. when \response in '' and [default] in [Yy]|[Yy]es  => exit code 0
          2. when \response in '' and [default] in [Nn]|[Nn]o   => exit code 1
          4. when \response in '' and [default] in ''|[Mm]aybe  => exit code 2
    
    Exit status:
      0  =>  answer is Yes
      1  =>  answer is No
      2  =>  no answer and no default answer specified
      3  =>  not expected answer
      4  =>  bad command arguments
      5+ =>  not expected `read` fail
