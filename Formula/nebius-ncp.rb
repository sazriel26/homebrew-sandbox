class NebiusNcp < Formula
  desc "Nebius AI CLI"
  homepage "https://nebius.ai"
  version "0.115.1+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "180c30b2cc89bf1e60b7f2529b6c3623cd1528d7f1aa60dad405c461a579339c"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "9b422c132aaa4734d14ff9c90a629dd896014a5145db93db0390fdc30dfd97fd"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "28782a341a55e711a123f3309602bc20af1e61c6851b8fd1a7b66b43aa81fdfa"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "47f44a602574a8bb938fc4c98da0ff8ae1c081302f84858a6f1c9e9326a28b87"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "4ffc5308a1722234875c7e2c6d92f0c960ed7f345342bf8fead8113ec0b30301"
      end
    end
  end

  conflicts_with "ncp", because: "may conflict with binary name ncp of #{desc}"

  def install
    bin.install "ncp"
    # FIXME: binary has not 0555 as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"ncp")

    # Install shell completions
    # FIXME: Until more efficient solution, workaround
    generate_completions_from_executable("/usr/bin/env", "HOME=#{HOMEBREW_TEMP}", bin/"ncp",
      "completion", shells: [:bash, :zsh], base_name: "ncp")

    # FIXME: shell completion can have some elements to fix
    system "sed", "-i.nok", "-e s/_yc_/_ncp_/g", "-e 1s/yc/ncp/", "#{zsh_completion}/_ncp"
    rm("#{zsh_completion}/_ncp.nok")
  end

  def caveats
    <<~EOS
      Add the following alias to your Shell RC (~/.zshrc or ~/.profile)

        alias docker-credential-ncp='ncp --no-user-output container docker-credential'

      For more information, please kindly consult #{homepage}/docs/cli
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/ncp version --semantic")
  end
end
