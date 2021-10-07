#!/bin/bash

set_hibernate_configuration() {
  cat <<EOF
<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
        <session-factory>
                <property name="connection.url">jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}</property>
                <property name="connection.driver_class">com.mysql.jdbc.Driver</property>
                <property name="dialect">org.hibernate.dialect.MySQL5InnoDBDialect</property>
                <property name="connection.username">${DB_USER}</property>
                <property name="connection.password">${DB_PWD}</property>
                <property name="show_sql">false</property>
                <property name="format_sql">false</property>

        <property name="hibernate.cache.region.factory_class">org.hibernate.cache.ehcache.EhCacheRegionFactory</property>
                <property name="hibernate.cache.use_query_cache">false</property>
                <property name="hibernate.cache.use_second_level_cache">false</property>
                <property name="hibernate.generate_statistics">false</property>

                <property name="connection.provider_class">org.hibernate.service.jdbc.connections.internal.C3P0ConnectionProvider</property>
                <property name="c3p0.acquire_increment">1</property>
                <property name="c3p0.idle_test_period">100</property>
                <property name="c3p0.max_size">100</property>
                <property name="c3p0.min_size">10</property>
                <property name="c3p0.timeout">100</property>


                <!-- Nao adicione as classes aqui! Elas ficariam replicadas em 3 xmls!
                                             Deixe somente no SessionFactoryCreator! -->

        </session-factory>
</hibernate-configuration>
EOF
}

conf_basic() {
  cat <<EOF
host=http://${MAMUTE_HOST}:${MAMUTE_PORT}
home.url=/
mail_logo_url=http://${MAMUTE_HOST}:${MAMUTE_PORT}/imgs/logo-mail.png
use.routes.parser.hack=false

feature.facebook.login = false
feature.google.login = false

feature.solr = ${MAMUTE_ENABLE_SOLR}
feature.signup=${MAMUTE_ENABLE_SIGNUP}
deletable.questions = ${MAMUTE_ALLOW_QUESTION_DELETE}

attachments.root.fs.path = ${MAMUTE_ATTACHMENTS_PATH}
EOF
}

conf_email() {
  cat <<EOF
vraptor.simplemail.main.server = ${MAIL_SERVER}
vraptor.simplemail.main.port = ${MAIL_PORT}
vraptor.simplemail.main.tls = ${MAIL_USE_TLS}
vraptor.simplemail.main.username = ${MAIL_USERNAME}
vraptor.simplemail.main.password = ${MAIL_PASSWORD}
vraptor.errorcontrol.error.subject = Production error at Mamute

vraptor.simplemail.main.from = ${MAIL_FROM}
vraptor.simplemail.main.from.name = ${MAIL_FROM_NAME}
EOF
}

conf_ldap() {
  (( ${#LDAP_HOST} == 0 )) && return

  cat <<EOF
feature.auth.ldap=true
feature.auth.db=false

ldap.host=${LDAP_HOST}
ldap.port=${LDAP_PORT}
ldap.user=${LDAP_USER}
ldap.pass=${LDAP_PASS}
ldap.emailAttr=mail
ldap.nameAttr=givenName
ldap.surnameAttr=sn
ldap.userDn=${LDAP_USERDN}
ldap.groupAttr=${LDAP_GROUP_ATTR}
ldap.moderatorGroup=${LDAP_MODERATOR_GROUP}
ldap.useSSL=${LDAP_USE_SSL}
EOF
}

set_configuration() {
  conf_basic
  conf_email
  conf_ldap
}

set_hibernate_configuration > WEB-INF/classes/production/hibernate.cfg.xml
set_configuration > WEB-INF/classes/production.properties

PORT=${MAMUTE_PORT} /opt/mamute/run.sh
