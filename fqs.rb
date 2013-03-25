
require 'tweetstream'
require 'thread'
require "./tasks"
require './configure'

# tweets is basically some peripheral register here
$tweets = Array.new(3)
# words to search for on twitter
$words = ["one direction", "bieber", "muse"]
# task that can be called
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

# function queue
$queue = Queue.new

# interrupt service routine that puts the task in the queue
$isrs = $flags.each_with_index.map do |f, i|
	-> {
		puts $tweets[i].cyan
		$queue.push($tasks[i])
	}
end

main = Thread.new do
	# main loop
	loop do
		task = $queue.pop
		task.call
	end
end

p.join
main.join
