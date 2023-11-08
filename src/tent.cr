require "./Player"
require "./AbSQLite"
require "./Const"

endpoint = Const::ENDPOINT
now = Time.local Time::Location.load("Asia/Tokyo")
end_time = Time.local(now.year, now.month, now.day, 13, 5, 0, location: Time::Location.load("Asia/Tokyo"))
Player.new(endpoint, "./tent.db").play(end_time)

