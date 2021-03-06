#!/bin/bash
PROGNAME="GreenRomProject Overlay"
STATE="Stable and growing"
grptemp="/home/$USER/.grptemp"
buildpath="/home/$USER/android/system"
devpath="/home/$USER/Desktop/dev/grp"

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
	echo -e "\t-g		... Clones GreenRomProject Overlay to $devpath"
	echo -e "\t-u		... Install/Update git\n\n"
	echo -e "EXIT STATUSES check exit status after script exits: echo \$?"
	echo -e "0 = Success"
	echo -e "1 = Oops root user detected ERROR"
	echo -e "2 = Usage syntax ERROR"
	echo -e "3 = chown ownership fix failed"
	echo -e "4 = No useage MUST HAVE ARGUMENT see grp.sh --help"
}
while getopts "ovgu" opt
do
	case $opt in
	v) set -x ;;
	o) sudo chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/android 
	   sudo chmod -R 777 $buildpath
	   out=$?
	   if [ $out = "1" ]; then
   		echo "A problem has arised while attempting to change ownership of the code @ /home/$USER/android/"
	   fi
		exit 3 ;;
	g) mkdir -p $devpath
	   cd $devpath
	   #avoid ownership and permission issues
	   sudo chmod -fR 777 $buildpath
	   sudo chown -R $SUDO_USER:$SUDO_USER $devpath
	   #remove old source so git clone does not complain about existing repos
								#KEEP ME IN ORDER
	   rm -r $devpath/android_packages_apps_Protips		#1 Protips
	   rm -r $devpath/android_vendor_greenromproject	#2 GRP Overlay
	   rm -r $devpath/android_device_motorola_sholes	#3 motorola sholes overlay
	   rm -r $devpath/android_build				#4 build system
	   rm -r $devpath/android_device_htc_glacier		#5 htc glacier overlay
	   rm -r $devpath/android_frameworks_base		#6 frameworks/base
	   rm -r $devpath/GRPmanifest				#7 GRPmanifest
	   rm -r $devpath/GRPdistro				#8 GRPdistro
	   #get new code for dev
	   git clone https://github.com/greenromproject/android_packages_apps_Protips.git	#1 Protips
	   git clone https://github.com/greenromproject/android_vendor_greenromproject.git 	#2 grp overlay
	   git clone https://github.com/greenromproject/android_device_motorola_sholes.git 	#3 motorola sholes overlay
	   git clone https://github.com/greenromproject/android_build.git 			#4 build system
	   git clone https://github.com/greenromproject/android_device_htc_glacier.git		#5 htc glacier overlay
	   git clone https://github.com/greenromproject/android_frameworks_base.git 		#6 Frameworks/base
	   git clone https://github.com/greenromproject/GRPmanifest.git				#7 GRPmanifest
	   git clone https://github.com/greenromproject/GRPdistro.git				#8 GRPdistro
	   out=$?
           if [ $out = "0" ]; then
		echo "GRP repo has been cloned to hidden temp directory $grptemp"
	     else
		echo "Failed to clone repo"
		echo "Exit Status $out"
	   fi ;;
	u) sudo apt-get install git ;;
	*) usage ; exit 2 ;;
	esac
done
STOP="true"
if [ "$STOP" = "true" ]; then
	echo -e "\nThis part of the script has outlived its usefullness the useage -g is VERY helpful to keep up with GRP developement\n\n\n For more information try grp.sh --help"
	exit 4
  else
mkdir -p $grptemp #hidden temp directory ;; deleted later
cd $grptemp

#group all repo clones together and keep order for ref
git clone https://github.com/greenromproject/android_packages_apps_Protips.git	#1 Protips
git clone https://github.com/greenromproject/android_vendor_greenromproject.git #2 grp overlay
git clone https://github.com/greenromproject/android_device_motorola_sholes.git #3 motorola sholes overlay
git clone https://github.com/greenromproject/android_build.git 			#4 build system
git clone https://github.com/greenromproject/android_device_htc_glacier.git	#5 htc glacier overlay
chmod -R 777 $buildpath #prevents read/write protection permission prompts

#group all deletes together and keep order for ref
rm -r $buildpath/packages/apps/Protips	#1 Protips
#don't need to delete we can just add to this directory #2 grp overlay
rm -r $buildpath/device/motorola/sholes #3 motorola sholes overlay
rm -r $buildpath/build #4 build system
rm -r $buildpath/device/htc/glacier #5 htc glacier overlay


#group all copies together and keep order for ref
cp -r $grptemp/android_packages_apps_Protips $buildpath/packages/apps/Protips #1 Protips
cp -r $grptemp/android_vendor_greenromproject $buildpath/vendor/greenrDeomproject #2 grp overlay
cp -r $grptemp/android_device_motorola_sholes $buildpath/device/motorola/sholes #3 motorola sholes overlay
cp -r $grptemp/android_build $buildpath/build #4 build system
cp -r $grptemp/android_device_htc_glacier $buildpath/device/htc/glacier #5 htc glacier overlay

#clean up
chmod -R 777 $grptemp #prevents read/write protection permission prompts
rm -fr $grptemp

exit 0
fi
