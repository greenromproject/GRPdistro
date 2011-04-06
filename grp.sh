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
	echo -e "EXIT STATUSES check exit status after script exits: echo $?"
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
	   fi
		exit 3 ;;
	g) mkdir -p /home/$USER/.grptemp  #TODO may remove as this is the main action of the script
	   cd /home/$USER/.grptemp
	   git clone https://github.com/greenromproject/android_packages_apps_Protips.git
	   out=$?
           if [ $out = "0" ]; then
		echo "GRP repo has been cloned to hidden temp directory home/$USER/.grptemp"
	     else
		echo "Failed to clone repo"
		echo "Exit Status $out"
	   fi ;;
	u) sudo apt-get install git ;;
	*) usage ; exit 2 ;;
	esac
done

mkdir -p /home/$USER/.grptemp #hidden temp directory ;; deleted later
cd /home/$USER/.grptemp

#group all repo clones together and keep order for ref
git clone https://github.com/greenromproject/android_packages_apps_Protips.git	#1 Protips
git clone https://github.com/greenromproject/android_build.git #2 android_build

#group all deletes together and keep order for ref
rm -r /home/$USER/android/system/packages/apps/Protips	#1 Protips
rm -r /home/$USER/android/system/build #2 android_build

#group all copies together and keep order for ref
cp -r /home/$USER/.grptemp/android_packages_apps_Protips/ /home/$USER/android/system/packages/apps/Protips #1 Protips
cp -r /home/$USER/.grptemp/android_build /home/$USER/android/system/build #2 android_build

rm -fr /home/$USER/.grptemp #clean up

exit 0
