#!/bin/bash
################################################################################
## Nome: nasa_project.sh
## Description: Pyspark para analise do dataset NASA Kennedy Space Center WWW
################################################################################

## Informacoes principais
JOB_NAME="nasa_project"
SCRIPT_PATH="../spark/"
DEBUG="y" #y or n

## Configuracoes spark
SPARK2_HOME=/usr/bin/
SPARK_MASTER=yarn

## Diretorios e arquivos 
HOME_DATA="../data/"
ARQUIVO_1="NASA_access_log_Aug95.gz"
ARQUIVO_2="NASA_access_log_Jul95.gz"

HDFS_WAREHOUSE="/incoming/"

function put_hdfs(){

	hdfs dfs -test -d "$HDFS_WAREHOUSE"
	if [ $? == 0 ]
    then
        hdfs dfs -test -f "${HDFS_WAREHOUSE}${ARQUIVO_1}"
		if [ $? == 0 ]
		then
			echo "[INFO] - ${ARQUIVO_1} existe no HDFS" 
			else
				hdfs dfs -put "${HOME_DATA}${ARQUIVO_1}" "${HDFS_WAREHOUSE}${ARQUIVO_1}"
		fi
		hdfs dfs -test -f "${HDFS_WAREHOUSE}${ARQUIVO_2}"
		if [ $? == 0 ]
		then
			echo "[INFO] - ${ARQUIVO_2} existe no HDFS" 
			else
				hdfs dfs -put "${HOME_DATA}${ARQUIVO_2}" "${HDFS_WAREHOUSE}"
		fi	
    else
		hdfs dfs -mkdir "${HDFS_WAREHOUSE}"
		hdfs dfs -put "${HOME_DATA}${ARQUIVO_1}" "${HDFS_WAREHOUSE}"
		hdfs dfs -put "${HOME_DATA}${ARQUIVO_2}" "${HDFS_WAREHOUSE}"
        
    fi

}

function pyspark_nasa_project() {
	echo "[INFO] - Executando funcao pyspark_nasa_project"
	
    echo "[INFO] - Executando spark submit para o job ${JOB_NAME}."
	${SPARK2_HOME}/spark-submit \
           --num-executors 1 --executor-memory 4G --executor-cores 2 --driver-memory 4G \
           --master ${SPARK_MASTER} \
		   --conf spark.sql.warehouse.dir=myWareHouseDir \
           --name ${JOB_NAME} ${SCRIPT_PATH}nasa_project.py
	
    if [ $? == 0 ]
    then
		echo "[INFO] - ${JOB_NAME} finalizado com sucesso."
    else
        echo "[ERRO] - Falha ao realizar processamento"
		exit 1
    fi

}


function main() {
     echo "-----------------------------------------------------------------"
     echo "[INFO] - Inicio do Fluxo ${JOB_NAME}.sh -"
     
     DATE_START=`date -u +%s`
     
	 put_hdfs
	 pyspark_nasa_project
     
     DATE_STOP=`date -u +%s`
     DATE_DURATION=`expr \( $DATE_STOP - $DATE_START \) / 60`
     
     echo "$JOB_NAME" "Success" "$DATE_DURATION"
     
     echo "[INFO] - Fim da carga ${JOB_NAME} do script ${JOB_NAME}.sh"
     echo "-----------------------------------------------------------------"
}

###  ..:: Fluxo ::..

[ "$DEBUG" == "n" ] && main &> /dev/null || main

exit 0

################################################################################

## ..:: Fim da execucao ::..
