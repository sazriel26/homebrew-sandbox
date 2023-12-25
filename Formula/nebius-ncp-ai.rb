class NebiusNcpAi < Formula
  desc "Nebius Cloud CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.0+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "4635347b01ee434614db124a1da0ce8c4ae56175dff02fdb41364130b687123d"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "b963412a1efdf6410e1dc53450b1879e9f7860d16a7cf451214dcb0662f117d9"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "df89b7eb1a7cc8c3e9706603a03e252845874ac7f620a20f94a97e64c1e9fcf4"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "e6b856a665ae61b057cbda9bdfd8229c3f17f1093adc1bac0d33c2eb8c67de3b"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "334ba683cb372eb61b1d2df7f95b93eb2ee1d46f7975e53fc587eb22b7ea350a"
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
