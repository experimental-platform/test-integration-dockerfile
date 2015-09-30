FROM experimentalplatform/test-integration-baseimage:latest

ADD run_tests.sh /run_tests.sh
ADD Dockerfile-nginx /Dockerfile-nginx
ADD index.html /index.html
RUN chmod 755 /run_tests.sh

RUN mkdir -p /.ssh && ssh-keygen -C "autogenerated $(date)" -V "+2h" -N "" -f /.ssh/id_rsa
RUN cp -a /.ssh /root/

CMD [ "/bin/bash" ]
