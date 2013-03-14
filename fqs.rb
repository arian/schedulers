
require "./tasks"
require "thread"

# new thread that reads stdin (the while blocks other stuff)
p1 = Thread.new do
	isr_char while $char = STDIN.getc
end

# function queue
$queue = Queue.new

# interrupt service routine
def isr_char
	$queue.push(Tasks.A) if $char == 'a'
	$queue.push(Tasks.B) if $char == 'b'
	$queue.push(Tasks.C) if $char == 'c'
end

main = Thread.new do
	# main loop
	loop do
		task = $queue.pop
		task
	end
end

p1.join
main.join
