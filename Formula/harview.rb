class Harview < Formula
  include Language::Python::Shebang

  desc "CLI that dumps HAR to a human-readable summary"
  homepage "https://github.com/fboender/harview"
  license "MIT"
  version "20230711"

  url "https://github.com/fboender/harview.git"

  livecheck do
    skip "There is no known version"
  end

#  depends_on "python"

  uses_from_macos "python"

  def install
    bin.install "src/harview"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"harview"
  end
end
