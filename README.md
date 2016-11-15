# hotsaw
Log collecting from Websphere to ElasticSearch 

Hotsaw is powerfull Logmanagement Service for application logs.

Logs are shipped over Logcourier to Elastic Search Nodes, where also the preprocessign with Logstash is done.
Logcouier itself is an enterprise shiper with features for multiline log preprocessing and dynamic config control on server clients.
A custom logsize limiter was build to limit the amount of data per websphere application server.
All WebSphere nodes are balanced and allow with logcourier embedded zeromq technology to queue/balance log messages on client side were required.

Features:
The log management system processed up to 70 GB logs/day collected from 50 Linux servers with running 300 web applications on WebSphere Application Server 8.0

Custom filter available for WebSphere Application Server Logs:
- SystemOut.log
- SystemErr.log
- Access.log (Inbound Default)

Hardware: 2 Servers Linux VMWare (32 GB Mem, 3 TB Diskspace) 
Current version of ELK stack: Logcourier 1.1, Logstash/ElasticSearch 1.4.4, Kibana 4.0
