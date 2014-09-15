#!/bin/bash 
echo "Start Generation"
FILE_NAME=`whoami`_software_info.html
cp start.html $FILE_NAME

echo "<h1>Software Info.</h1>" >> $FILE_NAME
echo "<i>User: </i><b>"`whoami`"</b>" >> $FILE_NAME   
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
sort processor | uniq | cut -f2`" >> $FILE_NAME


echo "</br>" >> $FILE_NAME
echo "<i>cpu cores</i>"":"  >> $FILE_NAME
echo ` nproc`  >> $FILE_NAME
echo "</br>" >> $FILE_NAME
echo "Hard Disk:" `df -h | sed -n 2p | awk '{print $2}' >>$FILE_NAME`

echo "                          Network Info:"

echo "Geteway :"  `route -n | grep 'UG[ \t]' | awk '{print $2}'`

echo eth0

echo "MacAdress:"  `ifconfig eth0 | grep HWaddr | cut -d " " -f 11`

echo lo
echo "Ip Adress:"  `ifconfig lo |grep "inet addr" | cut -b 21-`


cat end.html >> $FILE_NAME

/usr/bin/firefox $FILE_NAME


