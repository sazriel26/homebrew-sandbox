class YdbCliAT2130 < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.13.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
      sha256 "9fd53c4ac2ca759cbf37e4cce2d7e531a7d0641124e003bd13e78da0b449c2c5"
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
    bin.install "ydb" => "ydb-#{version}"
  end
end
