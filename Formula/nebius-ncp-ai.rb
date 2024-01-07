class NebiusNcpAi < Formula
  desc "Nebius Cloud Platform CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.1+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "19eb6499b7d1851a2df52a7b0cbcfa20aa9e165000d17b507b4861928e289b24"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "46ec5de625a3c013074db3d8daf5517374dd0332eeda80180e3779428cd78273"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "208a3a64f049732c3a4c0a41efd07e3129f9dfd64aefe282f4d9ba0ce90e9faf"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "5169aa97c5ed1e9352ed9ecf98c18bf2182c39fd36ae4eb9dc8997a1efc7824b"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "57be93db394a6df522c6b46cd874016b20d8ea70c9a8fe24b3341b7e2042779e"
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
    system "sed",
      "-i.nok",
      "-e /^#compdef/s/#compdef .*/#compdef ncp/",
      "-e s/_yc_/_ncp_/g",
      "-e /ncp/ { /ncp\.ai/! s/ncp/ncp.ai/g; }",
      "#{zsh_completion}/_ncp.ai"
    rm("#{zsh_completion}/_ncp.ai.nok")
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
