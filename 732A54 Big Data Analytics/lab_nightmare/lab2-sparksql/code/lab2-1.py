from pyspark import SparkContext
from pyspark.sql import SQLContext, Row, functions

iFile = "/Users/darin/Desktop/Big_Data/data/temperature-readings.csv"
oFile1 = '/Users/darin/Desktop/Big_Data/data/sql_max_temperature'
oFile2 = '/Users/darin/Desktop/Big_Data/data/sql_min_temperature'
startYear = 1950
endYear = 2014

sc = SparkContext(appName = "lab2-1")

lines = sc.textFile(iFile)
lines01 = lines.map(lambda x: x.split(";"))
lines02 = lines01.filter(lambda x: int(x[1][0:4]) >= startYear and
                                   int(x[1][0:4]) <= endYear)
dataTemp = lines02.map(lambda x: Row(station=x[0], date=x[1], year=x[1].split("-")[0], time=x[2],
                                  temp=float(x[3]), quality=x[4]))

dataTemp.registerTempTable("lab2-1-df")

# Max temperature
maxTemp = dataTemp1.groupBy("year").agg(functions.max("temp").alias("temp")) \
    .orderBy(["temp"], ascending = [0])

maxTemp = maxTemp.join(dataTemp1.select("station","year","temp"),["year","temp"],'left_outer')
maxTemp = maxTemp.orderBy(["temp"], ascending=[0])
maxTemp = maxTemp.rdd.sortBy(keyfunc=lambda x: x[1], ascending=False)
maxTemp.saveAsTextFile(oFile1)

## Min temperature
minTemp = dataTemp1.groupBy("year").agg(functions.min("temp").alias("temp")) \
    .orderBy(["temp"], ascending = [0])
minTemp = minTemp.join(dataTemp1.select("station","year","temp"),["year","temp"],'left_outer')
minTemp = minTemp.orderBy(["temp"], ascending=[0])
minTemp = minTemp.rdd.sortBy(keyfunc=lambda x: x[1], ascending=False)
minTemp.saveAsTextFile(oFile2)