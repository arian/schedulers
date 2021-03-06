
require 'tweetstream'
require "./tasks"
require './configure'

# tweets is basically some peripheral register here
$tweets = Array.new(3)
# flag is set in the isr for this kind of tweet
$flags = Array.new(3).map {|f| false }
# search words
$words = ["one direction", "bieber", "muse"]
# tasks that can be executed in the main loop if a flag is set to true
$tasks = [-> { Tasks.A }, -> { Tasks.B }, -> { Tasks.C }]

# this fetches tweets through some stream and puts them in the $tweets "register"

p = $words.each_with_index.map do |word, i|
	Thread.new do
		TweetStream::Client.new.track(word) do |status|
			$tweets[i] = status.text
			$isrs[i].call
		end
	end
end

# interrupt service routine that sets the flags
$isrs = $flags.each_with_index.map do |f, i|
	-> {
		puts $tweets[i].cyan
		$flags[i] = true
	}
end

# main loop
p1 = Thread.new do
	loop do

		# for each flag
		$flags = $flags.each_with_index do |flag, i|
			# if flag is true, execute task
			if flag
				$tasks[i].call
				# and reset the flag to false
				$flags[i] = false
			end
		end

	end
end

p1.join
p.each { |t| t.join }
