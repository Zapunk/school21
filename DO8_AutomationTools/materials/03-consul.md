# Consul

Initially, applications had a monolithic structure, meaning they consisted of one large service. However, this approach began to lose popularity among web solutions due to the growing importance of the following issues:

1. Such services are difficult to scale. Even if only one module needs to be scaled, it essentially means rescaling the entire application.
2. There is little flexibility. The technology stack for each module is strongly tied to the technologies used in other modules of the monolith.
3. Development complexity. The larger a monolith becomes, the harder it is to change, often because there are no clear interaction protocols between modules, which leads to the need to change many modules to add functionality to just one.

In response to these problems, a new idea emerged: changing the architecture from monolithic to microservices. Now, each entity is managed by a separate service that communicates with the other modules using a clearly defined protocol. Additionally, microservices can be located in a cluster using completely independent stacks. However, as is often the case, this has led to other equally serious problems.

1. Service Discovery: Services need to know the exact location of other services, which requires a complex configuration of modules that is highly dependent on the network topology.
2. Safety: Microservers send data to each other over an open network, so this data can be intercepted. A new vulnerability is emerging.

**Consul** is a tool designed to implement the Service Discovery pattern. It is primarily intended to eliminate the need for manual configuration of communication channels in microservice architecture applications. Now, instead of communicating directly with each other, services are registered in a separate *registry* before being deployed as part of a microservice application. Each microservice accesses only the proxy server *envoy* situated locally for that microservice (i.e., it "goes" to its localhost). The proxy server automatically resolves the microservice's requests based on the registered IP addresses of the necessary services in the system, returns *registry*.

Thus, all services are combined into one logical unit: the **Service Mesh**. The Service Mesh has its own data center, one or more Consul servers, and many registered services. Additionally, the Service Mesh provides authorization and encryption of connections between services using the Transport Layer Security (TLS) protocol, ensuring that "naked" service traffic never leaves a particular node.

<img src="misc/images/consul_diagram.png"  width="400">

Consul has a client-server architecture. A Consul server is installed on a machine within the network and performs Service Discovery in combination with lightweight agent clients located on registered machines with services that perform proxying.

Consul's performance is determined by the configuration file specified when Consul is run. You can validate the configuration file before running it with the command `consul validate <config file name>`.

Main fields of the configuration file:

- `server` — the flag that controls the type of agent (client/server — true/false).
- `advertise_addr` — the IP address used to announce to other nodes in the cluster.
- `bind` — the IP address/interface that the agent uses on its local machine.
- `ports` — ports for Consul agents (e.g., GRPC).
Рубрика