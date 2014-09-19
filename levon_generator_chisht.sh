#!/bin/bash


NUMBER=0
##Software Informacion
software_info()
{
	echo -e "\e[34mSoftware Info\e[0m"
}
##Showing user name
show_username()
{	
	echo "User:"`whoami`   

}
##What operating system using
operating_system()
{	
	echo "Description:"`lsb_release -d  | cut -f2`      


}
##central processor type
kernel_architecture()
{
	echo "Kernel Architecture: " 
		ARCH1=`uname -i`
		if [ "$ARCH1" == "i386" ]
			then
				echo "32bit"
		else
			echo "64bit"
				fi

}
##kernel type
kernel()
{
	echo "Kernel:"`uname -s` `uname -r`
}
##codename
codename()
{
	lsb_release -c 
}
##desktop environment (DE) is an implementation of the desktop metaphor made of a bundle of programs running on top of a computer operating system
desktop_enviroment()
{	
	echo "Desktop Environment:${DESKTOP_SESSION}"
}
##Hardware Information
hardware_info()
{
	echo -e "\e[32mHardware info\e[0m"
}
##Ram
memory()
{
	echo "Memory:" 
		free -m | grep Mem > Memory
		awk ' {print $2} ' Memory 
		rm Memory
		echo  "MB"
}
##Processor Type
processor()
{
	echo "Processor:  `grep "model name" /proc/cpuinfo > processor
		sort processor | uniq | cut -f2` "
		rm processor
		
}
##Number of cores
cpu_cores()
{
	echo "cpu cores:"  
		echo ` nproc`  
}
##Hard disk size
disk_size()
{
	echo "Hard Disk:" `lsblk | grep disk | awk ' {print $4} '` 

}
##Information about pc network conections
network_info()
{
		echo -e "\e[31mNetwork Info\e[0m"
}
##Router or a proxy server that routes between network
gateway()
{
	echo "Gateway"  `route -n | grep 'UG[ \t]' | awk '{print $2}' ` 
}
##eth-Ethernet is a family of computer networking technologies for local area (LAN) and larger network
##lo- links two or more devices using some wireless distribution method
##wlan
connections()
{
	LEVON=`/sbin/ifconfig | tr -s ' ' | cut -f 1 -d ' ' `
		for i in $LEVON
			do

				echo "$i" 
					HWadd=$( /sbin/ifconfig $i | grep HWaddr ) 
					if [ -n "$HWadd" ]
						then

							echo "MacAdress:" `/sbin/ifconfig $i | grep  HWaddr | awk ' {print $5}'` 
							fi
							INET=$(/sbin/ifconfig $i | grep "inet addr") 
							if [ -n "$INET" ]
								then
									echo "Ip Adress:"`/sbin/ifconfig $i | grep "inet addr" | awk ' {print $2	}' | cut -c 6-` 
									if [ $i=="lo" ]
										then
											echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'`
									else
										echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'` 
											echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $4}'` 
											fi
											fi
											done

}

#help

HELP1()
{
	echo "write --help to read tutorial"
}

HELP2()
{
	echo "This script can give you some information about your computer
	   Usage: [script name] [-a] [firefox]		
		[-a] - all information
		[-s] - information about software
		[-h] - informatin about hardware
		[-n] - information about network
		u can choose which what browser u want to open information
		chrome - opening with chromium browser
		firefox - opening with mozila firefox browser
		terminal - openin in terminal"
		


}



##software main
software_main()
{
	software_info
		show_username
		operating_system
		kernel_architecture
		kernel
		codename
		desktop_enviroment
}

##hardware main
hardware_main()
{
	hardware_info
		memory
		processor
		cpu_cores
		disk_size
}
##network main
network_main()
{
	network_info
		gateway
		connections
}
##Entry point
main()
{
A "$1" 
}
##arguments
A()
{
while getopts ":asrnh" Option 
do


case $Option in 

a ) software_main
hardware_main
network_main;;
s ) software_main ;;
r ) hardware_main;;
n ) network_main ;;
h ) HELP2;;	
*) HELP1
exit 0;;
esac
if [ "NUMBER" < 4 ]
then
NUMBER=$((NUMBER+1))
echo "$NUMbER"
exit 0
fi
#shift $(($OPTIND - 1))
#if [ "$#" > 4 ]
#then
#exit 0
#HELP1
#fi


done

exit 0
}
main "$@" 



