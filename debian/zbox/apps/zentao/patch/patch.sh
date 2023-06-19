#!/bin/bash

check_syntax(){
    local phpfile=$1
    return "$(php -l "$phpfile" | grep -c 'No syntax')"
}

fix_install_step6(){
	local file="control.php"
    local dir="/apps/zentao/module/install"
    cd $dir || exit 1
	cp $file ${file}.fix
	line=$(grep -n "step6()" $file | awk -F : '{print $1}')
	line=$((line+1))
	sed -i "$line a touch(\'/data/.installed.tmp\');" "$file".fix
	diff -uNr $file ${file}.fix > ${file}.patch
	patch -p0 < ${file}.patch
	if check_syntax "$dir/$file";then
        patch -Rp0 < ${file}.patch
    fi
	rm -f ${file}.fix ${file}.patch
}

fix_install_step6