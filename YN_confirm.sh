#!/bin/sh


YN_confirm() {

local io_file; io_file=${YN_CONFIRM_TTY_PATH:-/dev/tty};

local arg_printf print_response
unset arg_printf print_response
while case $# in 0) false;; *) ;;esac; do
	case $1 in
		--printf) arg_printf='';;
		--print-response) print_response='';;
		--stdin|-S)
			case ${YN_CONFIRM_TTY_PATH+x} in
				x) printf %s\\n >&2 "${FUNCNAME:-YN_confirm}: Isnoring -S option because YN_CONFIRM_TTY_PATH var is in the env.";;
				*) unset io_file
			esac
		;;
		[+-]x) set "$1";;
		-*) printf %s\\n "YN_confirm: unrecognized option: '$1'" >&2; return 4;;
		*) break;;
	esac
	shift
done


local default;default=${1-}
${1+shift}

local yn_prompt;yn_prompt='[y/n]'
case $default in
	[Yy]|[Yy]es|YES) yn_prompt='[Y/n]';;
	[Nn]|[Nn]o|NO)   yn_prompt='[y/N]';;
	''|[Mm]aybe) ;;
	*) printf %s\\n >&2 "YN_confirm: bad [default] argument '$default'"; return 4;;
esac
local IFS;IFS=${NEW_LINE-'
'}

case ${arg_printf-0} in 0) set -- %s "${*-}"; esac

case ${io_file:-"-"} in
	-) { printf "$@"; printf %s "${1:+ }$yn_prompt "; } >&2;;
	*) { printf "$@"; printf %s "${1:+ }$yn_prompt "; } >"$io_file";;
esac
	# eval '{ printf "$@"; printf %s "${1:+ }$yn_prompt "; } >${io_file-"&2"}${io_file+\$io_file};;'

# todo: integrate this exit status
local response
case ${io_file:-"-"} in
	-) read response;;
	*) read response <"$io_file";;
esac || {
	case ${print_response+${response+x}} in x) printf %s "$response"; esac
	case $default in
		[Yy]es|[Nn]o|[Mm]aybe|??*) return 0;;
		*) return 5;;
	esac
}
case ${print_response+${response+x}} in x) printf %s\\n "$response"; esac


case $response in
	[Yy]*) return 0;;
	[Nn]*) return 1;;
	'')
		case $default in
			[Yy]*) return 0;;
			[Nn]*) return 1;;
			*) return 2;;
		esac
	;;
	*)
		case $default in
			Y|N|M|Yes|No|Maybe|[A-Z]*) return 0;;
			*) return 3;;
		esac
	;;
esac



}








case "${0##*/}" in
	YN_confirm|YN_confirm[!A-Za-z0-9_]*) ;;
	*) return;; # when file was sourced by shell, just loads the function
esac


case ${1-} in --help|--help-long)
	#local help_long
	case $1 in
		--help-long) help_long='';;
		*) unset help_long;;
	esac
	printf %s\\n \
		"Usage: YN_confirm [-x|+x] [--stdin|-S] [--print-response] [default] [...prompt text]" \
		"" \
		"Options:" \
		"  --help            display ${help_long-"this "}help message" \
		"  --help-long       display ${help_long+"this "}long help message with argument examples" \
		"  --stdin|-S        read response from standard input" \
		"  --printf          pass [...prompt text] to printf. note: will append \$yn_prompt=' [y/n] ' to last argument" \
		"  --print-response  print response after succsesful read" \
		"  -x|+x             debug, turn on/off xtrace on shell" \
		"" \
		"Arguments:" \
		"  [...prompt text]  is joined by \$IFS (most likely a space)" \
		"  [default]:" \
		${help_long+ \
		"" \
		} \
		"    I. The length of [default] argument matters" \
		"    when \`read\` command failed" \
		"      (1 char)|'' => exit code 5" \
		"      (2+ chars)  => exit code 0" \
		${help_long+ \
		"" \
		"      1. when \`read\` failed and [default] in [Yy]es    => exit code 0" \
		"      2. when \`read\` failed and [default] in [Nn]o     => exit code 0" \
		"      3. when \`read\` failed and [default] in [Mm]aybe  => exit code 0" \
		"      4. when \`read\` failed and [default] in ''        => exit code 5" \
		"      5. when \`read\` failed and [default] in [Yy]      => exit code 5" \
		"      6. when \`read\` failed and [default] in [Nn]      => exit code 5" \
		"" \
		} \
		"    II. The capitalization of [default] argument matters" \
		"    when input is not as expected" \
		"      (UPPER)    => exit code 0" \
		"      (lower)|'' => exit code 3" \
		${help_long+ \
		"" \
		"      1. when \$response not in [YyNn]*|'' and [default] in Y|Yes      => exit code 0" \
		"      2. when \$response not in [YyNn]*|'' and [default] in N|No       => exit code 0" \
		"      3. when \$response not in [YyNn]*|'' and [default] in Maybe      => exit code 0" \
		"      4. when \$response not in [YyNn]*|'' and [default] in ''|maybe   => exit code 3" \
		"      5. when \$response not in [YyNn]*|'' and [default] in y|yes      => exit code 3" \
		"      6. when \$response not in [YyNn]*|'' and [default] in n|no       => exit code 3" \
		} \
		${help_long+ \
		"" \
		"    III. [y/n/''] matters, Examples for empty input:" \
		"      1. when \response in '' and [default] in [Yy]|[Yy]es  => exit code 0" \
		"      2. when \response in '' and [default] in [Nn]|[Nn]o   => exit code 1" \
		"      4. when \response in '' and [default] in ''|[Mm]aybe  => exit code 2" \
		} \
		${help_long+ \
		"" \
		"Exit status:" \
		"  0  =>  answer is Yes" \
		"  1  =>  answer is No" \
		"  2  =>  no answer and no default answer specified" \
		"  3  =>  not expected answer" \
		"  4  =>  bad command arguments" \
		"  5+ =>  not expected \`read\` fail" \
		`: " 130    Interrupted with CTRL-C or ESC" :` \
		} \
	;
	exit
esac

YN_confirm "$@"




#""" # bat -r23:38 /usr/share/yash/initialization/common
#  23   │   history()
#  24   │   if [ -t 0 ] && (
#  25   │     for arg do
#  26   │       case "${arg}" in
#  27   │         (-[drsw]?* | --*=*) ;;
#  28   │         (-*c*) exit;;
#  29   │       esac
#  30   │     done
#  31   │     false
#  32   │   ) then
#  33   │     printf 'history: seems you are trying to clear the whole history.\n' >&2
#  34   │     printf 'are you sure? (yes/no) ' >&2
#  35   │     case "$(head -n 1)" in
#  36   │       ([Yy]*) command history "$@";;
#  37   │       (*)     printf 'history: cancelled.\n' >&2;;
#  38   │     esac
#

