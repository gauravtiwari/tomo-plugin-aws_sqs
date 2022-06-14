require "tomo"
require_relative "aws_sqs/tasks"
require_relative "aws_sqs/version"

module Tomo::Plugin::AwsSqs
  extend Tomo::PluginDSL

  tasks Tomo::Plugin::AwsSqs::Tasks
  defaults aws_sqs_systemd_service: "aws_sqs_%{application}.service",
           aws_sqs_systemd_service_path: ".config/systemd/user/%{aws_sqs_systemd_service}",
           aws_sqs_systemd_service_template_path: File.expand_path("aws_sqs/service.erb", __dir__),
           aws_sqs_systemd_command: "bundle exec aws_sqs_active_job --queue default"
end
