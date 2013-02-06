require "lib/array.sh"
require "lib/fail.sh"

log_level=${log_level:-"INFO"}
log_color=${log_color:-"true"}
log_color_id=${log_color_id:-"2"}
log_pid=${log_pid:-$$}
log_context=${log_context:-""}

# usage: log_context_add <key> [<val>]
log_context_add() {
	if (( $# < 1 ))
	then
		fail "Usage: log_context_add <key> <val>"
	fi

	local key=$1
	local val=$2

	log_context="${log_context:+"$log_context "}$key${val:+=$val}"
}

log_date() {
	date "+%Y-%m-%d %H:%M:%S"
}

debug_levels=( DEBUG )
log_debug() {
	if ! array_contains "$log_level" "${debug_levels[@]}" 
	then
		return 0
	fi

	if [[ "$log_color" != "true" ]] || ! tput setaf &> /dev/null 
	then
		echo -e "[$(log_date)] [$log_pid] [$log_context] [DEBUG]: $1"
	else
		echo -e "$(tput setaf $log_color_id)[$(log_date)] [$log_pid] [$log_context] [DEBUG]$(tput sgr0): $1"
	fi
}

# Logs a message out in a friendly green log_color if 
# a tty has been allocated.
#
info_levels=( DEBUG INFO )
log_info() {
	if ! array_contains "$log_level" "${info_levels[@]}" 
	then
		return 0
	fi

	if [[ "$log_color" != "true" ]] || ! tput setaf &> /dev/null 
	then
		echo -e "[$(log_date)] [$log_pid] [$log_context] [INFO]: $1"
	else
		echo -e "$(tput setaf $log_color_id)[$(log_date)] [$log_pid] [$log_context] [INFO]$(tput sgr0): $1"
	fi
}

# Logs a message out in a unfriendly red log_color. 
# The use should clearly know that something
# has gone wrong.
#
error_levels=( DEBUG INFO ERROR )
log_error() {
	if ! array_contains "$log_level" "${error_levels[@]}" 
	then
		return 0
	fi

	if [[ "$log_color" != "true" ]] || ! tput setaf &> /dev/null 
	then
		echo -e "[$(log_date)] [$log_pid] [$log_context] [ERROR]: $1"
	else
		echo -e "$(tput setaf $log_color_id)[$(log_date)] [$log_pid] [$log_context] [ERROR]$(tput sgr0): $1"
	fi
}
