#!/bin/bash
perm=$(id -u)
if [ $perm == 0 ]; then
	ping -c 1 www.google.com &> /dev/null
	con=$?
	if [ $con = 0 ]; then 
		read -p "¿Quieres Conectarte a tor? y/n: " x
		echo "Nessus se está levantando, espera"
		if [[ "$x" == "y" ]] || [[ -z "$x" ]]; then
			docker-compose up -d &> /dev/null
			id=$(docker ps | grep -i nessus | awk '{print $1}')
			sleep 4
			docker exec -ti -u root $id service tor start &> /dev/null
			docker exec -ti -u root $id bash /usr/bin/anonsurf start &> /dev/null
			sleep 3
			port=$(docker ps | grep -i nessus | awk '{print $11}' | sed 's/>/ /g' | sed 's/\// /g' | awk '{print$2}')
			echo "Esta es la url para el acceso https://localhost:$port"
			ip=$(docker exec -ti -u root $id curl -s icanhazip.com | sed 's/[[:space:]]*$//')
			echo "Esta es la ip pública del contenedor"
			curl -s ipinfo.io/$ip | sed 's/{//g' | sed 's/}//g' | sed 's/"//g' | sed 's/,//g' | grep -v "readme" 
			read -p "¿Quieres iniciar el server proxy? y/n: " p
			if [[ "$p" == "y" ]] || [[ -z "$p" ]]; then
				echo "Para cerrar el server proxy pulsa ctrl + c "
				docker exec -ti -u root $id tinyproxy -d 
				port=$(docker ps | grep -i nessus | awk '{print $13}' | sed 's/>/ /g' | sed 's/\// /g' | awk '{print$1}' | sed 's/://g' | sed 's/-//g')
			
			fi	
		elif [[ "$x" == "n" ]]; then
			docker-compose up -d &> /dev/null 
			sleep 2
			id=$(docker ps | grep -i nessus | awk '{print $1}')
                	port=$(docker ps | grep -i nessus | awk '{print $11}' | sed 's/>/ /g' | sed 's/\// /g' | awk '{print$2}')
			echo "Esta es la url para el acceso https://localhost:$port"
		else 
			echo "Error vuelve a intentarlo"
			sleep 2
			clear
			./start.sh	
		fi	
	else 
		read -p "No tienes acceso a internet, seguro que quieres arrancar el contenedor? y/n: " y
		if [[ "$y" == "y" ]] || [[ -z "$y" ]]; then
			docker-compose up -d &> /dev/null
			sleep 3
			id=$(docker ps | grep -i nessus | awk '{print $1}')
        		port=$(docker ps | grep -i nessus | awk '{print $11}' | sed 's/>/ /g' | sed 's/\// /g' | awk '{print$2}')
        		sleep 2
        		echo "Esta es la url para el acceso https://localhost:$port"
		else
			echo "Gracias por utilizar el programa"
		fi
	fi	
else
	echo "Ejecuta el script con permisos de sudo "
fi	
