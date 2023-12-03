class NebiusNcp < Formula
  desc "Nebius AI CLI"
  homepage "https://nebius.ai"
  version "0.113.0+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "77b3318ab5e84957ecd8822658def8b7055712daa2e51d491b50a71f694fc8f4"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "101b857263b9791a0994b6c30503a65aad2386b97f2bb74d1809eaed1accf7e8"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "6f0bf2aed584a1ff0cc71c65c14b0b696f6b38ab08a1482baa7053d411ba63a4"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "47b9c39acb3061145d181bfd34483852fe646a93354815def991feab217fd3d2"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "118a6c2aede269daa7acbf70a03a6b3ac325c8db51036f787616ad04eee9eac9"
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
