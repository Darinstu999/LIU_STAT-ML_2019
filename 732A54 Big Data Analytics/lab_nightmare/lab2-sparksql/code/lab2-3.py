from pyspark import SparkContext
from pyspark.sql import Row, functions

data = "/Users/darin/Desktop/Big_Data/data/temperature-readings.csv"
result = "/Users/darin/Desktop/Big_Data/data/avg_month_temp"
startYear = 1960
endYear = 2014

sc = SparkContext(appName="lab2-3")

lines = sc.textFile(data)
lines01 = lines.map(lambda x: x.split(";"))
lines02 = lines01.filter(lambda x: int(x[1][0:4]) >= startYear and
                                   int(x[1][0:4]) <= endYear)
dataTemp = lines02.map(lambda x: Row(station=x[0], date=x[1], year=x[1].split("-")[0],
                                     month = x[1].split("-")[1],time=x[2],
                                     temp=float(x[3]), quality=x[4]))

dataTemp.registerTempTable("lab2-3-df")

# calculate the avg daily temp
minTemp = dataTemp.groupBy("year", "month", "day", "station") \
    .agg(functions.min("temp").alias("minT"))
maxTemp = dataTemp.groupBy("year", "month", "day", "station") \
    .agg(functions.max("temp").alias("maxT"))

min_maxTemp = minTemp.join(maxTemp,["year","month","day","station"])
min_maxTemp = min_maxTemp.withColumn("avg_temp",(min_maxTemp.minT + min_maxTemp.maxT)/2) \
    .select("year","month","station","avg_temp")

# calculate the monthly temp
avg_month_temp = min_maxTemp.groupBy("year","month","station")\
    .agg(functions.avg("avg_temp")).alias("avg_month_temp") \
    .orderBy(["avg_month_temp"], ascending = [0])

avg_month_temp = avg_month_temp.sortBy(keyfunc=lambda x:x[3], ascending=False)
avg_month_temp.saveAsTextFile(result)