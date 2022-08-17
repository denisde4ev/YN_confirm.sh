	case ${1-} in
	--help|--help-long)
		case $1 in
			--help-long) help_long='';;
			*) unset help_long;;
		esac
		printf %s\\n \
			"Usage: YN_confirm [-x|+x] [--stdin] [--print-response] [default] [...prompt text]" \
			"" \
			"Options:" \
			"  --help            display ${help_long-"this "}help message" \
			"  --help-long       display ${help_long+"this "}long help message with argument examples" \
			"  --stdin           read response from standard input" \
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
			"      2. when \`read\` failed and [default] in [Nn]o     => exit code 0 (counterintuitive?)" \
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
			"      2. when \$response not in [YyNn]*|'' and [default] in N|No       => exit code 0 (counterintuitive?)" \
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
			"      3. when \response in '' and [default] in ''|[Mm]aybe  => exit code 2" \
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
			`: " 130    Interrupted with CTRL-C or ESC" ` \
			} \
		;
		exit
	esac
