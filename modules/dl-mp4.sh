dl-mp4 () {
  name="${2:-original-vid}"
  ext="$(echo $1 | rev | cut -d"." -f1 | rev)"

  folder="$(mktemp -d)"
  yt-dlp $1 -P "${folder}/" -o ${name}.${ext}

  new_name="${name}.mp4"

 echo ${folder}/${name}.${ext}
 echo $new_name

  crf="${3:-28}"
  ffmpeg -i "${folder}/${name}.${ext}" -vcodec libx264 -crf ${crf} -pix_fmt yuv420p ${new_name}
  echo "$1 -> ${new_name}"
}
