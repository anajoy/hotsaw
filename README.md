# hotsaw
log fileshiper websphere to ELK 

Hotsaw is Powerfull Logmemangment Service for Application Logs.

Logs are shipped over Logcourier to Elastic Search Nodes, where also the preprocessign is done.
Logcouier itself is an intelligent shiper with added features for multiline log preprocessing and dynamic config control.
A custom logsize limiter was build to limit the amount of data per application server websphere.
All WebSphere nodes are balanced and allow with zeromq technology to queue up log messages were required.
