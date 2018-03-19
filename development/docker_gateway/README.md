DOCKER CA API Gateway project
================================


## docker-compose.yml
This file will allow a single SSG instance create using:
```
$ docker-compose -f docker-compose.yml up -d
$ docker-compose -f docker-compose.yml logs -f
```


* Managed Data Server Detail
	* Name: LAC Managed MySQL
	* URL: jdbc:mysql://mysqldb:3306
	* User name: root
	* Password: 7layer

### Check the container status:
```
$ docker ps --format "table {{.Names}} \t{{.Image}} \t{{.Status}} \t{{.Ports}}"
```


To stop the container and remove the volume:
```
$ docker-compose -f docker-compose.yml down --volumes
```

---

## docker-compose.ssg.yml
This project will allow multiple SSG instance scaling using LBproxy to round-robin:
```
$ docker-compose --project-name lbproxy --file docker-compose.ssg.yml --file docker-compose.lb.yml up -d --build
```

### Verify logs
```
$ docker-compose --project-name lbproxy --file docker-compose.ssg.yml --file docker-compose.lb.yml logs --follow

```

### Scale container
```

$ docker-compose --project-name lbproxy --file docker-compose.ssg.yml --file docker-compose.lb.yml up -d --scale ssg=2

```


To stop the container and remove the volume:
```
$ docker-compose --project-name lbproxy --file docker-compose.ssg.yml --file docker-compose.lb.yml down --volumes
```
