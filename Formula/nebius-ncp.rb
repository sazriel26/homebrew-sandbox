class NebiusNcp < Formula
  desc "Nebius AI CLI"
  homepage "https://nebius.ai"
  version "0.115.0+Nebius-AI"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.nemax.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "33c5c97804126a7dd15af418c606c8ca8de46524f2cbcd5bedf0e75c1e27b7dc"
    end
    on_intel do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "77bd66765a1abfe37a361db597ce0dfb33ab68f24a12998bd99483d352ce2b9e"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "d557e59276bd865f93be06fddae57c7892b347ea291b8307d374718f71667af3"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "d6a7b0688b2d960b4e658f8e0ae19a50c1ebdef762c7d0f78d11aa843257022b"
      else
        url "https://storage.nemax.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "5e7e659cafa238b6ce06854145bc9115de3137c252ace5157f4e30566c7c8459"
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
