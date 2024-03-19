class NebiusNcpAi < Formula
  desc "Nebius Cloud Platform CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.5+Nebius-AI"
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
      sha256 "97a67ed08c665c0542a4ca6d1f788e937ea35f0842046cc705abbfff01d68aa8"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "5fecb3da28813ae8ed51090ec70c8e72421be9dcc40b15e1b3541395c79c7a46"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "fcc3f66e2ccb4b6f7e3f334e32b75be7b7a1938ba89d88b0b05b137a8aad921b"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "0896afdbf27a9ebce64710d6495c9c589d6a8b4d9cc2ca18fdca70f39f8e6c16"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "14b3abb5ccde44f65926a921bc138b0600d477bb6396acee454d3e144371c306"
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
