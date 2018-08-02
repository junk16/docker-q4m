FROM centos:7
MAINTAINER jun.yamada jun.16@mac.com

RUN yum  groupinstall -y "Development Tools"
RUN yum install -y wget \
                   ncurses-static.x86_64 \
                   ncurses-static.i686

RUN wget https://downloads.mysql.com/archives/get/file/mysql-5.1.72.tar.gz -P /tmp \
  && cd /tmp && tar zxf mysql-5.1.72.tar.gz && cd mysql-5.1.72 \
  && ./configure \
  && make install \
  && groupadd mysql \ 
  && useradd -r -g mysql mysql \
  && mysql_install_db --user=mysql \ 
  && chmod 744 /tmp/mysql-5.1.72/support-files/mysql.server \
  && /tmp/mysql-5.1.72/support-files/mysql.server start \
  && wget http://q4m.kazuhooku.com/dist/q4m-0.9.10.tar.gz -P /tmp \ 
  && cd /tmp && tar zxf q4m-0.9.10.tar.gz \
  && cd /tmp/q4m-0.9.10 \
  && ./configure --with-mysql=/tmp/mysql-5.1.72 \
  && make install \
  && mysql -u root < /tmp/q4m-0.9.10/support-files/install.sql \
  && mysql -uroot -e "grant all privileges on *.* to root@'%'"

RUN rm -rf /tmp/mysql-5.1.72* && rm -rf q4m-0.9.10*

EXPOSE 3306
CMD ["mysqld_safe", "--user=mysql"]
