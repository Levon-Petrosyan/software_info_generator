#!/bin/bash

##arguments into varibles
arg=$1
no_arg=$2


##Print user name
username()
{	
	echo "                       User:                    "`whoami`   
}

##Print operating system name
operating_system()
{	
	echo "                       Description:             "`lsb_release -d  | cut -f2`      
}

##Print architecure type
architecture_type()
{
		ARCH1=`uname -i`
		if [ "$ARCH1" == "i386" ]
		then
	               echo "                       Kernel Architecture:     32bit"
		else
			echo "                       Kernel Architecture:     64bit"
		fi
}

##Print kernel type
kernel()
{
	echo "                       Kernel:                  "`uname -s` `uname -r`
}

##Print codename
codename()
{
	echo "                       Codename:                "`lsb_release -c | awk ' {print $2'}` 
}

##Print desktop environment 
desktop_enviroment()
{	
	echo "                       Desktop Environment:     ${DESKTOP_SESSION}"
}

##Random access memory
memory()
{
	echo "                       Memory:                  "`	free -m | grep Mem > Memory
		awk ' {print $2} ' Memory 
		rm Memory
		echo "MB"`
}

##Print processor Type
processor()
{
	echo "                       Processor               `grep "model name" /proc/cpuinfo > processor
		                             sort                  processor | uniq | cut -b 13-` "
		rm processor
}

##Number of cores
cpu_cores()
{
	echo "                       cpu cores:               "`nproc`  
}

##Hard disk size
disk_size()
{
	echo "                       Hard Disk:               "`lsblk | grep disk | awk ' {print $4} '` 

}

##Router or a proxy server that routes between network
gateway()
{
	echo "                       Gateway:                "  `route -n | grep 'UG[ \t]' | awk '{print $2}' ` 
}

##Print information about eth,lo and wlan
network_interface()
{
	LEVON=`/sbin/ifconfig -a | tr -s ' ' | cut -f 1 -d ' ' `
		for i in $LEVON
		do		
			echo ""	
			echo -e "                       \033[1m$i\033[0m" 
			echo " "
			HWadd=$( /sbin/ifconfig $i | grep HWaddr ) 
				if [ -n "$HWadd" ]
				then
					echo "                       MacAdress:               "`/sbin/ifconfig  $i | grep  HWaddr | awk ' {print $5}'` 
				fi
				INET=$(/sbin/ifconfig  $i | grep "inet addr") 
					if [ -n "$INET" ]
					then
						echo "                       Ip Adress:               "`/sbin/ifconfig  $i | grep "inet addr" | awk ' { print $2 }' | cut -c 6-` 
							if [ "$i" = "lo" ]
							then
								echo "                       Mask:                    "`/sbin/ifconfig  $i | grep "inet addr" | awk ' {print $3}' | grep Mask | cut -b 6-`                            

 
							else
							echo "                       Broadcast:               "`/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}' | cut -b 7-`
 
							echo "                       Mask:                    "`/sbin/ifconfig  $i | grep "inet addr" | awk ' {print $4}' | cut -b 6-` 
							fi
					fi
		done
}

##Check if first character << - >>
cheking_minus()
{
	minus="$(echo $arg | head -c 1)"
		if [ "$minus" != "-" ]
		then
			secondary_help
			exit 0
		fi
}

##Checking if arg count is less then 5 (include "-")
cheking_count()
{
	count=${#arg}
		if [[ "$count" > "4" ]];
	        then
			secondary_help
			exit 0
		fi
}

##checking if one character is dublicated`
cheking_dublicate()
{
	for (( c=1; c<=${count}; c++ ))
		do
			dublicate=`grep -o "${arg:$c:1}" <<<"$arg" | wc -l`
				if [[ "$dublicate" > "1" ]];
				then
					secondary_help
	 				exit 0
				fi
	done
}

##cheking any command after choosing all[-a]
cheking_a()
{

 A="$(echo $arg | cut -b 2)"
                if [ "$A" = "a" ]
                then
			if [ -n "$(echo $arg | cut -b 3-4)" ]
			then
                    		secondary_help
                          	exit 0
                        fi
		fi

}

##cheking second argument 
second_argument()
{
	if [ -n "$no_arg" ]
	then
		secondary_help
		exit 0
	fi
}

##cheking any arguments aroud help
around_help()
{
	if [ "$arg" = "-h" ]
	then
		 chief_help 
		 exit 0
	fi
}


##cheking that  arguments right or wrong
right_argument()
{
	while getopts ":asrd" Option

    		 do

      	 	case $Option in
      			 a);;
      			 s);;
			 r);;
			 d);;
			 *)  secondary_help
			exit 0 ;;
	esac
	done 

}
##taking arguments and print outputs
process_system_info()
{
        OPTIND=1
        while getopts ":asrdh" Option 
		do
			case $Option in 

				a ) software_info
					hardware_info
					network_info;;
				s ) software_info ;;
				r ) hardware_info;;
				d ) network_info ;;
				h ) chief_help;;	
				*) secondary_help
	                	exit 0;;
	esac
	done

}

##Print information how to see chief help
secondary_help()
{
	echo "write -h (help) to read tutorial"
}

##Print information how to use program
chief_help()
{
	echo "This script can give you some information about your computer
		Usage: [script name] [-a] | 		
		[-a] - all information
		[-s] - information about software
		[-r] - informatin about hardware
		[-d] - information about network"

}

##software main
software_info()
{
        
        echo -e "\n                               \e[34mSoftware Info\e[0m\n"
	username
	operating_system
	architecture_type
	kernel
	codename
	desktop_enviroment
}

##hardware main
hardware_info()
{
	echo -e "  \n                              \e[32mHardware info\e[0m\n "
	memory
	processor
	cpu_cores
	disk_size
}

##network main
network_info()
{
		echo -e "\n                               \e[31mNetwork Info\e[0m\n"	
		gateway
		network_interface
}

##argument cheking
arg_check()
{
	second_argument
	cheking_minus
	around_help
	cheking_count
	cheking_dublicate
	cheking_a
	right_argument "$1"
}


##Entry point
main() 
{
	arg_check "$1"
	process_system_info "$1" 
}

main "$@" 

