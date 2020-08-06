### parse file header
### remove file header, create new file with the main content
# sed -n '开始行数,结束行数p'  待截取的文件  >> 保存的新文件
#sed -i '1,7d' Bloomberg_Sample_Attribution_Report.csv > 2.csv  
##sed -n '1,7d' Bloomberg_Sample_Attribution_Report.csv > 2.csv  
#sed -i '1d' temp.txt
#sed -i '1,7d' temp.txt
#sed -i '$d' temp.txt
#
# n = wc -l 
# tail -( n -7 ) > new file
### write headers to end of each row
### read level 1 field, write to end of each row

# create a copy for processing
cp $1 temp1.csv

# remove header
sed -i '1,7d' temp1.csv
# remove trailer
sed -i '$d' temp1.csv

#remove double quote and the comma in between
#more temp1.csv | awk -F"\"" '/".*"/ {gsub(",","",$2); print $1$2$3} {print $0}' > temp2.csv
more temp1.csv | awk -F"\"" ' !/.*".*/ {print $0} /".*"/ {gsub(",","",$2); print $1$2$3}' > temp2.csv

#create a test file with only 4 records
sed -n '1,4p' temp1.csv > test_temp.csv

#
#NME=$1
#echo $NME

# parse header values into variables
eval `sed -n '1p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print "RPT_NME=" $1}'`
eval `sed -n '2p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print "PORTFOLIO=" $1}'`
eval `sed -n '3p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print "BENCHMARK=" $1}'`
eval `sed -n '4p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print "RUN_DT=" $1}'`
PERIOD=$(sed -n '5p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print $1}')
eval `sed -n '6p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print "CURRENCY=" $1}'`
CLASSIFICATION=$(sed -n '7p' $1 | awk -F ": " '{print $2}' | awk -F "," '{print $1}')

# append header values, also copy sectors to below rows.
awk -F "," -v OFS=',' '{if($1==1){a=$2;print $2,"'"$RPT_NME"'","'"$PORTFOLIO"'","'"$BENCHMARK"'","'"$RUN_DT"'","'"$PERIOD"'","'"$CURRENCY"'","'"$CLASSIFICATION"'",$0} else {print a,"'"$RPT_NME"'","'"$PORTFOLIO"'","'"$BENCHMARK"'","'"$RUN_DT"'","'"$PERIOD"'","'"$CURRENCY"'","'"$CLASSIFICATION"'",$0}}' temp2.csv > final.csv
# do the same for test file
#awk -F "," -v OFS=',' '{if($1==1){a=$2;print $2,"'"$RPT_NME"'","'"$PORTFOLIO"'","'"$BENCHMARK"'","'"$RUN_DT"'","'"$PERIOD"'","'"$CURRENCY"'","'"$CLASSIFICATION"'",$0} else {print a,"'"$RPT_NME"'","'"$PORTFOLIO"'","'"$BENCHMARK"'","'"$RUN_DT"'","'"$PERIOD"'","'"$CURRENCY"'","'"$CLASSIFICATION"'",$0}}' test_temp.csv > test_result.csv


# other test statements
#awk -F "," -v OFS=',' '{a=$2;if($1==1){a=$2;print 5} else {print a}}' new_temp.csv
#more temp.csv | grep Consumer | awk -F"\"" '/".*"/ {gsub(",","",$2); print $1$2$3}'  
#more doub.csv | awk -F"\"" ' !/.*".*/ {print $0} /".*"/ {gsub(",","",$2); print $1$2$3}' 
