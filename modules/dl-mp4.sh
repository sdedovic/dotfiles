dl-mp4 () {
  name="${2:-original-vid}"
  ext="$(echo $1 | rev | cut -d"." -f1 | rev)"
  new_name="${name}.mp4"
  folder="$(mktemp -d)"
  crf="${3:-28}"

  yt-dlp $1 -P "${folder}/" -o ${name}.${ext}
  ffmpeg -i "${folder}/${name}.${ext}" -vcodec libx264 -crf ${crf} -pix_fmt yuv420p ${new_name}

  echo "\n$1 -> ${new_name}\n"
}
