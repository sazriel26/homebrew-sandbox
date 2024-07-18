class Sxconsole < Formula
  include Language::Python::Virtualenv

  desc "A tool to extract and analyze data from sosreports"
  homepage "https://github.com/sbradley7777/sx"
  license "GPL-2.0"

  url "https://github.com/sbradley7777/sx.git",
    tag: "sx-2.17"

  head "https://github.com/sbradley7777/sx.git",
    branch: "master"

  depends_on "python"

  uses_from_macos "python"

  def install
    # From python@3.x
    system "2to3",
      "--no-diffs",
      "--nobackups",
      "--write",
      ".",
      "sxconsole"

    virtualenv_install_with_resources
  end
end
