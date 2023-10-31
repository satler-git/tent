
class Song
  def initialize(song_name : String, artist_name : String, count : Int32)
    @song_name = song_name
    @artist_name = artist_name
    @count = count
  end

  def play
    process = Process.new("pplay", [@song_name, @artist_name], output: Process::Redirect::Pipe)
    process.wait()
  end

  def count
    @count
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
    # サブ配列を要素数でグループ化し、各グループをシャッフル
    shuffled_subarrays = @songlist.group_by { |i| i.count }.values.map { |subarray| subarray.shuffle }
    
    # シャッフルされたサブ配列をフラット化
    @songlist = shuffled_subarrays.flatten
  end

  def to_s
    @songlist
  end

  def play(end_time : Time)
    self.sort()
    played_list = [] of Song

    @songlist.each do |i|
      time = Time.local Time::Location.load("Asia/Tokyo")
      if ! time >= Time
        i.play()
        played_list << i
      else
        return played_list
      end
    end
  end
end
