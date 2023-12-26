class NebiusNcpIl < Formula
  desc "Nebius Cloud CLI (IL)"
  homepage "https://nebius.com/il"
  version "0.116.0+Nebius-IL"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.il.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "2d86ba916b1b737f7c530140f396aaaeda1a2b5f8888c9ff420a5a8f23b29096"
    end
    on_intel do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "bd9003cbf15491375715e1c6086c048f6ff73ff2e0e75e95096597dd64fd0f78"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "d7c6b91bfd19df159481aaf536ffcc0dd57b674ebd755c5fad09df0e9522abf4"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "ab476490fbdb6b0ca960893e0155c3f149d2ebd6b467d2ea7026487b627756ea"
      else
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "f88b5d1232f31200005b8bed85be1384212d98e436162c906692a7555195e374"
      end
    end
  end

  def install
    # Only one binary to link
    bin.install "ncp" => "ncp-il"
    # FIXME: binary has not 0555 as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"ncp-il")

    # Install shell completions
    # FIXME: Until more efficient solution, workaround
    generate_completions_from_executable("/usr/bin/env", "HOME=#{HOMEBREW_TEMP}", bin/"ncp-il",
      "completion", shells: [:bash, :zsh], base_name: "ncp-il")

    # FIXME: shell completion can have some elements to fix
    system "sed", "-i.nok",
      "-e s/_yc_/_ncp_il_/g", "-e 1s/yc/ncp-il/",
      "-e /_ncp_/ { /_ncp_il/! s/_ncp_/_ncp_il_/g; }",
      "#{zsh_completion}/_ncp-il"
    rm("#{zsh_completion}/_ncp-il.nok")
  end

  def caveats
    <<~EOS
      Add the following alias to your Shell RC (~/.zshrc or ~/.profile)

        alias docker-credential-ncp-il='ncp-il --no-user-output container docker-credential'

      For more information, please kindly consult #{homepage}/docs/cli
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/ncp-il version --semantic")
  end
end
