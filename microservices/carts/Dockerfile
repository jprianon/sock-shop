FROM weaveworksdemos/carts:0.4.8

#Version 1

# Set hostname
ENV HOSTNAME=carts

# Security settings
USER nobody:nogroup
#RUN sudo chmod 755 /usr/src/app

# Environment variables
ENV JAVA_OPTS="-Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false"

# Container settings
CMD ["java", "-jar", "carts.jar"]
