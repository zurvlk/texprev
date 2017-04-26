#!/bin/bash
# see also http://mizti.hatenablog.com/entry/2013/01/27/204343
# see also http://qiita.com/tamanobi/items/74b62e25506af394eae5
usage() {
  echo "任意のtexファイルを監視し、更新時にpdfファイルを自動生成します"
}
update() {
  echo `openssl sha256 -r $1 | awk '{print $1}'`
}
if [ $# -ne 1 ];
then
  usage
  exit 1
fi

INTERVAL=1 #監視間隔(ｓｅｃ)
no=0
last=`update $1`
while true;
do
  sleep $INTERVAL
  current=`update $1`
  if [ "$last" != "$current" ];
  then
    nowdate=`date '+%Y/%m/%d'`
    nowtime=`date '+%H:%M:%S'`
    echo -e "\n\e[33m[[ no:$no\tdate:$nowdate\ttime:$nowtime\tfile:$1 ]]\e[m\n"
    #eval $2

 	filename=`echo ${1%.tex}_preview`

	cp $1 `echo $filename.tex`
	platex `echo $filename.tex`
	dvipdf `echo $filename.dvi`
    last=$current
    no=`expr $no + 1`
  fi
done
