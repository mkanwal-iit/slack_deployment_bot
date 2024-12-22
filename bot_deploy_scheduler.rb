require "sinatra"
require "dotenv/load"
require "json"
require "http"
require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

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

# Define deployment stages
def handle_deployment(channel_id, user_id, environment = "default", branch = "main")
  stages = [
    ":rocket: Initiating deployment to #{environment} on branch #{branch}...",
    ":hammer_and_wrench: Building packages...",
    ":white_check_mark: Running tests...",
    ":package: Deploying to production...",
    ":tada: Deployment successful!",
  ]

  stages.each do |stage|
    send_message_to_slack(stage, channel_id)
    sleep(2)
  end
  send_message_to_slack("Deployment finished. Thank you, <@#{user_id}>!", channel_id)
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
  message = <<~MSG
        Hello, <@#{user_id}>! :wave: Ready to start a deployment? Here are your options:

  *For an Immediate Deployment*:
  > Type `/deploy environment=production branch=main`

  *For a Scheduled Deployment*:
  > Type `/deploy environment=staging branch=feature time=14:30` (24-hour format)

  :rocket: *Let’s get things rolling!*
  MSG
  send_message_to_slack(message, channel_id)

  # Respond to Slack
  content_type :json
  { text: "Greeting message sent to <@#{user_id}>." }.to_json
end

# Route for scheduled or immediate deployment
post "/slack/deploy" do
  puts "Received a POST request to /slack/deploy"
  puts "Request Params: #{params.inspect}"

  if params["token"] != slack_token
    halt 403, "Invalid token"
  end

  user_id = params["user_id"]
  command_text = params["text"]
  channel_id = params["channel_id"]

  # Parse parameters to extract environment, branch, and schedule time
  parameters = command_text.split(" ").each_with_object({}) do |param, hash|
    key, value = param.split("=")
    hash[key.to_sym] = value
  end

  environment = parameters[:environment] || "default"
  branch = parameters[:branch] || "main"
  schedule_time = parameters[:time] # Expected format "HH:MM" (24-hour)

  if schedule_time
    # Schedule the deployment at the specified time
    scheduler.cron("#{schedule_time.split(":").last} #{schedule_time.split(":").first} * * *") do
      handle_deployment(channel_id, user_id, environment, branch)
    end
    send_message_to_slack("Scheduled deployment at #{schedule_time} for environment=#{environment}, branch=#{branch}.", channel_id)
  else
    # Immediate deployment if no time is specified
    Thread.new do
      handle_deployment(channel_id, user_id, environment, branch)
    end
    send_message_to_slack("Deployment started immediately for environment=#{environment}, branch=#{branch}.", channel_id)
  end

  content_type :json
  { text: "Deployment process initiated. Updates will be sent to this channel." }.to_json
end
