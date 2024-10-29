class YdbCliAT2150 < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.15.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      disable! date: "2024-10-29", because: :unsupported
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
    end
    on_intel do
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/amd64/ydb", using: :nounzip
      sha256 "c8b766d9ea4f28971b802a2462da471ac6dbb2a09c3c5820c079e0e493ebc42f"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/linux/amd64/ydb", using: :nounzip
        sha256 "631edb9ed0851ae9c899bf91fb22f7ebe4c44b200aa5aa0c39877441e4133735"
      end
    end
  end

  def install
    libexec.install "ydb-#{version}.to_s" => "ydb"
  end
end
