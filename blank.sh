#!/bin/bash

function println(){
    echo "start:    ${1}"
    echo "---------------------"
}

function init(){
    println "build-start"
    docker-compose build

}

function create_nginx(){
    println "create-nginx-start"
    println "create-nginx-end"
}

function get_user_input(){
    read -p "${1}" y
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
    fi
    return 0
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
    println "composer install"
    flag=1
    name=$2
    set +x
    echo $name
    BASE_DIR="${CODE_DIR_NAME}/${name}"
    DOCKER_BASE_DIR="${DOCKER_CODE_DIR_NAME}/${name}"
    composer_check $name
    npm_check $name
    # 生成对应conf

    # 重启nginx
    docker_handle restart nginx
    # 写入host

    # other...
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
    echo "please intput [init|get|install]"
    echo "many uses input -h"
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