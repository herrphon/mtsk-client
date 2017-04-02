sprit-monitor
=============

[![GitHub version](https://badge.fury.io/gh/herrphon%2Fsprit-monitor.png)](http://badge.fury.io/gh/)
[![gemnasium dependency status](https://gemnasium.com/herrphon/sprit-monitor.png)](https://gemnasium.com/herrphon/sprit-monitor)
[![Travis CI](https://travis-ci.org/herrphon/sprit-monitor.png)](https://travis-ci.org/herrphon/sprit-monitor)
[![Code Climate](https://codeclimate.com/repos/52fe0531e30ba05ab20094ad/badges/00289cf9d4bd5c3fed9b/gpa.png)](https://codeclimate.com/repos/52fe0531e30ba05ab20094ad/feed)
[![Coverage Status](https://coveralls.io/repos/herrphon/sprit-monitor/badge.png?branch=master)](https://coveralls.io/r/herrphon/sprit-monitor?branch=master)



Usage
-----


```
./bin/sprit-monitor.rb get --name="Jet Durlach" --location=48.997,8.45645 --type=e10 --operator=JET
>  {
>    "name":"Jet Durlach",
>    "location":"48.997,8.45645",
>    "radius":2,
>    "gas_type":"e10",
>    "operator":"JET",
>    "price":1.489,
>    "laengengrad":8.45645,
>    "breitengrad":48.997,
>    "strasse":"KILLISFELDSTR. 32",
>    "ort":"KARLSRUHE",
>    "plz": 76227
>  }

./bin/sprit-monitor.rb get --name="Jet Pforzheim" --location=75175 --type=e5 --operator=JET
>  {
>     "name"="Jet Pforzheim",
>     "location":"75175",
>     "radius":2,
>     "gas_type":"e5",
>     "operator":"JET",
>     "price":1.559,
>     "laengengrad":8.72514,
>     "breitengrad":48.8985,
>     "strasse":"EUTINGER STR. 85",
>     "ort":"PFORZHEIM",
>     "plz":75175
>   }

```

Data can be sent to some logging tool, e.g. logstash. :-)