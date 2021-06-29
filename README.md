
https://hub.docker.com/orgs/iascfrba

== Bajando la imagen


```
docker pull iascfrba/iasckub
```


== Como ejecutar la imagen de iascbub

```
docker run -p 49160:8080 -d iascfrba/iasckub
```

despues de eso podemos tan solo probar que responda bien la imagen haciendo un curl al puerto expuesto:

```
curl -i localhost:49160
````

```
$ curl -i localhost:49160

HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 28
ETag: W/"1c-GKA8c+rk/DndwVCk9T6NgEs2kMU"
Date: Fri, 25 Jun 2021 20:18:53 GMT
Connection: keep-alive
Keep-Alive: timeout=5
```

== Primeros pasos con kubernetes

