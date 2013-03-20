
require 'tweetstream'
require "./tasks"
require './configure'

# tweet is basically some peripheral register here
$tweets = Array.new(3)
$words = ["one direction", "bieber", "muse"]
$tasks = [-> { Tasks.A }, -> { Tasks.B }, -> { Tasks.C }]

# this fetches tweets through some stream and puts them in the $tweet "register"

p = $words.each_with_index.map do |word, i|
	Thread.new do
		TweetStream::Client.new.track(word) do |status|
			$tweets[i] = status.text.downcase
		end
	end
end

p2 = Thread.new do
	loop do

		$words.each_with_index { |word, i|
			# save in local variable to prevent shared data bug
			tweet = $tweets[i]
			if not tweet.nil? and not tweet.index($words[i]).nil?
				puts tweet.cyan
				$tasks[i].call
				$tweets[i] = nil
			end

		}

	end
end

p2.join
p.each { |t| t.join }
