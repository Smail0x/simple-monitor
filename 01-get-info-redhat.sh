#!/bin/bash

#get argements
arg=$1
arg2=$2


if [[ $arg == 'web-service' ]];then
	# get info
	if [[ $arg2 == 'nginx' ]];then
		ip_req=$(cat /var/log/nginx/*.log | grep ' -' | cut -d ' ' -f1,6,7,8,9 | awk '{print $1,$2,$3,$4,$5}' | uniq)		
		if [[ $ip_req ]];then
			while true;do
			{
			IFS=,
			read -p 'Enter (l) to show Logs (e) to show error (q) to quit: '  comm
			if [[ $comm == 'l' ]];then
				echo '------------------------- Logs Of Nginx --------------------------'
				echo $ip_req
				IP_c=$(awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | sed 's/^./Total Request: /g')
				IP_Er_req=$(awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | sed 's/^[0-9]*/Request Page :/g')
				IP_Er_req=($IP_Er_req)
				IP_c=($IP_c)

			       echo $IP_c
		       	       echo $IP_Er_req

			elif [[ $comm == 'e' ]];then
				echo '------------------------- Errores Of Nginx --------------------------'
				err=$(cat /var/log/nginx/error.log | uniq | cut -d ' ' -f1,2,5 | sed 's/ /--/g' | sed 's/-[0-9]*[a-z]/ --> /g' | sed 's#^#Date : #g')
				echo $err
			elif [[ $comm == 'q' ]];then
				echo 'Good Bay....' >&2
				break
			else
				echo 'Pleas Enter Value....'
			fi

			}
			done
			
		fi
	else
		echo 'We Have Just nginx This Moment... ;)'	
		echo './00-get-info web-service nginx'
	fi
elif [[ $arg == 'system' ]];then
	#echo 'Sorry Netx Time I well Create log system'
	if [[ $arg2 == 'ssh' ]];then
		echo '============================================'
		echo '           SSH  SECURITY RAPPORT  '
		echo '============================================'
		# Login Secsass
		num_of_sec=$(cat /var/log/secure | grep 'Accepted password' |awk '{print $11}' | sort | wc -l)
		num_of_fail=$(cat /var/log/secure | grep ssh  | grep 'Failed password' | awk '{print $11}' | sort | wc -l)
		ip_failed_login=$(cat /var/log/secure | grep ssh  | grep 'Failed password' | awk '{print $11}' | sort | uniq -c | awk '{print $1 " Times loging :" ,$2}""')
		check_brute_force=$(cat /var/log/secure | grep 'Failed password' | awk '{print $11}'  | uniq -c | sort -rn| awk '{print $1}')
		find_ip_bro=$(cat /var/log/secure | grep 'Failed password' | awk '{print $11}'  | uniq -c | sort -nr |awk '{print $2}')

		echo '[#] Login Secsass of mny ips : '$num_of_sec
		echo '[#] Login Failde  : '$num_of_fail 
		echo '[#] Ips Who Fileds To Login SSH : ' $ip_failed_login
		find_ip_bro=($find_ip_bro)
		check_brute_force=($check_brute_force)
		#echo ${check_brute_force[0]}
		if (( ${check_brute_force[0]} >= 20  ));then
			echo 
			echo
			echo ' ====================== WARNING ========================='
			echo '         ------------   brute_force ------------'
			echo
			echo 'This IP : '${find_ip_bro} 'He try '${check_brute_force[0]} 'Times To Login On Server....!!!!!!' 
			echo
			echo '=========================================================='
		fi
		
	#elif [[ $arg2 ]];then

		
	elif [[ $arg2 == * ]] ;then
		if [[ -e $arg2 ]];then
			num_of_sec=$(cat $arg2 | grep 'Accepted password' |awk '{print $11}' | sort | wc -l)
			num_of_fail=$(cat $arg2 | grep ssh  | grep 'Failed password' | awk '{print $11}' | sort | wc -l)
			ip_failed_login=$(cat $arg2 | grep ssh  | grep 'Failed password' | awk '{print $11}' | sort | uniq -c | awk '{print $1 " Times loging :" ,$2}""')
			check_brute_force=$(cat $arg2 | grep 'Failed password' | awk '{print $11}'  | uniq -c | sort -rn| awk '{print $1}')
			find_ip_bro=$(cat $arg2 | grep 'Failed password' | awk '{print $11}'  | uniq -c | sort -nr |awk '{print $2}')

			echo '[#] Login Secsass of mny ips : '$num_of_sec
			echo '[#] Login Failde  : '$num_of_fail 
			echo '[#] Ips Who Fileds To Login SSH : ' $ip_failed_login
			find_ip_bro=($find_ip_bro)
			check_brute_force=($check_brute_force)
			#echo ${check_brute_force[0]}
			if [[ -z $check_brute_force  ]];then
				echo 'You chouse Wrong File.... ' 2>&1
				exit 2
			fi
			

			if (( ${check_brute_force[0]} >= 20  ));then
				echo 
				echo
				echo ' ====================== WARNING ========================='
				echo '         ------------   brute_force ------------'
				echo
				echo 'This IP : '${find_ip_bro} 'He try '${check_brute_force[0]} 'Times To Login On Server....!!!!!!' 
				echo
				echo '=========================================================='
			fi
		else
			
			echo 'Sory we Have SSH ckeck...'
			echo './00-get-info system <service> or path'
			exit 1
		fi
	else
		echo 'Sory we Have SSH ckeck...'
		echo './00-get-info system <service> or path'
		
	fi
else 
	echo 'Sorry We Have logs For System and web-service'
	echo './00-get-info <system> <service>'
fi
