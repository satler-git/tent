class Song
  property id : Int64
  property song_name : String
  property artist_name : String
  property count : Int64

  def initialize(song_name : String, artist_name : String)
    @id = 0
    @song_name = song_name
    @artist_name = artist_name
    @count = 0
  end

  def initialize(id : Int64, song_name : String, artist_name : String, count : Int64)
    @id = id
    @song_name = song_name
    @artist_name = artist_name
    @count = count
  end

  def play
    process = Process.new("pplay", [@song_name, @artist_name], output: STDOUT)
    puts "Now playing #{@song_name} #{@artist_name}"
    process.wait
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
      break if time >= end_time
      i.play
      played_list << i
    end
    played_list
  end
end
