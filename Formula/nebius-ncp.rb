class NebiusNcp < Formula
  desc "Nebius AI CLI"
  homepage "https://nebius.ai"
  version "0.114.0+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "d782e83ce595b128e5aa6b5e9252658287e37375f6ed7f1097ecb731ebffcbf7"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "fbbaf631b86bc8c064d655284da9400b8cf6129b37183eff2e972fed2ce4e65e"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "01e0277ec6fa5ab6171e70d89473f080217c671aa6521aa1b86f34ff9e327389"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "718ef1f14c2924c3ec2adf74e7c0f9ac5618b8e326b3e56d94c6a662f147c1a3"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "1e576823cb9faba862f614dfe20553d6ef77b180ffba42dff9cd67b317aecaf4"
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
