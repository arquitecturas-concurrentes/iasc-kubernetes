## HPA 

*Nota: el componente de HPA necesita de `metrics-server` para funcionar, por lo que hay que instalar este servicio previamente*

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.2/components.yaml
```

En este ejemplo final vamos a usar un componente nuevo llamado [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/), que nos permite escalar automaticamente la cantidad de pods de un replica controller basado en el uso de los recursos actuales de las replicas levantadas.


![](./horizontal-pod-autoscaler.svg)

Este componente mediante el [calculo de metricas](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details) o [limites](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details) que podemos setearle.

En el ejemplo podemos hacer que el deployment de `iasc-service` se pueda escalar hasta 5 pods, teniendo como punto de partida dos replicas iniciales. En `spec.scaleTargetRef`, se define el target del recurso a escalar y `spec.scaleTargetRef.targetCPUUtilizationPercentage`, permite definir el threshold relativo de uso de la CPU para que HPA escale en 1 la cantidad de pods levantados del deployment apuntado.

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: iasc-service-autoscaler
  namespace: iasc
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: iasc-service
  minReplicas: 2
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
```  