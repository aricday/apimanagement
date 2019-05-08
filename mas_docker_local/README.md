# Mobile API Gateway (MAS): MAG-4.2, OTK-4.3.1, GW-9.4

## <a name="configuration"></a>Configuration:

Theses steps will setup the environment to showcase the use-cases above. The FQDN references in the tutorial will be **mas.docker.local**, **msgw.docker.local**, **lac.docker.local** for the MAS/OTK, MGW, and LAC UI external services respectively. **consul.docker.local** will be used to reference the Consul UI. The FQDNs point to your Docker Engine IP address so update your local */etc/hosts* file accordingly. *For native Docker on the MAC, this is the loopback IP: **127.0.0.1**.* The FQDNs can be changed to suite your needs, but the coresponding environment variables and x509 certificates should also be changed (see [development](#development))

Custom environment variables are exported from the Makefile for every *make* command vi the [.custom.env](.custom.env) file. These custom environment variables include application specific hostnames, certificates, and user credentials:

```
## Export some application specific environment variables

# certificates
export MGW_SSL_KEY_B64="$(cat config/certs/msgw.cert.p12 | base64)"
export MGW_SSL_KEY_PASS=password
export MGW_SSL_PUBLIC_CERT_B64="$(cat config/certs/msgw.cert.pem | base64)"
export MAS_SSL_KEY_B64="$(cat config/certs/mas.cert.p12 | base64)"
export MAS_SSL_KEY_PASS=password
export MAS_SSL_PUBLIC_CERT_B64="$(cat config/certs/mas.cert.pem | base64)"

# MAS/MAG/OTK
export MAS_HOSTNAME=mas.docker.local
export MDC_HOSTNAME=${MAS_HOSTNAME}
export OTK_HOSTNAME=${MAS_HOSTNAME}
...
```

## <a name="installation"></a>Installation:

Start the main application via the **make** command. You can tail the logs in this terminal via *make log* or open a new one (docker-compose -f docker-compose.yml logs -f)

	make

Once the application is ready, you should be able to login to the MAS developer console, view the MGW Quickstart documentation, LAC interface, and Consul interface. The MAS, MGW, and LAC require and administrator for authentication, username/password: **admin/password** for MAS/MGW and **admin/Password1** for LAC

	https://msgw.docker.local:9443/quickstart/1.0/doc
	https://mas.docker.local
	http://lac.docker.local
	http://consul.docker.local:8500

## <a name="demo examples"></a>Demo examples:

### <a name="creation"></a>Creation:

The LAC interface allows you to create a RESTful API with a few clicks by providing a datasource and credentials. There is already a pre-defined example Beer Data that is loaded when the LAC container starts. The Beer Data LAC MS returns some beer attributes from a MySQL database. You can check out the seeded data with the following command:

	docker-compose -f docker-compose.beers.yml exec mysql_beers  mysql -uroot -proot -e "SELECT * FROM data.beers ORDER BY updated_at DESC LIMIT 10"

You can walk through the functionality of LAC from the [user interface](http://lac.docker.local)


### <a name="discovery"></a>Discovery:

The Quickstart template language provides a JSON syntax language to protect and discover your MS in the MGW. The [Quickstart Beer Data example](files/msgw/quickstart/beer_data.json) is leveraging the MGW's 'RequireOauth2Token' to validate an OAuth Bearer access token with proper scope via the OAuth hub of the MAS/OTK instance. The 'ConsulLookup' integrates with Consul to query the MS service availability and dynamically update routing strategies based off container availability. 

Full list of template options in the [docs](https://msgw.docker.local:9443/quickstart/1.0/doc). The Quickstart payloads can  be provisioned programatically via curl, service registry, etc. or during container instantiation via a configruation managment database and/or continuous integation/deployment systems (CI/CD)*

Check the service exists via *curl* or *browser*

	curl -k -4 -i -u 'admin:password' https://msgw.docker.local:9443/quickstart/1.0/services

Try to access the Beer Data service with Basic Auth (failure)

	curl -k -4 -i -u 'admin:password' https://msgw.docker.local:9443/beers

We need a valid OAuth token to access the protected resource. Let's consume the new MS via a Mobile client. You can also use curl in the [Bonus](#bonus) section below.


### <a name="iosconsumption"></a>iOS_Consumption:

Now that the MS is protected by the MGW, let's levage a simple mobile application to consume the MS via OAuth tokens. Navigate to the [MAS Developer Console](https://mas.docker.local) and login with the admin credentials. Create a new application, select the iOS platform, and download the **msso_config.json**. Open the [MicroservicesDemo.xcworkspace](../MicroservicesDemo/MicroservicesDemo.xcworkspace) in Xcode <~ 9.4.x and place the **msso_config.json** file into the project. The *Supporting Files* folder is typically where I drop it. Build the iOS mobile application and run the simluator in iOS <~ 11.x. Login to the mobile application and you can now see the Beers from the Beer data API you created!. Try adding a new Beer and show the data in the database.  That was fast and easy!!

### <a name="andriodconsumption"></a>Andriod_Consumption:

Now that the MS is protected by the MGW, let's levage a simple mobile application to consume the MS via OAuth tokens. Navigate to the [MAS Developer Console](https://mas.docker.local) and login with the admin credentials. Create a new application, select the Andriod platform, and download the **msso_config.json**. Open the [AndriodDemo.assets](../AndriodBeerDemo/MASSessionUnlockSample) in Studio <~ 3.2 and place the **msso_config.json** file into the project assets. Using AVD Manager Tools, create an AVD and map the gateway hostname in /system/etc/hosts if this is a local build without DNS resolution.

```
$ cd ~/Library/Android/sdk/
$ vi hosts (add local ifconfig IP for mas.docker.local)
$ ./tools/emulator -avd Pixel2xl -writable-system &
$ adb root
$ adb remount
$ adb push hosts /system/etc
```

Login to the mobile application and you can now see the Beers from the Beer data API you created!. 

### <a name="security"></a>Security:

Since we added Rate Limiting in our [Quickstart Beer Data example](files/msgw/quickstart/beer_data.json), you can hit refresh a few times on the Beer list table to trigger the limit.


## <a name="Teardown"></a>Teardown:

### <a name="clean-all"></a>clean-all: 

Stop the application stack via the **make** command. The default option is the *clean* command (source .custom.env; docker-compose -f docker-compose.yml stop && docker-compose -f docker-compose.yml rm -f && docker volume prune -f).  For full removal, please use *clean-all* (clean-beers clean-token_exchange).

```
  make clean-all
```
