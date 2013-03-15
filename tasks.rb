
require "colored"

# using block_while instead of sleep. Sleep puts the current thread
# into the sleeping state.
def block_while(ms)
	time_start = Time.now
	loop do
		time = (Time.now - time_start) * 1000
		break if time > ms
	end
end

module Tasks

	def self.A
		puts "executing task A".green
		block_while(400)
	end

	def self.B
		puts "executing task B".green
		block_while(200)
	end

	def self.C
		puts "executing task C".green
		block_while(800)
	end

end
