require "test_helper"

class Tomo::Plugin::AwsSqs::TasksTest < Minitest::Test
  def setup
    @tester = Tomo::Testing::MockPluginTester.new("aws_sqs", settings: { application: "example" })
  end

  def test_setup_systemd
    @tester.mock_script_result("ls -A1 /var/lib/systemd/linger", stdout: "testing\n")
    expected_scripts = [
      "ls -A1 /var/lib/systemd/linger",
      "mkdir -p .config/systemd/user",
      "> .config/systemd/user/aws_sqs_example.service",
      "systemctl --user daemon-reload",
      "systemctl --user enable aws_sqs_example.service"
    ]

    @tester.run_task("aws_sqs:setup_systemd")
    expected_scripts.zip(@tester.executed_scripts).each do |expected, actual|
      assert_match(expected, actual)
    end
  end

  def test_setup_systemd_dies_if_linger_is_disabled
    @tester.mock_script_result("ls -A1 /var/lib/systemd/linger", stdout: "some_other_user\n")
    error = assert_raises(Tomo::Runtime::TaskAbortedError) do
      @tester.run_task("aws_sqs:setup_systemd")
    end
    assert_match("Linger must be enabled", error.to_console)
  end

  def test_reload
    @tester.run_task("aws_sqs:reload")
    assert_equal("systemctl --user reload aws_sqs_example.service", @tester.executed_script)
  end

  def test_restart
    @tester.run_task("aws_sqs:restart")
    assert_equal("systemctl --user restart aws_sqs_example.service", @tester.executed_script)
  end

  def test_start
    @tester.run_task("aws_sqs:start")
    assert_equal("systemctl --user start aws_sqs_example.service", @tester.executed_script)
  end

  def test_stop
    @tester.run_task("aws_sqs:stop")
    assert_equal("systemctl --user stop aws_sqs_example.service", @tester.executed_script)
  end

  def test_log
    assert_raises(Tomo::Testing::MockedExecError) do
      @tester.run_task("aws_sqs:log", "-f")
    end
    assert_equal("journalctl -q --user-unit\=aws_sqs_example.service -f", @tester.executed_script)
  end
end
