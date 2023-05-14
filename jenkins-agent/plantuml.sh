#!/bin/sh
# Simple wrapper for the PlantUML jar file
${JAVA_HOME}/bin/java \
            -Djava.net.useSystemProxies=true \
            -Djava.awt.headless=true \
            -jar \
            /usr/share/java/plantuml.jar "$@"
