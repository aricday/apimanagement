DOCKER CA Live API Creator
================================


## docker-compose.yml
This file will allow a single SSG instance called "mas":
```
$ docker-compose -f docker-compose.yml up -d
$ docker-compose -f docker-compose.yml logs -f
```

## docker-compose.lac.yml
```
$ docker-compose -f docker-compose.lac.yml up -d lac_mysqldb
$ docker-compose -f docker-compose.lac.yml up -d
$ docker-compose -f docker-compose.lac.yml logs -f
```

* Managed Data Server Detail
	* Name: LAC Managed MySQL
	* URL: jdbc:mysql://lac_mysqldb:3306
	* User name: root
	* Password: 7layer

### Check the container status:
```
$ docker ps --format "table {{.Names}} \t{{.Image}} \t{{.Status}} \t{{.Ports}}"
```


### To stop the container and remove the volume:
```
$ docker-compose -f docker-compose.yml -f docker-compose.lac.yml down --volumes
```
