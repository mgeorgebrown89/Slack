# <img src="https://raw.githubusercontent.com/mgeorgebrown89/PSlickPSlack/master/Media/PSlickPSlack_icon.png" alt="pslickpslack" width="50"/> PSlickPSlack

![GitHubRelease][] [![PSGallery][]][PSGalleryLink] [![PSGalleryDL][]][PSGalleryDLLink] [![Slack][]][SlackLink] [![License][]][LicenseLink]

---

## Introduction

PSlickPSlack is a PowerShell Module for composing and sending Slack messages using the new [Slack Blocks](https://api.slack.com/block-kit).

## Purpose

The main purpose for this module is to help PowerShell users easily and quickly craft Slack messages that look good using their existing PowerShell skills.

## Getting Started

To use **PSlickPSlack** you will need access to a Slack Workspace with a Slack Application and either have a **User Token**, a **Bot Token**, or a **Webhook**.

### Create a Slack Workspace

If necessary, [create a Slack Workspace](https://slack.com/create), otherwise, if you already have access to a Slack Workspace, proceed to the next step.

### Create a Slack Application

[Create a Slack Application](https://api.slack.com/apps?new_app=1) in your desired Slack Workspace. From here, there are several options to start sending messages to Slack via PowerShell. 

### Option A: Webhooks

### Option B: OAuth Access Token

### Option C: Bot User OAuth Access Token

```powershell
Install-Module -Name PSlickPSlack
```

## Contributing

Pester Tests should be run on PowerShell Core.

[GitHubRelease]: https://img.shields.io/github/v/release/mgeorgebrown89/pslickpslack?style=for-the-badge&color=36C5F0

[PSGallery]: https://img.shields.io/powershellgallery/v/PSlickPSlack.svg?logo=powershell&label=Powershell+Gallery&style=for-the-badge&color=2EB67D
[PSGalleryLink]: https://www.powershellgallery.com/packages/PSlickPSlack

[PSGalleryDL]: https://img.shields.io/powershellgallery/dt/PSlickPSlack.svg?logo=powershell&label=downloads&style=for-the-badge&color=ECB22E
[PSGalleryDLLink]: https://www.powershellgallery.com/packages/PSlickPSlack

[Slack]: https://img.shields.io/badge/Slack-Join-brightgreen.svg?logo=slack&label=Slack&style=for-the-badge&color=E01E5A
[SlackLink]: https://pslickposh.slack.com/

[License]: https://img.shields.io/github/license/mgeorgebrown89/pslickpslack.svg?label=License&style=for-the-badge&color=4A154B
[LicenseLink]: https://github.com/mgeorgebrown89/PSlickPSlack/blob/master/LICENSE