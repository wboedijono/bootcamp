#!\bin\bash
if [ -z "$1" ]
then
  echo "arg is empty"
  exit
elif [ -z "$2" ]
then
  echo "arg is empty"
  exit
elif [ -z "$3" ]
then
  echo "arg is empty"
  exit
else
  echo "Input Accepted!!!"
	case $3 in
        	"B") #Blackjack
                grep -m1 "Hour" "$1"_Dealer_schedule | awk '{print $1,$2,$3,$4}'
                grep -iF "$2" "$1"_Dealer_schedule | awk '{print $1,$2,$3,$4}'
        ;;
        	"R") #Roulette
                grep -m1 "Hour" "$1"_Dealer_schedule | awk '{print $1,$2,$5,$6}'
                grep -iF "$2" "$1"_Dealer_schedule | awk '{print $1,$2,$5,$6}'
        ;;
        	"T") #Texas Hold Em
                grep -m1 "Hour" "$1"_Dealer_schedule | awk '{print $1,$2,$7,$8}'
                grep -iF "$2" "$1"_Dealer_schedule | awk '{print $1,$2,$7,$8}'
        ;;
        	*)
        	echo "Usage: roulette_dealer_finder_by_time.sh 031X '02:00:00 am' 'B'"
        	echo "Usage: roulette_dealer_finder_by_time.sh 031X 02:00:00 'R'"
	;;
	esac

fi
