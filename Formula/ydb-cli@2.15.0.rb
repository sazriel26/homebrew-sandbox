class YdbCliAT2150 < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  version "2.15.0"
  license "Apache-2.0"

  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
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
    # Only one binary to link
    bin.install "ydb"
  end

  def caveats
    <<~EOS
      For more information, please kindly consult #{homepage}/en/docs/reference/ydb-cli/
    EOS
  end
end
