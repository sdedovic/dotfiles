dl-mp4 () {
  new_name="${2:-output.mp4}"
  folder="$(mktemp -d)"
  crf="${3:-28}"

  tmp_name="$(yt-dlp $1 -P "${folder}/" -o ${tmp_name} --print after_move:filepath)"
  ffmpeg -i "${tmp_name}" -vcodec libx264 -crf ${crf} -pix_fmt yuv420p ${new_name} -y

  echo "\n$1 -> ${new_name}\n"
}
