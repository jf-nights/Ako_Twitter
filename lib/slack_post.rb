Bundler.require
require 'slack'

class SlackClient
  USERNAME = "Ako"
  ICON_EMOJI = ":ako:"
  def initialize
    slack_token = open("/home/jf712/.slack/ako").read.split("\n")[1]
    Slack.configure do |config|
      config.token = slack_token
    end

    @options = {
      :channel => '',
      :text => '',
      :username => USERNAME,
      :icon_emoji => ICON_EMOJI
    }
  end

  def post(channel, message)
    @options[:channel] = channel
    @options[:text] = message
    Slack.chat_postMessage(@options)
  end
end
