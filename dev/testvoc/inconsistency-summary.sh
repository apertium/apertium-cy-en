INC=$1
PAIR=$2
OUT=testvoc-summary.$PAIR.txt
POS="adj adv cm cnjadv cnjcoo cnjsub det guio ij rel n np num pr preadv predet prn vaux vbdo vbhaver vblex vbmod vbser"

echo -n "" > $OUT;

date >> $OUT
echo -e "===============================================" >> $OUT
echo -e "POS\tTotal\tClean\tWith @\tWith #\tClean %" >> $OUT
for i in $POS; do
	if [ "$i" = "det" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<n>' -e '<np>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<n>' -e '<np>' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<n>' -e '<np>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "preadv" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<adj>' -e '<adv>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<adj>' -e '<adv>' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<adj>' -e '<adv>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "adv" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<adj>' -e '<v' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<adj>' -e '<v' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<adj>' -e '<v' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "cnjsub" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<v' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<v' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<v' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "prn" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<pr>' -e '<v' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<pr>' -e '<v' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<pr>' -e '<v' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "vbhaver" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<pp' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<pp' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<pp' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "vblex" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<adv' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<adv' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<adv' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "pr" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<prn' -e '<ger' -e '<det' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<prn' -e '<ger' -e '<det' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v -e '<prn' -e '<ger' -e '<det' | grep -v REGEX |  wc -l`;
	else
		TOTAL=`cat $INC | grep "<$i>" | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" | grep ' #' | grep -v REGEX |  wc -l`;
	fi
	UNCLEAN=`calc $AT+$HASH`;
	CLEAN=`bc <<< $TOTAL-$UNCLEAN`;
	PERCLEAN=`calc $UNCLEAN/$TOTAL*100 |sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	echo $PERCLEAN | grep "Err" > /dev/null;
	if [ $? -eq 0 ]; then
		TOTPERCLEAN="100";
	else
		TOTPERCLEAN=`calc 100-$PERCLEAN | sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	fi

	echo -e $TOTAL";"$i";"$CLEAN";"$AT";"$HASH";"$TOTPERCLEAN;
done | sort -gr | awk -F';' '{print $2"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6}' >> $OUT

echo -e "===============================================" >> $OUT
cat $OUT;
