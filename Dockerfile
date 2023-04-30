FROM sonarqube:9.5-community

ENV BRANCH_PLUGIN_VERSION=1.12.0
ENV EXTANALYZER_PLUGIN_VERSION=0.0.16
ENV DEPCHECK_PLUGIN_VERSION=3.0.1
ENV SONAR_SWIFT_PLUGIN_VERSION=0.4.6

ADD --chown=sonarqube:sonarqube https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${BRANCH_PLUGIN_VERSION}/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar /opt/sonarqube/extensions/plugins/
ENV SONAR_WEB_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar=web"
ENV SONAR_CE_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar=ce"

ADD --chown=sonarqube:sonarqube https://github.com/amalabey/sonar-external-analyzer/releases/download/release-${EXTANALYZER_PLUGIN_VERSION}/sonar-external-analyzer-${EXTANALYZER_PLUGIN_VERSION}.jar /opt/sonarqube/extensions/plugins/
ADD --chown=sonarqube:sonarqube https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/${DEPCHECK_PLUGIN_VERSION}/sonar-dependency-check-plugin-${DEPCHECK_PLUGIN_VERSION}.jar /opt/sonarqube/extensions/plugins/
ADD --chown=sonarqube:sonarqube https://github.com/Idean/sonar-swift/releases/download/${SONAR_SWIFT_PLUGIN_VERSION}/backelite-sonar-swift-plugin-${SONAR_SWIFT_PLUGIN_VERSION}}.jar /opt/sonarqube/extensions/plugins/


