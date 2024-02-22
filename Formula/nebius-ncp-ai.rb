class NebiusNcpAi < Formula
  desc "Nebius Cloud Platform CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.4+Nebius-AI"
  license :cannot_represent
  revision 1

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "8f6077b43382ea25832cd0c55792fd432f6f51c4ebbc864dc56b421b12335fe0"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "3c531e46ef6686b82c58f694d3848533e67b34434fb1bf171d46719ce5f84e6f"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "bebf58fada3778f2c47f6aaba305e69d4f9f07dc387975e85c2470ff7d45e406"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "604e93e48c33b9145126500ef45b13843036ac6e5ae2b48af47f7b4b6b6c292b"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "05c022d465657c80c30e44597de428d732e914f07ac3d3c786d7ff6d7310c93a"
      end
    end
  end

  def install
    bin.install "ncp" => "ncp.ai"
    # FIXME: binary has not 0555 as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"ncp.ai")

    # Install shell completions
    # FIXME: Until more efficient solution, workaround
    generate_completions_from_executable("/usr/bin/env", "HOME=#{HOMEBREW_TEMP}", bin/"ncp.ai",
      "completion", shells: [:bash, :zsh], base_name: "ncp.ai")

    # FIXME: shell completion can have some elements to fix
    # ZSH
    system "sed",
      "-i.nok",
      "-e /ncp/ { /ncp\.ai/! s/ncp/ncp.ai/g; }",
      "#{zsh_completion}/_ncp.ai"
    rm("#{zsh_completion}/_ncp.ai.nok")
    # BASH
    system "sed",
      "-i.nok",
      "-e /ncp/ { /ncp\.ai/! s/ncp/ncp.ai/g; }",
      "#{bash_completion}/ncp.ai"
    rm("#{bash_completion}/ncp.ai.nok")
  end

  def caveats
    <<~EOS
      Add the following alias to your Shell RC (~/.zshrc or ~/.profile)

        alias docker-credential-ncp.ai='ncp.ai --no-user-output container docker-credential'

      For more information, please kindly consult #{homepage}/docs/cli
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/ncp.ai version --semantic")
  end
end
