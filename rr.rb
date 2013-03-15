
require 'tweetstream'
require "./tasks"
require './configure'

# tweet is basically some peripheral register here
$tweet = ""

$word2 = "one direction" # too much tweets
$word1 = "bieber" # way way too much
$word3 = "muse" # not enough

# this fetches tweets through some stream and puts them in the $tweet "register"
p1 = Thread.new do
	TweetStream::Client.new.track($word1, $word2, $word3) do |status|
		$tweet = status.text.downcase
	end
end

p2 = Thread.new do
	loop do

		# save in local variable to prevent shared data bug
		tweet = $tweet
		if not tweet.index($word1).nil?
			puts tweet.cyan
			Tasks.A
		end

		tweet = $tweet
		if not tweet.index($word2).nil?
			puts tweet.cyan
			Tasks.B
		end

		tweet = $tweet
		if not tweet.index($word3).nil?
			puts tweet.cyan
			Tasks.C
		end

	end
end

p2.join
p1.join
