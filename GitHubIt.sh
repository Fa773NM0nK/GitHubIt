#!/bin/bash


# setting up GithubIt

# asks user whether he wants to use the global username and email or setup a new, local one
# then asks git to ignore this script AND ".gitignore"

if [ "$1" = "--setup" -o "$1" = "-s" ];
then
	option=0;
	while [ "$option" -ne 1 -a "$option" -ne  2  ];
	do
		echo "Which Username and Email do you want to use?"
		echo "1. The one Globally Configured for Git"
		echo "2. A different one"
	
		read -p "Enter Choice : " option
		case "$option" in
		"1")	git config user.name "`git config --global user.name`"
				if [ "$?" -ne 0 ];
				then
					echo -e "\n\t\e[41mFailed to set Username.\e[0m Is this a Git repository? Have you set a Global Username?\n"
					echo "Encountered error(s); Exiting!"
					exit 1
				fi
				git config user.email "`git config --global user.email`"
				if [ "$?" -ne 0 ];
				then
					echo -e "\n\t\e[41mFailed to set Email.\e[0m Have you set a Global Email?\n"
					echo "Encountered error(s); Exiting!"
					exit 1
				fi
				echo -e "\nUsing Globally Configured Git Username and Email"	
				;;
		"2")	echo
				read -p "Enter your name : " name
				read -p "Enter your GitHub email : " email
				git config user.name $name
				if [ "$?" -ne 0 ];
				then
					echo -e "\n\t\e[41mFailed to set Username.\e[0m Is this a Git repository?\n"
					echo "Encountered error(s); Exiting!"
					exit 1
				fi
				git config user.email $email
				if [ "$?" -ne 0 ];
				then
					echo -e "\n\t\e[41mFailed to set Email.\e[0m\n"
					echo "Encountered error(s); Exiting!"
					exit 1
				fi
				;;
		*)		echo -e "\n\t\e[41mWrong Option, Enter Again\e[0m\n"
				;;
		esac
	done
	
	echo "GitHubIt.sh" > .gitignore
	echo ".gitignore" >> .gitignore
	
	echo -e "\nGitHubIt Setup Successfully!"


# starting to track files

elif [ "$1" = "--track" -o "$1" = "-t" ];
then
	for file in ${@:2}
	do
		git add $file
		if [ "$?" -eq 0 ];
		then
			echo -e "Tracking \"$file\""
		else
			echo -e "\n\t\e[41mFailed to track \"$file\"!\e[0m Cannot find it.\n"
		fi 
	done

elif [ "$1" = "--track-all" -o "$1" = "-ta" ];
then
	git add .
	if [ "$?" -ne 0 ];
	then
		echo -e "\n\t\e[41mFailed!!!\e[0m\n"
	else
		echo "Tracking Everyting"
	fi


# committing changes

files=""
elif [ "$1" = "--commit" -o "$1" = "-c" ];
then
	if [ "$2" = "--message" -o "$2" = "-m" ];
	then
		if [ $# -lt 3 ]
		then
			echo -e "\n\t\e[41mError\e[0m : \e[36mCommit Message not provided\e[0m, Exiting\n"
			exit 1
		fi
		
		message=$3
		
		if [ $# -gt 3 ];
		then
			for file in ${@:4}
			do
				files+="$file "
			done
		fi
	else
		message=""
		
		if [ $# -gt 1 ];
		then
			for file in ${@:2}
			do
				files+="$file "
			done
		fi
	fi
	
	if [ "$files" != "" ];
	then
		git add $files
		if [ "$?" -ne 0 ];
		then
			echo -e "\n\t\e[41mFailed to commit \"$file\"!\e[0m Cannot find a file that was asked to be commited. Exiting\n"
			git reset HEAD
			exit 1
		fi
	else
		git diff --name-only --diff-filter=M | xargs git add
	fi
	
	if [ "$message" != "" ]
	then
		git commit -m "$message"
	else
		git commit --allow-empty-message -m ""
	fi
	
	if [ "$?" -eq 0 ];
	then
		echo "Committed Successfuly!"
	else
		echo -e "\n\t\e[41mCommit Failed!\e[0m\n"
		git reset HEAD
		exit 1
	fi


# an interface for push

elif [ "$1" = "--push" -o "$1" = "-ph" ];
then
	git push -u
	
	if [ "$?" -eq 0 ];
	then
		echo "Pushed Successfuly!"
	else
		echo -e "\n\t\e[41mPush Failed!\e[0m\n"
		exit 1
	fi
	
# an interface for first push

elif [ "$1" = "--push-first" -o "$1" = "-phf" ];
then
	if [ $# -ge 2 ]
	then
		branch="$2"
	else
		branch="master"
	fi
	
	git push origin $branch
	
	if [ "$?" -eq 0 ];
	then
		echo "Pushed Successfuly to branch : $branch!"
	else
		echo -e "\n\t\e[41mPush Failed!\e[0m\n"
		exit 1
	fi


# an interface for pull

elif [ "$1" = "--pull" -o "$1" = "-pl" ];
then
	git pull
	
	if [ "$?" -eq 0 ];
	then
		echo "Pulled Successfuly!"
	else
		echo -e "\n\t\e[41mPull Failed!\e[0m\n"
		exit 1
	fi


else
	echo -e "\n\t\e[41mError\e[0m : Cannot understand options\n"
fi


# exiting without errors ( yay! )

exit 0

