#!/usr/bin/bash

# Simple script to pull latest version of org from Savannah and make
# the updated version.

function usage {
        echo "Usage: $(basename $0) [-imth]" 2>&1
        echo '   -i   directory in which org is installed, or to be installed'
        echo '   -m   location of `make` if not in standard path'
        echo '   -t clone   if creating new repo'
        echo '   -t pull    if updating existing repo'
	echo '   -h         this help file'
        exit 1
}

org_git='https://git.savannah.gnu.org/cgit/emacs/org-mode.git'
org_make='/usr/bin/make'

# org_home is where the git repo is located or will be placed.
# commandline
# `-i <install-dir>`
# `-m <make-dir>`
# `-t <type=clone or pull>`
# `-t clone` means a first-time install,
# `-t pull` means update existing repo.

if [[ ${#} -eq 0 ]]; then
   usage
fi

# Define list of arguments expected in the input
optstring=":i:m:t:hr:"

while getopts ${optstring} arg; do
  case "${arg}" in
      i) echo "Option 'i' was called, setting org_home"
	 org_home=$OPTARG
	 echo "org_home is $org_home" ;;
      m) echo "Option 'm' was called, setting org_make"
	 org_make=$OPTARG
	 echo "org_make is $org_make" ;;
      r) echo "Option r was called, getting new repo host"
	 if [[ -n "$OPTARG" ]] ; then
	     org_git=$OPTARG
	     echo "git repo is $org_git"
	 else
	     echo "Error! New repo missing!"
	     exit 1
	 fi
	 ;;
      t) echo "Option 't' was called, setting type to $OPTARG"
	 if [[ "$OPTARG" == "clone" ]] ; then
	     org_type=$OPTARG
	     echo "We'll be cloning the repo"
	 elif [[ "$OPTARG" == "pull" ]] ; then
	     org_type=$OPTARG
	     echo "We'll be pulling the latest release"
	 else
	     echo "Error! Unknown option."
	     exit 1
	 fi ;;
      h) usage ;;
      ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done

if [[ "$org_type" == "clone" ]] ; then
    echo "now we are cloning the repo"
elif [[ "$org_type" == "pull" ]] ; then
    echo "now we are pulling the latest release"
fi

# ------------- end of script --------------
#
# "You can get the arguments as positional parameters with '$1', '$2',
# '$3', and so on You can dynamically get all of the positional
# parameters without having to count them with '$@' You can count the
# number of positional parameters if you need to with '$#'"
#
# if [[ $1 ]] ; then
#     org_home=$1
#     echo "org_home is $org_home"
# else
#     org_home='~/.emacs.d/org-new/org-mode'
#     echo "org_home is $org_home"
# fi
