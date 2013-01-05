#!/bin/bash

# setting up GithubIt
# asks user whether he wants to use the global username and email or setup a new, local one
# then asks git to ignore this script AND ".gitignore"
if [ "$1" = "--setup" ];
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
	exit 0
fi

