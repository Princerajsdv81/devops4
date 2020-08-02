FROM ubuntu

RUN apt-get clean autoclean;
RUN apt-get autoremove --yes;
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt-get update ;
RUN apt-get upgrade -y ;
RUN apt-get install openssh-server -y;
RUN apt-get install openjdk-8-jdk -y;
RUN apt-get install curl -y ;
RUN adduser --quiet --disabled-password --gecos "jenkins" jenkins ;
RUN echo "jenkins:jenkins" | chpasswd ;
RUN mkdir /home/ws ;
RUN chown -R jenkins:jenkins /home/ws/
RUN mkdir /run/sshd ;

RUN mkdir /root/.kube
COPY config /root/.kube
COPY ca.crt /root/.kube/
COPY client.crt /root/.kube
COPY client.key /root/.kube/

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl ;


RUN chmod +x ./kubectl

RUN mv ./kubectl /usr/local/bin/kubectl

COPY config /home/jenkins/.kube/


CMD ["/usr/sbin/sshd", "-D"] ;

