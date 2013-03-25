
require 'tweetstream'
require "./tasks"
require './configure'

# tweets is basically some peripheral register here
$tweets = Array.new(3)
# the words to search for
$words = ["one direction", "bieber", "muse"]
$tasks = [-> { Tasks.A }, -> { Tasks.B }, -> { Tasks.C }]

# this fetches tweets through some stream and puts them in the $tweets "register"

p = $words.each_with_index.map do |word, i|
	Thread.new do
		TweetStream::Client.new.track(word) do |status|
			$tweets[i] = status.text
		end
	end
end

p2 = Thread.new do
	loop do

		# for each word
		$words.each_with_index { |word, i|
			# save in local variable to prevent shared data bug
			tweet = $tweets[i]
			# check if it is not empty
			if not tweet.nil?
				puts tweet.cyan
				# execute task
				$tasks[i].call
				$tweets[i] = nil
			end

		}

	end
end

p2.join
p.each { |t| t.join }
