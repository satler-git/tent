import sys
from ytmusicapi import YTMusic

def search(song_name, artist_name):
    client = YTMusic(language="ja")
    search_results = client.search(f"{song_name} {artist_name}")

    return search_results[0].get("videoId")

def echo_url(song_name, artist_name):
    vid = search(song_name, artist_name)
    print(f"https://www.youtube.com/watch?v={vid}")

if len(sys.argv) == 3:
    echo_url(sys.argv[1], sys.argv[2])
else:
    print("Invalid args count")
