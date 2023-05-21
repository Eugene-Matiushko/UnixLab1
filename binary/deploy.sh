#!/bin/bash
TOMCAT_SERVER_DIR=/mnt/c/Uni/Tomcat/apache-tomcat-10.1.8
WAR_FILE_NAME=/mnt/c/Uni/demo/binary/jopa.war
APP_ENDPOINT=/UnixApp
TOMCAT_USERNAME=robot
TOMCAT_PASSWORD=12345
TOMCAT_MANAGER_PORT=8080
TOMCAT_MANAGER_PROTOCOL=http
deploy_app() {
echo "Deploying $WAR_FILE_NAME..."
curl -sS -u $TOMCAT_USERNAME:$TOMCAT_PASSWORD "$TOMCAT_MANAGER_PROTOCOL://localhost:$TOMCAT_MANAGER_PORT/manager/text/deploy?path=$APP_ENDPOINT&update=true" --upload-file "$WAR_FILE_NAME"
}
undeploy_app() {
echo "Undeploying $WAR_FILE_NAME..."
curl -sS -u $TOMCAT_USERNAME:$TOMCAT_PASSWORD "$TOMCAT_MANAGER_PROTOCOL://localhost:$TOMCAT_MANAGER_PORT/manager/text/undeploy?path=$APP_ENDPOINT&update=true"
}
start_server() {
echo "Starting Tomcat server..."
sh $TOMCAT_SERVER_DIR/bin/startup.sh
}
stop_server() {
echo "Stopping Tomcat server..."
sh $TOMCAT_SERVER_DIR/bin/shutdown.sh
}
usage() {
echo "Usage: $0 [-d] [-u] [-s] [-t] [-p]"
echo "Options:"
echo " -d: Deploy the application"
echo " -u: Undeploy the application"
echo " -s: Start the Tomcat server"
echo " -t: Stop the Tomcat server"
echo " -p: Displays the status of the deployed application"
}

status_app() {
echo "Displaying status of $APP_ENDPOINT..."
curl -sS -u $TOMCAT_USERNAME:$TOMCAT_PASSWORD "$TOMCAT_MANAGER_PROTOCOL://localhost:$TOMCAT_MANAGER_PORT/manager/text/list" | grep $APP_ENDPOINT
}
while getopts ":dustbrph:c:" opt; do
case $opt in
d)
deploy_app
;;
u)
undeploy_app
;;
s)
start_server
;;
t)
stop_server
;;
p)
status_app
;;
h)
usage
exit 0
;;
\?)
echo "Invalid option: -$OPTARG" >&2
usage
exit 1
;;
:)
echo "Option -$OPTARG requires an argument." >&2
usage
exit 1
;;
esac
done