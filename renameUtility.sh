#!/bin/bash


########## FUNCTIONS ##########
printInstructions() {
	echo "===== Renaming Utility ====="
	echo "Select an option by number:"
	echo "	1- Increase/Decrease Episode Number"
	echo "	2- Change Season"
	echo "	0- Exit"

	read -p "Which? " MANAGE_OPTION
	# Check that the option is a number.
	CHECK_REGEX='^[0-9]+$'
	while ! [[ $MANAGE_OPTION =~ $CHECK_REGEX ]]
	do
		read -p "Not a valid option. Which? " MANAGE_OPTION
	done 
}

########## MAIN ##########
while printInstructions
do

if (( $MANAGE_OPTION == 0 ))
then
	echo "Bye!"
	exit
fi

if (($MANAGE_OPTION==1))
then
	echo "===== Increase/Decrease Episode Number ====="
	read -e -p "Enter starting directory: " DIRECTORY
	while [ ! -d "$DIRECTORY" ]
	do
		read -p "$DIRECTORY is not a valid directory. Enter starting directory: " DIRECTORY
	done
	read -e -p "Enter offset: " OFFSET
	CHECK_REGEX='^-?[0-9]+$'
        while ! [[ $OFFSET =~ $CHECK_REGEX ]]
        do
                read -p "Not a valid number. ? Enter offset: " OFFSET 
        done
	for FILE in "$DIRECTORY"/*
	do
		# Save the original file name for later
		ORIG="$FILE"
		# Extract the episode code (eg: S01E12)
		EP_CODE=$(ls "$FILE" | awk 'match($0, /[Ss][0-9]+[Ee][0-9]+/) {print substr($0, RSTART, RLENGTH)}' | tr "[a-z]" "[A-Z]")
		# Extract the season bit to keep for later
		EP_SEASON=$(echo "$EP_CODE" | cut -dE -f1)
		# Apply the offset to the episode number and add a 1 width 0 padding for tidiness.
		EP_MODIFIED=$(echo "$EP_CODE"| cut -dE -f2 | xargs -I ep echo "ep + $OFFSET" | bc)
		printf -v EP_MODIFIED "%02d" $EP_MODIFIED
		# Create the new episode code and generate the new filename for the move
		EP_CODE_NEW="$EP_SEASON"E"$EP_MODIFIED"
		MODIFIED=$(echo "$ORIG" | sed -e "s/$EP_CODE/$EP_CODE_NEW/g")
		# Finally move the file. Force the interactive option for extra safety.
		mv -vi "$ORIG" "$MODIFIED"
	done
fi

if (( $MANAGE_OPTION==2))
then
	echo "===== Change Season ====="
	read -e -p "Enter starting directory: " DIRECTORY
        while [ ! -d "$DIRECTORY" ]
        do
                read -p "$DIRECTORY is not a valid directory. Enter starting directory: " DIRECTORY
        done
	read -e -p "Enter season: " SEASON 
        CHECK_REGEX='^[0-9]+$'
        while ! [[ $SEASON =~ $CHECK_REGEX ]]
        do
                read -p "Not a valid number. ? Enter season: " SEASON 
        done	
	for FILE in "$DIRECTORY"/*
	do
		# Save the original file name for later
		ORIG="$FILE"
		# Extract the episode code (eg: S01E12)
		EP_CODE=$(ls "$FILE" | awk 'match($0, /[Ss][0-9]+[Ee][0-9]+/) {print substr($0, RSTART, RLENGTH)}' | tr "[a-z]" "[A-Z]")
		# Extract the episode number to keep for later
		EP_NUMBER=$(echo "$EP_CODE" | cut -dE -f2)
		# Do a 1 width 0 padding on the new season number for tidiness
		printf -v SEASON "%02d" "$SEASON"
		# Create the new episode code and generate the new filename for the move
		EP_CODE_NEW=S"$SEASON"E"$EP_NUMBER"
		MODIFIED=$(echo "$ORIG" | sed -e "s/$EP_CODE/$EP_CODE_NEW/g")
		# Finally move the file. Force the interactive option for extra safety.
		mv -vi "$ORIG" "$MODIFIED"
	done	

fi

done
