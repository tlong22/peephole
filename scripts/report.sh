#!/bin/bash

###############################################
# JOOS Compile Benchmarks & Report Statistics #
###############################################

# Run with -O to include optimizations (which is usually what you want to do,
# but you can run it without for debugging).

if [[ -z $1 ]]
then	
	total=`$PEEPDIR/scripts/joosc_bench.sh | grep code_length | awk '{sum += $3} END {print sum}'`
	echo -e "TOTAL CODE LENGTH: $total"
	exit 0
fi

# Total code length without optimizations (Hard-coded).
total=20814
# Total code length with optimizations.
totalo=`$PEEPDIR/scripts/joosc_bench.sh -O | grep code_length | awk '{sum += $3} END {print sum}'`

echo -e "----- CODE LENGTH REPORT -----"
echo -e "NO OPT.: $total"
echo -e "A- OPT.: (TODO)"
echo -e "A+ OPT.: (TODO)"

# The file containing the last total code length with optimizations exists.
if [[ -f $PEEPDIR/scripts/.last_total_opt_code_length ]]
then
	last_totalo=`head -1 $PEEPDIR/scripts/.last_total_opt_code_length`

	echo -e "LAST OPT.: $last_totalo"
	echo ""

	# Calculate code length differences and output.
	if [[ $total -ge $totalo ]]
	then
		diff1=$(expr $total - $totalo)
		if [[ $totalo -ge $last_totalo ]]
		then
			diff2=$(expr $totalo - $last_totalo)
			echo -e "OUR OPT.: $totalo (-$diff1 NO OPT., +$diff2 LAST OPT.)"
		else
			diff2=$(expr $last_totalo - $totalo)
			echo -e "OUR OPT.: $totalo (-$diff1 NO OPT., -$diff2 LAST OPT.)"
		fi 
	else
		diff1=$(expr $totalo - $total)
		if [[ $totalo -ge $last_totalo ]]
		then
			diff2=$(expr $totalo - $last_totalo)
			echo -e "OUR OPT.: $totalo (+$diff1 NO OPT., +$diff2 LAST OPT.)"
		else
			diff2=$(expr $last_totalo - $totalo)
			echo -e "OUR OPT.: $totalo (+$diff1 NO OPT., -$diff2 LAST OPT.)"
		fi
	fi
else
	echo ""

	# Calculate the code length difference and output.
	if [[ $total -ge $totalo ]]
	then
		diff=$(expr $total - $totalo)
		echo -e "OUR OPT.: $totalo (-$diff NO OPT.)"
	else
		diff=$(expr $totalo - $total)
		echo -e "OUR OPT.: $totalo (+$diff NO OPT.)"
	fi
fi

# Store the newly calculated total.
echo $totalo > $PEEPDIR/scripts/.last_total_opt_code_length