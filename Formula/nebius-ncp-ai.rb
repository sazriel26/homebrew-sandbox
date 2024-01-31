class NebiusNcpAi < Formula
  desc "Nebius Cloud Platform CLI (AI)"
  homepage "https://nebius.ai"
  version "0.116.3+Nebius-AI"
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
      sha256 "2a72614344f53136e666cc47a9daec0e2b9f9db1d28eda5cc1d1ef2cdb762e52"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "01df394efb06015f319f3d34f0d2f46fb1ae6bb13bd1b3d3c4d53f147eecebfd"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "2877b62fa2bb4c6ea209e9ef5fd731c1d686103c54a7522b3426bafe2ab5597f"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "afe608262e54703b961d9738d800c9fe301dfbe07e4ca9da30d1f1c8776dbc70"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "673dcf5c31a166c19b41ed5877b5042fcd9ddafb8a4dc03ca81af044778e97ae"
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
