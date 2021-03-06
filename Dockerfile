FROM ubuntu:18.04

# User Name
ARG USERNAME=yoichiro

# Install Dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget curl zip lsb-release ssh && \
# Install Google Cloud SDK
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk google-cloud-sdk-app-engine-java

# Add a new user
RUN groupadd --gid 1000 $USERNAME && useradd -u 1000 -g 1000 -s /bin/bash -d /home/$USERNAME -m $USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME

# Install nodebrew and NodeJS 8
RUN curl -L git.io/nodebrew | perl - setup && \
    /home/$USERNAME/.nodebrew/current/bin/nodebrew install-binary v8.15.0 && \
    /home/$USERNAME/.nodebrew/current/bin/nodebrew use v8.15.0 && \
    /bin/bash -l -c 'echo "export PATH=\$HOME/.nodebrew/current/bin:\$PATH" >> $HOME/.bashrc'

# Prepare working directory
WORKDIR /home/$USERNAME/project

VOLUME /home/$USERNAME/project

# Expose the port for each service
EXPOSE 5000
EXPOSE 5001
EXPOSE 4200
EXPOSE 8080
EXPOSE 8000
EXPOSE 4000

CMD ["/bin/bash"]
