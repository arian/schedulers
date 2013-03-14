
require "./tasks"

# new thread that reads stdin (the while blocks other stuff) that calls the isr
p1 = Thread.new do
	irs_char while $char = STDIN.getc
end

# interrupt service routine
def irs_char
	$t1.wakeup if $char == 'a'
	$t2.wakeup if $char == 'b'
	$t3.wakeup if $char == 'c'
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
