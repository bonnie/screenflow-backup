# usage: bash backup.sh /path/to/directory/with/screenflow/files

cmd="tar"
# cmd="echo tar"

export cmd

datestring=`date +%s`
dest="raw screenflow zipped"

echo "RENAMING old directory"
mv -f "$1/${dest}" "$1/${dest} ${datestring}"

for dir in "" "_archived" "_unused"
do
  echo "PROCESSING $1/${dir}"
  mkdir "$1/raw screenflow zipped/${dir}"
  for sfile in "$1/${dir}"/*.screenflow ; do
    f="${sfile##*/}"
    echo "    ${f}"
    ${cmd} -czf "$1/${dest}/${dir}/${f}.tar.gz" -C "$1/${dir}" "${f}" 
  done  
done

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