class Song
  property id : Int64
  property song_name : String
  property artist_name : String
  property count : Int64
  property url : String

  def initialize(song_name : String, artist_name : String)
    @id = 0
    @song_name = song_name
    @artist_name = artist_name
    @count = 0
    @url = "0"
  end

  def initialize(id : Int64, song_name : String, artist_name : String, count : Int64)
    @id = id
    @song_name = song_name
    @artist_name = artist_name
    @count = count
    @url = "0"
  end

  def play
    if @url == "0"
      # 検索
      process = Process.new("pplay", [@song_name, @artist_name], output: STDOUT)
      puts "Now searching #{@song_name} #{@artist_name}"
      # 検索を待つ
      process.wait
      @url = process.output.gets_to_end
    end
    # 再生を開始
    Process.new("mpv", ["-fs", @url], output: STDOUT)
    puts "Now playing #{@song_name} #{@artist_name}"
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

    @songlist.each do |i|
      time = Time.local Time::Location.load("Asia/Tokyo")

      puts "End time has been exceeded" if time >= end_time
      break if time >= end_time

      i.play
      played_list << i
    end
    played_list
  end
end
