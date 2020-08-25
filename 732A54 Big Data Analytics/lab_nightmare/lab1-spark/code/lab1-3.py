from pyspark import SparkContext

data1 = "BDA/input/temperature-readings.csv"
result3 = "BDA/output/avg_station_month_temp"
startYear = 1960
endYear = 2014

sc = SparkContext(appName="lab1-3")

lines = sc.textFile(data1)
lines01 = lines.map(lambda a: a.split(";"))
lines02 = lines01.filter(lambda x: (int(x[1][0:4]) >= startYear and
                                    int(x[1][0:4]) <= endYear))

stationTemp = lines02.map(lambda x:((x[1], x[0]), (float(x[3]), float(x[3]))))

# get the daily min and max Temps
stationMinMaxTemp = stationTemp.reduceByKey(lambda (mintemp1, maxtemp1),(mintemp2, maxtemp2):
                                            (min(mintemp1, mintemp2), max(maxtemp1, maxtemp2)))
# get the monthly avg_Temp
stationMonthlyAvgTemps = stationMinMaxTemp.map(lambda ((day, station), (mintemp, maxtemp)):
                                               ((day[0:7], station), (sum((mintemp, maxtemp)), 2))) \
    .reduceByKey(lambda (temp1, count1), (temp2, count2):
                                          (temp1 + temp2, count1 + count2)) \
    .map(lambda ((month, station), (temp, count)):
                                  ((month, station), temp / float(count)))

stationMonthlyAvgTemps.saveAsTextFile(result3)
