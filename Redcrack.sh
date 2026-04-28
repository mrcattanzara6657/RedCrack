#!/bin/bash

banner=$(cat << "EOF"
 ██▀███  ▓█████ ▓█████▄  ▄████▄   ██▀███   ▄▄▄       ▄████▄   ██ ▄█▀
▓██ ▒ ██▒▓█   ▀ ▒██▀ ██▌▒██▀ ▀█  ▓██ ▒ ██▒▒████▄    ▒██▀ ▀█   ██▄█▒ 
▓██ ░▄█ ▒▒███   ░██   █▌▒▓█    ▄ ▓██ ░▄█ ▒▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ 
▒██▀▀█▄  ▒▓█  ▄ ░▓█▄   ▌▒▓▓▄ ▄██▒▒██▀▀█▄  ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ 
░██▓ ▒██▒░▒████▒░▒████▓ ▒ ▓███▀ ░░██▓ ▒██▒ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄
░ ▒▓ ░▒▓░░░ ▒░ ░ ▒▒▓  ▒ ░ ░▒ ▒  ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒
  ░▒ ░ ▒░ ░ ░  ░ ░ ▒  ▒   ░  ▒     ░▒ ░ ▒░  ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░
  ░░   ░    ░    ░ ░  ░ ░          ░░   ░   ░   ▒   ░        ░ ░░ ░ 
   ░        ░  ░   ░    ░ ░         ░           ░  ░░ ░      ░  ░   
                 ░      ░                           ░               
EOF
)
echo -e "\033[0;31m$banner\033[0m"
sleep 1
echo "[*] welcome to Redcrack"
sleep 1
echo "[*] checking depenencies"
sleep 1
command -v john >/dev/null || sudo apt install john
command -v hydra >/dev/null || sudo apt install hydra
command -v nuclei >/dev/null || sudo apt install nuclei
if [ -f /usr/share/wordlists/rockyou.txt ]; then
	sleep 1
	echo "[*] rockyou exists"
elif [ -f /usr/share/wordlists/rockyou.txt.gz ]; then
	sleep 1
	echo "[*] unzipping rockyou"
	sudo gunzip /usr/share/wordlists/rockyou.txt.gz
	sleep 1
	echo "[*] rockyou ready"
else
	sudo apt install wordlists
	sleep 1
	echo "[*] wordlists installed"
	sleep 1
	echo "[*] unzipping rockyou"
	sleep 1
	sudo gunzip /usr/share/wordlists/rockyou.txt.gz
	echo "[*] rockyou ready"
fi
sleep 1
echo "[*] choose mode, crack for password cracking, force for bruteforce, web for web enum"
read mode
if [ $mode = "crack" ]; then
	sleep 1
	echo "[*] choose wordlist, type none for default, rockyou"
	read wordlist
	if [ $wordlist = "none" ]; then
		wordlist=/usr/share/wordlists/rockyou.txt
	fi
	sleep 1
	echo "$wordlist"
	sleep 1
	echo "[*] specify hash"
	read hash
	sleep 1
	echo "[*] specify hashtype"
	read hashtype
	sleep 1
john --session=temp --pot=~/redcrack/redcrack.pot --wordlist=$wordlist --format=$hashtype $hash
rm ~/redcrack/redcrack.pot
fi
if [ $mode = "force" ]; then
	sleep 1
	echo "[*] specify wordlist, type none for default, rockyou"
	read wordlist2
	if [ $wordlist2 = "none" ]; then
		wordlist2=/usr/share/wordlists/rockyou.txt
	fi
	sleep 1
	echo "[*] specify target IP"
	read IP
	sleep 1
	echo "[*] specify target service"
	read service
	echo "[*] do you want to specify a username or use a wordlist?"
	read or
	if [ $or = username ]; then
		echo "[*] specify username"
		read username
		sleep 1
		echo "[*] starting"
hydra -l $username -P $wordlist2 $IP $service
	fi
	if [ $or = wordlist ]; then 
		echo "[*] specify wordlist"
		read userlist
		sleep 1
		echo "[*] starting"
hydra -L $userlist -P $wordlist2 $service $IP
	fi
fi
if [ $mode = "web" ]; then
	sleep 1
	echo "[*] do you want to use normal mode or advanced mode?"
	read or2
	if [ $or2 = "normal" ]; then
		sleep 1
		echo "[*] normal mode"
		sleep 1
		echo "[*] set target URL"
		read url
		sleep 1
		nuclei -u $url
	fi
	if [ $or2 = "advanced" ]; then
		sleep 1
		echo "[*] set target url"
		read target2
		sleep 1
		echo "[*] specify congfig path"
		read config
		sleep 1
		nuclei -u $target -t $config
	fi
fi








