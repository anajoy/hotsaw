# hotsaw
log fileshiper websphere to ELK 

Hotsaw is powerfull Logmanagement Service for application logs.

Logs are shipped over Logcourier to Elastic Search Nodes, where also the preprocessign is done.
Logcouier itself is an intelligent shiper with added features for multiline log preprocessing and dynamic config control.
A custom logsize limiter was build to limit the amount of data per websphere application server.
All WebSphere nodes are balanced and allow with zeromq technology to queue up log messages were required.

Features:
Custom filter available for WebSphere Application Server Logs:
- SystemOut.log
- SystemErr.log
- Access.log (Inbound Default)
