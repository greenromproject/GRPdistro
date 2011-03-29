
###
###  GRP http://greenromproject.com/
###
###  before you run this script run these commands
###
###  chmod a+x debsetup.sh
###  sudo su
###  ./debsetup.sh
###
#check for root
if [ $USER = "root" ]; then
	
	#/etc/rc.local is a script that is executed on every boot anything in this script will be persistant through reboots
	#remove exit 0 from rc.local so we can append before script exits
	sudo ed -s /etc/rc.local <<< $'g/exit 0/d\nw'	
	#this forces any wireless soft switches 'ON' just in case	
	sudo echo nmcli nm wifi on >> /etc/rc.local
	sudo echo "PATH=$PATH:/home/$SUDO_USER/bin" >> /etc/rc.local  #if we decide on a single path this can also point to adb.
	#replace exit status to rc.local
	sudo echo "exit 0" >> /etc/rc.local
	


############################################
# What else does everyone want to do here? #
############################################


	#no error exit status
	exit 0
  else
	echo "This script requires root access"
	#exit status reflects script failure
	exit 1
fi
