#!/bin/sh


YN_confirm() {


	io_file=/dev/tty
	case $1 in
	--help|--help-long)
		case $1 in
			--help-long) help_long=1;;
			*) unset help_long;;
		esac
		printf %s\\n \
			"Usage: YN_confirm [--stdin] [default] [...prompt text]" \
			"" \
			"Options:" \
			"  --help       display help message and exit" \
			"  --help-long  display long help message with argument examples and exit" \
			"  --stdin      read response from standard input" \
			"" \
			"Arguments:" \
			"  [...prompt text]  is joined by new lines" \
			"  [default]:" \
			"    I. The length of [default] argument matters" \
			"    when \`read\` command failed" \
			"      1 char|'' => exit code 5" \
			"      2+ chars  => exit code 0" \
			${help_long+ \
			"" \
			"      1. when \`read\` failed and [default] in [Yy]'es'    => exit code 0" \
			"      2. when \`read\` failed and [default] in [Nn]'o'     => exit code 0 (counterintuitive?)" \
			"      3. when \`read\` failed and [default] in [Mm]'aybe'  => exit code 0" \
			"      3. when \`read\` failed and [default] in ''          => exit code 5" \
			"      4. when \`read\` failed and [default] in [Yy]        => exit code 5" \
			"      5. when \`read\` failed and [default] in [Nn]        => exit code 5" \
			"" \
			} \
			"    II. The capitalization of [default] argument matters" \
			"    when input is not as expected" \
			"      upper    => exit code 0" \
			"      lower|'' => exit code 3" \
			${help_long+ \
			"" \
			"      1. when \$response not in [YyNn]*|'' and [default] in 'Y'*       => exit code 0" \
			"      1. when \$response not in [YyNn]*|'' and [default] in 'N'*       => exit code 0" \
			"      1. when \$response not in [YyNn]*|'' and [default] in 'Maybe'    => exit code 0" \
			"      1. when \$response not in [YyNn]*|'' and [default] in ''|'maybe' => exit code 3" \
			"      1. when \$response not in [YyNn]*|'' and [default] in 'y'*       => exit code 3" \
			"      1. when \$response not in [YyNn]*|'' and [default] in 'n'*       => exit code 3" \
			} \
			${help_long+ \
			"Exit status:" \
			"  0 =>  answer is Yes" \
			"  1 =>  answer is No" \
			"  2 =>  no answer and no default answer specified" \
			"  3 =>  not expected answer" \
			`: " 130    Interrupted with CTRL-C or ESC" ` \
			} \
		;
		exit
		;;
	--stdin)
		shift
		unset io_file
		;;
	esac


	default=${1-}; shift
	local yn_prompt;yn_prompt='[y/n]'
	case $default in
		[Yy]|[Yy]es|YES) yn_prompt='[Y/n]';;
		[Nn]|[Nn]o|NO)   yn_prompt='[y/N]';;
		[Mm]aybe) ;;
		'') ;;
		*) printf %s\\n >&2 "YN_confirm: warning, bad [default] argument '$1'";;
	esac

	case ${io_file+x} in
		x) printf %s "${@-}${@:+ }$yn_prompt" >"$io_file";;
		*) printf %s "${@-}${@:+ }$yn_prompt" >&2;;
	esac

	# todo: integrate this exit status
	unset respond
	case ${io_file+x} in
		x) read respond <"$io_file";;
		*) read respond;;
	esac || {
		case $default in
			[Yy]es|[Nn]o) return 0;;
			*) return 5;;
		esac
	}



	case $respond in
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
				[YN]*) return 0;;
				*) return 3;;
			esac
		;;
	esac
}

case "${0##*/}" in
	YN_confirm|YN_confirm[!A-Za-z0-9_]*) YN_confirm "$@";;
	*) ;;
esac



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

