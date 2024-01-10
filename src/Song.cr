class Song
  property id : Int64
  property song_name : String
  property artist_name : String
  property count : Int64
  property locale : String

  def initialize(song_name : String, artist_name : String)
    @id = 0
    @song_name = song_name
    @artist_name = artist_name
    @count = 0
    @locale = "0"
  end

  def initialize(id : Int64, song_name : String, artist_name : String, count : Int64)
    @id = id
    @song_name = song_name
    @artist_name = artist_name
    @count = count
    @locale = "0"
  end

  def play(next_song : Song)
    if (@locale == "0") | File.exists?(locale)
      # ロケールが設定されていないかファイルがなかったら
      # ダウンロード
      process = Process.new("pplay", [@song_name, @artist_name], output: STDOUT)
      puts "Start downloading #{@song_name} #{@artist_name}"
      # ダウンロードを待つ
      process.wait
      @locale = process.output.gets_to_end
    end
    # 再生を開始
    mpv_process = Process.new("mpv", [@locale], output: STDOUT)
    puts "Now playing #{@song_name} #{@artist_name}"
    # プレダウンロード
    pre_process = Process.new("pplay", [next_song.song_name, next_song.artist_name], output: STDOUT)
    puts "Start downloading #{next_song.song_name} #{next_song.song_name}"
    # ダウンロード完了を待つ
    pre_process.wait
    next_song.locale = pre_process.output.gets_to_end
    # 再生終了を待つ
    mpv_process.wait
    next_song
  end

  def to_s
    "#{@song_name} #{@artist_name} #{@count}"
  end
end

class Songlist
  def initialize
    @songlist = [] of Song
  end

  def add(song : Song)
    @songlist << song
  end

  def <<(song : Song)
    @songlist << song
  end

  def sort
    shuffled_subarrays = @songlist.group_by(&.count).values.map(&.shuffle)

    @songlist = shuffled_subarrays.flatten
  end

  def to_s
    @songlist
  end

  def play(end_time : Time)
    self.sort
    played_list = [] of Song
    puts "Start playing list"

    @songlist.each_with_index do |i, index|
      time = Time.local Time::Location.load("Asia/Tokyo")

      puts "End time has been exceeded" if time >= end_time
      break if time >= end_time

      @songlist[index + 1] = i.play(@songlist[index + 1])
      played_list << i
    end
    played_list
  end
end
