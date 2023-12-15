#!/usr/bin/bash

convert_to_mp4() {
    file=$1
    codec=`ffprobe $file 2>&1 | grep "Audio:" | awk '{print $4}'`
    if [ "$codec" == "ac3" ] || [ "$codec" == "mp3" ]; then
        echo "codec ac3 or mp3"
        ffmpeg -i $file \
            -ac 2 \
            -acodec ac3 \
            -b:a 128k \
            -vcodec mpeg4 \
            -s 1280x720 \
            -b:v 2000k \
            -r 24 \
            ${file}_ac3.mp4
    elif [ "$codec" == "wmapro" ] || [ "$codec" == "wmav2" ]; then
        echo "wmv"
        ffmpeg -i $file \
            -ac 2 \
            -acodec aac \
            -b:a 128k \
            -vcodec mpeg4 \
            -s 1280x720 \
            -b:v 3000k \
            -r 24 \
            ${file}.mp4
    else
        echo "codec other"
        ffmpeg -y -vsync 1 \
            -i $file \
            -f mp4 \
            -vcodec libx264 \
            -map 0:0 \
            -map 0:1 \
            -s 1280x720 \
            -r 30 \
            -b:a 128k \
            -b:v 1000k \
            -aspect 16:9 \
            -acodec copy \
            -bsf:a aac_adtstoasc \
            $file.mp4
    fi
}

if [ $# -ne 0 ]; then
    convert_to_mp4 $1
else
    for file in `ls -1 | egrep "(mp4|ts|wmv|mkv|avi|m4v)$"`
    do
        echo "file: $file"
        convert_to_mp4 $file
    done
fi

# beep sound
echo 
