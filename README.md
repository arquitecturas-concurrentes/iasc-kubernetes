
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

# Plano de control de K8s

El plano de control es lo que controla el clúster y lo hace funcionar. Consiste en
múltiples componentes que pueden ejecutarse en un solo nodo maestro o dividirse en múltiples
nodos y replicados para garantizar una alta disponibilidad. Estos componentes son:

- `El servidor API de Kubernetes`. Es la API mediante el usuario y los componentes se comunican con el plano de control.
- `Scheduler`. permite encolar las aplicaciones (asigna un nodo trabajador a cada implementación
componente capaz de su aplicación).
- `Controller Manager`. que realiza funciones a nivel de clúster, como replicar
localizar componentes, realizar un seguimiento de los nodos de trabajo, gestionar las fallas de los nodos,
y así.
- `etcd`. un almacén de datos distribuido confiable que almacena de manera persistente el clúster
configuración.


- `Docker, rkt, or another container runtime` which runs your containers
- `The Kubelet` which talks to the API server and manages containers on its node
- `The Kubernetes Service Proxy (kube-proxy)`, which load-balances network traffic
between application components

### Notas

Para instalar k8s dashboard ver el readme en el directorio de extra.

En el caso de usar el ejemplo 5, el componente de HPA necesita de `metrics-server` para funcionar, por lo que hay que instalar este servicio previamente

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.2/components.yaml
```