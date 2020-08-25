from pyspark import SparkContext

data2 = "BDA/input/precipitation-readings.csv"
data3 = "BDA/input/stations-Ostergotland.csv"
result5 = "BDA/output/avg_prec_ost"

sc = SparkContext(appName="lab1-5")

prec = sc.textFile(data2)
stations = sc.textFile(data3)

# stations data
stations = stations.map(lambda x: x.split(";"))
stations = stations.map(lambda x: x[0])
stations = stations.coalesce(1)
stations = stations.collect()
stations = sc.broadcast(stations)

# prec data
prec = prec.map(lambda x: x.split(";"))
prec = prec.map(lambda x: (x[0],x[1][0:4],x[1][5:7], float(x[3])))
prec = prec.filter(lambda x: x[0][0] in stations.value)

#
prec_2016 = prec.filter(lambda x: int(x[0][1]) >= 1993 and
                                  int(x[0][1]) <= 2016)
prec_2016 = prec_2016.reduceByKey(lambda x, y: x + y)
prec_2016 = prec_2016.map(lambda line: ((line[0][1], line[0][2]), (line[1], 1)))
prec_2016 = prec_2016.reduceByKey(lambda x, y: (x[0] + y[0], x[1] + y[1]))
prec_2016 = prec_2016.map(lambda line: (line[0][0], line[0][1], (line[1][0] / line[1][1])))
prec_2016 = prec_2016.coalesce(1)

prec_2016.saveAsTextFile(result5)