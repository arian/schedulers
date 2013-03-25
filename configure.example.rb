# rename this to configure.rb and fill in the correct values

TweetStream.configure do |config|
	config.consumer_key       = 'abcdefghijklmnopqrstuvwxyz'
	config.consumer_secret    = '0123456789'
	config.oauth_token        = 'abcdefghijklmnopqrstuvwxyz'
	config.oauth_token_secret = '0123456789'
	config.auth_method        = :oauth
end
