class YdbCli < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.11.0"
  license :cannot_represent

  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
    end
    on_intel do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/amd64/ydb", using: :nounzip
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/linux/amd64/ydb", using: :nounzip
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
    assert_match "version.to_s", shell_output("#{bin}/ydb version --semantic")
  end
end
