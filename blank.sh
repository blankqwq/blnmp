#!/bin/bash

function println(){
    echo "start:    ${1}"
    echo "---------------------"
}

function init(){
    println "build-start"
    docker_handle pull
}

function create_nginx(){
    println "create-nginx-start"
    println "create-nginx-end"
}

function get_user_input(){
    read -p "${1}:" y
    flag=0
    case $y in
        "y")
            flag=1
            ;;
        "n")
            flag=0
            ;;
        *)
            flag=$2
    esac
    return $flag
}


function composer_check(){
    if [ -e "${BASE_DIR}/composer.json"  ]
    then
        flag=1
        if [ -d "${BASE_DIR}/vendor" ]
        then
            echo "已检测到执行过composer ... "
            get_user_input "是否继续执行 [y/n]"
            flag=$?
        fi
        if [ $flag -eq 1 ]
        then
            docker-compose exec php sh -c "cd ${DOCKER_BASE_DIR} && composer install"
        fi
        return 1
    fi
    return 0
}

function npm_check(){
    if [ -e "${BASE_DIR}/package.json"  ]
    then
        flag=1
        if [ -d "${BASE_DIR}/node_modules" ]
        then
            echo "已检测到执行过npm ... "
            get_user_input "是否继续执行 [y/n]"
            flag=$?
        fi
        if [ $flag -eq 1 ]
        then
            docker-compose exec node sh -c "cd ${DOCKER_BASE_DIR} && cnpm install"
        fi
        return 1
    fi
    return 0
}

function nginx_generate(){
    name=${1}
    WEB_SITE="www.${name}.test"
    WEB_SITE_PUBLIC="${name}\/public"
    if [ ! -e "${BASE_DIR}/public" ] 
    then
        WEB_SITE_PUBLIC="${name}"
    fi
    TARGET_NGINX_FILE=$NGINX_DIR/$WEB_SITE.conf
    TEMPLATE_FILE=$TEMPLATE_DIR/nginx/php.conf
    flag=1
    if [ -e "${TARGET_NGINX_FILE}"  ]
    then
        echo "已检测到执行过nginx generate ... "
        get_user_input "是否继续执行 [y/n]"
        flag=$?
    fi
    if [ ${flag} -eq 1 ]
    then 
        # generate
        sed -e 's/${DOMAIN}/'"$WEB_SITE"'/g' -e  's/${PATH}/'"$WEB_SITE_PUBLIC"'/g' ${TEMPLATE_FILE} > ${TARGET_NGINX_FILE}
    fi
    docker_handle restart nginx
}

function get(){
    println "get-start"
    cd $CODE_DIR_NAME
    if [ -d $2  ] 
    then
        println "${2} dir exist"
    else
        git clone $1 $2
    fi
    cd ..
    println "start other install"
    flag=1
    name=$2
    set +x
    echo $name
    BASE_DIR="${CODE_DIR_NAME}/${name}"
    DOCKER_BASE_DIR="${DOCKER_CODE_DIR_NAME}/${name}"
    NGINX_DIR="./nginx/conf/vhost/"
    composer_check $name
    IS_BE=$?
    if [ ${IS_BE} -eq 1 ]
    then
        nginx_generate $name
    else
        npm_check $name
        IS_FE=($?)
    fi
}

function docker_handle(){
    set -x
    if [ $1 = "up" ] || [ $1 = "u" ]
    then
        docker-compose up -d
        return 0
    fi
    docker-compose $*
}

function install(){
    return 0
}

function help(){
    echo "please intput [init|d|get]"
    echo "d: docker-compose handle"
    echo "get: project init"
}

handle(){
    # 获取参数执行对应函数
    # 判断是否有env文件
    if [ ! -e .env ] 
    then
        cp .env.example .env
    fi
    source .env
    case $1 in
        "init")
            init $2
            ;;
        "get")
            get $2 $3 $4
            ;;
        "install")
            install $2
            ;;
        "d")
            docker_handle $2 $3 $4
            ;;
        *)
            help
    esac
    return 0
}

handle $*