require "sinatra"
require "dotenv/load"
require "json"
require "http"

# Load environment variables
slack_token = ENV["SLACK_VERIFICATION_TOKEN"]
puts "Slack Verification Token Loaded: #{slack_token.nil? ? "No" : "Yes"}"

# Helper method to send messages to Slack
def send_message_to_slack(text, channel_id)
  uri = URI("https://slack.com/api/chat.postMessage")
  headers = {
    "Content-Type" => "application/json; charset=utf-8",
    "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}",
  }
  body = {
    channel: channel_id,
    text: text,
  }.to_json

  response = HTTP.headers(headers).post(uri, body: body)
  puts "Response from Slack: #{response.status} - #{response.body}"
end

# Generate fake Git commit messages
def generate_git_message(user_id)
  messages = [
    "Update README.md with usage section",
    "Fix typo in deployment script",
    "Add error handling for login feature",
    "Refactor code after peer review",
    "Improve performance of database query",
    "Upgrade libraries to latest stable versions",
  ]
  "#{messages.sample} - commit by @#{user_id}"
end

post "/slack/bot" do
  puts "Received a POST request to /slack/bot"
  puts "Request Params: #{params.inspect}"

  if params["token"] != slack_token
    puts "Invalid token received: #{params["token"]}"
    halt 403, "Invalid token"
  end

  user_id = params["user_id"]
  channel_id = params["channel_id"]

  # Greet the user and prompt for deployment
  message = "Hello <@#{user_id}>! :wave: If you're ready to deploy, type `/deploy` to begin the deployment process."
  send_message_to_slack(message, channel_id)

  # Respond to Slack
  content_type :json
  { text: "Greeting message sent to <@#{user_id}>." }.to_json
end

# Define the route for the slash command
post "/slack/deploy" do
  puts "Received a POST request to /slack/deploy"
  puts "Request Params: #{params.inspect}"

  if params["token"] != slack_token
    puts "Invalid token received: #{params["token"]}"
    halt 403, "Invalid token"
  end

  puts "Token verified successfully"
  user_id = params["user_id"]
  command_text = params["text"]
  channel_id = params["channel_id"]

  # Parse command text into parameters
  parameters = command_text.split(" ").each_with_object({}) do |param, hash|
    key, value = param.split("=")
    hash[key.to_sym] = value
  end

  environment = parameters[:environment] || "default"
  branch = parameters[:branch] || "main"

  # Start deployment process
  Thread.new do
    stages = [
      ":rocket: Initiating deployment to #{environment} on branch #{branch}...",
      ":hammer_and_wrench: Building packages...",
      ":white_check_mark: Running tests...",
      ":package: Deploying to production...",
      ":tada: Deployment successful!",
    ]
    stages.each do |stage|
      send_message_to_slack(stage, channel_id)
      sleep(2)  # Simulate time delay between deployment stages
    end
    send_message_to_slack(generate_git_message(user_id), channel_id)  # Send fake Git commit message
  end

  # Immediate response to the user
  content_type :json
  {
    response_type: "in_channel",
    text: "Hello <@#{user_id}>! :gear: Starting deployment with parameters: environment=#{environment}, branch=#{branch}. :eyes: Please check the channel for updates.",
  }.to_json
end
