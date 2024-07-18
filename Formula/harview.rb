class Harview < Formula
  include Language::Python::Virtualenv

  desc "CLI that dumps HAR to a human-readable summary"
  homepage "https://github.com/fboender/harview"
  license "MIT"
  version "ad7d387"

  url "https://github.com/fboender/harview.git"

  depends_on "python"

  uses_from_macos "python"

  def install
    virtualenv_install_with_resources
  end
end
