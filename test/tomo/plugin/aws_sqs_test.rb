require "test_helper"

class Tomo::Plugin::AwsSqsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Tomo::Plugin::AwsSqs::VERSION
  end
end
