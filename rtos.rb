
require "./tasks"

# new thread that reads stdin (the while blocks other stuff) that calls the isr
Thread.new do
	irs_char while $char = STDIN.getc
end

# interrupt service routine
def irs_char
	$sems[0] += 1 if $char == 'a'
	$sems[1] += 1 if $char == 'b'
	$sems[2] += 1 if $char == 'c'
end

# semaphores
$sems = [0, 0, 0]

# possible states of a tasks
STATUS = {:RUNNING  => 1, :READY => 2, :BLOCKED => 3}

# tasks
def create_task(fn, priority)
	task = {
		:prio => priority,
		:fn => -> {
			task[:status] = STATUS[:RUNNING]
			fn.call(task)
		},
		:status => STATUS[:READY]
	}
	return task
end

$tasks = [
	create_task(->(task) {
		if $sems[0] > 0
			Tasks.A
			$sems[0] -= 1
			task[:status] = STATUS[:READY]
		else
			task[:status] = STATUS[:BLOCKED]
		end
	}, 10),
	create_task(->(task) {
		if $sems[1] > 0
			Tasks.B
			$sems[1] -= 1
			task[:status] = STATUS[:READY]
		else
			task[:status] = STATUS[:BLOCKED]
		end
	}, 3),
	create_task(->(task) {
		if $sems[2] > 0
			Tasks.C
			$sems[2] -= 1
			task[:status] = STATUS[:READY]
		else
			task[:status] = STATUS[:BLOCKED]
		end
	}, 8)
].sort! {|x, y| y[:prio] - x[:prio]}

def get_next_task

	# note that $tasks is sorted on priority
	$tasks.each do |t|
		if t[:status] != STATUS[:RUNNING]
			t[:fn].call
			break if t[:status] == STATUS[:READY]
		end
	end

end

while true
	get_next_task
end
