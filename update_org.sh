#!/usr/bin/bash
#
# 20220211T042359
# Michael Powe
#
# Script to get the latest version of org from Savannah repo and run
# make on the new version. To clone, either pass in a new path on the
# command line, or delete the standard directory and clone without a
# new path. This will recreate the repo in its usual place. Set the
# variable $org_home to point to the full path to the local repo,
# including the 'org-mode' name of the repo itself. NOTE: no trailing
# backslash. Running without parameters shows the help text.
#
# ----------------------------------------------------------------
#			      Variables
# ----------------------------------------------------------------
org_home="/c/Users/micha/AppData/Roaming/.emacs.d/org-new/org-mode"
# parent of $org_home
org_new=${org_home%/*}
org_repo='git://git.savannah.gnu.org/emacs/org-mode.git'
org_make="/usr/bin/make"
org_type=""
org_command=""
# Define list of arguments expected in the input
optstring=":i:m:t:hr:"
# ----------------------------------------------------------------
#			      Functions
# ----------------------------------------------------------------
get_data(){

    if [ "$org_type" == "clone" ] ; then
	if [[ -n $org_new && -d $org_new ]] ; then
	    cd $org_new
	    $org_command
	    cd "$org_new/org-mode"
	    $org_make
	elif [ ! -d $org_new ] ; then
	    echo "$org_new does not exist. Please check your path."
	    exit 1
	else
	    # default value is the parent of standard $org_home
	    cd $org_new
	    $org_command
	    cd $org_home
	    $org_make
	fi
    elif [ "$org_type" == "pull" ] ; then
	cd $org_home
	org_status=$($org_command)

	if [ ! "$org_status" == "Already up to date." ] ; then
	    $org_make
	else
	    echo "New build not needed."
	fi
    fi
}

usage() {
cat << EOF

Usage: $(basename $0) [-imth]
   -i   [optional] directory in which org is installed, or to be installed.
   	Not needed if using the default directory.
   -m   [optional] location of make if not in standard path
   -t   'clone' create a new repo
   -t   'pull'  update existing repo
   -h   this help file
EOF
}
# ----------------------------------------------------------------
#			     Git 'er Done
# ----------------------------------------------------------------
if [[ ${#} -eq 0 ]]; then
    usage
    exit 1
fi

while getopts ${optstring} arg; do
  case "${arg}" in
      i) echo "setting org_home ..."
	 org_new=$OPTARG
	 ;;
      m) echo "setting org_make ..."
	 org_make=$OPTARG
	 ;;
      r) echo "setting new repo host ..."
	 if [[ -n "$OPTARG" && "$OPTARG" != "-*" ]] ; then
	     org_repo=$OPTARG
	 else
	     echo "Error! New repo missing!"
	     exit 1
	 fi
	 ;;
      t) echo "setting type to $OPTARG ..."
	 if [[ "$OPTARG" == "clone" ]] ; then
	     org_type=$OPTARG
	     org_command="git clone $org_repo"
	 elif [[ "$OPTARG" == "pull" ]] ; then
	     org_type=$OPTARG
	     org_command="git pull"
	 else
	     echo "Error! Unknown option."
	     exit 1
	 fi
	 ;;
      h) usage
	 ;;
      ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done

get_data

#-------------------------- End of Script ------------------------
