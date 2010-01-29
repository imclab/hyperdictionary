require File.expand_path("#{File.dirname(__FILE__)}/../../../test_helper")

class Piston::Git::TestGitCommitRememberance < Piston::TestCase
  def setup
    super
    @repos = mock("repository")
    @repos.stubs(:url).returns("git://github.com/francois/arepos.git")

    @reposdir = Pathname.new("tmp/repos.git")
    @commit = Piston::Git::Commit.new(@repos, "ab"*20)
    @commit.stubs(:git).with("ls-remote", @repos.url, @commit.commit).returns("b"*40)
    @values = @commit.remember_values
  end

  def test_remembers_original_commit_sha1
    assert_equal @values[Piston::Git::COMMIT], @commit.sha1
  end

  def test_remembers_original_branch_name
    assert_equal @values[Piston::Git::BRANCH], @commit.revision
  end
end
