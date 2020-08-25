from pyspark import SparkContext
from pyspark.sql import Row, functions

data1 = "/Users/darin/Desktop/Big_Data/data/precipitation-readings.csv"
data2 = "/Users/darin/Desktop/Big_Data/data/stations-Ostergotland.csv"
result5 = "/Users/darin/Desktop/Big_Data/data/avg_prec_ost"

sc = SparkContext(appName="lab2-5")

# get data and pre-process
station = sc.textFile(data1).cache()
station = station.map(lambda line:line.split(";"))
station = station.map(lambda x:Row(station=x[0], name=x[1]))
stations = sqlContext.createDataFrame(station)
stations.registerTempTable("q5_Stations")

dataPrec = sc.textFile(data2).cache()
dataPrec = dataPrec.map(lambda line:line.split(";"))
dataPrec = dataPrec.filter(lambda x:(int(x[1][0:4])>=1993 and int(x[1][0:4])<=2016)) dataPrec = dataPrec.map(lambda x:Row(station=x[0], date=x[1], year=x[1].split("-")[0], month=x[1].split("-")[1], day=x[1].split("-")[2],
time=x[2], prec=float(x[3]), quality=x[4]))
dataPrec = sqlContext.createDataFrame(dataPrec)
dataPrec.registerTempTable("q5_dataPrec")

# merge together and get the avg_prec
Result = stations.join(dataPrec, "station")
Result = Result.groupBy("year", "month", "station").agg(F.sum("prec").alias("precSum")) Result = Result.groupBy("year", "month").agg(F.avg("precSum").alias("precAvg"))
Result = Result.orderBy(["year", "month"], ascending=[0,0])
Result.saveAsTextFile("result5")
