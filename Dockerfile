FROM firekcc/java
MAINTAINER firekcc <lyk_1226@126.com>

ARG MAVEN_VERSION=3.6.1
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apk update\
    && apk upgrade\
    && apk add --update curl\
    && mkdir -p /opt/maven /opt/maven/ref\
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz\
    && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c -\
    && tar -xzf /tmp/apache-maven.tar.gz -C /opt/maven --strip-components=1\
    && rm -f /tmp/apache-maven.tar.gz\
    && ln -s /opt/maven/bin/mvn /usr/bin/mvn\
    && apk del perl\
    && rm -rf /var/cache/apk/*

ENV MAVEN_HOME /opt/maven
ENV MAVEN_CONFIG /root/.m2

ADD mvn-entrypoint.sh /opt/bin/
ADD settings.xml /opt/maven/ref

#ENTRYPOINT ["/opt/bin/mvn-entrypoint.sh"]
CMD ["mvn","-v"]





