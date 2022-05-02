cmd="tar"
# cmd="echo tar"

export cmd

datestring=`date +%s`
dest="raw screenflow zipped"
dropbox_script="/Users/presenter/src/Dropbox-Uploader/dropbox_uploader.sh"

if [ $# -lt 2 ]
  then
    echo "usage: bash backup.sh /path/to/directory/with/screenflow/files /path/to/copy/to/on/dropbox/within/studio-uploads"
    exit
fi

echo "RENAMING old directory"
mv -f "$1/${dest}" "$1/${dest} ${datestring}"

for dir in "" "_archived" "_unused"
do
  if [ -d "$1/${dir}" ]
    then
      echo "PROCESSING $1/${dir}"
      mkdir "$1/raw screenflow zipped/${dir}"
      for sfile in "$1/${dir}"/*.screenflow ; do
        f="${sfile##*/}"
        echo "    ${f}"
        ${cmd} -czf "$1/${dest}/${dir}/${f}.tar.gz" -C "$1/${dir}" "${f}" 
      done  
  fi
done


# remote_dir=${dropbox_script} search $2
# if [ remote_dir -ne "" ]
#   then
#     echo "---------> renaming existing dropbox folder"
#     ${dropbox_script} move $2 "$2-${datestring}"
# fi

destdir="$2-${datestring}"

echo "---------> making new dropbox directory: ${destdir}"
"${dropbox_script}" mkdir ${destdir}

echo "---------> Uploading to dropbox folder $2"
"${dropbox_script}" -hp upload "$1/raw screenflow zipped/"* "${destdir}" 

echo "----------> look for files in /Apps/studio-upload/${destdir}"

# echo "PROCESSING $1"
# dir=$1
# for sfile in "$1"/*.screenflow ; do
#   f="${sfile##*/}"
#   ${cmd} -czf "$1/${dest}/${f}.tar.gz" "$1/${f}" 
# done

# echo "PROCESSING $1/_archived"
# for sfile in "$1"/_archived/*.screenflow ; do
#   f="${sfile##*/}"
#   ${cmd} -czf "$1/${dest}/${f}.tar.gz" "$1/${f}" 
# done

# echo "PROCESSING $1/_unused"
#   f="${sfile##*/}"
#   ${cmd} -czf "$1/${dest}/${f}.tar.gz" "$1/${f}" 
# done