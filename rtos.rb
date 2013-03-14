
require 'tweetstream'
require "./tasks"
require './configure'

$tweet = ""

$word1 = "ubuntu"
$word2 = "linux"
$word3 = "apple"

# interrupt service routine
def irs_tweet
	$t1.wakeup if not $tweet.index($word1).nil?
	$t2.wakeup if not $tweet.index($word2).nil?
	$t3.wakeup if not $tweet.index($word3).nil?
end

p1 = Thread.new do
	TweetStream::Client.new.track($word1, $word2, $word3) do |status|
		$tweet = status.text.downcase
		irs_tweet
	end
end

$t1 = Thread.new do
	loop do
		Thread.stop
		Tasks.A
	end
end

$t2 = Thread.new do
	loop do
		Thread.stop
		Tasks.B
	end
end

$t3 = Thread.new do
	loop do
		Thread.stop
		Tasks.C
	end
end

p1.join

$t1.join
$t2.join
$t3.join
