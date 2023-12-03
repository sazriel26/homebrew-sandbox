class NebiusYc < Formula
  desc "Nebius IL CLI"
  homepage "https://nebius.com/il"
  version "0.113.0+Nebius-IL"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.il.nebius.cloud/cli/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.il.nebius.cloud/cli/release/#{version}/darwin/arm64/yc", using: :nounzip
      sha256 "7cf34793e269e81cad02d586868beff4f0b367f3c8261d5d927fec0df86dd862"
    end
    on_intel do
      url "https://storage.il.nebius.cloud/cli/release/#{version}/darwin/amd64/yc", using: :nounzip
      sha256 "0557998a782134698096dcaa52a3c7b1ff77bef16f334ec26f200df43f974a59"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/cli/release/#{version}/linux/arm64/yc", using: :nounzip
      sha256 "1f7c23d0150ba03a754bee9bc2f4d977c7a17039b0c11c6d2a33fc497b38c063"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/cli/release/#{version}/linux/amd64/yc", using: :nounzip
        sha256 "e5e64b0e7f1da70c751f8723dba0e0ba0c27643b216ed42d0f69666a206801bd"
      else
        url "https://storage.il.nebius.cloud/cli/release/#{version}/linux/386/yc", using: :nounzip
        sha256 "fdd6130a8100636df72d5dc7eaa29666afd13046ba2299efb4edbffb37255386"
      end
    end
  end

  def install
    # Only one binary to link
    bin.install "yc"
    # FIXME: binary has not 0555 as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"yc")

    # Install shell completions
    # FIXME: Until more efficient solution, workaround
    generate_completions_from_executable("/usr/bin/env", "HOME=#{HOMEBREW_TEMP}", bin/"yc",
      "completion", shells: [:bash, :zsh], base_name: "yc")
  end

  def caveats
    <<~EOS
      Add the following alias to your Shell RC (~/.zshrc or ~/.profile)

        alias docker-credential-yc='yc --no-user-output container docker-credential'

      For more information, please kindly consult #{homepage}/docs/cli
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/yc version --semantic")
  end
end
