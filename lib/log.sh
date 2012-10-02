require "lib/array.sh"

log_level=${log_level:-"INFO"}
log_color=${log_color:-"true"}
log_color_id=${log_color_id:-"2"}
log_pid=${log_pid:-$$}

debug_levels=( DEBUG )
log_debug() {
	if ! array_contains "$log_level" "${debug_levels[@]}" 
	then
		return 0
	fi

	if [[ "$log_color" != "true" ]] || ! tput setaf &> /dev/null 
	then
		echo -e "[$log_pid] [DEBUG]: $1"
	else
		echo -e "$(tput setaf $log_color_id)[$log_pid] [DEBUG]$(tput sgr0): $1"
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
		echo -e "[$log_pid] [INFO]: $1"
	else
		echo -e "$(tput setaf $log_color_id)[$log_pid] [INFO]$(tput sgr0): $1"
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
		echo "[$log_pid] [ERROR]: $1" 1>&2
	else
		echo -e "$(tput setaf $log_color_id)[$log_pid] [ERROR] $(tput sgr0): $1" 1>&2
	fi
}
