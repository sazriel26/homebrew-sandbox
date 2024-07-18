class Harview < Formula
  include Language::Python::Virtualenv

  desc "CLI that dumps HAR to a human-readable summary"
  homepage "https://github.com/fboender/harview"
  version "ad7d387"
  license "MIT"

  head "https://github.com/fboender/harview.git"

  depends_on "python"

  uses_from_macos "python"

  def install
    virtualenv_install_with_resources
  end
end
