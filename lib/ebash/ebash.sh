#! /usr/bin/env bash 

require "lib/fail.sh"
require "lib/random.sh"

# Processes an embedded bash file (*.esh) and if successful, prints
# the outputs to standard out.
# 
# $1 - The esh file.
#
ebash() {
	if [[ -z $1 ]] 
	then
		fail "Must provide a ebash file."
	fi 

	local file=$1
	if [[ ! -f $file ]] 
	then
		fail "Must provide a ebash file."
	fi 

	local tmp_file=/tmp/ebash.$(random_str).tmp
	if ! touch $tmp_file &> /dev/null
	then
		fail "Must provide a ebash file."
	fi 

	local delim=${ebash_delim:-"--"}

	(
		unset cmd
		declare local cmd

		{
			echo "cat - <<EOF"
			while IFS='' read -r line
			do
				# is this the first line, and is it a bash cmd?
				if [[ -z $cmd ]] && ! echo $line | grep -q "^$delim"
				then
					cmd=false
					echo "cat - <<EOF"
					printf "%s\n" "$line"
					continue
				fi

				# is this the start or end of a bash cmd area?
				if echo $line | grep -q "^$delim"
				then 
					if [[ -z $cmd ]] || ! $cmd
					then
						echo "EOF"
						cmd=true
						continue
					fi

					echo "cat - <<EOF"
					cmd=false
					continue
				fi

				printf "%s\n" "$line"

			done < $file

			$cmd || echo "EOF" 

		} > $tmp_file
	)

	(
		set -o errtrace
		set -o errexit

		ebash_on_exit() {
			rm -f $tmp_file
		}

		ebash_on_template_error() {
			local line_num=$1

			# The line number of the /tmp/bashee.out file will be
			# offset by one from the real template since we 
			# added an extra line at the beginning.
			(( line_num-- )) 

			fail "Error procesing template: $file: $line_num"
		}


		trap 'ebash_on_exit' EXIT
		trap 'ebash_on_template_error' ERR

		source $tmp_file
	) || fail 'Error interpretting embedded bash file'
}
