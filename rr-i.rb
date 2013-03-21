
require 'tweetstream'
require "./tasks"
require './configure'

# tweet is basically some peripheral register here
$tweets = Array.new(3)
$flags = Array.new(3).map {|f| false }
$words = ["one direction", "bieber", "muse"]
$tasks = [-> { Tasks.A }, -> { Tasks.B }, -> { Tasks.C }]

# interrupt service routine that sets the flags
$isrs = $flags.each_with_index.map do |f, i|
	-> {
		puts $tweets[i].cyan
		$flags[i] = true
	}
end

# this fetches tweets through some stream and puts them in the $tweets "register"

p = $words.each_with_index.map do |word, i|
	Thread.new do
		TweetStream::Client.new.track(word) do |status|
			$tweets[i] = status.text
			$isrs[i].call
		end
	end
end

# main loop
p1 = Thread.new do
	loop do

		$flags = $flags.each_with_index do |flag, i|
			if flag
				$tasks[i].call
				$flags[i] = false
			end
		end

	end
end

p1.join
p.each { |t| t.join }
