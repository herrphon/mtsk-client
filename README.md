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
$ ./bin/sprit-monitor 
Sprit Monitor commands:
  sprit-monitor get -l, --location=LOCATION -n, --name=NAME -o, --operator=OPERATOR t, --type=TYPE  # get price
  sprit-monitor help [COMMAND]                                                                      # Describe available commands or one specific command
```



Example
-------

```
$ ./bin/sprit-monitor get --name="Jet Durlach" --location=48.997,8.45645 --type=e10 --operator=JET
{
  "name": "Jet Durlach",
  "mtsk_id": "51D4B432A0951AA0E10080009459E03A",
  "type": "e10",
  "price": 1.299,
  "latitude": 48.997,
  "longitude": 8.45645,
  "street": "Killisfeldstr. 32",
  "city": "Karlsruhe",
  "zip_code": 76227,
  "distance": "0.00"
}


$ ./bin/sprit-monitor get --name="Jet Pforzheim" --location=75175 --type=e5 --operator=JET
{
  "name": "Jet Pforzheim",
  "mtsk_id": "51D4B6B4A0951AA0E10080009459E03A",
  "type": "e5",
  "price": 1.289,
  "latitude": 48.8937,
  "longitude": 8.69659,
  "street": "Luisenstr. 16",
  "city": "Pforzheim",
  "zip_code": 75172,
  "distance": "1.95"
}
```

