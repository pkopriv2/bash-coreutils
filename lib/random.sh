# returns a random string of the given length. will not contain special
# characters.
random_str() {
	env LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c ${1:-8}
}

# returns a random number [lower, upper]
random_num() {
	:
}
