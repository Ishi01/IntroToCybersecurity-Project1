#!/bin/bash

#WHEN U DO ERROR CHECKING, REFER TO NOTES AND LECTURE FOR WEEK 5

#Find length of input to determine between the 3rd and 4th functions
fileName=$1
lenInput=`echo $2 | awk '{print length}'`

#If condition is maxstate, then do the following operations
if [ $2 = "maxstate" ]
then
	#First, print out all state codes from file using awk, then sort them using sort
	#then compress them using uniq -c into 2 columns, 1 with number of repeats and 2 w/ string
	#then sort those in descending order using sort -rn
	#finally, using awk format output and print the highest repeating state code + num of reps
	awk -F '\t' '(NR>1) {print $2}' $fileName | sort | uniq -c | sort -rn | awk 'NR==1{print "State with greatest number of incidents: "$2" with a total of "$1 }'

elif [ $2 = "maxyear" ]
then
	#print out column of all years
	#sort years and condense using uniq -c
	#sort by number of occurences
	#print year with most occurences and amount of occurences
	awk -F '\t' '(NR>1) {print $8}' $fileName | sort | uniq -c | sort -rn | awk 'NR==1{print "Year with greatest nunmber of incidences: "$2" with a total of "$1 }'

elif [ $lenInput = 2 ]
#save $1 to state to avoid confusion inside awk
state=$2
then
	#print out all years where the state is equal to the names state
	awk -F '\t' '(NR>1) { if ($2 == "$state") print $8}' $fileName | uniq -c
fi
