# Wow Server Queue Checker

> Only tested with WOTLK classic

## What does it do?
This Powershell script can log to Discord when:
- Is user in queue?
- Is user in lobby/character selection?
- Is user in-game?
- Is user logged out?

## How do I install it?

#### First, create up a Discord Webhook
Follow Discord instructions: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks

#### Then, Run queue-check.ps1 periodically with Task Scheduler in Windows
1. Download the [queue-check.ps1]() file and place it somewhere on your computer where it wont be deleted.
2. Open the Windows Task Scheduler
  1. Press Windows key + R
  2. type taskschd.msc and press OK
3. Click "Create Basic Task" in the menu on the right
  1. Create a Basic Task: Give it a name, for example: Cron_Wow
  2. Trigger: Select Daily trigger
  3. Trigger Daily: Set start time to 00:00:00 and press Next
  4. Action: Select "Start a program"
  5. Action Start a Program: Enter "powershell" into Program/script.
  6. Action Start a Program: Copy this into arguments and replace the bold parts with your own information. See ***queue-check.ps1 Arguments*** for more info on arguments.
    `-ExecutionPolicy Bypass -File ***C:\Users\MatsJ\Desktop\wow\queue-check.ps1*** -DiscordUserName ***Gullbart*** -DiscordUserId ***345935396712087552*** -WebHook ***https://discord.com/api/webhooks/12323/sahdk***`
  7. Finish: Click Next and Finish
4. Right click the task you just created and press "properties"
5. Select "Run whether user is logged on or not"
6. Select "Triggers" tab and press "Edit"
7. Tick "Repeat task every" to "2 minutes"
8. Press OK twice and enter password if prompted

###### queue-check.ps1 Arguments
| Argument         | Description                                                                                                                           | Example                                               |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| -Debug           | Toggle verbose debug                                                                                                                  | -Debug true                                           |
| -DiscordUserId   | Discord user id. See https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-              | -DiscordUserId 345935396712087552                     |
| -DiscordUserName | Discord user name                                                                                                                     | -DiscordUserName Gullbart                             |
| -InGamePort      | Port we use to determine if you are in-game. (default 6724)                                                                           | -InGamePort 6724                                      |
| -LobbyPort       | Port we use to determine if you are in-lobby/character selection. (default 3724)                                                      | -LobbyPort 3724                                       |
| -QueuePort       | Port we use to determine if you are in-queue (Gehennas is 1119)                                                                       | -QueuePort 1119                                       |
| -WebHook         | Discord webhook to post events to. See https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks for how to set it up | -WebHook https://discord.com/api/webhooks/12323/sahdk |

## How does it do it?

#### Detection
We use powershell tools to check which network sockets are active and registered to the WowClassic process.
We noticed that wow uses different ports for differents features. These are the sockets we check:
- 3724 is Established when logged in
- 6724 is Established when in-game
- 1119 is Established when in-queue on Gehennas

> The queue checker does not intrude on wow process in any way!

#### Discord Webhook

We use a webhook to post events to a Discord channel. Read on how to set up a webhook in your discord server here:
- https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks

