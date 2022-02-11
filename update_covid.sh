#!/usr/bin/bash
#
# Manage the COVID repo from the NYT
# 20220211T101547
#
# Edit the script to set the default path for the repo.  The repo is
# named `covid-19-data`, so that should be the end of the path for
# $covid_home. The clone command will automatically start in its
# parent directory, unless you change directories with the `-i`
# option. If you clone without `-i`, it is assumed you have deleted
# the original clone and just want a new one. (Because git will not
# clone into an existing directory.)
#
# ----------------------------------------------------------------
#			      Variables
# ----------------------------------------------------------------
# NOTE: no trailing backslash
covid_home="/c/Users/micha/Dropbox/src/covid/covid-19-data"
# strips off the trailing piece of the path
covid_new_home=${covid_home%/*}
covid_repo="git@github.com:nytimes/covid-19-data.git"
covid_clone="git clone $covid_repo"
covid_pull="git pull"
covid_command=""
covid_process=""
# Define list of arguments expected in the input
optstring=":cphir:"
# ----------------------------------------------------------------
#			      Functions
# ----------------------------------------------------------------
usage() {
    cat << EOF

Usage: $(basename $0) [-chipr]
-i [optional]<install-dir> directory in which covid repo is installed,
   or to be installed. If you don't provide a value, the default will
   be used, so don't use it if you're not changing the install directory.
-c clone
-p pull
-r [optional]<repo-url> repo to be cloned/pulled. if this parameter is used,
   a value is required.
-h this help file
EOF

}

# Remember that the git command will run in a subshell, so you won't
# be changed into that directory yourself.

get_data(){
    if [[ $covid_process == "clone"  ]] ; then
	if [ -d $covid_new_home ] ; then
	    cd $covid_new_home
	else
	    echo "$covid_new_home does not exist. Please check your path."
	    exit 1
	fi
	$covid_command
    elif [[ $covid_process == "pull" ]] ; then
	cd $covid_home
	$covid_command
    elif [ "$#" -eq 0 ] ; then
	usage
	exit 0
    else
	echo "Something went horribly wrong getting data."
	exit 1
    fi
}
# ----------------------------------------------------------------
#			     Actual Work
# ----------------------------------------------------------------

# quit with help message if no parameters given
if [[ ${#} -eq 0 ]]; then
    usage
    exit 1
fi

while getopts ${optstring} arg; do
  case "${arg}" in
      c) echo "cloning ..."
	 covid_process="clone"
	 covid_command=$covid_clone
	 ;;
      p) echo "pulling ..."
	 covid_process="pull"
	 covid_command=$covid_pull
	 ;;
      r) echo "setting new repo host url ..."
	 if [[ -n "$OPTARG" ]] ; then
	     covid_repo=$OPTARG
	     echo "git repo is $covid_repo"
	 fi
	 ;;
      i) echo "cloning to new directory ..."
	 # stolen from StackOverflow: how to make a parameter argument
	 # optional, i.e., have a default value
	 nextopt=${!OPTIND}
	 # existing and not starting with dash?
	 if [[ -n $nextopt && $nextopt != -* ]] ; then
	     OPTIND=$((OPTIND + 1))
	     covid_new_home=$nextopt
	     echo "New install dir is now $covid_new_home"
	 else
	     echo "Install dir is still $covid_new_home"
	 fi
	 ;;
      h) usage
	 exit 0
	 ;;
      ?)
      echo "Invalid option: -${OPTARG}."
      echo
      exit 1
      ;;
  esac
done

get_data
