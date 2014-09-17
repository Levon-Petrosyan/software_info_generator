#!/bin/bash
##init

	BROWSER_TYPE="$1"
init()
{
	echo "Start Generation"
		FILE_NAME=`whoami`_software_info.html
		cp start.html $FILE_NAME
}

##Software Informacion
software_info()
{
	echo "<h1>Software Info.</h1>" >> $FILE_NAME
}
##Showing user name
show_username()
{	
	echo "<i><font size="=3">User: </i><b>"`whoami`"</b>" >> $FILE_NAME   
		echo "<br/>" >> $FILE_NAME
}
##What operating system using
operating_system()
{	
	echo "<i>Description: </i><b>"`lsb_release -d  | cut -f2`"</b>" >> $FILE_NAME     

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
	echo "<h1>Hardware Info</h1>" >> $FILE_NAME
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
	echo "<h2> Network Info:</h2>" >> $FILE_NAME
}
##Router or a proxy server that routes between network
gateway()
{
	echo "Gateway"  `route -n | grep 'UG[ \t]' | awk '{print $2}' ` >>$FILE_NAME
		echo "</br>" >> $FILE_NAME
}
#echo "<b>"`/sbin/ifconfig | grep eth | awk ' {print $1'}`"</b>" >> $FILE_NAME
#echo "</br>" >> $FILE_NAME
#echo "<i>MacAdress:</i>" >> $FILE_NAME `/sbin/ifconfig -a | grep HWaddr >macadress
#head -1 macadress |  awk ' {print $5 '}` >> $FILE_NAME
#echo "<h3>lo</h3>" >>$FILE_NAME
#echo "<i>Ip Adress:</i>"  `/sbin/ifconfig lo |grep "inet addr" | cut -b 21-` >> $FILE_NAME
#wifi=`head -2 macadress`
#if [ "$wifi" != null ]
#then
#echo "WIfI KA" >> $FILE_NAME
#else
#echo "No Wifi conection" >> $FILE_NAME
#fi
#rm macadress


##eth-Ethernet is a family of computer networking technologies for local area (LAN) and larger network
##lo- links two or more devices using some wireless distribution method
##wlan
connections()
{
	LEVON=`/sbin/ifconfig | tr -s ' ' | cut -f 1 -d ' ' `
		for i in $LEVON
			do

				echo $i >> $FILE_NAME
					echo "</br>" >> $FILE_NAME
					HWadd=$( /sbin/ifconfig $i | grep HWaddr ) #>> $FILE_NAME
					if [ -n "$HWadd" ]
						then

							echo "MacAdress:" `/sbin/ifconfig $i | grep  HWaddr | awk ' {print $5}'` >> $FILE_NAME 
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
			echo "select chrome or firefox and terminal"


				fi

}


#Entry point
main()
{
	init
		software_info
		show_username
		operating_system
		kernel_architecture
		kernel
		codename
		desktop_enviroment
		hardware_info
		memory
		processor
		cpu_cores
		disk_size
		network_info
		gateway
		connections
		cat end.html >> $FILE_NAME
		show 
}


main



