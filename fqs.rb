
require "./tasks"

# new thread that reads stdin (the while blocks other stuff)
Thread.new do
	isr_char while $char = STDIN.getc
end

# function queue
$queue = Array.new

# interrupt service routine
def isr_char
	$queue.push(Tasks.A) if $char == 'a'
	$queue.push(Tasks.B) if $char == 'b'
	$queue.push(Tasks.C) if $char == 'c'
end

# main loop
while true
	$queue.pop() if not $queue.empty?
end
