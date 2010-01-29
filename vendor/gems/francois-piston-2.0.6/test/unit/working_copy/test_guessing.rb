require File.expand_path("#{File.dirname(__FILE__)}/../../test_helper")

class TestWorkingCopyGuessing < Piston::TestCase
  def setup
    super
    Piston::WorkingCopy.send(:handlers).clear
    @dir = mkpath("tmp/wc")
  end

  def test_guess_when_no_handlers_raises
    assert_raise Piston::WorkingCopy::UnhandledWorkingCopy do
      Piston::WorkingCopy.guess(@dir)
    end
  end

  def test_guess_asks_each_handler_in_turn
    Piston::WorkingCopy.add_handler(handler = mock("handler"))
    handler.stubs(:name).returns("aname")
    handler.expects(:understands_dir?).with(@dir).returns(false)
    assert_raise Piston::WorkingCopy::UnhandledWorkingCopy do
      Piston::WorkingCopy.guess(@dir)
    end
  end

  def test_guess_returns_first_handler_that_understands_the_url
    handler = mock("handler")
    handler.stubs(:name).returns("aname")
    handler.expects(:understands_dir?).with(@dir).returns(true)
    handler_instance = mock("handler_instance")
    handler.expects(:new).with(File.expand_path(@dir)).returns(handler_instance)

    Piston::WorkingCopy.add_handler handler
    assert_equal handler_instance, Piston::WorkingCopy.guess(@dir)
  end
end
