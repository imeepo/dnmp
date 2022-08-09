# +---------------------+ #
#        基本设置
# +---------------------+ #

ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

# alpine国内镜像源
ARG ALPINE_MIRRORS_URL
RUN if [ $ALPINE_MIRRORS_URL ] ; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_MIRRORS_URL}/g" /etc/apk/repositories; \
    fi

# 设置时区
ARG TZ
RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

# PHP镜像的www-data用户uid和gid都是82，需要把它们变更为1000 (主用户)
RUN apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data


# +---------------------+ #
#        安装扩展
# +---------------------+ #

ARG PHP_EXTENSIONS
COPY ./extensions /tmp/extensions
WORKDIR /tmp/extensions
RUN chmod +x install.sh \
    && sh install.sh \
    && rm -rf /tmp/extensions
ADD ./extensions/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions


# +---------------------+ #
#        可选安装
# +---------------------+ #

# 修复: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${ALPINE_MIRRORS_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# 是否安装Composer
ARG PHP_INSTALL_COMPOSER
RUN if [ ${PHP_INSTALL_COMPOSER} = true ] ; then \
        curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar && \
        chmod +x /usr/bin/composer; \
    fi


# +---------------------+ #
#        最后操作
# +---------------------+ #

# 设置进入容器后默认进入的目录
WORKDIR /www
