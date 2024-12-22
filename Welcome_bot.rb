require "dotenv/load"
require "http"

slack_token = ENV["SLACK_BOT_TOKEN"]
channel = ENV["SLACK_CHANNEL"]

puts "Slack Token: #{slack_token}"
puts "Channel: #{channel}"

def post_message_to_slack(slack_token, channel, text)
  response = HTTP.auth("Bearer #{slack_token}")
                 .post("https://slack.com/api/chat.postMessage", json: {
                                                                   channel: channel,
                                                                   text: text,
                                                                 })

  parsed_response = response.parse
  puts "Full API response: #{parsed_response}"

  if parsed_response["ok"]
    puts "Message posted successfully!"
  else
    puts "Failed to post message: #{parsed_response["error"]}"
  end
end

post_message_to_slack(slack_token, channel, <<~MESSAGE
  :wave: *Hello there!
  I'm your friendly *Deployment Bot* here to assist you with deployments!

  If you'd like to see deployment options and get started, just type:
  > `/bot`

  :rocket: Let’s make deployments simple and smooth together! 
MESSAGE
)
