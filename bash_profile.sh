#@IgnoreInspection BashAddShebang
# Set architecture flags export
ARCHFLAGS="-arch x86_64"
#
# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:$HOME/git/qe-tools/bin:$HOME/git/QAA/jenkins/BuildScripts/ios_app:$PATH
#
# update code sign allocate for xcode sym link
export CODESIGN_ALLOCATE="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/codesign_allocate"
#
# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc
#
# Load RVM into a shell session *as a function*
#
export M2_HOME=`brew --prefix maven`/libexec
export M2=$M2_HOME/bin
export JAVA_HOME=$(/usr/libexec/java_home)
#
# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
#
# oracle path stuff
export DYLD_LIBRARY_PATH=/opt/oracle/instantclient_11_2:$DYLD_LIBRARY_PATH
export PATH=/opt/oracle/instantclient_11_2:$PATH
export ORACLE_HOME=/opt/oracle/instantclient_11_2
export OCI_DIR=$ORACLE_HOME
#
# db2 path stuff
DB2HOME="/Users/db2inst1/sqllib"
export DYLD_LIBRARY_PATH="$DB2HOME/lib64:$ORACLE_HOME:$DYLD_LIBRARY_PATH"
export IBM_DB_HOME="$DB2HOME"
#
# Docker Variables
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
#
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#
# Alias Helpers
alias qaa='cd ~/git/QAA'
alias ios='cd ~/git/ios-app'
alias bp='cat ~/.bash_profile'
alias ebp='vim '$HOME'/.bash_profile'
alias build_mcom='build_app mcom update'
alias build_bcom='build_app bcom update'
alias code='cd ~/Code'
alias mcom_irb="CALABASH_FULL_CONSOLE_OUTPUT=1 APP_BUNDLE_PATH=$HOME'/git/QAA/test_servers/MCOM QA.app' DEVICE_TARGET=simulator DEVICE_ENDPOINT='http://localhost:37265' DEBUG=1 calabash-ios console"
alias start_mcom="echo 'start_test_server_in_background' | mcom_irb && mcom_irb"
alias bcom_irb="CALABASH_FULL_CONSOLE_OUTPUT=1 APP_BUNDLE_PATH=$HOME'/git/QAA/test_servers/BCOM QA.app' DEVICE_TARGET=simulator DEVICE_ENDPOINT='http://localhost:37265' DEBUG=1 calabash-ios console"
alias start_bcom="echo 'start_test_server_in_background' | bcom_irb && bcom_irb"
alias glog='git log --oneline --decorate --all --graph'
alias rcop='rake app:ios:rubocop'
alias push='git-review'

