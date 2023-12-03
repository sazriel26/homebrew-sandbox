class YdbCli < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.7.0"
  license :cannot_represent

  # FIXME: Do not use with homebrew, only refering to version check for automation :)
  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
      sha256 "010a28ca860504645957e6975c0876010d8b8d9af870becbde3729b079e00bc5"
    end
    on_intel do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/amd64/ydb", using: :nounzip
      sha256 "e629b82c326be2564a716da502f2b52a70dbff66ad2ab00d530df91b8ff20705"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/linux/amd64/ydb", using: :nounzip
        sha256 "b560f2958aa02fc414e7722d18cb737cca6bb74bcfb79e917fb1c5ebe12be0f4"
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
