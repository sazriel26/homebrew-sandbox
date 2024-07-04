class Xsos < Formula
  desc "sosreport examiner"
  homepage "https://github.com/ryran/xsos"
  version "HEAD"
  license "GPL"
  revision 1

  head "https://github.com/ryran/xsos.git"

  livecheck do
    url :head
    strategy :github_latest
  end

  patch :DATA

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gawk"
  depends_on "gnu-getopt"
  depends_on "gnu-sed"

  def install
    bin.install "xsos"

    bash_completion.install "xsos-bash-completion.bash"
  end
end
__END__
diff --git a/xsos b/xsos
index b02e428..185cdc9 100755
--- a/xsos
+++ b/xsos
@@ -15,6 +15,18 @@
 #    General Public License <gnu.org/licenses/gpl.html> for more details.
 #-------------------------------------------------------------------------------
 
+# Homebrew GNU tools
+if ! [[ "${PATH}" =~ ^HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin ]]; then
+  export PATH="HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:HOMEBREW_PREFIX/opt/gnu-getopt/bin:HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:${PATH}"
+fi
+# Homebrew workaround for latest BASH
+if ! [[ "${SHELL}" == "HOMEBREW_PREFIX/bin/bash" ]]; then
+  exec /usr/bin/env SHELL="HOMEBREW_PREFIX/bin/bash" \
+    "HOMEBREW_PREFIX/bin/bash" "${0}" "${@}"
+  echo Oooops\! Looks like the workaround for Homebrew did not work. Exiting...>&2
+  exit
+fi
+
 # See https://github.com/ryran/xsos/issues/208
 export LC_ALL=en_US.UTF-8
 

