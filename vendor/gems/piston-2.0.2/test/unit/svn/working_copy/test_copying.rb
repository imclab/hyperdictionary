require File.expand_path("#{File.dirname(__FILE__)}/../../../test_helper")

class Piston::Svn::TestSvnWorkingCopyCopying < Piston::TestCase
  def setup
    super
    @wcdir = mkpath("tmp/wc")
    @wc = Piston::Svn::WorkingCopy.new(@wcdir)
    @wc.stubs(:svn)
    @wc.stubs(:svn).with(:info, anything).returns("a:b")
  end

  def test_copies_files
    files = ["file.rb"]
    files.expects(:copy_to).with("file.rb", @wcdir + files.first)
    @wc.copy_from(files)
  end

  def test_ensures_directories_are_created
    files = ["file/a.rb"]
    @wcdir.expects(:+).with(files.first).returns(target = mock("target"))
    target.expects(:dirname).returns(target)
    target.expects(:mkdir)
    files.expects(:copy_to).with("file/a.rb", target)
    @wc.copy_from(files)
  end
end
