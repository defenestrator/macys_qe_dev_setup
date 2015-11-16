#!/usr/bin/env bash
red=$'\e[31m'
grn=$'\e[32m'
red_bold=$'\e[1;31m'
yel=$'\e[33m'
blu=$'\e[34m'
mag=$'\e[35m'
cyn=$'\e[36m'
end=$'\e[0m'
###############################################################################
# A shell script to help QE folk set up their Mac development environment.    #
# An attempt to shorten the cycle between new-hire and useful asset.          #
###############################################################################
#
###############################################################################
# Interactively sets values for these variables before running this script    #
# Delete your password from this file when done so you don't get compromised. #
##########
#
echo -en "
        ${blu}This script will attempt to automate the installation and configuration
        of as many pre-requisites to starting your new job as a QE developer
        at${end} ${red}macys.com${end} ${blu}as is presently possible.${end}

        ${red_bold}Requirement:${end} ${blu}Mac OS X Mavericks (10.9) or higher.${end}

${grn}Enter your first and last name, human, then press${end} [ENTER]: "
read HUMAN_NAME
echo -n "${grn}Enter your RACFID and press${end} [ENTER]: "
read RACFID
echo -n "${grn}Enter your PASSWORD and press${end} [ENTER]: "
read PASSWORD
GERRIT_HOST="qagerrit"
###############################################################################
# Write .bash_profile and create setup.log                                                         #
###############################################################################
touch ./setup.log && LOG="setup.log" && cp ./bash_profile.sh ~/.bash_profile || echo "failed to write .bash_profile" >> $LOG ;
###############################################################################
# Install Essential Dependencies                                              #
###############################################################################
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && brew update && brew doctor || echo Homebrew installation FAILED >> $LOG &&
brew install git || echo Failed Git install is fail. >> $LOG;
curl -sSL https://get.rvm.io | bash -s stable || echo RVM install has failed. >> $LOG;
rvm install ruby-2.0.0-p643 || echo Failed to install Ruby 2.0.0 >> $LOG;
brew install python || echo Failed Python installation is fail. >> $LOG;
echo $PASSWORD | sudo -S pip install git-review || echo Failed Git-Reivew installation via pip. >> $LOG;
###############################################################################
# Configure $PATH variable                                                    #
###############################################################################
export PATH=/"/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bash_profile || echo 'failed to write new path paths to $PATH' >> $LOG;
###############################################################################
# Configure RVM/Ruby                                                          #
###############################################################################
rvm use 2.0.0 --default || echo 'set Ruby 2.0.0 as rvm default FAILED' >> $LOG;
###############################################################################
# Configure Git globals and directory for repos
# Clone Git repositories for QAA and Gerrit
###############################################################################
mkdir ~/git
git config --global user.name $HUMAN_NAME
git config --global user.email Jeremy.Anderson@macys.com
git config --global merge.tool kdiff3
git config --global --add gitreview.username $RACFID
echo "HERE IS YOUR GLOBAL GIT CONFIG:" >> $LOG && git config --global --list >> $LOG;
###############################################################################
# Generate SSH Key                                                            #
###############################################################################
ssh-keygen -t rsa -N ""
###############################################################################
# Configure Pre-commit hook for Gerrit                                        #
###############################################################################
scp -p -P 29418 $RACFID@qagerrit:hooks/commit-msg ~/git/QAA/.git/hooks/commit-msg || echo "failed to write git pre-commit message hook" >> $LOG;
###############################################################################
# Install and Configure Gems                                                  #
###############################################################################
gem install bundler || echo "Bundler Gem install failed." >> $LOG;
gem install calabash-cucumber || echo "Calabash Gem failed to install" >> $LOG;
###############################################################################
# Accept XCode License Agreement (or else!)                                   #
###############################################################################
echo $PASSWORD | sudo -S /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept || echo "XCode license agreement NOT accepted." >> $LOG;
###############################################################################
# Mount Share and run Ruby 2 DB Setup script.                                 #
###############################################################################
# @TODO: Figure out Samba Mounting Command for
open smb://$RACFID:$LOCAL_PASSSWORD@mcwgroups/mdc-document || echo "Samba Mount Failed" >> $LOG;
###############################################################################
# create or edit /etc/sysctl.conf
###############################################################################
echo $PASSWORD | sudo -S touch /etc/sysctl.conf && echo $PASSWORD | sudo -S echo "kern.sysv.shmmax=1073741824
kern.sysv.shmmin=1
kern.sysv.shmmni=4096
kern.sysv.shmseg=32
kern.sysv.shmall=1179648
kern.sysv.maxfilesperproc=65536
kern.sysv.maxfiles=65536" >> /etc/sysctl.conf || echo "Failed to write /etc/sysctl.conf" >> $LOG;
###############################################################################

cp "/Volumes/mdc-document/QAA team Setup Installers/Ruby200Upgrade/mac/db2_v101_macos_expc.tar.gz" ~/
tar -xvf ~/db_2v101_macosx_expc.tar.gz || echo "extract of db2 installer failed" >> $LOG;
#cd ~/expc && sudo ./db2_install || echo "failed to install db2";
bash ./install_ruby_gems.sh || echo "gems install script failed." >> $LOG;