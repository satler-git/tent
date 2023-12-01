import sys
import subprocess
from ytmusicapi import YTMusic
import yt_dlp

def search(song_name, artist_name):
    client = YTMusic(language="ja")
    search_results = client.search(f"{song_name} {artist_name}")
    
    return search_results[0].get("videoId")

def dl(vid):
    ydl_opts = {
        'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
        'outtmpl': f"tmp/{vid}.%(ext)s",  # 保存先の設定
    }
    ydl = yt_dlp.YoutubeDL(ydl_opts)
    video_url = f"https://www.youtube.com/watch?v={vid}"
    with ydl:
        result = ydl.extract_info(video_url, download=True)
    return result

def echo_locate(song_name, artist_name):
    vid = search(song_name, artist_name)
    info_dict = dl(vid)
    locate = f"tmp/{vid}.mp4"
    if 'requested_downloads' in info_dict:
        locate = info_dict['requested_downloads'][0]['filename']
    else:
        print("Couldn't find access.")
    print(locate)

if len(sys.argv) == 3:
    echo_locate(sys.argv[1], sys.argv[2])
else:
    print("Invalid args count")
