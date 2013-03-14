
require 'tweetstream'

require './configure'

TweetStream::Client.new.track('bieber', 'apple', 'weekend') do |status|
  puts "#{status.text}"
end
