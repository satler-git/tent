import sys
import subprocess
from ytmusicapi import YTMusic
import yt_dlp

def search(song_name, artist_name):
    client = YTMusic(language="ja")
    search_results = client.search(f"{song_name} {artist_name}")
    
    for result in search_results:
        if result["resultType"] == "song":
            vid = result.get("videoId")
            return vid
            break
        else:
            continue
    print(f"{song_name} is not a music?")
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

def play(song_name, artist_name):
    vid = search(song_name, artist_name)
    info_dict = dl(vid)
    locate = f"tmp/{vid}.mp4"
    if 'downloaded_file_path' in info_dict:
        locate = info_dict['downloaded_file_path']
    else:
        print("Couldn't find access.")

    try:
        subprocess.check_call(["mpv"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["mpv", "--fs", locate])
    except subprocess.CalledProcessError:
        print("Couldn't find \"mpv\" .")

if len(sys.argv) == 3:
    play(sys.argv[1], sys.argv[2])
else:
    print("Invalid args count")