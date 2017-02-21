#!/usr/bin/env python

import os
import time, timeit
from slackclient import SlackClient

# Based on https://www.fullstackpython.com/blog/build-first-slack-bot-python.html
# Colby Chiang, 2017-02-17

# starterbot's ID as an environment variable
BOT_ID = os.environ.get("BOT_ID")

# constants
AT_BOT = "<@" + BOT_ID + ">"
SLASH_BOT = "</status>"

# instantiate Slack & Twilio clients
slack_client = SlackClient(os.environ.get('SLACK_BOT_TOKEN'))

# time test script
test_script = '/gscmnt/gc2719/halllab/users/cchiang/src/disktime/testscript.sh'

# logs
data_dir = '/gscmnt/gc2719/halllab/users/cchiang/src/disktime/data'
logs = [data_dir + '/' + 'gc2718.time.txt',
        data_dir + '/' + 'gc2719.time.txt',
        data_dir + '/' + 'gc2802.time.txt']
        

# command


def get_status():
    latest_status = []
    for logfile in logs:
        l = ''
        with open(logfile, 'r') as f:
            for line in f:
                l = line.rstrip()
        print l
        latest_status.append([os.path.basename(logfile)] + l.split('\t'))

    return latest_status

def announce_status(disk_status):
    response = 'Warning: cluster response time > %s s :sonic_waiting:' % warn_time
    response = response + '\n```\n'
    for disk in disk_status:
        response = response + '\t'.join(disk) + '\n'
    response = response + '```'

    channel='clusterbot-test'
    slack_client.api_call("chat.postMessage", channel=channel,
                          text=response, as_user=True)
    return


def handle_command(command, channel):
    """
        Receives commands directed at the bot and determines if they
        are valid commands. If so, then acts on the commands. If not,
        returns back what it needs for clarification.
    """
    response = "Not sure what you mean. Use the *" + EXAMPLE_COMMAND + \
               "* command with numbers, delimited by spaces."
    if command.startswith(EXAMPLE_COMMAND):
        response = "Sure...write some more code then I can do that!"
    slack_client.api_call("chat.postMessage", channel=channel,
                          text=response, as_user=True)


def parse_slack_output(slack_rtm_output):
    """
        The Slack Real Time Messaging API is an events firehose.
        this parsing function returns None unless a message is
        directed at the Bot, based on its ID.
    """
    output_list = slack_rtm_output
    if output_list and len(output_list) > 0:
        for output in output_list:
            print output
            if output and 'text' in output and AT_BOT in output['text']:
                # return text after the @ mention, whitespace removed
                return output['text'].split(AT_BOT)[1].strip().lower(), \
                       output['channel']
    return None, None


if __name__ == "__main__":
    global warn_time
    warn_time = 10
    disk_status = get_status()
    announce = False
    for disk in disk_status:
        if float(disk[-1]) > warn_time:
            announce_status(disk_status)
            break

    # announce_status()
    # READ_WEBSOCKET_DELAY = 1 # 1 second delay between reading from firehose
    # if slack_client.rtm_connect():
    #     print("StarterBot connected and running!")
    #     while True:
    #         command, channel = parse_slack_output(slack_client.rtm_read())
    #         if command and channel:
    #             handle_command(command, channel)
    #         time.sleep(READ_WEBSOCKET_DELAY)
    # else:
    #     print("Connection failed. Invalid Slack token or bot ID?")

