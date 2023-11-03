require "./AbSQLite"
require "./Song"
require "crest"
require "json"

# 環境変数API_ENDPOINTにはURIスキームをつけてはいけない
class Caller
  def initialize(endpoint : String)
    @endpoint = endpoint
  end

  def insert_to(db_path : String)
    db = AbSQL.new(db_path)
    acquired = 0
    DB.open "sqlite3://#{db_path}" do |database|
      database.query "select value from settings where key = ?", "received" do |settings|
        settings.each do
          acquired = settings.read(Int64)
        end
      end
    end
    # リクエスト
    response = Crest.get(
      @endpoint,
      params: {:acquired => acquired.to_s},
      user_agent: "Mozilla/5.0"
    )
    listed_response = JSON.parse(response.body)
    listed_response = listed_response.as_a

    count = 0
    listed_response.each do |song|
      count += 1
      db.insert_song(Song.new(song["song_name"].to_s, song["artist_name"].to_s), song["mail"].to_s)
    end
    count += acquired
    DB.open "sqlite3://#{db_path}" do |database|
      database.exec "update settings set value = ? where key = ?", count, "received"
    end
  end
end
