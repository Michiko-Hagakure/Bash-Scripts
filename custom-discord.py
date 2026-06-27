#!/usr/bin/env python3
import sys
import json
import requests

# read argument from command line
alert_file = open(sys.argv[1])
hook_url = sys.argv[2]

# load json data from the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# get details from the alert json
alert_level = alert_json['rule']['level']
rule_desc = alert_json['rule']['description']
agent_name = alert_json['agent']['name']
rule_id = alert_json['rule']['id']

# format message to send to Discord
discord_msg = {
    "content": f"🚨 **WAZUH ALERT DETECTED** 🚨\n"
               f"**Agent/Host:** {agent_name}\n"
               f"**Rule ID:** {rule_id} (Level {alert_level})\n"
               f"**Description:** {rule_desc}"
}

# post the message to the Discord webhook
requests.post(hook_url, json=discord_msg)