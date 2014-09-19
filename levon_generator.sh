#!/bin/bash
##init
PART_TYPE="$1"
	BROWSER_TYPE="$2"
init()
{
	
		FILE_NAME=`whoami`_software_info.html
		cp start.html $FILE_NAME
}

##Software Informacion
software_info()
{
	echo "<h1><i><font color=":#00FFCC">Software Info</h1></font></i>" >> $FILE_NAME
}
##Showing user name
show_username()
{	
	echo "<i><b><font size="2">User: </i><b>"`whoami`"</font><i></b>" >> $FILE_NAME   
		echo "<br/>" >> $FILE_NAME
}
##What operating system using
operating_system()
{	
	echo "Description:"`lsb_release -d  | cut -f2` >> $FILE_NAME     

		echo "<br/>" >> $FILE_NAME
}
##central processor type
kernel_architecture()
{
	echo "Kernel Architecture: " >> $FILE_NAME
		ARCH1=`uname -i`
		if [ "$ARCH1" == "i386" ]
			then
				echo "<b>32bit</b>" >> $FILE_NAME
		else
			echo "<b>64bit</b>" >> $FILE_NAME
				fi

				echo "<br/>" >> $FILE_NAME
}
##kernel type
kernel()
{
	echo "<i>Kernel: </i><b> "`uname -s` `uname -r`"</b>" >> $FILE_NAME
		echo "<br/>" >> $FILE_NAME
}
##codename
codename()
{
	lsb_release -c >> $FILE_NAME
		echo "<br/>" >> $FILE_NAME
}
##desktop environment (DE) is an implementation of the desktop metaphor made of a bundle of programs running on top of a computer operating system
desktop_enviroment()
{	
	echo "<i>Desktop Environment: </i><b>${DESKTOP_SESSION}</b>" >> $FILE_NAME
}
##Hardware Information
hardware_info()
{
	echo "<h1><font color=":#00FFCC">Hardware Info</h1></font>" >> $FILE_NAME
}
##Ram
memory()
{
	echo "<i>Memory: </i><b>" >> $FILE_NAME
		free -m | grep Mem > Memory
		awk ' {print $2} ' Memory >> $FILE_NAME
		rm Memory
		echo  "MB</b>" >> $FILE_NAME
		echo "</br>" >> $FILE_NAME
}
##Processor Type
processor()
{
	echo "<i>Processor<i>  `grep "model name" /proc/cpuinfo > processor
		sort processor | uniq | cut -f2` ">> $FILE_NAME
		rm processor
		echo "</br>" >> $FILE_NAME
}
##Number of cores
cpu_cores()
{
	echo "<i>cpu cores</i>"":"  >> $FILE_NAME
		echo ` nproc`  >> $FILE_NAME
		echo "</br>" >> $FILE_NAME
}
##Hard disk size
disk_size()
{
	echo "Hard Disk:" `lsblk | grep disk | awk ' {print $4} '` >>$FILE_NAME
		echo "</br>" >> $FILE_NAME
}
##Information about pc network conections
network_info()
{
	echo "<h1><font color=":#00FFCC"> Network Info</h1></font>" >> $FILE_NAME
}
##Router or a proxy server that routes between network
gateway()
{
	echo "<b><i><font size="2">Gateway"  `route -n | grep 'UG[ \t]' | awk '{print $2}' `"</font></i></b>" >>$FILE_NAME
}
##eth-Ethernet is a family of computer networking technologies for local area (LAN) and larger network
##lo- links two or more devices using some wireless distribution method
##wlan
connections()
{
	LEVON=`/sbin/ifconfig | tr -s ' ' | cut -f 1 -d ' ' `
		for i in $LEVON
			do
				echo "</br>" >> $FILE_NAME   
					echo "<h2>$i</h2>" >> $FILE_NAME
					echo "</br>" >> $FILE_NAME
					HWadd=$( /sbin/ifconfig $i | grep HWaddr ) #>> $FILE_NAME
					if [ -n "$HWadd" ]
						then

							echo "<i>MacAdress:</i>" `/sbin/ifconfig $i | grep  HWaddr | awk ' {print $5}'` >> $FILE_NAME 
							echo "</br>" >> FILE_NAME
							fi
							INET=$(/sbin/ifconfig $i | grep "inet addr") #>> $FILE_NAME
							if [ -n "$INET" ]
								then
									echo "Ip Adress:"`/sbin/ifconfig $i | grep "inet addr" | awk ' {print $2	}' | cut -c 6-` >> $FILE_NAME
									echo "</br>" >> $FILE_NAME
									if [ $i=="lo" ]
										then
											echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'` >> $FILE_NAME
											echo "</br>" >>$FILE_NAME
									else
										echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'` >> $FILE_NAME
											echo "</br>" >>$FILE_NAME
											echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $4}'` >> $FILE_NAME
											echo "</br>" >>$FILE_NAME		
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
		[-a] - all information
		[-s] - information about software
		[-h] - informatin about hardware
		[-n] - information about network
		u can choose which what browser u want to open information
		chrome - opening with chromium browser
		firefox - opening with mozila firefox browser
		terminal - openin in terminal
		example - [script name] [-a] [firefox]"


}


#part
part_of_script()
{
	if [ "$PART_TYPE" == "-a" ]
		then
			software_main
			hardware_main
			network_main
			elif [ "$PART_TYPE" == "-s" ]
			then
			software_main
			elif [ "$PART_TYPE" == "-h" ]
			then
			hardware_main
			elif [ "$PART_TYPE" == "-n" ]
			then
			network_main
			elif [ "$PART_TYPE" == "--help" ]
			then
			HELP2
			exit 0
	else
		HELP1
			exit 0	

			fi
}
##opening type
show()
{ 
	echo $BROWSER_TYPE
		if [ "$BROWSER_TYPE" == "firefox" ]
			then
				/usr/bin/firefox $FILE_NAME
				elif [ "$BROWSER_TYPE" == "chrome" ]
				then
				/usr/bin/chromium-browser $FILE_NAME
				elif [ "$BROWSER_TYPE" == "terminal" ]
				then
				cat $FILE_NAME
		else
			HELP1

				fi

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
	init


		part_of_script
		cat  end.html >> $FILE_NAME
		show  
}


main



