from pyspark import SparkContext

data1 = "BDA/input/temperature-readings.csv"
result2_1 = 'BDA/output/over_ten_mth_temp_counts'
result2_2 = 'BDA/output/over_ten_temp_distinct_counts'
startYear = 1950
endYear = 2014
standardTemp = 10

sc = SparkContext(appName="lab1-2")

lines = sc.textFile(data1)
lines01 = lines.map(lambda x: x.split(";"))

# select year
lines02 = lines01.filter(lambda x: (int(x[1][0:4]) >= startYear and
                                    int(x[1][0:4]) <= endYear))

# 1. year, month, number

temperatures = lines02.map(lambda x:
                           (x[1][0:7], (float(x[3]), 1))) \
    .filter(lambda (x, (y, z)): y > standardTemp)

reading_counts = temperatures.reduceByKey(lambda (temp1, count1), (temp2, count2):
                                          (temp1, count1 + count2)) \
    .map(lambda (x, (y, z)):(x, z))

reading_counts.saveAsTextFile(result2_1)

# 2. year, month, distinct number

station_temperatures = lines02.map(lambda x:
                                   (x[1][0:7],(x[0], float(x[3])))) \
    .filter(lambda (x, (y, z)): z > standardTemp)

year_station = station_temperatures.map(lambda (x, (y, z)):
                                        (x, (y, 1))).distinct()

reading_counts = year_station.reduceByKey(lambda (station1, count1), (station2, count2):
                                          (station1, count1 + count2)) \
    .map(lambda (x, (y, z)): (x, y))

reading_counts.saveAsTextFile(result2_2)