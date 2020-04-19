## What does this do?

This is a simple bash script that runs on dedicated JKA server box that will take
amsay messages and relay them to a Discord of choice, via a Discord webhook.

## Getting Started

### Discord Webhook

You will need a Discord webhook set up on whichever Discord you want to relay
messages to. Check out [this article](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks) for more information.

### Enable logging

In order for this script to work, you will need to be able to read server logs.
Make sure your server is logging to a file. The level of privacy is at your 
discretion, as long as you are able to log messages created by `/amsay`.

## Installation

### Script installation

Place the `amsay_relay.sh` file in whichever directory you wish to run it from. 
A good default would be the Gamedata folder of your server's Jedi Academy 
installation.

Set executable permissions on the script:

```
chmod +x ./amsay_relay.sh
```

### Create a configuration file

Create a configuration file named something recognizable such as `amsay_relay.cfg` and place it a directory of your choosing. An example would be your server's mod directory (e.g. the `japlus` folder).

There are two values that need to be set in this configuration file:

```
discord_webhook_url=https://discordapp.com/api/webhooks/YOUR/WEBHOOK/URL
log_file=path/to/server/log
```

## Running the script

If you used the recommended paths described above, you can simply run 

```
./amsay_relay.sh
```

If your relay config lives somewhere custom, you can pass the
path to it directly:

`./amsay_relay.sh path/to/amsay_relay.cfg`.