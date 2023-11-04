dl-mp4 () {
  ext="$(echo $1 | rev | cut -d"." -f1 | rev)"
  tmp_name="${original}.${ext}"
  new_name="${2:-output.mp4}"
  folder="$(mktemp -d)"
  crf="${3:-28}"

  yt-dlp $1 -P "${folder}/" -o ${tmp_name}
  ffmpeg -i "${folder}/${tmp_name}" -vcodec libx264 -crf ${crf} -pix_fmt yuv420p ${new_name} -y

  echo "\n$1 -> ${new_name}\n"
}
