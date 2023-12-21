require "./Player"
require "./AbSQLite"

def endpoint : String
  if ARGV.size == 2
    ARGV[1]
  elsif ENV["ENDPOINT"]?.nil?
    raise "Can't find env \"ENDPOINT\".Did you set env?"
  else
    ENV["ENDPOINT"]
  end
end

endpoint = endpoint()
now = Time.local Time::Location.load("Asia/Tokyo")
end_time = Time.local(now.year, now.month, now.day, 13, 5, 0, location: Time::Location.load("Asia/Tokyo"))
Player.new(endpoint, "./tent.db").play(end_time)
