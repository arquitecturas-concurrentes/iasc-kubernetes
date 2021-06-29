# Deployments

## Sobre los deployments

Un controlador de Deployment proporciona actualizaciones declarativas para los Pods y los ReplicaSets.

Cuando describes el estado deseado en un objeto Deployment, el controlador del Deployment se encarga de cambiar el estado actual al estado deseado de forma controlada. Puedes definir Deployments para crear nuevos ReplicaSets, o eliminar Deployments existentes y adoptar todos sus recursos con nuevos Deployments.

El siguiente ejemplo de un Deployment crea un ReplicaSet para arrancar dos Pods

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

`.metadata.name` describe como se va a llamar el deployment. Otro campo que podemos mencionar es el campo selector define cómo el Deployment identifica los Pods que debe gestionar. En este caso, simplemente seleccionas una etiqueta que se define en la plantilla Pod (app: nginx). Sin embargo, es posible definir reglas de selección más sofisticadas, siempre que la plantilla Pod misma satisfaga la regla.

El campo template contiene los siguientes sub-campos:

- Los Pods se etiquetan como app: nginx usando el campo labels.
- La especificación de la plantilla Pod, o el campo .template.spec, indica que los Pods ejecutan un contenedor, nginx, que utiliza la versión 1.14.2 de la imagen de nginx de Docker Hub.
- Crea un contenedor y lo llamar nginx usando el campo name.
- Ejecuta la imagen nginx en su versión 1.14.2.
- Abre el puerto 80 para que el contenedor pueda enviar y recibir tráfico.

Para crear y aplicar el deployment en el cluster basta con aplicar el yaml con `kubectl`

```bash
$ kubectl apply -f nginx_deployment-1.4.yaml 
deployment.apps/nginx-deployment created
```

> Nota: Hay que indicar el parámetro --record para registrar el comando ejecutado en la anotación de recurso `kubernetes.io/change-cause`. Esto es útil para futuras introspecciones, por ejemplo para comprobar qué comando se ha ejecutado en cada revisión del Deployment.

Con el comando `get deployments`, vamos a poder conocer en que estado estan nuestros deployments.

```bash
$ kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   0/2     2            0           8s
````
 
Se muestran varios campos, una descripcion de los mismos es la siguiente:

- `NAME` enumera los nombre de los Deployments del clúster.
- `DESIRED` muestra el número deseado de réplicas de la aplicación, que se define cuando se crea el Deployment. Esto se conoce como el estado deseado.
- `CURRENT` muestra cuántas réplicas se están ejecutando actualment.
- `UP-TO-DATE` muestra el número de réplicas que se ha actualizado para alcanzar el estado deseado.
- `AVAILABLE` muestra cuántas réplicas de la aplicación están disponibles para los usuarios.
- `AGE` muestra la cantidad de tiempo que la aplicación lleva ejecutándose.

si queremos saber en que estado estan los deployments, podemos usar el siguiente comando `kubectl rollout status deployment/<deployment-name>`

```bash
$ kubectl rollout status deployment/nginx-deployment
Waiting for rollout to finish: 1 out of 2 new replicas have been updated...
deployment "nginx-deployment" successfully rolled out
```

ahora que sabemos que el deployment fue exitoso, podemos hacer algo como lo siguiente:

```bash
$ kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2/2     2            2           51s
```

Para ver el ReplicaSet (rs) creado por el Deployment, basta con ejecutar el comando `kubectl get rs`:

```bash
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-66b6c48dd5   2         2         2       74s
```

con 

```bash
$ kubectl get pods --show-labels
NAME                                READY   STATUS    RESTARTS   AGE   LABELS
nginx-deployment-66b6c48dd5-fls7s   1/1     Running   0          40m   app=nginx,pod-template-hash=66b6c48dd5
nginx-deployment-66b6c48dd5-j2mll   1/1     Running   0          40m   app=nginx,pod-template-hash=66b6c48dd5
```

## Describiendo un deployment

Vamos a poder describir los deployments que tenemos actualmente con el comando `kubectl describe deployments`

```
$ kubectl describe deployments
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Mon, 28 Jun 2021 17:44:18 -0300
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 3
                        kubernetes.io/change-cause: kubectl apply --filename=nginx_deployment-1.4.yaml --record=true
Selector:               app=nginx
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:1.14.2
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-66b6c48dd5 (2/2 replicas created)
Events:
  Type    Reason             Age                From                   Message
  ----    ------             ----               ----                   -------
  Normal  ScalingReplicaSet  54m                deployment-controller  Scaled up replica set nginx-deployment-66b6c48dd5 to 2
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled up replica set nginx-deployment-559d658b74 to 1
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled up replica set nginx-deployment-66b6c48dd5 to 3
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled down replica set nginx-deployment-66b6c48dd5 to 2
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled up replica set nginx-deployment-559d658b74 to 2
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled down replica set nginx-deployment-66b6c48dd5 to 1
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled up replica set nginx-deployment-559d658b74 to 3
  Normal  ScalingReplicaSet  50m                deployment-controller  Scaled down replica set nginx-deployment-66b6c48dd5 to 0
  Normal  ScalingReplicaSet  42m                deployment-controller  Scaled down replica set nginx-deployment-559d658b74 to 2
  Normal  ScalingReplicaSet  42m (x4 over 42m)  deployment-controller  (combined from similar events): Scaled down replica set nginx-deployment-559d658b74 to 0
```

Este comando es bastante util ya que nos permite ver como esta compuesto el deployment, que template usan los pods, y la seccion `Events`, que nos muestra los eventos que se han registrado. Si nuestro deployment cambia en el tiempo tendremos nuevas versiones del deployment, ya que el mismo es inmutable (a menos que borremos el deployment).

## Editando un deployment

Podemos editar un deployment de varias maneras, sea actualizando el yaml que tenemos, o bien actualizandolo al vuelo con el comando  `kubectl edit deployment.v1.apps/<deployment name>`

```bash
$ kubectl edit deployment.v1.apps/nginx-deployment
```

nos va a abrir el spec del deployment donde vamos a poder cambiar el valor del campo .spec.template.spec.containers[0].image de nginx:1.14.1 a nginx:1.16.1. Una vez editado nos va a dar el siguiente resultado:

```bash
deployment.apps/nginx-deployment edited
```

Para ver el estado del despliegue:

```
kubectl rollout status deployment.v1.apps/nginx-deployment
```

una vez que se haya completado el roll update, nos va a devolver este comando, el siguiente resultado: `deployment "nginx-deployment" successfully rolled out`


otra alternativa de edicion en linea puede ser escalar los pods del deployment:

```
kubectl scale deployment.v1.apps/nginx-deployment --replicas=3
```

una vez que ya este el update listo, podemos ver los recursos que tenemos en el viejo y el nuevo deployment:

```
$ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-559d658b74   0         0         0       60m
nginx-deployment-66b6c48dd5   3         3         3       64m
```

tambien podemos autoescalar el cluster con:

```
kubectl autoscale deployment.v1.apps/nginx-deployment --min=3 --max=5 --cpu-percent=80
```

Esto nos crea al menos 3 pods y como maximo 5, y cada vez que el cpu de uno de los pods existentes llegue al cpu de 80% se va a crear un nuevo pod.

```
$ kubectl get hpa
NAME               REFERENCE                     TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   <unknown>/80%   3         5         3          8m5s
```

Si queremos ahora ver como esta compuesto el autoscaler que tenemos pdemos hacer algo como: `kubectl get hpa.v2beta2.autoscaling -o yaml`

```bash
$ kubectl get hpa.v2beta2.autoscaling -o yaml 
apiVersion: v1
items:
- apiVersion: autoscaling/v2beta2
  kind: HorizontalPodAutoscaler
  metadata:
    creationTimestamp: "2021-06-28T21:54:58Z"
    name: nginx-deployment
    namespace: default
    resourceVersion: "7937"
    uid: ec23c4c9-24f4-45ef-b585-bfca76e0d1c8
  spec:
    maxReplicas: 5
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 80
          type: Utilization
      type: Resource
    minReplicas: 3
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: nginx-deployment
  status:
    conditions:
    - lastTransitionTime: "2021-06-28T21:55:14Z"
      message: the HPA controller was able to get the target's current scale
      reason: SucceededGetScale
      status: "True"
      type: AbleToScale
    - lastTransitionTime: "2021-06-28T21:55:14Z"
      message: 'the HPA was unable to compute the replica count: failed to get cpu
        utilization: unable to get metrics for resource cpu: unable to fetch metrics
        from resource metrics API: the server could not find the requested resource
        (get pods.metrics.k8s.io)'
      reason: FailedGetResourceMetric
      status: "False"
      type: ScalingActive
    currentMetrics: null
    currentReplicas: 3
    desiredReplicas: 0
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```

Tambien ademas de hacerlo inline, podemos hacer tambien un 

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-autoscaler
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
  minReplicas: 3
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
```