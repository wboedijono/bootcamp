#!\bin\bash

#variables
d=$1
t=$2
#commands
#grep -m1 "Hour" "$d"_Dealer_schedule | awk -F" " '{print $3,$4,$5,$6,$7,$8}';
#echo "Date: ""$d"
#echo "Time: ""$t"
result1=$(grep -m1 '^Hour' "$d"_Dealer_schedule)
result2=$(grep -iF "$t" "$d"_Dealer_schedule | wc -l)
result3=$(grep -iF "$t" "$d"_Dealer_schedule | awk -F" " '{print $1,$2,$3,$4,$5,$6,$7,$8}')

#print  output
echo "$result1"
#echo "$result2"
if ( $result > 1); then
  echo "$result3"
else
  echo "No match was found"
fi
