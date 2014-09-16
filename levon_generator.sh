#!/bin/bash 
echo "Start Generation"
FILE_NAME=`whoami`_software_info.html
cp start.html $FILE_NAME

echo "<h1>Software Info.</h1>" >> $FILE_NAME
echo "<i><font size="=3">User: </i><b>"`whoami`"</b>" >> $FILE_NAME   
echo "<br/>" >> $FILE_NAME

echo "<i>Description: </i><b>"`lsb_release -d  | cut -f2`"</b>" >> $FILE_NAME     

echo "<br/>" >> $FILE_NAME
echo "Kernel Architecture: " >> $FILE_NAME
ARCH1=`uname -i`
if [ "$ARCH1" == "i386" ]
then
echo "<b>32bit</b>" >> $FILE_NAME
else
echo "<b>64bit</b>" >> $FILE_NAME
fi

echo "<br/>" >> $FILE_NAME
echo "<i>Kernel: </i><b> "`uname -s` `uname -r`"</b>" >> $FILE_NAME
echo "<br/>" >> $FILE_NAME
lsb_release -c >> $FILE_NAME
echo "<br/>" >> $FILE_NAME
echo "<i>Desktop Environment: </i><b>${DESKTOP_SESSION}</b>" >> $FILE_NAME
echo "<h1>Hardware Info</h1>" >> $FILE_NAME
echo "<i>Memory: </i><b>" >> $FILE_NAME
free -m | grep Mem > Memory
awk ' {print $2} ' Memory >> $FILE_NAME
rm Memory
echo  "MB</b>" >> $FILE_NAME

echo "</br>" >> $FILE_NAME
echo "<i>Processor<i>  `grep "model name" /proc/cpuinfo > processor
sort processor | uniq | cut -f2` ">> $FILE_NAME
rm processor

echo "</br>" >> $FILE_NAME
echo "<i>cpu cores</i>"":"  >> $FILE_NAME
echo ` nproc`  >> $FILE_NAME
echo "</br>" >> $FILE_NAME
echo "Hard Disk:" `lsblk | grep disk | awk ' {print $4} '` >>$FILE_NAME
echo "</br>" >> $FILE_NAME
echo "<h2> Network Info:</h2>" >> $FILE_NAME
echo "Geteway :"  `route -n | grep 'UG[ \t]' | awk '{print $2}' ` >>$FILE_NAME
echo "</br>" >> $FILE_NAME
echo "<b>"`/sbin/ifconfig | grep eth | awk ' {print $1'}`"</b>" >> $FILE_NAME
echo "</br>" >> $FILE_NAME
echo "<i>MacAdress:</i>" >> $FILE_NAME `/sbin/ifconfig -a | grep HWaddr >macadress
head -1 macadress |  awk ' {print $5 '}` >> $FILE_NAME
echo "<h3>lo</h3>" >>$FILE_NAME
echo "<i>Ip Adress:</i>"  `/sbin/ifconfig lo |grep "inet addr" | cut -b 21-` >> $FILE_NAME
wifi=`head -2 macadress`
if [ "$wifi" != null ]
then
echo "WIfI KA" >> $FILE_NAME
else
echo "No Wifi conection" >> $FILE_NAME
fi

rm macadress




LEVON=`/sbin/ifconfig | tr -s ' ' | cut -f 1 -d ' ' `
for i in $LEVON
do
echo $i
HWadd=$( /sbin/ifconfig $i | grep HWaddr )
	if [  -n "$HWadd"  ]
	then
	echo "MacAdress:" `/sbin/ifconfig $i | grep  HWaddr | awk ' {print $5}'` 
	fi
INET=$(/sbin/ifconfig $i | grep "inet addr")
	if [ -n "$INET" ]
	then
	echo "Ip Adress:"`/sbin/ifconfig $i | grep "inet addr" | awk ' {print $2	}' | cut -c 6-`
		if [ $i == "lo" ]
		then
		echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'`
		else
		echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $3}'`
		echo `/sbin/ifconfig $i | grep "inet addr" | awk ' {print $4}'` 
		fi
	fi
done
exit 0



cat end.html >> $FILE_NAME

/usr/bin/firefox $FILE_NAME

