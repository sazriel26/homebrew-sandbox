class Xsos < Formula
  desc "Sosreport examiner"
  homepage "https://github.com/ryran/xsos"
  # TODO: No tag updated, only HEAD for the moment
  # url "https://github.com/ryran/xsos.git", tag: "v0.7.19"
  license "GPL-3.0-or-later"

  head "https://github.com/ryran/xsos.git",
    branch: "master"

  option "with-untar-file", "Enable untar sosreport if not already"

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gawk"
  depends_on "gnu-getopt"
  depends_on "gnu-sed"

  if build.with? "untar-file"
    patch do
      url "https://gist.githubusercontent.com/sazriel26/b5af52a53ebdc8a4ccda7858113e7417/raw/be5683e7b27a03012cb2c97d803adc70262c600c/xsos-head.diff"
    end
  end

  def install
    libexec.install "xsos"

    (bin/"xsos").write_env_script "#{HOMEBREW_PREFIX}/bin/bash", "-- #{libexec}/xsos",
      :HOMEBREW_PREFIX => HOMEBREW_PREFIX,
      :PATH => "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${HOMEBREW_PREFIX}/opt/gnu-getopt/bin:${HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin:${PATH}"

    bash_completion.install "xsos-bash-completion.bash"
  end
end
