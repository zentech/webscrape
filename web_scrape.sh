#!/bin/bash
#web scraping quotes website

if [ $# -ne 1 ]; then
	echo "Usage $(basename $0) 'Author Name'"
	exit -1
fi

curl=$(which curl)
outfile="output.txt"
name=$(echo $1 | tr ' ' '+')
regex="--$1 "
url="http://localhost/quote/index.php?author=$name"

#dump webpage
function dump_webpage() {
	$curl -o $outfile $url &>/dev/null
	check_errors
}

#clean the webpage
function strip_html() {
	grep "<p>" $outfile | sed 's/<[^>]*>//g' > temp.txt && cp temp.txt $outfile
	sed -i "s/$regex/\n/g" $outfile
}

#loop through content of file
function print_quotes() {
	echo "All quotes!"
	while read quote; do
		echo "${quote}"
	done < $outfile
}

#checking for errors
function check_errors() {
	[ $? -ne 0 ] && echo "Error Downloading page..." && exit -1
}

######################
#		MAIN		 #
######################

dump_webpage
strip_html
print_quotes

#END