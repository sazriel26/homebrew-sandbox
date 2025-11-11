class JiraCli < Formula
  desc "Jira Command-Line"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli.git"
  version "1.5.2"
  license "MIT"

  on_macos do
    version "1.7.0" # @github-actions-macos-latest@
    on_arm do
      url "#{homepage}/releases/download/v#{version}/jira_#{version}_macOS_arm64.tar.gz"
    end
    on_intel do
      url "#{homepage}/releases/download/v#{version}/jira_#{version}_macOS_x86_64.tar.gz"
    end
  end

  on_linux do
    version "1.7.0" # @github-actions-ubuntu-latest@
    on_arm do
      url "#{homepage}/releases/download/v#{version}/jira_#{version}_linux_arm64.tar.gz"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "#{homepage}/releases/download/v#{version}/jira_#{version}_linux_x86_64.tar.gz"
      else
        url "#{homepage}/releases/download/v#{version}/jira_#{version}_linux_i386.tar.gz"
      end
    end
  end

  def install
    bin.install "bin/jira" => "jira-cli"

    generate_completions_from_executable(bin/"jira-cli",
      "completion", base_name: "jira-cli")

    # FIXME: shell completion can have some elements to fix
    # ZSH
    system "sed",
      "-i.nok",
      "-e /jira/ { s/jira/jira-cli/g; }",
      "#{zsh_completion}/_jira-cli"
    rm("#{zsh_completion}/_jira-cli.nok")
    # BASH
    system "sed",
      "-i.nok",
      "-e /jira/ { s/jira/jira-cli/g; }",
      "#{bash_completion}/jira-cli"
    rm("#{bash_completion}/jira-cli.nok")
  end

  def caveats
    <<~EOS
      For more information, please kindly consult #{homepage}
    EOS
  end

  test do
    assert_match "version.to_s", shell_output("#{bin}/jira-cli version")
  end
end
