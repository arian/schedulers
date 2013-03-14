
require "./tasks"

# main loop

while true

	char = STDIN.getc

	Tasks.A if char == "a"
	Tasks.B if char == "b"
	Tasks.C if char == "c"

end
