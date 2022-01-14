#!/bin/bash

function println(){
    echo "------\t\t${1}\t\t------"
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
    if [ -d "${CODE_DIR_NAME}/${2}/vendor" ]
    then
        echo "已检测到执行过composer ... "
        echo "是否继续执行 [y/n]" && read y
        if [ -z $y ] || [ $y = "n" ]
        then
            flag=0
        fi
    fi
    if [ $flag -eq 1 ]
    then
        docker-compose exec php sh -c "cd ${2} && composer install"
    fi
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