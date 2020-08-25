from pyspark import SparkContext
from pyspark.sql import Row, functions

data = "/Users/darin/Desktop/Big_Data/data/temperature-readings.csv"
data2 = "/Users/darin/Desktop/Big_Data/data/precipitation-readings.csv"
result = "/Users/darin/Desktop/Big_Data/data/max_temp_prec"

sc = SparkContext(appName="lab2-4")
# data temp
dataTemp = sc.textFile(data)
dataTemp = dataTemp.map(lambda x: x.split(";"))
dataTemp = dataTemp.filter(lambda x: int(x[1][0:4]) >= 1950 and
                                   int(x[1][0:4]) <= 2014)
dataTemp = dataTemp.map(lambda x: Row(station=x[0], temp=float(x[3])))

dataTemp = dataTemp.registerTempTable("lab2-4-temp-df")

## get the max-temp
maxTemp = dataTemp.groupBy("station").agg(functions.max("temp").alias("maxTemp"))
maxTemp = maxTemp.filter(maxTemp.maxTemp > 25 and
                         maxTemp.maxTemp < 30)

# data prec
dataPrec = sc.textFile(data2)
dataPrec = dataPrec.map(lambda x: x.split(";"))
dataPrec = dataPrec.filter(lambda x: int(x[1][0:4]) >= 1950 and
                                   int(x[1][0:4]) <= 2014)
dataPrec = dataPrec.map(lambda x: Row(station=x[0],prec=float(x[3])))

dataPrec = dataPrec.registerTempTable("lab2-4-prec-df")

## get the max-prec
maxPrec = dataPrec.groupBy("station").agg(functions.max("prec").alias("maxPrec"))
maxPrec = maxPrec.filter(maxPrec.maxPrec > 100 and
                         maxPrec.maxPrec < 200)

# merge them together
maxTempPrec = maxTemp.join(maxPrec, "station")
maxTempPrec = maxTempPrec.orderby(["station"], ascending = [0])
maxTempPrec.saveAsTextFile(result)