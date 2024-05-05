class NebiusNcpAi < Formula
  desc "Nebius Cloud Platform CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.7+Nebius-AI"
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
      sha256 "8ac91dbec4ffbef9fa0e0a62ca2d824d2ea7872441c4a276d8617947c82d599b"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "bf4dc20f9d96ce4108d90af2351512fe8be1c57d01a77ea0d8b25c6ff75a58fe"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "00dfdad75cd6583261416ece90f08a6118fcf061f0f3de378a9f94ced126e522"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "76c3c37482a3e190ced37de3aa90f00757f4105ed85795c1795580842671b38e"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "db7a08e44b41db28ca80e510b9f0d93bb943b05b53c3c8812927b0521e6d3d02"
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
