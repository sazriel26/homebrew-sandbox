class NebiusNcpIl < Formula
  desc "Nebius Cloud Platform CLI (IL)"
  homepage "https://nebius.com/il"
  version "0.116.6+Nebius-IL"
  license :cannot_represent
  revision 1

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.il.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "7d4d6db17b4ba434a4bee586b09ef8118fe32b11b5b0048e2b06f01004d46f8e"
    end
    on_intel do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "66a1a18f977b98237b2c6f5bf25474f67052b58c40cb1455671ee50e03b38b8b"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "ba8b1e051beda0cbf6f3fbc671216e04ffd4a7f484c14843cd386b80f30cd5c6"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "a4bd403cd0b6162aa4f47d5bd6d237c1abeed2ddaea99102ac3d5987ae0171a7"
      else
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "0371eabb6a79ccef50136eabb4a975d3c9ba3b0050348b2b5cd54218f23fcd78"
      end
    end
  end

  def install
    # Only one binary to link
    bin.install "ncp" => "ncp.il"
    # FIXME: binary has not 0555 as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"ncp.il")

    # Install shell completions
    # FIXME: Until more efficient solution, workaround
    generate_completions_from_executable("/usr/bin/env", "HOME=#{HOMEBREW_TEMP}", bin/"ncp.il",
      "completion", shells: [:bash, :zsh], base_name: "ncp.il")

    # FIXME: shell completion can have some elements to fix
    # ZSH
    system "sed",
      "-i.nok",
      "-e /ncp/ { /ncp\.il/! s/ncp/ncp.il/g; }",
      "#{zsh_completion}/_ncp.il"
    rm("#{zsh_completion}/_ncp.il.nok")
    # BASH
    system "sed",
      "-i.nok",
      "-e /ncp/ { /ncp\.il/! s/ncp/ncp.il/g; }",
      "#{bash_completion}/ncp.il"
    rm("#{bash_completion}/ncp.il.nok")
  end

  def caveats
    <<~EOS
      Add the following alias to your Shell RC (~/.zshrc or ~/.profile)

        alias docker-credential-ncp.il='ncp.il --no-user-output container docker-credential'

      For more information, please kindly consult #{homepage}/docs/cli
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/ncp.il version --semantic")
  end
end
