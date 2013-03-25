
require "colored"

module Tasks

	def self.A
		puts "executing task A".green
		sleep(0.4)
	end

	def self.B
		puts "executing task B".green
		sleep(0.2)
	end

	def self.C
		puts "executing task C".green
		sleep(0.8)
	end

end
