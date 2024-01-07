class NebiusNcpIl < Formula
  desc "Nebius Cloud Platform CLI (IL)"
  homepage "https://nebius.com/il"
  version "0.116.1+Nebius-IL"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.il.nebius.cloud/ncp/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/arm64/ncp", using: :nounzip
      sha256 "a6e9e345fe8d3ce291f2e8ff064ace4e907e3e5453ded391f5bfbad6fcf85fd9"
    end
    on_intel do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/darwin/amd64/ncp", using: :nounzip
      sha256 "a6626197b3398ff01211892d8c1ed949a08c0303349bb5eae3aa9b0ccb800bb7"
    end
  end

  on_linux do
    on_arm do
      url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/arm64/ncp", using: :nounzip
      sha256 "6dda365a5d5446765a1667852f2c50ebabfc1f6931609c09ec0095e7f51889df"
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/amd64/ncp", using: :nounzip
        sha256 "7afe1e9cdc04625cbc2665c7227684636329169c56c924ca64f7af59b5ec86c5"
      else
        url "https://storage.il.nebius.cloud/ncp/release/#{version}/linux/386/ncp", using: :nounzip
        sha256 "fed51f06b6b42dbcfb66ac3bde2f2eccdb492f296bb124e780f61160a6bfbc89"
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
    system "sed",
      "-i.nok",
      "-e /^#compdef/s/#compdef .*/#compdef ncp/",
      "-e s/_yc_/_ncp_/g",
      "-e /ncp/ { /ncp\.il/! s/ncp/ncp.il/g; }",
      "#{zsh_completion}/_ncp.il"
    rm("#{zsh_completion}/_ncp.il.nok")
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
