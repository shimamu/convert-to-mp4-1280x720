#!/usr/bin/bash

convert_to_mp4() {
    file=$1
    codec=`ffprobe $file 2>&1 | grep "Audio:" | awk '{print $4}'`
    if [[ "$codec" == "ac3" ]]; then
        ffmpeg -i $file \
            -ac 2 \
            -acodec ac3 \
            -ab 256k \
            -vcodec mpeg4 \
            -s 1280x720 \
            -b 3000k \
            -r 24 \
            ${file}_ac3.mp4
    else
        ffmpeg -y -vsync 1 \
            -i $file \
            -f mp4 \
            -vcodec libx264 \
            -map 0:0 \
            -map 0:1 \
            -s 1280x720 \
            -aspect 16:9 \
            -acodec copy \
            -bsf:a aac_adtstoasc \
            $file.mp4
    fi
}

if [ $# -ne 0 ]; then
    convert_to_mp4 $1
else
    for file in `ls -1 | egrep "(ts|mp4)$"`
    do
        echo "file: $file"
        convert_to_mp4 $file
    done
fi

# beep sound
echo 
