
require 'tweetstream'
require 'colored'
require "./tasks"
require './configure'

$tweet = ""

$atweet = ""
$btweet = ""
$ctweet = ""

$_running = 1;
$_ready   = 2;
$_blocked = 3;

$word1 = "windows"
$word2 = "linux"
$word3 = "apple"

# interrupt service routine
def irs_tweet
	if not $tweet.index($word1).nil? and $t1[:state] != $_ready
		puts "interrupt %s" % $word1
		$atweet = $tweet
		$t1[:state] = $_ready
		$scheduler.wakeup # something changed, let the scheduler check things
	end
	if not $tweet.index($word2).nil?
		puts "interrupt %s" % $word2 and $t2[:state] != $_ready
		$btweet = $tweet
		$t2[:state] = $_ready
		$scheduler.wakeup
	end
	if not $tweet.index($word3).nil?
		puts "interrupt %s" % $word3 and $t3[:state] != $_ready
		$ctweet = $tweet
		$t3[:state] = $_ready
		$scheduler.wakeup
	end
end

# this fetches tweets through some stream and calls the isr
p1 = Thread.new do
	TweetStream::Client.new.track($word1, $word2, $word3) do |status|
		$tweet = status.text.downcase
		irs_tweet
	end
end

# code to create a task
def create_task(function, priority)
	t = {
		:th => Thread.new do
			loop do
				t[:state] = $_ready
				puts "ready"
				# let's do something else
				$scheduler.wakeup

				# block until the task is ready again
				t[:state] = $_blocked
				Thread.stop

				t[:state] = $_running
				function.call
			end
		end,
		:state => $_ready,
		:priority => priority
	}
end

# create tasks with priorities
$t1 = create_task(-> { puts $atweet.cyan; Tasks.A }, 1)
$t2 = create_task(-> { puts $btweet.cyan; Tasks.B }, 4)
$t3 = create_task(-> { puts $ctweet.cyan; Tasks.C }, 8)

# sort tasks so it's easier to pick the highest priority task
$tasks = [$t1, $t2, $t3].sort { |x, y| y[:priority] - x[:priority] }

# find next task with highest priority
def next_task
	$tasks.each do |t|
		return t if t[:state] == $_ready
	end
	return nil
end

# scheduler thread
$scheduler = Thread.new do

	# start first task
	current = nil

	loop do
		# block until we have something to do
		Thread.stop

		# lets continue with current task, because we can't do preemting in ruby
		if current && (current[:state] == $_running || current[:th].status == "run")
			next
		end

		t = next_task

		# preemt lower priority task
		# this doesn't work, looks like you can't simply stop and resume
		# threads in ruby. You can kill them, but that means you cannot
		# wake them up again.
		# if current && current[:th].status == "run" &&  t[:priority] > current[:priority]
		# 	puts "PREEMPT prio %d" % current[:priority]
		# 	current[:th].kill
		# 	current[:state] = $_ready
		# end

		# next task
		if t and not t.nil?
			current = t
			t[:th].wakeup
		end

	end
end

# don't exit main thread

$scheduler.join

$t1[:th].join
$t2[:th].join
$t3[:th].join

p1.join
