require "sqlite3"
require "db"
require "./Song"

class AbSQL
  @db : String

  def initialize(db_path : String)
    # 存在確認
    if File.exists?(db_path)
      @db = db_path
    else
      # 初期化
      DB.open "sqlite3://#{db_path}" do |database|
        # queueテーブルを作成。
        database.exec "create table queue (
          id INTEGER PRIMARY KEY,
          artist_name TEXT,
          song_name TEXT,
          count INTEGER
        )"
        # usersテーブル
        database.exec "create table users (
          id INTEGER PRIMARY KEY,
          email TEXT,
          count INTEGER
        )"
        # 適当な数字を入れることができる
        database.exec "create table settings (
          id INTEGER PRIMARY KEY,
          key TEXT,
          value INTEGER
        )"
        # 設定の生成
        database.exec "insert into settings (key,value) values (\"received\",0)"
      end
      @db = db_path
    end
  end

  # 曲を追加
  def insert_song(song : Song, email : String)
    # このとき渡されるSongのカウントは関係ない。
    DB.open "sqlite3://#{@db}" do |database|
      # ユーザーを読み取ってカウントを増やす。
      count = 0
      user = database.query("select count from users WHERE email = ?", email)
      hit_count = 0
      user.each do
        hit_count += 1
      end
      if hit_count == 0
        database.exec "insert into users (email,count) values (?, ?)", email, count
      elsif hit_count == 1
        user.each do
          if !user.nil?
            count = user.read(Int64)
          end
        end
      else
        STDERR.puts "invaild hit count"
      end

      database.exec "insert into queue (artist_name, song_name, count) values (?, ?, ?)", song.artist_name, song.song_name, (count + 1)
      # ユーザーのデータを書き換え
      database.exec "update users set count = ? where email = ?", (count + 1), email
    end
  end

  def load_songs : Songlist
    DB.open "sqlite3://#{@db}" do |database|
      database.query "select id, artist_name, song_name, count from queue" do |songs|
        list = Songlist.new
        songs.each do
          song = songs.read(Int64, String, String, Int64)
          list.add(Song.new(song[0], song[2], song[1], song[3]))
        end
        list
      end
    end
  end

  def delete_song(song : Song)
    DB.open "sqlite3://#{@db}" do |database|
      database.exec "delete from queue where id = ?", song.id
    end
  end

  def settings(key : String) : Int64
    DB.open "sqlite3://#{@db}" do |database|
      database.query "select value from settings where key = ?", key do |settings|
        settings.each do
          puts settings.read(Int64)
          settings.read(Int64)
        end
      end
    end
    return 0.to_i64
  end

  def set(key : String, value : Int64)
    DB.open "sqlite3://#{@db}" do |database|
      # エラーにならないか
      settings(key)
      database.exec "update settings set value = ? where key = ?", value, key
    end
  end
end

# 削除のときにはload_songsから帰ってきたSonglistのplayメソッドから帰ってきたものをeachdoする。
