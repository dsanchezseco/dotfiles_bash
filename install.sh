#!/bin/bash
set -e

# get working directory
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

# check the OS to edit the correct .bashrc or .bash_profile
if [[ "$OSTYPE" == "linux-gnu"* ]]
then
    echo "Detected system is Linux/GNU, we'll edit .bashrc..."
    CONFIG_FILE=".bashrc"
elif [[ "$OSTYPE" == "darwin"* ]]
then
    echo "Detected system is OSX, we'll edit .bash_profile..."
    CONFIG_FILE=".bash_profile"
fi

#  move the files to $HOME (hidden)
cp $THIS_DIR/aws_load_session.sh $HOME/.aws_load_session.sh
cp $THIS_DIR/git_branch_info.sh $HOME/.git_branch_info.sh
cp $THIS_DIR/bash_aliases $HOME/.bash_aliases
cp $THIS_DIR/artifactory_creds $HOME/.artifactory_creds

# if there's a backup of .bashrc override the content of the original
# else create the backup
if [ -e $HOME/${CONFIG_FILE}.bak ]
then
    cp $HOME/${CONFIG_FILE}.bak $HOME/${CONFIG_FILE}
else
    cp $HOME/${CONFIG_FILE} $HOME/${CONFIG_FILE}.bak
fi

# then add the content of concat2bashrc to the .bashrc file
cat $THIS_DIR/concat2bashrc >> $HOME/${CONFIG_FILE}


#OPTIONAL TODO: ask if use artifactory to create or not and populate the vars
cp $THIS_DIR/artifactory_creds $HOME/.artifactory_creds
echo "Remember to populate the $HOME/artifactory_creds file if needed"
