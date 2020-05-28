#!/bin/bash
  # Shellscript criado para bloquear os corriqueiros bruteforce probes
  # feitos para a porta do ssh. Pega as ultimas 20 tentativas ilegais na porta do ssh.
  # Verifica se voce já bloqueou o mané e se voce quer adicionar na regra do iptables.
  # Caso queira usar no crontab, é so mudar o valor da var $MODE pra "AUTO"...
  # Abracos, Mastah
  
  MODE="AUTO"
  #MODE="MANUAL"
  
  if [ -f /var/log/messages ] ; then
    ips=$(cat -n /var/log/messages | tail -n 20 | grep -i Illegal | grep -i sshd | awk -F" " {'print $11'})
    attempts=1
    for ip in $ips ; do
       lastip=$ip
       if [ "$lastip" == "$ip" ] ; then
          attempts=$(expr $attempts + 1)
          if [ $attempts -ge 5 ] ; then
             echo "Brute force SSHD attack detected from $ip"
             attempts=1
             lastip=""
             blocked=$(iptables -L INPUT | grep -i $ip | grep -i DROP)
                    if [ "$blocked" ] ; then
                echo "> Ip Already Blocked. Continuing with scan"
                echo " "
             else
                if [ $MODE == "MANUAL" ] ; then
                   echo "> Do You Want to add this IP to INPUT DROP in IPTABLES rules? (y/n)"
                   read resp
                   if [ "$resp" == "y" ] ; then
                      iptables -A INPUT -s $ip -j DROP
                      echo "> IP $ip ADDED TO IPTABLES INPUT DROP ruleset"
                      echo " "
                   fi
                else
                   iptables -A INPUT -s $ip -j DROP
                   echo "> IP $ip ADDED TO IPTABLES INPUT DROP ruleset"
                   echo " "
                fi
             fi
          fi
       fi
    done
  fi