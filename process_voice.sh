#!/usr/bin/env bash
# Dùng: đặt s3.m4a ... s22.m4a vào thư mục "raw/" rồi chạy ./process_voice.sh
# Lọc tạp âm + chuẩn hóa âm lượng, xuất ra voice/<id>-en.mp3 (khớp mục trong guide-script).
IDS=(x cover team welcome glance route history laut village matter riffel jung aletsch gexp lucerne lake zurich rhine video lavaux chillon culture tips gallery thanks)
mkdir -p voice
for n in $(seq 1 24); do
  in=$(ls raw/s$n.m4a raw/s$n.mp3 raw/s$n.wav 2>/dev/null | head -1)
  [ -z "$in" ] && { echo "s$n: không có file -> giữ giọng robot nếu đã có"; continue; }
  ffmpeg -loglevel error -y -i "$in" \
    -af "highpass=f=90,lowpass=f=12000,afftdn=nr=18:nf=-35:tn=1,loudnorm=I=-16:TP=-1.5:LRA=11" \
    -ar 44100 -ac 1 -b:a 96k "voice/${IDS[$n]}-en.mp3" && echo "s$n -> voice/${IDS[$n]}-en.mp3"
done
