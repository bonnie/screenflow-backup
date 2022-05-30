# dropbox uploader GitHub
# https://github.com/andreafabrizi/Dropbox-Uploader

cmd="tar"
# cmd="echo tar"

export cmd

datestring=`date +%s`
dest="raw screenflow zipped"
dropbox_script="/Users/presenter/src/Dropbox-Uploader/dropbox_uploader.sh"
backup_file="last-backup-timestamp"
compressed_file_count=0

if [ $# -lt 2 ]
  then
    echo "usage: bash backup.sh /path/to/directory/with/screenflow/files /path/to/copy/to/on/dropbox/within/studio-uploads"
    echo "Example: bash backup.sh /Users/presenter/Documents/test-next-raw-video/01-introduction \"/next-test/01-introduction\""
    exit
fi

if [ -d "$1/${dest}" ]
  then
    echo "RENAMING old directory"
    mv -f "$1/${dest}" "$1/${dest}-${datestring}"
fi

for dir in "" "_archived" "_unused"
do
  if [ -d "$1/${dir}" ]
    then
      echo "PROCESSING $1/${dir}"
      # get last backup date
      if [ -f "$1/${dir}/${backup_file}" ]
        then
          last_backup=`cat "$1/${dir}/${backup_file}"`
          last_backup_date=`date -r ${last_backup}`
          echo "  backing up files since ${last_backup_date}"
        else
          last_backup=0
          echo "  backing up ALL files"
      fi
      mkdir "$1/${dest}/${dir}"
      for sfile in "$1/${dir}"/*.screenflow ; do
        f="${sfile##*/}"
        mod_date=`date -r "$1/${dir}/${f}" +%s`
        if [ ${mod_date} -gt ${last_backup} ]
          then
            echo "    compressing ${f}"
            ${cmd} -czf "$1/${dest}/${dir}/${f}.tar.gz" -C "$1/${dir}" "${f}"
            ((compressed_file_count=compressed_file_count + 1))
          # else
          #   echo "    [SKIPPING ${f}]"
        fi
      done
      # record latest mod date
      if [ ${compressed_file_count} -gt 0 ]
        then
          echo ${datestring} > "$1/${dir}/${backup_file}"
      fi
  fi
done


# remote_dir=${dropbox_script} search $2
# if [ remote_dir -ne "" ]
#   then
#     echo "---------> renaming existing dropbox folder"
#     ${dropbox_script} move $2 "$2-${datestring}"
# fi

if [ ${compressed_file_count} -gt 0 ]
  then
    destdir="$2-${datestring}"

    echo "---------> making new dropbox directory: ${destdir}"
    "${dropbox_script}" mkdir ${destdir}

    echo "---------> Uploading to dropbox folder $2"
    "${dropbox_script}" -hp upload "$1/${dest}/"* "${destdir}" 

    echo "----------> look for files in /Apps/studio-upload/${destdir}"
  else
    echo "----------> NO FILES BACKED UP FOR $1"
fi

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