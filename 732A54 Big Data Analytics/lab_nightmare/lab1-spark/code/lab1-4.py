from pyspark import SparkContext

data1 = "BDA/input/temperature-readings.csv"
data2 = "BDA/input/precipitation-readings.csv"
result4 = "BDA/output/max_temp_prec"

sc = SparkContext(appName="lab1-4")

# max_temp
temp = sc.textFile(data1)
temp = temp.map(lambda a: a.split(";"))
temp = temp.map(lambda x: (x[0], float(x[3])))

maxTemp = temp.reduceByKey(max)
maxTemp = maxTemp.filter(lambda a: a[1] > 25 and a[1] < 30)

# max_prec
prec = sc.textFile(data2)
prec = prec.map(lambda a: a.split(";"))
prec = prec.map(lambda x: (x[0]+','+x[1], float(x[3])))

maxPrec = prec.reduceByKey(lambda v1, v2: v1+v2)
maxPrec = maxPrec.filter(lambda a: a[1] >= 100 and a[1] <= 200)

# merge them together
maxTempPrec = maxTemp.leftOuterJoin(maxPrec)
maxTempPrec = maxTempPrec.map(lambda a: '%s,%s,%s' % (a[0], a[1][0], a[1][1]))

maxTempPrec.saveAsTextFile(result4)