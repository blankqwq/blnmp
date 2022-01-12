#!/bin/sh
function println(){
    echo "------${1}------"
}

function init(){
    println "build-start"
    docker-compose build

}

function create_nginx(){
    println "create-nginx-start"
    println "create-nginx-end"
}

function composer(){
    return 0
}

function get(){
    cd $CODE_DIR_NAME
    println "get-start"
    git clone $1 $2
    println "composer install"
    composer $2
}

function docker_handle(){
    if [ $1 = "up" ] || [ $1 = "u" ]
    then
        docker-compose up -d
    else 
        docker-compose $1 $2 $3 $4 $5
    fi
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
            docker_handle $2
            ;;
        *)
            help
    esac
    return 0
}

handle $1 $2