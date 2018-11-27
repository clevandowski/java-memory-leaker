LOG_DATE:=$(shell date +%F_%H-%M-%S)

build:
	docker build -t clevandowski/memory-leaker:1.0 .

# JVM memory parameters prevents container OOMKilled
# info from docker container inspect:
# {
#   "Memory": 536870912,
#   "MemorySwap": -1,
#   "MemorySwappiness": 0
# }
# Limit max before the container is OOKilled:~370m
run-swap-disabled:
	docker run --memory=512m --memory-swappiness=0 -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms372m -Xmx372m -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy' \
		clevandowski/memory-leaker:1.0

# In progress
run-swap-disabled-G1:
	docker run --memory=256m --memory-swappiness=0 -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms512m -Xmx512m -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy -XX:+UseG1GC -XX:G1HeapRegionSize=16M' \
		clevandowski/memory-leaker:1.0

# Paramètre de la swap par défaut:
# {
#   "Memory": 268435456,
#   "MemorySwap": 536870912,
#   "MemorySwappiness": null
# }
# ==> Swap de 256m (swap=MemorySwap-Memory), donc 1x la mémoire
run-default-swap:
	docker run --memory=256m -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms350m -Xmx350m -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy' \
		clevandowski/memory-leaker:1.0


# Will swap until JVM reach OutOfMemory of heap space
# bad usage of --memory-swap ?
# see https://docs.docker.com/config/containers/resource_constraints/#--memory-swap-details 
#
# Container parameters from docker container inspect:
# {
#   "Memory": 268435456,
#   "MemorySwap": 268435456,
#   "MemorySwappiness": null
# }
# swap=MemorySwap-Memory=0
run-swap-0:
	docker run --memory=512m --memory-swap=512m -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms350m -Xmx350m -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy' \
		clevandowski/memory-leaker:1.0

run-swap-limited:
	docker run --memory=256m --memory-swap=512m -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms350m -Xmx350m -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy' \
		clevandowski/memory-leaker:1.0

run-swap-unlimited:
	docker run --memory=256m --memory-swap=-1 -v $$PWD/logs:/logs -p 8080:8080 -p 9010:9010 \
		--env JAVA_OPTS='-XX:+PrintFlagsFinal -Xms2g -Xmx2g -XX:+ExitOnOutOfMemoryError -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xloggc:/logs/${LOG_DATE}-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCCause -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=5M -XX:+PrintAdaptiveSizePolicy' \
		clevandowski/memory-leaker:1.0

