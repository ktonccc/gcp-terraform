# Usa una imagen base de Jenkins LTS
FROM jenkins/jenkins:lts

# Cambia al usuario root para instalar paquetes
USER root

# Instala paquetes necesarios
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    unzip

# Instala Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update && apt-get install -y terraform

# Instala Google Cloud SDK (gcloud)
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y

# Instala plugins de Jenkins para Terraform y Google Cloud
RUN /usr/local/bin/install-plugins.sh \
    workflow-aggregator \
    git \
    ssh-slaves \
    terraform \
    google-cloud-sdk

# Establece la configuración por defecto de Jenkins
COPY config/jenkins-settings/* /usr/share/jenkins/ref/

# Expone el puerto de Jenkins
EXPOSE 8080

# Establece el directorio de trabajo
WORKDIR /var/jenkins_home

# Ejecuta Jenkins
CMD ["/usr/local/bin/jenkins.sh"]
