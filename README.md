# <img src="https://raw.githubusercontent.com/mgeorgebrown89/Slack/master/Media/Slack_Module_icon.png" alt="Slack Module" width="50"/> Slack, A PowerShell Module

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fmgeorgebrown89%2Fslack%2Fbadge%3Fref%3Dmaster&style=for-the-badge)](https://actions-badge.atrox.dev/mgeorgebrown89/slack/goto?ref=master)
![GitHubRelease][] [![PSGallery][]][PSGalleryLink] [![PSGalleryDL][]][PSGalleryDLLink] [![Slack][]][SlackLink] [![License][]][LicenseLink]

---

## Introduction

Slack is a PowerShell Module for composing and sending Slack messages using the new [Slack Blocks](https://api.slack.com/block-kit).

## Purpose

The main purpose for this module is to help PowerShell users easily and quickly craft Slack messages that look good using their existing PowerShell skills. Use this module to output information from your scripts and functions to a Slack Channel. If you really want to, you could enable interactive components (there are plans to make this easier, but for now, you'll have to figure out that set up on your own)!

## Getting Started

To use **Slack** you will need access to a Slack Workspace with a Slack Application and either have a **User Token**, a **Bot Token**, or a **Webhook**.

### Create a Slack Workspace

If necessary, [create a Slack Workspace](https://slack.com/create), otherwise, if you already have access to a Slack Workspace, proceed to the next step.

### Create a Slack Application

<details>
<summary><a href="https://api.slack.com/apps">Create a Slack Application</a> and install it in your desired Slack Workspace. </summary>
<br>
<img src="Media\gifs\createSlackApp1.gif">
</details>
There are several options to start sending messages to Slack via PowerShell.

#### Option A: Webhooks

<details>
<summary>From the Basic Information page for your Slack App, click <b>Add features and functionality</b>, then <b>Incoming Webhooks</b>. Turn them <b>on</b>, and click <b>Add New Webhook to Workspace</b>. Select a channel to post to, click <b>allow</b>, then copy the webhook to use in your PowerShell code.</summary>
<br>
<img src="Media\gifs\createSlackWebhook1.gif">
</details>

#### Option B: OAuth Access Token

#### Option C: Bot User OAuth Access Token

## Install and Configure the Module

```powershell
Install-Module -Name Slack
```

## Contributing

Pester Tests should be run on PowerShell Core.

[GitHubActions]: https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fatrox%2Fsync-dotenv%2Fbadge&style=for-the-badge
[GitHubActionsLink]: https://actions-badge.atrox.dev/atrox/sync-dotenv/goto

[GitHubRelease]: https://img.shields.io/github/v/release/mgeorgebrown89/slack?style=for-the-badge&color=36C5F0

[PSGallery]: https://img.shields.io/powershellgallery/v/Slack.svg?logo=powershell&label=Powershell+Gallery&style=for-the-badge&color=2EB67D
[PSGalleryLink]: https://www.powershellgallery.com/packages/Slack

[PSGalleryDL]: https://img.shields.io/powershellgallery/dt/Slack.svg?logo=powershell&label=downloads&style=for-the-badge&color=ECB22E
[PSGalleryDLLink]: https://www.powershellgallery.com/packages/Slack

[Slack]: https://img.shields.io/badge/Slack-Join-brightgreen.svg?logo=slack&label=Slack&style=for-the-badge&color=E01E5A
[SlackLink]: https://osh.slack.com/

[License]: https://img.shields.io/github/license/mgeorgebrown89/slack.svg?label=License&style=for-the-badge&color=4A154B
[LicenseLink]: https://github.com/mgeorgebrown89/Slack/blob/master/LICENSE