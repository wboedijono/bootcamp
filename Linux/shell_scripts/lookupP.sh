#!\bin\bash

#grep -i $1 Roulette_Losses
#grep -E '(-\$)' * | awk  '{if($1 ~ "'$h'") print}' | awk -F":" '{print substr($1,1,4)":"$2":"$3":"substr($4,1,5)}'
#grep -E '(-\$)' * | awk  '{if($1 ~ "'$h'") print}' | awk -F":" '{print $2":"$3":"$4}' | awk -F" " '{print $1 $2}'

h=$1
result=$(grep -E '(-\$)' "$h"* | awk -F":" '{print substr($1,1,4),$2":"$3":"$4}')
echo "$result"

