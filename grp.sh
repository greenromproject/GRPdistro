#!/bin/bash
PROGNAME="GreenRomProject Overlay"
STATE="Experimental"

#make executable: chmod a+x grp.sh
#this script doesn't need root for most of this so it will exit if root is present to avoid accidents
#

#check for root
	if [ $USER = "root" ]; then
		echo "script won't run as root as rm command can be dangerous to system"	
		exit 1
	fi

usage(){
	echo -e "$PROGNAME is currently in an $STATE state."
	echo -e "Usage: $PROGNAME [-v] [-o] [-g] [-u]"
	echo -e "*** script assumes location of CyanogenMod's source to be /home/$USER/android/system ***"
	echo -e "\t-v		... Most of the commands do not produce visual output.  This shows commands as executed"
	echo -e "\t-o		... Attempt to fix Ownership issues"
	echo -e "\t-g		... Clones GreenRomProject Overlay"
	echo -e "\t-u		... Install/Update git"
	echo -e "EXIT STATUSES"
	echo -e "0 = Success"
	echo -e "1 = Oops root user detected ERROR"
	echo -e "2 = Usage syntax ERROR"
	echo -e "3 = chown ownership fix failed"
}
while getopts "ovgu" opt
do
	case $opt in
	v) set -x ;;
	o) sudo chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/android 
	   out=$?
	   if [ $out = "1" ]; then
   		echo "A problem has arised while attempting to change ownership of the code @ /home/$USER/android/"
		exit 3;;
	g) mkdir -p /home/$USER/android/temp
	   cd /home/$USER/android/temp
	   git clone http://github.com/greenromproject/grp.git ###Currently doesn't exit yet
	   out=$?
           if [ $out = "0" ]; then
		echo "GRP repo has been cloned to /home/$USER/android/temp/"
	     else
		echo "Failed to clone repo"
		echo "Exit Status $out"
	   fi
	u) sudo apt-get install git ;;
	*) usage ; exit 2 ;;
	esac
done

mkdir -p /home/$USER/android/temp
cd /home/$USER/android/temp
git clone http://github.com/greenromproject/grp.git ###Currently doesn't exit yet
rm #CM's version of stuff we themed ;; this may be removed if cp --force works as it's help advertises
cp -r #our stuff to the build directories ;; usage cp SOURCE DESTINATION
rm -r /home/$USER/android/temp #clean up
exit 0
