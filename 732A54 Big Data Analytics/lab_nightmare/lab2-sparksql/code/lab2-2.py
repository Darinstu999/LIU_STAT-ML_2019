from pyspark import SparkContext
from pyspark.sql import SQLContext, Row, functions

data = "/Users/darin/Desktop/Big_Data/data/temperature-readings.csv"
result1 = '/Users/darin/Desktop/Big_Data/data/sql_over_ten_temp_counts'
result2 = '/Users/darin/Desktop/Big_Data/data/sql_over_ten_temp_distinct_counts'
startYear = 1950
endYear = 2014

sc = SparkContext(appName = "lab2-2")

lines = sc.textFile(data)
lines01 = lines.map(lambda x: x.split(";"))
lines02 = lines01.filter(lambda x: int(x[1][0:4]) >= startYear and
                                   int(x[1][0:4]) <= endYear)
dataTemp = lines02.map(lambda x: Row(station=x[0], date=x[1], year=x[1].split("-")[0],
                                     month = x[1].split("-")[1],time=x[2],
                                     temp=float(x[3]), quality=x[4]))

dataTemp.registerTempTable("lab2-2-df")

# 1. larger than 10 degrees

ten_temp = dataTemp.filter(dataTemp["temp"] > 10).groupby(["year","month"]) \
    .agg(functions.count("station"))
ten_temp = ten_temp.sortBy(keyfunc=lambda x:x[2], ascending=False)
ten_temp.saveAsTextFile(result1)

# 2. distinct & larger than 10 degrees

distinct_ten_temp = dataTemp.filter(dataTemp["temp"] > 10).groupby(["year","month"]) \
    .agg(functions.countDistinct("station"))
distinct_ten_temp = distinct_ten_temp.sortBy(keyfunc=lambda x:x[2], ascending=False)
distinct_ten_temp.saveAsTextFile(result2)