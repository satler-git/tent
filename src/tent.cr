require "./Player"
require "./AbSQLite"
require "clim"

module Tent
  class Cli < Clim
    main do
      desc "Auto Youtube Music player"
      usage "tent [options]"
      version "Version 0.1.0"
      option "--init", type: Bool, desc: "Init API endpoint"
      run do |opts, _|
        if opts.init
          # init
          puts "エンドポイントを入力してください"
          endpoint = gets
          File.open("./tent.txt", "w") do |file|
            [endpoint].each do |line|
              file.puts(line)
            end
          end
        else
          # 普通に実行
          endpoint = ""
          File.read_lines("./tent.txt").each do |line|
            endpoint = line
          end
          now = Time.local Time::Location.load("Asia/Tokyo")
          end_time = Time.local(now.year, now.month, now.day, 13, 5, 0, location: Time::Location.load("Asia/Tokyo"))
          Player.new(endpoint, "./tent.db").play(end_time)
        end
      end
    end
  end
end

Tent::Cli.start(ARGV)
