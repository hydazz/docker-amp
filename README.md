## Alpine Edge fork of [MitchTalmadge/AMP-dockerized](https://github.com/MitchTalmadge/AMP-dockerized/)
[AMP](https://cubecoders.com/AMP) is short for Application Management Panel. It's CubeCoders next-generation server administration software built for both users, and service providers. It supports both Windows and Linux based servers and allows you to manage all your game servers from a single web interface.

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/repository/docker/vcxpz/amp) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/amp?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/auto_build-weekly-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-amp/actions?query=workflow%3A%22Cron+Update+CI%22)

## Version Information
![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![s6 overlay](https://img.shields.io/badge/s6_overlay-2.1.0.2-blue?style=for-the-badge) ![amp](https://img.shields.io/badge/amp-2.0.9.0-blue?style=for-the-badge)

## Usage
```
docker run -d \
  --name=amp \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -p 8080:8080 \
  -e USERNAME= `#webui username` \
  -e PASSWORD= `#webui password` \
  -e LICENCE= `#see below` \
  -e MODULE= `#see below` \
  -e JDK_VERSIONS= `#see below` \
  -v <path to appdata>:/config \
  --mac-address=xx:xx:xx:xx:xx:xx `#see below` \
  --restart unless-stopped \
  vcxpz/amp
```
On Unraid? There's a [template](https://github.com/hydazz/docker-templates/blob/main/hydaz/amp.xml)

## Quickstart snippet from [MitchTalmadge/AMP-dockerized](https://github.com/MitchTalmadge/AMP-dockerized/)

**Please DO NOT bug CubeCoders for support without first asking here; they do not support nor endorse this image and will tell you that you are on your own.**

If you need help with AMP when using this image, please [create an issue](https://github.com/hydazz/docker-amp/issues/new) and we will figure it out!

# Supported Modules

**Tested and Working:**

- Minecraft Java Edition

**Untested:**

- [Everything Else](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility)

If you are able to get an untested module working, please make an issue about it so we can add it to the tested list and create an example

If you are *not* able to get a module working, make an issue and we can work together to figure out a solution!

## MAC Address (Important! Please read.)
AMP is designed to detect hardware changes and will de-activate all instances when something significant changes.
This is to stop people from sharing pre-activated instances and bypassing the licencing server. One way of detecting
changes is to look at the MAC address of the host's network card. A change here will de-activate instances.

By default, Docker assigns a new MAC address to a container every time it is restarted. Therefore, unless you want to
painstakingly re-activate all your instances on every server reboot, you need to assign a permanent MAC address.

For most people, this can be accomplished by generating a random MAC address in Docker's acceptable range.
The instructions to do so are as follows:

**Linux**

    echo $RANDOM | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**MacOS**

    echo $RANDOM | md5 | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**Windows**

    Get a new OS (https://miniwebtool.com/mac-address-generator)

- Copy the generated MAC and use it when starting the container.
  - For `docker run`, use the following flag: (Substitute your generated MAC)

    `--mac-address="02:42:AC:XX:XX:XX"`
  - For Docker Compose, use the following key next to `image`:

    `mac_address: 02:42:AC:XX:XX:XX`

If you have a unique network situation, a random MAC may not work for you. In that case you will need
to come up with your own solution to prevent address conflicts.

If you need help with any of this, please make an issue.

## Ports

Here's a rough (and potentially incorrect) list of default ports for the various modules. Each module also exposes port 8080 for the Web UI (can be changed with environment variables). If you find an inaccuracy, open an issue!

| Module Name | Default Ports |
|-|-|
| `ADS` | No additional ports.                                                                                                                                                                           |
| `ARK` | UDP 27015 & UDP 7777 & UDP 7778 ([Guide](https://ark.gamepedia.com/Dedicated_Server_Setup))                                                                                                    |
| `Arma3` | UDP 2302 to UDP 2306 ([Guide](https://community.bistudio.com/wiki/Arma_3_Dedicated_Server))                                                                                                    |
| `Factorio` | UDP 34197 ([Guide](https://wiki.factorio.com/Multiplayer))                                                                                                                                     |
| `FiveM` | UDP 30120 & TCP 30120 ([Guide](https://docs.fivem.net/docs/server-manual/setting-up-a-server/))                                                                                                 |
| `Generic`   | Completely depends on what you do with it.                                                                                                                                                     |
| `JC2MP`     | UDP 27015 & UDP 7777 & UDP 7778 (Unconfirmed!)                                                                                                                                                 |
| `McMyAdmin` | TCP 25565                                                                                                                                                                                      |
| `Minecraft` | TCP 25565 (Java) or UDP 19132 (Bedrock)                                                                                                                                                        |
| `Rust`      | UDP 28015 ([Guide](https://developer.valvesoftware.com/wiki/Rust_Dedicated_Server))                                                                                                            |
| `SevenDays` | UDP 26900 to UDP 26902 & TCP 26900 ([Guide](https://developer.valvesoftware.com/wiki/7_Days_to_Die_Dedicated_Server))                                                                          |
| `srcds`     | Depends on the game. Usually UDP 27015. ([List of games under srcds](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility#applications-running-under-the-srcds-module)) |
| `StarBound` | TCP 21025 ([Guide](https://starbounder.org/Guide:Setting_Up_Multiplayer))                                                                                                                      |

Just a quick note about ports: some games use TCP, some games use UDP. Make sure you are using the right protocol. Don't fall into the trap of accidentally mapping a TCP port for a UDP game -- you won't be able to connect.

## Environment Variables

### JDK Versions

| Name | Description | Default Value|
|-|-|-|
| `JDK_VERSIONS` | Space separated list OpenJDK Versions to be installed. OpenJDK is required by Minecraft. If you plan to not use Minecraft then leave this blank. Supported versions: `9`, `10`, `11`, `12`, `13`, `14`, `15` | No Default. Leaving this blank will not install OpenJDK |

**Example:**
- If you need  OpenJDK 9, 11 and 13 installed, set `JDK_VERSIONS="9 11 13"`

### Licence

| Name | Description | Default Value |
|-|-|-|
| `LICENCE` | The licence key for CubeCoders AMP. You can retrieve or buy this on [their website.](https://manage.cubecoders.com/) | No Default. AMP will not boot without a real licence. |

**Important Details:**
- _Americans:_ This is spelled licenCe not licenSe. Got me a few times.
- When a McMyAdmin licence is provided, the one and only instance will be a Minecraft instance. This cannot be overridden;
 you must buy a new license to use AMP with other/multiple games.

### Module

| Name     | Description                                                      | Default Value |
|----------|------------------------------------------------------------------|---------------|
| `MODULE` | Which Module to use for the main instance created by this image. | `ADS`         |

To run multiple game servers under this image, use the default value of `ADS` (Application Deployment Service) which allows you to create various modules from the web ui.

To be clear, this Docker image creates ONE instance by default. If you want to create more, use `ADS` as the first
  instance, and create the rest with the web UI. Otherwise, you can pick any other module from the list.

Here are the accepted values for the `MODULE` variable:

| Module Name | Description                                                                                                   |
|-------------|---------------------------------------------------------------------------------------------------------------|
| `ADS`       | Application Deployment Service. Used to manage multiple modules. Need multiple game servers? Pick this.       |
| `ARK`       |                                                                                                               |
| `Arma3`     |                                                                                                               |
| `Factorio`  |                                                                                                               |
| `FiveM`     |                                                                                                               |
| `Generic`   | For advanced users. You can craft your own module for any other game using this. You're on your own here.     |
| `JC2MP`     | Just Cause 2                                                                                                  |
| `McMyAdmin` | If you have a McMyAdmin Licence, this will be picked for you no matter what. It is equivalent to `Minecraft`. |
| `Minecraft` | Includes Java (Spigot, Bukkit, Paper, etc.) and Bedrock servers.                                              |
| `Rust`      |                                                                                                               |
| `SevenDays` | 7-Days To Die                                                                                                 |
| `srcds`     | Source-based games like TF2, GMod, etc. [Full List](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility#applications-running-under-the-srcds-module) |
| `StarBound` |                                                                                                               |

### Timezone
| Name | Description                                                          | Default Value |
|------|----------------------------------------------------------------------|---------------|
| `TZ` | The timezone to use in the container. Pick from the "TZ database name" column on [this page](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)   | `Etc/UTC`        |

Example: `TZ=America/Denver`

### User/Group

| Name  | Description                                                          | Default Value |
|-------|----------------------------------------------------------------------|---------------|
| `UID` | The ID of the user (on the host) who will own the ampdata volume.    | `1000`        |
| `GID` | The ID of the group for the user above.                              | `1000`        |

When not specified, these both default to ID `1000`; i.e. the first non-system user on the host.

### Web UI

| Name       | Description                                                                                                                                             | Default Value |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| `PORT`     | The port of the Web UI for the main instance. Since you can map this to any port on the host, there's hardly a reason to change it.                     | `8080`        |
| `USERNAME` | The username of the admin user created on first boot.                                                                                                   | `admin`       |
| `PASSWORD` | The password of the admin user. This value is only used when creating the new user. If you use the default value, please change it after first sign-in. | `password`    |

## Volumes

| Mount Point | Description |
|-|-|
| `/config`  | **Required!** This volume contains everything AMP needs to run. This includes all your instances, all their game files, the web ui sign-in info, etc. Essentially, without creating this volume, AMP will be wiped on every boot.|

## HTTPS / SSL / TLS

Setting up HTTPS is independent of the Docker image. Just follow this [official guide](https://github.com/CubeCoders/AMP/wiki/Setting-up-HTTPS-with-AMP)
and when it tells you to access `/home/AMP/.ampdata`, access the volume you mapped on the host instead. It has the same contents.
To restart the AMP instances, just restart the Docker container.

Or, just put [CloudFlare](https://www.cloudflare.com/) and its free SSL cert in front of your web UI and save yourself hours of pain.

# Upgrading AMP

To upgrade, all you have to do is pull our latest Docker image! We automatically check for AMP updates every hour. When a new version is released, we build and publish an image both as a standalone tag and on `:latest`.

# Contributing

I welcome contributors! Just open an issue first, or post in one of the contibution welcome / help wanted issues, so that we can discuss before you start coding. Thank you for helping!!
