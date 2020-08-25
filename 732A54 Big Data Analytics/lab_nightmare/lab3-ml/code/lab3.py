from __future__ import division
from math import radians, cos, sin, asin, sqrt, exp
from datetime import datetime
from pyspark import SparkContext

sc = SparkContext(appName="lab_kernel")

def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    # haversine formula
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6367 * c
    return km

h_distance = 1000
h_date = 30
h_time = 6
a = 58.4274
b = 14.826
date = "2013-11-04"

#######
stations = sc.textFile("/Users/darin/Desktop/Big_Data/data/stations.csv")
temp = sc.textFile("/Users/darin/Desktop/Big_Data/data/temperature-readings.csv")
result3 = "/Users/darin/Desktop/Big_Data/data/lab3"

stations = stations.map(lambda line: line.split(";"))
stations = stations.map(lambda x: (int(x[0]), float(x[3]),float(x[4])))

temp = temp.map(lambda line: line.split(";"))
temp = temp.map(lambda x: (int(x[0]),x[1],x[2],float(x[3])))

times = ["24:00:00", "22:00:00", "20:00:00", "18:00:00", "16:00:00", "14:00:00",
"12:00:00", "10:00:00", "08:00:00", "06:00:00", "04:00:00"]

output = [0]*len(times)

def K_dist(data,coords, h):
    u = data.map(lambda x: (x[0],haversine(x[2],x[1],coords[0],coords[1])/h))
    k = u.map(lambda x: (x[0],exp(-(x[1]**2))))
    return k

def K_date(x,date,h):
    diff_date = (datetime(int(x[0:4]),int(x[5:7]),int(x[8:10]))
                 - datetime(int(date[0:4]),int(date[5:7]),int(date[8:10]))).days / h
    k = exp(-(diff_date ** 2))
    return k

def K_time(x,time,h):
    diff_time = (datetime(2000,1,1,int(x[0:2]),int(x[3:5]),int(x[6:8]))
                 - datetime(2000,1,1,int(time[0:2]),int(time[3:5]),int(time[6:8]))).seconds / h
    k = exp(-(diff_time**2))
    return k

def predict():
    k_dist = K_dist(stations,[b,a],h_distance)
    k_dist_broadcast = k_dist.collectAsMap()
    stations_dist = sc.broadcast(k_dist_broadcast)
    #Filter on date
    filtered_dates = temp.filter(lambda x: (datetime(int(x[1][0:4]),int(x[1][5:7]),
                                                      int(x[1][8:10])) <= datetime(int(date[0:4]),
                                                                                   int(date[5:7]),
                                                                                   int(date[8:10]))))
    filtered_dates.cache()
    for time in times:
        filtered_times = filtered_dates.filter(lambda x: ((datetime(int(x[1][0:4]),
                                                                    int(x[1][5:7]),
                                                                    int(x[1][8:10]))== datetime(int(date[0:4]),
                                                                                                int(date[5:7]),
                                                                                                int(date[8:10]))
                                                           )
                                                         ) and
                                                         (datetime(2000, 1, 1,
                                                                   int(x[2][0:2]),
                                                                   int(x[2][3:5]),
                                                                   int(x[2][6:8])) <= datetime(2000, 1, 1,
                                                                                              int(time[0:2]),
                                                                                              int(time[3:5]),
                                                                                              int(time[6:8]))
                                                          )
                                               )

        kernel = filtered_times.map(lambda x: (stations_dist.value[x[0]],
                                               K_date(x[1], date, h_date),
                                               K_time(x[2], time, h_time),
                                               x[3]))

        k_sum = kernel.map(lambda x: (x[0] * x[1] * x[2], x[3]))
        k_sum = k_sum.map(lambda x: (x[0] * x[1], x[0]))
        k_sum = k_sum.reduce(lambda x, y: (x[0] + y[0], x[1] + y[1]))
        output[times.index(time)] = (time, k_sum[0] / k_sum[1])

predict()
output.saveAsTextFile(result3)