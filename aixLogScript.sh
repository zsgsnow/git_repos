#!/usr/bin/ksh
host=`hostname`
date_str=`date +"%Y%m%d"`
file=${host}.${date_str}.txt
echo "#hostname#" >> $file
hostname >> $file
echo >> $file
echo "#uname -Mu#" >> $file
uname -Mu >> $file
echo >> $file
echo "#netstat -in#" >> $file
netstat -in >>$file
echo >> $file
echo "#netstat -rn#" >> $file
netstat -rn >>$file
echo >> $file
echo "#errpt#" >>$file
errpt >>$file
echo >> $file
echo "#df -k#" >>$file
df -k >>$file
echo >> $file
echo "#lsvg -o#" >>$file
lsvg -o >>$file
echo >> $file
echo "#lsvg -o|lsvg -il#" >>$file
lsvg -o|lsvg -il >>$file
echo >> $file
echo "#lsps -a#">>$file
lsps -a >>$file
echo >> $file
echo "#lsps -s#">>$file
lsps -s >>$file
echo >> $file
echo "#df -k#">>$file
df -k >>$file
echo >> $file
echo "#lsdev -Cc disk#">>$file
lsdev -Cc disk >>$file
echo >> $file
echo "#lscfg -l hdisk*#">>$file
lscfg -l hdisk* >>$file
echo >> $file
echo "#lsdev -Cc processor#">>$file
lsdev -Cc processor>>$file
echo >> $file
echo "#lsdev -Cc memory#">>$file
lsdev -Cc memory >>$file
echo >> $file
echo "#lsattr -El mem0#">>$file
lsattr -El mem0>>$file
echo >> $file
echo "#vmstat 1 10#">>$file
vmstat 1 10 >>$file
echo >> $file
echo "#iostat 2 5#">>$file
iostat 2 5 >>$file
echo >> $file
echo "# cat /etc/hosts#" >>$file
cat /etc/hosts >>$file
echo >> $file
echo "#oslevel -r#">>$file
oslevel -r >>$file
echo >> $file
echo "#oslevel -s#">>$file
oslevel -s >>$file
echo >> $file
echo "#instfix -i|grep ML#">>$file
instfix -i|grep ML >>$file
echo >> $file
echo "#lsmcode -c#">>$file
lsmcode -c >>$file
echo >> $file
echo #lssrc -g cluster#">>$file
lssrc -g cluster >>$file
echo >> $file
echo "#lslpp -l|grep cluster#">>$file
lslpp -l|grep cluster >>$file
echo >> $file
echo "#lsattr -El sys0#">>$file
lsattr -El sys0 >>$file
echo >> $file
echo "#uptime#">>$file
uptime >>$file
echo >> $file
echo "#prtconf#" >>$file
prtconf >>$file
echo >> $file
banner finish >>$file
