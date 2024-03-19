class NebiusNcpIl < Formula
  desc "Nebius Cloud Platform CLI (IL)"
  homepage "https://nebius.com/il"
  version "0.116.5+Nebius-IL"
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
      sha256 "405e0acfd1c560a72839f0702c75ec1c1da4a9a8e91fa3c3917b0b0ce49ce541"
    end
    on_intel do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "577cbf09f14ae638650ef96a41250350dd0da2ca807d1183ea3156275c0a0c0e"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "79bf52cd0591a5c1fea03240683cfbe1cf90deaa107bf34ffa7510df416cb1b6"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "6ae25249f60ca234b397b09a5fd5a695a6a0d7d4fe907733fc4b7b2ec0b1ef99"
      else
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "19c5754d978cadba648aa679de95af8d7e1c4ab0ae64538c05bc11847de4240e"
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
