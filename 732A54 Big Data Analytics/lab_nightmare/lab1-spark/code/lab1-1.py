##### lab1-1 #####
from pyspark import SparkContext

data1 = "BDA/input/temperature-readings.csv"
result1 = "BDA/output/max_temperature"
result2 = "BDA/output/min_temperature"

sc = SparkContext(appName="lab1-1")
lines = sc.textFile(data1)
lines01 = lines.map(lambda x: x.split(";"))
# select year condition
lines02 = lines01.filter(lambda x: int(x[1][0:4]) >= 1950 and
                                   int(x[1][0:4]) <= 2014)
dateTemp = lines02.map(lambda x: (x[1][0:4], (x[0], float(x[3]))))

# define min and max funcs
min = (lambda x, y: x if x[1] < y[1] else y)
max = (lambda x, y: x if x[1] > y[1] else y)

minTemp = dateTemp.reduceByKey(min)
maxTemp = dateTemp.reduceByKey(max)

minMaxTemp = minTemp.union(maxTemp).reduceByKey(lambda x,y: (x[0],x[1],y[0],y[1]))

# sort by highest temp on descending order
sortedMinMaxTemp1 = minMaxTemp.sortBy(keyfunc=lambda x: x[1][3], ascending=False)
# sort by lowest temp on descending order
sortedMinMaxTemp2 = minMaxTemp.sortBy(keyfunc=lambda x: x[1][1], ascending=False)

# list_year-station-maxTemp
output1 = sortedMinMaxTemp1.map(lambda x: '%s,%s,%s' % (x[0], x[1][2], x[1][3]))
# list_year-station-minTemp
output2 = sortedMinMaxTemp2.map(lambda x: '%s,%s,%s' % (x[0], x[1][0], x[1][1]))

output1.saveAsTextFile(result1)
output2.saveAsTextFile(result2)
