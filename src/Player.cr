require "./Caller"
require "./Song"
require "./AbSQLite"

class Player
  @list : Songlist

  def initialize(endpoint : String, db_path : String)
    @db_path = db_path
    @caller = Caller.new(endpoint)
    @caller.insert_to(@db_path)
    @list = AbSQL.new(@db_path).load_songs
    @list.sort
  end

  def play(end_time : Time)
    played = @list.play(end_time)
    db = AbSQL.new(@db_path)
    if !played.nil?
      played.each do |played_song|
        db.delete_song(played_song)
      end
    end
  end
end
