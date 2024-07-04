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
    end
    on_intel do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
      else
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
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
