mtsk-client
===========

[![GitHub version](https://badge.fury.io/gh/herrphon%2Fsprit-monitor.png)](http://badge.fury.io/gh/)
[![gemnasium dependency status](https://gemnasium.com/herrphon/mtsk-client.png)](https://gemnasium.com/herrphon/mtsk-client)
[![Travis CI](https://travis-ci.org/herrphon/mtsk-client.png)](https://travis-ci.org/herrphon/mtsk-client)
[![Code Climate](https://codeclimate.com/github/herrphon/mtsk-client/badges/gpa.svg)](https://codeclimate.com/github/herrphon/mtsk-client)
[![Coverage Status](https://coveralls.io/repos/herrphon/sprit-monitor/badge.png?branch=master)](https://coveralls.io/r/herrphon/sprit-monitor?branch=master)


Usage
-----

```
$ ./bin/mtsk-client 

  NAME
      mtsk-client - Describe your application here
  
  SYNOPSIS
      mtsk-client [global options] command [command options] [arguments...]
  
  VERSION
      0.0.1
  
  GLOBAL OPTIONS
      --help    - Show this message
      --version - Display the program version
  
  COMMANDS
      get  - Get mtsk data
      help - Shows a list of commands or help for one command
                                                              # Describe available commands or one specific command
  
```



Example
-------

```
$ ./bin/mtsk-client get --name="Jet Durlach" --location=48.997,8.45645 --type=e10 --brand=JET
  {
    "name": "Jet Durlach",
    "mtsk_id": "51D4B432A0951AA0E10080009459E03A",
    "brand": "JET",
    "type": "e10",
    "price": 1.399,
    "latitude": 48.997,
    "longitude": 8.45645,
    "street": "Killisfeldstr. 32",
    "city": "Karlsruhe",
    "zip_code": 76227,
    "distance": "0.00"
  }


$ ./bin/mtsk-client get --name="Jet Pforzheim" --location=75175 --type=e5 --brand=JET
{
  "name": "Jet Pforzheim",
  "mtsk_id": "51D4B6B4A0951AA0E10080009459E03A",
  "brand": "JET",
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


Links
-----


* <https://github.com/davetron5000/gli>
* <http://naildrivin5.com/blog/2013/12/02/introduction-to-gli.html>

