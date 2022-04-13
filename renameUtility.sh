#!/bin/bash


########## FUNCTIONS ##########
printInstructions() {
	echo "===== Renaming Utility ====="
	echo "Select an option by number:"
	echo "	1- Increase/Decrease episode number"
	echo "	2- Change Season"
	echo "	0- Exit"

	read -p "Which? " manageOption
	re='^[0-9]+$'
	while ! [[ $manageOption =~ $re ]]
	do
		read -p "Not a valid option. Which? " manageOption
	done 
}

########## MAIN ##########
while printInstructions
do

if (( $manageOption == 0 ))
then
	echo "Bye!"
	exit
fi

if (($manageOption==1))
then
	echo "===== Increase/Decrease episode number ====="
	read -e -p "Enter starting directory: " DIRECTORY
	while [ ! -d "$DIRECTORY" ]
	do
		read -p "$DIRECTORY is not a valid directory. Enter starting directory: " DIRECTORY
	done
	read -e -p "Enter offset: " OFFSET
	re='^-?[0-9]+$'
        while ! [[ $OFFSET =~ $re ]]
        do
                read -p "Not a valid number. ? Enter offset: " OFFSET 
        done
	for f in "$DIRECTORY"/*
	do
		ORIG="$f"
		EP_CODE=$(ls "$f" | awk 'match($0, /[Ss][0-9]+[Ee][0-9]+/) {print substr($0, RSTART, RLENGTH)}' | tr "[a-z]" "[A-Z]")
		EP_SEASON=$(echo "$EP_CODE" | cut -dE -f1) 
		EP_MODIFIED=$(echo "$EP_CODE"| cut -dE -f2 | xargs -I ep echo "ep + $OFFSET" | bc)
		printf -v EP_MODIFIED "%02d" $EP_MODIFIED
		EP_CODE_NEW="$EP_SEASON"E"$EP_MODIFIED"
		MODIFIED=$(echo "$ORIG" | sed -e "s/$EP_CODE/$EP_CODE_NEW/g")
		mv -vi "$ORIG" "$MODIFIED"
	done
fi

if (( $manageOption==2))
then
	echo "===== Change Season ====="
	read -e -p "Enter starting directory: " DIRECTORY
        while [ ! -d "$DIRECTORY" ]
        do
                read -p "$DIRECTORY is not a valid directory. Enter starting directory: " DIRECTORY
        done
	read -e -p "Enter season: " SEASON 
        re='^[0-9]+$'
        while ! [[ $SEASON =~ $re ]]
        do
                read -p "Not a valid number. ? Enter season: " SEASON 
        done	
	for f in "$DIRECTORY"/*
        do
		ORIG="$f"
                EP_CODE=$(ls "$f" | awk 'match($0, /[Ss][0-9]+[Ee][0-9]+/) {print substr($0, RSTART, RLENGTH)}' | tr "[a-z]" "[A-Z]")
                EP_NUMBER=$(echo "$EP_CODE" | cut -dE -f2)
		printf -v SEASON "%02d" "$SEASON"
		EP_CODE_NEW=S"$SEASON"E"$EP_NUMBER"
		MODIFIED=$(echo "$ORIG" | sed -e "s/$EP_CODE/$EP_CODE_NEW/g")
		mv -vi "$ORIG" "$MODIFIED"
	done	

fi

done
