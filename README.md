## otelcollector configuration

is need to activate telemetry on otelcollector to write logs on disk.

This container control the log size (logrotate) and monitor the log from collector in real time, reporting on API if found any error

```
receivers:                                                                                                                                                         
  kafka:                                                                                                                                                          
    brokers:                                                                                                                                                      
    - test-kafka.test.svc.cluster.local:9092                                                                                                          
    topic: otlp_metrics-0a88b255-f876-4467-bac8-1c55f53610a8                                                                                                      
    protocol_version: 2.0.0                                                                                                                                       
extensions:                                                                                                                                                       
  pprof:                                                                                                                                                          
    endpoint: 0.0.0.0:1888                                                                                                                                        
  basicauth/exporter:                                                                                                                                             
    client_auth:                                                                                                                                                  
      username: admin                                                                                                                                             
      password: yourpass                                                                                                                                   
exporters:                                                                                                                                                        
  prometheusremotewrite:                                                                                                                                          
    endpoint: https://prometheus.example.com/api/v1/write                                                                                                        
    auth:                                                                                                                                                         
      authenticator: basicauth/exporter                                                                                                                           
service:
  telemetry:
    logs: 
      level: warn
      encoding: json
      disable_caller: true
      disable_stacktrace: true
      output_paths: [ /var/log/otelcollector-log.json ]
  extensions:
  - pprof
  - basicauth/exporter
  pipelines:
    metrics:
      receivers:
      - kafka
      exporters:
      - prometheusremotewrite
