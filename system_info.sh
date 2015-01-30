#!/bin/bash

##arguments into varibles
arg=$1
no_arg=$2
        	

##Print user name
username()
{	
	printf "\t\t\t User: \t\t\t `whoami`\n "  
}

##Print operating system name
operating_system()
{	
	printf "\t\t\t Description: \t\t `lsb_release -d  | cut -f2`\n"      
}

##Print architecure type
architecture_type()
{
	ARCH1=`uname -i`
		if [ "$ARCH1" == "i386" ]
			then
				printf "\t\t\t Kernel Architecture:\t 32bit\n"
		else
			printf "\t\t\t Kernel Architecture:\t 64bit\n"
				fi
}

##Print kernel type
kernel()
{
	printf "\t\t\t Kernel:\t\t `uname -s` `uname -r`\n"
}

##Print codename
codename()
{
	printf "\t\t\t Codename:\t\t `lsb_release -c | awk ' {print $2'}`\n" 
}

##Print desktop environment 
desktop_enviroment()
{	
	printf "\t\t\t Desktop Environment:\t ${DESKTOP_SESSION}\n"
}

##Random access memory
memory()
{
	printf "\t\t\t Memory:\t\t ` free -m | grep Mem > Memory   
 awk ' {print $2} ' Memory`"  
   printf "MB\n"
rm Memory 
}

##Print processor Type
processor()
{
	printf "\t\t\t Processor:\t\t`cat /proc/cpuinfo | grep "model name" | head -1 | cut -f2 | cut -b 2-`\n"
}

##Number of cores
cpu_cores()
{
	printf "\t\t\t Cpu cores:\t\t `nproc`\n"  
}

##Hard disk size
disk_size()
{
	printf  "\t\t\t Hard Disk:\t\t `lsblk | grep disk | awk ' {print $4} '`\n" 

}

##Router or a proxy server that routes between network
gateway()
{
	printf  "\t\t\t Gateway:\t\t `route -n | grep 'UG[ \t]' | awk '{print $2}' `\n" 
}

##Print information about eth,lo and wlan
network_interface()
{
	LEVON=`/sbin/ifconfig -a | tr -s ' ' | cut -f 1 -d ' ' `
		for i in $LEVON
			do	
				printf "\n \t\t\t $i \n\n "   
					HWadd=$( /sbin/ifconfig $i | grep HWaddr ) 
					if [ -n "$HWadd" ]
						then
							printf "\t\t\t MacAdress:\t\t `/sbin/ifconfig  $i | grep  HWaddr | awk ' {print $5}'`\n" 
							fi
							INET=$(/sbin/ifconfig  $i | grep "inet addr") 
							if [ -n "$INET" ]
								then
									printf "\t\t\t Ip Adress:\t\t `/sbin/ifconfig  $i | grep "inet addr" | awk ' { print $2 }' | cut -c 6-`\n" 
									if [ "$i" = "lo" ]
										then
											printf " \t\t\t Mask:\t\t\t `/sbin/ifconfig  $i | grep "inet addr" | awk ' {print $3}' | grep Mask | cut -b 6-`\n"                            


									else
										printf "\t\t\t Broadcast:\t\t `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}' | cut -b 7-`\n"

				printf " \t\t\t Mask:\t\t\t `/sbin/ifconfig  $i | grep "inet addr" | awk ' {print $4}' | cut -b 6-`\n"
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

	echo -e "\n\t\t\t\t\t\e[34mSoftware Info\e[0m\n"
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
	echo -e "\n\t\t\t\t\t\e[32mHardware info\e[0m\n "
		memory
		processor
		cpu_cores
		disk_size
}

##network main
network_info()
{
	echo -e "\n\t\t\t\t\t\e[31mNetwork Info\e[0m\n"	
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
  	
# vim:et:tabstop=4:shiftwidth=4:cindent:fo=croq:textwidth=80:

