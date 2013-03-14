
require "./tasks"

# new thread that reads stdin (the while blocks other stuff) that calls the isr
Thread.new do
	isr_char while $char = STDIN.getc
end

# flags that are set by the
$flagA = false
$flagB = false
$flagC = false

# interrupt service routine
def isr_char
	$flagA = true if $char == 'a'
	$flagB = true if $char == 'b'
	$flagC = true if $char == 'c'
end

# main loop
while true

	if $flagA
		$flagA = false
		Tasks.A
	end

	if $flagB
		$flagB = false
		Tasks.B
	end

	if $flagC
		$flagC = false
		Tasks.C
	end

end
