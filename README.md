# Slack Deployment Bot

This repository contains the Slack Deployment Bot, a tool designed to automate deployments via Slack.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

# Slack Deployment Bot

## Setup Instructions

### Slack API

You can find the Slack API details [here](https://api.slack.com/apps/A07V6L26W1M/slash-commands?saved=1).

### Ngrok Endpoints

You can find the Ngrok endpoints [here](https://dashboard.ngrok.com/endpoints/).

### Steps to Run the Bot

1. **Start Ngrok**

```sh
ngrok http 4567
```

2. **Run Ruby Scripts**

- For greetings inside the deployment channel:
  ```sh
  ruby Welcome_bot.rb
  ```
- For deployment:
  ```sh
  ruby bot_deploy_scheduler.rb
  ```

3. **Run Tests**

```sh
rspec spec/
```

## Additional Information

- Ensure you have all the necessary dependencies installed before running the scripts.
- Refer to the Slack API and Ngrok documentation for more details on configuration and usage.

## Introduction

The Slack Deployment Bot is a powerful tool that allows you to manage and automate your deployment processes directly from Slack. It integrates seamlessly with your existing CI/CD pipeline to provide a smooth and efficient deployment experience.

## Features

- Trigger deployments from Slack
- Monitor deployment status
- Rollback deployments
- Customizable commands

## Installation

To install the Slack Deployment Bot, follow these steps:

1. Clone the repository:

```bash
git clone https://github.com/yourusername/slack_deployment_bot.git
```

2. Navigate to the project directory:

```bash
cd slack_deployment_bot
```

3. Executing Script:

```bash
ruby bot_deploy_scheduler.rb
```

## Usage

To use the Slack Deployment Bot, follow these steps:

1. Configure your Slack app and obtain the necessary tokens.
2. Set up your environment variables:

```bash
export SLACK_BOT_TOKEN=your-slack-bot-token
export CI_CD_API_KEY=your-ci-cd-api-key
```

3. Start the bot:

```bash
ruby bot_deploy_scheduler.rb
```

## Contributing

We welcome contributions to the Slack Deployment Bot. To contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch:

```bash
git checkout -b feature-branch
```

3. Make your changes and commit them:

```bash
git commit -m "Description of your changes"
```

4. Push to the branch:

```bash
git push origin feature-branch
```
## Screenshots

### System Diagram

![Slackbot Implementation](https://github.com/mkanwal-iit/png)

### Radar Data Output

![Slackbot SlashCommands](https://github.com/mkanwal-iit/png)

### Pedestrian Detection

![Slackbot Process](https://github.com/mkanwal-iit/.png)



