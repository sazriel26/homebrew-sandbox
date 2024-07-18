class Harview < Formula
  include Language::Python::Shebang

  desc "CLI that dumps HAR to a human-readable summary"
  homepage "https://github.com/fboender/harview"
  license "MIT"
  version "ad7d387"

  url "https://github.com/fboender/harview.git"

  uses_from_macos "python"

  def install
    #bin.install "src/harview"
    #rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"harview"
    virtualenv_install_with_resources
  end
end
