#!/bin/bash

# setting up GithubIt
# this will take the username and GitHub email from the user and save it in ".GitHubIt_config"
# this information will be used while pushing
if [ "$1" = "--setup" ];
	then
	read -p "Enter your name : " name
	read -p "Enter your GitHub email : " email
	echo "username $name" > .GitHubIt_config
	echo "email $email" >> .GitHubIt_config
fi

