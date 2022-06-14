# tomo-plugin-aws_sqs

[![Gem Version](https://badge.fury.io/rb/tomo-plugin-aws_sqs.svg)](https://rubygems.org/gems/tomo-plugin-aws_sqs)
[![Circle](https://circleci.com/gh/gauravtiwari/tomo-plugin-aws_sqs/tree/main.svg?style=shield)](https://app.circleci.com/pipelines/github/gauravtiwari/tomo-plugin-aws_sqs?branch=main)
[![Code Climate](https://codeclimate.com/github/gauravtiwari/tomo-plugin-aws_sqs/badges/gpa.svg)](https://codeclimate.com/github/gauravtiwari/tomo-plugin-aws_sqs)

This is a [tomo](https://github.com/mattbrictson/tomo) plugin that provides tasks for managing [aws_sqs](https://github.com/bensheldon/aws_sqs) via [systemd](https://en.wikipedia.org/wiki/Systemd), based on the recommendations in the aws_sqs documentation. This plugin assumes that you are also using the tomo `rbenv` and `env` plugins, and that you are using a systemd-based Linux distribution like Ubuntu 18 LTS.

---

- [Installation](#installation)
- [Settings](#settings)
- [Tasks](#tasks)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Installation

Run:

```
$ gem install tomo-plugin-aws_sqs
```

Or add it to your Gemfile:

```ruby
gem "tomo-plugin-aws_sqs"
```

Then add the following to `.tomo/config.rb`:

```ruby
plugin "aws_sqs"

setup do
  # ...
  run "aws_sqs:setup_systemd"
end

deploy do
  # ...
  # Place this task at *after* core:symlink_current
  run "aws_sqs:restart"
end
```

### enable-linger

This plugin installs aws_sqs as a user-level service using systemctl --user. This allows aws_sqs to be installed, started, stopped, and restarted without a root user or sudo. However, when provisioning the host you must make sure to run the following command as root to allow the aws_sqs process to continue running even after the tomo deploy user disconnects:

```
# run as root
$ loginctl enable-linger <DEPLOY_USER>
```

## Settings

| Name                                     | Purpose                                                                                                                                                                                                         |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aws_sqs_systemd_service`               | Name of the systemd unit that will be used to manage good*job <br>**Default:** `"aws_sqs*%{application}.service"`                                                                                              |
| `aws_sqs_systemd_service_path`          | Location where the systemd unit will be installed <br>**Default:** `".config/systemd/user/%{aws_sqs_systemd_service}"`
| `aws_sqs_systemd_command`          | Command to run  <br>**Default:** `"bundle exec aws_sqs_active_job --queue default"`                                                                                         |
| `aws_sqs_systemd_service_template_path` | Local path to the ERB template that will be used to create the systemd unit <br>**Default:** [service.erb](https://github.com/gauravtiwari/tomo-plugin-aws_sqs/blob/main/lib/tomo/plugin/aws_sqs/service.erb) |

## Tasks

### aws_sqs:setup_systemd

Configures systemd to manage aws_sqs. This means that aws_sqs will automatically be restarted if it crashes, or if the host is rebooted. This task essentially does two things:

1. Installs a `aws_sqs.service` systemd unit
1. Enables it using `systemctl --user enable`

Note that these units will be installed and run for the deploy user. You can use `:aws_sqs_systemd_service_template_path` to provide your own template and customize how aws_sqs and systemd are configured.

`aws_sqs:setup_systemd` is intended for use as a [setup](https://tomo-deploy.com/commands/setup/) task. It must be run before aws_sqs can be started during a deploy.

### aws_sqs:restart

Gracefully restarts the aws_sqs service via systemd, or starts it if it isn't running already. Equivalent to:

```
systemctl --user restart aws_sqs.service
```

### aws_sqs:start

Starts the aws_sqs service via systemd, if it isn't running already. Equivalent to:

```
systemctl --user start aws_sqs.service
```

### aws_sqs:stop

Stops the aws_sqs service via systemd. Equivalent to:

```
systemctl --user stop aws_sqs.service
```

### aws_sqs:status

Prints the status of the aws_sqs systemd service. Equivalent to:

```
systemctl --user status aws_sqs.service
```

### aws_sqs:log

Uses `journalctl` (part of systemd) to view the log output of the aws_sqs service. This task is intended for use as a [run](https://tomo-deploy.com/commands/run/) task and accepts command-line arguments. The arguments are passed through to the `journalctl` command. For example:

```
$ tomo run -- aws_sqs:log -f
```

Will run this remote script:

```
journalctl -q --user-unit=aws_sqs.service -f
```

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/gauravtiwari/tomo-plugin-aws_sqs/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

Most of the code is taken from https://github.com/mattbrictson/tomo-plugin-sidekiq

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome! Thanks @mattbrictson for Tomo 🙏
