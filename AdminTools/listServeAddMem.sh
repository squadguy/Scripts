#!/bin/bash

#This script enrolls a single user into all of the listserves they should be a member of depending on their class.
#Useful when the automated script misses them.
#Comes with baked in cool CLI menu!

#arrays of lists for each employee type
declare -a emp=('announce' 'itsnews' 'official' 'au-spartan-sports');
declare -a reg_staff=("${emp[@]}" 'staff');
declare -a faculty=("${emp[@]}" 'faculty-forum' 'forum' 'instruction');
declare -a adjunct=('instruction' 'itsnews' 'offical' 'forum' 'au-spartan-sprots');
declare -a grad_student=('au-grad' 'all-students');
declare -a student=('au-undergrad' 'all-students');
declare -a it_staff=("${reg_staff[@]}" 'its-staff');
declare -a gwc_staff=("${reg_staff[@]}" 'gwc-staff');
declare -a gwc_faculty=("${reg_staff[@]}" 'GWC-faculty');
declare -a gwc_instructor=("${adjunct[@]}" 'GWC-instructors');

#file where username will be read from
usernameFile=/tmp/mems.txt

#clear the mems.txt file
echo "" > /tmp/mems.txt

##echo ${reg_staff[@]}

#get the email to add to mailinglists from the person
echo "Enter the username: (No @comany.edu):"
read username

#append compnay's email domain for user - how nice of me
username=$username@company.edu

#move the full email into the file to be read from
echo $username > $usernameFile

#remind the user who they entered
echo "You entered: $username"

echo
echo

#Get the type of employee from user
echo "Enter number of user type:"
echo "(1) Regular Staff"
echo "(2) Faculty"
echo "(3) Adjunct"
echo "(4) Grad Student"
echo "(5) Undgergrad"
echo "(6) IT Staff"
echo "(7) GWC Staff"
echo "(8) GWC Faculty"
echo "(9) GWC Instructor"
echo "(0) To EXIT"

#get the input from user
read empType

##echo $empType


#prepare the array for the for loop
if [ $empType == 1 ]
	then
		declare -a empArray=("${reg_staff[@]}");	

elif [ $empType == 2 ]
	then
		declare -a empArray=("${faculty[@]}");	

elif [ $empType == 3 ]
	then
		declare -a empArray=("${adjunct[@]}");	

elif [ $empType == 4 ]
	then
		declare -a empArray=("${grad_student[@]}");	

elif [ $empType == 5 ]
	then
		declare -a empArray=("${student[@]}");	

elif [ $empType == 6 ]
	then
		declare -a empArray=("${it_staff[@]}");	

elif [ $empType == 7 ]
	then
		declare -a empArray=("${gwc_staff[@]}");	

elif [ $empType == 8 ]
	then
		declare -a empArray=("${gwc_faculty[@]}");	

elif [ $empType == 9 ]
	then
		declare -a empArray=("${gwc_instructor[@]}");	

else
	echo "Exiting"
	#need exit for script here
fi

#enroll the email in the lists they should be on
for i in "${empArray[@]}"
do
#need to add full path the script here
	echo "/usr/local/mailman/bin/add_members -r /tmp/mems.txt -w n -a n $i"
done

scp /tmp/mems.txt neptune:/tmp/mems.txt

#./add_members -r /tmp/mems.txt -w n -a n $listServe

