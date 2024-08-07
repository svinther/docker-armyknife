FROM debian:12-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
openssh-server \
iputils-ping \
net-tools \
iproute2 \
dnsutils \
nmap \
rsync \
ncat \
curl \
telnet \
jq \
less \
pv \
git \
vim \
bash-completion \
&& rm -rf /var/lib/apt/lists/*

#https://kubernetes.io/releases/
RUN curl -L -o /usr/local/bin/kubectl https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
&& chmod +x /usr/local/bin/kubectl \
&& kubectl completion bash > /etc/bash_completion.d/kubectl

RUN echo . /etc/bash_completion >> /root/.bashrc

RUN mkdir /var/run/sshd \
&& echo 'root:root' | chpasswd \
&& sed -i 's/#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-o", "LogLEvel=DEBUG"]
