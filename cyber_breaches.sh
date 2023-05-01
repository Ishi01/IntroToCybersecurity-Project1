#!/bin/bash

#WHEN U DO ERROR CHECKING, REFER TO NOTES AND LECTURE FOR WEEK 5

#Find length of input to determine between the 3rd and 4th functions
filename=$1
leninput=`echo $2 | awk '{print length}'`

#ERROR CHECKING
#Check if file is in correct .tsv format
if [[ $filename != *".tsv"* ]];
then
	echo "File must be in the .tsv format"
	exit 1
fi

#Check to make sure file is not empty
if [ ! -s $filename ];
then
	echo "File must exist and not be empty"!
	exit 1
fi

#Check that the correct number of inputs is met
if [ "$#" -ne 2 ];
then
	echo "Script requires 2 inputs, <filename>.tsv AND maxstate OR maxyear OR <2 character state code> OR <4 digit year>"
	exit 1
fi


#DATA SCRIPT
#If condition is maxstate, then do the following operations
if [ $2 == "maxstate" ];
then
	#First, print out all state codes from file using awk, then sort them using sort
	#then compress them using uniq -c into 2 columns, 1 with number of repeats and 2 w/ string
	#then sort those in descending order using sort -rn
	#finally, using awk format output and print the highest repeating state code + num of reps
	awk -F '\t' '(NR>1) {print $2}' $filename | sort | uniq -c | sort -rn | awk 'NR==1{print "State with greatest number of incidents: "$2" with a total of "$1 }'

elif [ $2 == "maxyear" ];
then
	#print out column of all years
	#sort years and condense using uniq -c
	#sort by number of occurences
	#print year with most occurences and amount of occurences
	awk -F '\t' '(NR>1) {print $8}' $filename | sort | uniq -c | sort -rn | awk 'NR==1{print "Year with greatest nunmber of incidences: "$2" with a total of "$1 }'

#Check if input length is 2, which indicates a state code was entered
elif [ $leninput == "2" ];
then
	state=$2
	#print out all years where the state is equal to the named state
	#sort years and condense using uniq -c
	#sort so highest number of incidents is on top of the page
	#print year with most occurences and amount of occurences
	awk -F '\t' '(NR>1) { if ($2 == "'"$state"'") print $8}' $filename | sort | uniq -c | sort -rn | awk 'NR==1 {print "Year with greatest number of incidents for '$state' is "$2" with count "$1""}'

#Check if input  length is 4, which indicates a year was entered
elif [ $leninput == "4" ];
then
	#save year to variable
	year=$2
	#print all states for named year
	#condense with uniq -c
	#sort by largest number of state name occurences so largest is on top
	#print first row which contains results
	awk -F '\t' '(NR>1) { if ($8 == "'"$year"'") print $2}' $filename | sort | uniq -c | sort -rn | awk 'NR==1 {print "State with greatest number of incidents in '$year' is "$2", with "$1" incidents"}'

else
	echo "Input not recognized, format is: ./cyber_breaches.sh <filename>.tsv maxyear OR maxstate OR <2 character state code> OR <4 digit year>"
	exit 1
fi
