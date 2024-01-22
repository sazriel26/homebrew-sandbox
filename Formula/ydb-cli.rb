class YdbCli < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.8.0"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
      sha256 "33b446b0a44230ad117c482c3ecc88f4316bf2af6d992109c4e441a2ae0a8156"
    end
    on_intel do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/amd64/ydb", using: :nounzip
      sha256 "e176598c64c6ac17b5efda01b5fc4379eb7a4d0799b98ebfb1ef15dbca06a808"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/linux/amd64/ydb", using: :nounzip
        sha256 "9782b12db9fdaa6fa6d02a4dcffa87fb5b25cb956a603a69391f12105b6f6eb1"
      end
    end
  end

  def install
    # Only one binary to link
    bin.install "ydb"
  end

  def caveats
    <<~EOS
      For more information, please kindly consult #{homepage}/en/docs/reference/ydb-cli/
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/ydb version --semantic")
  end
end
