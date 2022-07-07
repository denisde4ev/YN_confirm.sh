	# YN_confirm.sh
Prompt/Ask/Question "Prompt text [y/n]" for POSIX sh. Different exit code for (cant read stdin) and (wrond input typed)

note: Instead of options this script uses complex matching <br>to first argument `$1` of (upper `Y|N` or lower case `y|n`) and (1 `y|n|''` letter or full `yes|no|maybe`).<br>
See [`YN_confirm --help-long` help message](#help-message)

## How to use:
``` shell
$ if YN_confirm y 'My question?'; then echo ok; else echo exit code: $?; fi
My question? [Y/n]
(( when user accepts by typing: "yes"))
```
accpeting is when answer is in `y*|n*` and (when $1='y' and no answer/\[Enter\])

``` shell
$ if YN_confirm Yes 'Do you want to clear cache?'; then echo will delete something un-needed from ~/.cache/...; else echo exit code $?; fi
Do you want to clear cache? [Y/n]
(( When user types: "idk" )): will delete something un-needed from ~/.cache/...
(( When user types: "nOo" )): exit code: 1

$ if YN_confirm y 'Do you want to clear cache?'; then echo will delete something un-needed from ~/.cache/...; else echo exit code $?; fi

```


# Help message:
this
