# Kubernetes

Kubernetes is a powerful framework for orchestrating application containers developed by Google. Like **Docker Swarm**, Kubernetes performs the basic functions of an orchestration tool, such as ensuring high availability, protecting internal traffic, and encapsulating a complex microservice application architecture into a single entity. But what is the main difference between Kubernetes and Docker Swarm? Besides being more complex and offering more control over containers, Kubernetes's main feature is that it is a higher-level solution than Docker Swarm and is not directly tied to Docker technology. **Docker** is currently the absolute leader in application containerization, but it is not the only technology. Kubernetes offers a unified approach regardless of the containerization tool.

## The architecture and principles of Kubernetes

Conceptually, a Kubernetes cluster is the following structure:

<img src="misc/images/kubernetes.drawio.png"  width="600">

The Kubernetes architecture includes the following main components:

The **master node** is the main node that manages all the nodes in a Kubernetes cluster. It consists of several components:

1. The kube-apiserver — a component that provides an API for managing a Kubernetes cluster.
2. etcd — a key-value store that stores Kubernetes cluster configuration data.
3. kube-scheduler — a component responsible for scheduling work on nodes in a Kubernetes cluster.
4. kube-controller-manager — a component that manages the controllers that are responsible for performing operations such as scaling and fault recovery.

A **Node**, or **Worker node**, is the node on which application containers run. It consists of the following components:

1. kubelet — a component that manages containers on the node and communicates with the kube-apiserver on the master node.
2. kube-proxy — a component that is responsible for routing network requests to containers on the node.

A **Pod** is the smallest unit in Kubernetes and contains one or more application containers. A Pod is a minimal Kubernetes abstraction because Kubernetes seeks to move away from being bound to a specific containerization tool. This necessitates the creation of a new type of abstraction: an additional "container for containers." Each Pod has its own IP address, which is determined dynamically when it runs, and shares the resources of the host on which it runs. Note that when a Pod is restarted, its IP address changes because a new Pod is actually being started.

However, there are many other objects necessary to understand the Kubernetes architecture. Most of these objects are listed below.

A **Service** is a Kubernetes object that provides a persistent IP address and DNS name for accessing the application within the cluster. It can route requests to different Pods based on selectors. Additionally, when replicating a Pod, the service object acts as a balancer, distributing requests between replicas.

A Kubernetes **Volume** is an object used to store data needed by containers in a Pod. A volume can be connected to an application container to provide access to data.

A **Namespace** is a Kubernetes object that groups cluster resources and shares access to those resources between users and teams.

In Kubernetes, **replication** is a mechanism that allows you to create multiple copies of the same application and run them on multiple nodes. This ensures the application's high availability and allows you to handle large workloads.

A **Replication Controller** manages the process of creating and scaling replicated Pods in Kubernetes. When a Replication Controller is created, it creates the specified number of Pods. If any Pod fails or is deleted, the controller automatically creates a new Pod to replace it.

Replicated Pods have a label that helps the Replication Controller manage them. Labels are also used to determine which Pods should receive traffic.

You can use Replica Controllers to scale applications horizontally by increasing or decreasing the number of replicated Pods. This allows you to quickly respond to changes in application load.

In Kubernetes, **Deployment** and **StatefulSet** are objects that control application runtime and scaling. These objects provide a declarative way to define the desired state of an application and manage its lifecycle automatically.

A **Deployment** provides management of application deployment (installation) in Kubernetes. It specifies how and when to create application instances, as well as which updates to apply when the configuration changes. Deployments automatically create and manage multiple replicas of the application for fault tolerance and scalability.

**StatefulSet** provides control over the installation and scaling of stateful applications. This can be useful for databases that store data on hard disks and cannot be easily copied and run on another cluster node, for example. StatefulSet provides unique names for each application instance, stores their state, and provides unique host IDs for each instance.

In both cases, Kubernetes automatically manages the application lifecycle, including scaling, updating, and rolling back changes. Developers can define the desired state of the application, and Kubernetes will ensure it is achieved and maintained throughout the application's life cycle.

In Kubernetes, the **Ingress** is an object that allows you to manage incoming traffic to the cluster. Ingress serves as a controller that defines traffic routing rules between services within the cluster and external services. It enables developers and administrators to manage incoming traffic, configure routing and security, and perform load balancing. Additionally, Ingress can be used to configure SSL encryption and client authentication. Overall, using Ingress simplifies network management and improves application performance on Kubernetes.

**ConfigMap** and **Secret** are two Kubernetes mechanisms for storing configuration data and secrets, respectively.

A **ConfigMap** stores configuration data used by applications in containers, usually as environment variables. These can be parameters that need to be changed when deploying an application, such as a database address or web server port. A ConfigMap can be applied to any number of containers in a Pod.

A **Secret** is used to store sensitive information, such as passwords, keys, and certificates. Secrets can be used for any number of containers in a Pod. It is important to note that Secrets are stored encrypted in the etcd of the Kubernetes cluster.

Using ConfigMap and Secret reduces the number of parameters required in application manifests and improves application security since confidential information is not stored in clear form.

## The kubectl command line interface

**Kubectl** is a Kubernetes API client that provides access to functions in the Kubernetes environment. The Kubernetes API is an HTTP REST API server that provides access to all Kubernetes functions as endpoints for HTTP requests.

### Basic kubectl commands

* **config**

Configuring and displaying the system configuration (kubeconfig):

  `kubectl config view`.

* **apply**

Managing Kubernetes resources:

  `kubectl apply -f <relative path to the manifest>`;

  `kubectl explain pods`.

* **get**

Viewing and finding system resources:

  `kubectl get <resource name> --<search parameters>`.

* **edit, scale, delete**

Editing specific system resources. The most popular commands when maintaining a Kubernetes system are:

  `kubectl edit <service name>`;

  `kubectl scale --replicas=<number of services> <service name|path to the manifest file>`;

  `kubectl delete <service name|path to the manifest file>`.

* **logs**

This is an important tool for debugging the system in case of errors. Often, the problem lies not only in the incorrect configuration of the orchestration system but also in the software product running in the environment.

To debug a software product, use the command:

  `kubectl logs <service name>`.

## Manifest

A Kubernetes **manifest** is a file that describes the desired state of a Kubernetes object. A manifest can contain parameters and configuration settings for objects such as deployments, services, and configuration maps.

The general structure of a Kubernetes manifest is as follows:

```yml
apiVersion: <API version> # version of the Kubernetes API that the object uses
kind: <Object type> # object type (deployment, service, configmap, etc.)
metadata: # object's metadata, such as title, labels, etc.
  name: <Object name>
  labels:
    <Object labels>
spec: # object specification describing the desired state
  <Object parameters>
```

For example, the manifest for a deployment might look like this:


```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image
        ports:
        - containerPort: 8080
```

In this example, we specify the desired number of replicas (3), define a selector to identify Pods labeled `app: my-app`, and describe the Pod template to be created, if necessary. The template specifies the name of the container, the image used, and the port to be opened in the container.

Splitting manifests into different files to show a step-by-step deployment is a common practice. For instance, you might first create a configuration map, then secrets, then services, and so on.