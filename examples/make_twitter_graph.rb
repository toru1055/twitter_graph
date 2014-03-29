require 'twitter'
require './lib/twitter_graph'

# These are dummy keys.
# You should change them to your client keys.
api_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "xxxxxxx"
  config.consumer_secret     = "yyyyyyyyyyyyy"
  config.access_token        = "XXXXXXX"
  config.access_token_secret = "YYYYYYYYYYYYY"
end

# This is also dummy id list
# You should change to twitter ids which you want to make a graph.
twitter_ids = [
  1234567,
  2345678,
  4556677
]
client = TwitterGraph::Client.new(api_client)
client.run(twitter_ids)
