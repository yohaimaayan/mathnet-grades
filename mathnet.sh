#!/usr/bin

#todo alias this script
#todo give this script correct chmod
#todo save files in Dropbox
#todo create help somehow

if [ $# -eq 0 ]; then
	echo "Please enter the course number:"
	read COURSE
fi

echo "Please enter your MATHNET administrator username:"
read USER

echo "Please enter your MATHNET administrator password:"
read -s PASSWD  # -s is there so the characters you type don't show up

# determine the current semester
YEAR=`date '+%y'`
MONTH=`date '+%m'`
CODE=$(($YEAR-1))$YEAR

if [ "$MONTH" -gt 5 ]; then
	SEMESTER="$CODE"b
else
	SEMESTER="$CODE"a
fi


for COURSE in "$@"; do
	URL="https://mathnet.technion.ac.il/M/mathnet?action=login&course=${COURSE}_$SEMESTER"

	curl --silent --location -cookie "$COOKIE" --cookie-jar "$COOKIE" \
		--data "action=login" --data "course=104033_$SEMESTER" --data "login=$USER" --data "password=${PASSWD}" "$URL" --data "Submit.x=34" "Submit.y=19" > temp.html

	sed -n "s/.*mathnetsessionid=\([a-z]*\).*/\1/p" <temp.html >temp2.txt # this grabs the mathnetsessionsid

	SESSION=$(head -n 1 temp2.txt) # the previous line creates two lines in the temp2 file, so just take one

	# cleanup:

	rm temp.html
	rm temp2.txt

	# now grab all grade webpages:

	curl "https://mathnet.technion.ac.il/M/mathnet?action=admin&get=admin_hw&tags=CSV&mathnetsessionid=$SESSION" > hw.html

	curl "https://mathnet.technion.ac.il/M/mathnet?action=admin&get=admin_tut&tags=CSV&mathnetsessionid=$SESSION" > hachana.html

	curl "https://mathnet.technion.ac.il/M/mathnet?action=admin&get=admin_tirgul&tags=CSV&mathnetsessionid=$SESSION" > tirgul.html

	# now grab just the csv part (this takes one line before and after too)

	LC_ALL=C sed -n '/<\/pre>/q;p' < hw.html > hw.temp
	LC_ALL=C sed -n '/<pre>/,$p' < hw.temp > hw.csv

	LC_ALL=C sed -n '/<\/pre>/q;p' < hachana.html > hachana.temp
	LC_ALL=C sed -n '/<pre>/,$p' < hachana.temp > hachana.csv

	LC_ALL=C sed -n '/<\/pre>/q;p' < tirgul.html > tirgul.temp
	LC_ALL=C sed -n '/<pre>/,$p' < tirgul.temp > tirgul.csv

	# cleanup:

	rm hw.html
	rm hw.temp
	rm hachana.html
	rm hachana.temp
	rm tirgul.html
	rm tirgul.temp

	# remove one extra line above and one below
	# to be fixed, doesn't work on Mac:

	# tail -n +2 hw.csv > hw.csv 
	# tail -n +2 hachana.csv > hachana.csv
	# tail -n +2 tirgul.csv > tirgul.csv

	# also remove last line from each file:
	# ...

	mkdir $COURSE
	mv hw.csv $COURSE
	mv hachana.csv $COURSE
	mv tirgul.csv $COURSE
done
