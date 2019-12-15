from pyspark.context import SparkContext
from pyspark.sql.context import SQLContext
from pyspark.sql import functions as Func
from pyspark.sql.functions import regexp_extract

import sys


def returnCountDisctinctHosts(logs_df):
	return logs_df.select(Func.countDistinct("host"))


def returnCount404Status(logs_df):
	return logs_df.filter(logs_df.status == 404)\
	.count()

def returnTop5URI404(logs_df):
	return logs_df.filter(logs_df.status == 404)\
	.groupBy("endpoint")\
	.count()\
	.sort('count', ascending=False)\
	.limit(5)

def return404StatusPerDay(logs_df):
	return logs_df.filter(logs_df.status == 404)\
	.groupBy("timestamp")\
	.count()

def returnTotalOfBytes(logs_df):
	return logs_df.groupBy()\
	.agg(Func.sum('content_size'))


def createLogDataframe( ):
	base_df = sqlContext.read.text('/incoming/*.gz')
	host_pattern = r'(^\S+\.[\S+\.]+\S+)\s'
	ts_pattern = r'\[(\d{2}/\w{3}/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})]'
	method_uri_protocol_pattern = r'\"(\S+)\s(\S+)\s*(\S*)\"'
	status_pattern = r'\s(\d{3})\s'
	content_size_pattern = r'\s(\d+)$'

	logs_df = base_df.select(regexp_extract('value', host_pattern, 1).alias('host'),
                         regexp_extract('value', ts_pattern, 1).alias('timestamp'),
                         regexp_extract('value', method_uri_protocol_pattern, 1).alias('method'),
                         regexp_extract('value', method_uri_protocol_pattern, 2).alias('endpoint'),
                         regexp_extract('value', method_uri_protocol_pattern, 3).alias('protocol'),
                         regexp_extract('value', status_pattern, 1).cast('integer').alias('status'),
                         regexp_extract('value', content_size_pattern, 1).cast('integer').alias('content_size'))
	return logs_df 	

if __name__ == "__main__":
		sc = SparkContext()
		sqlContext = SQLContext(sc)

		logs_df = createLogDataframe().persist()
	
		returnCountDisctinctHosts(logs_df)
		returnCount404Status(logs_df)
		returnTop5URI404(logs_df)
		return404StatusPerDay(logs_df)
		returnTotalOfBytes(logs_df)
	


