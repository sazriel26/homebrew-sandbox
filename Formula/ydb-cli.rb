class YdbCli < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  license "Apache-2.0"
  url "#{homepage}"

  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      version "2.13.0"
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/arm64/ydb", using: :nounzip
      sha256 "9fd53c4ac2ca759cbf37e4cce2d7e531a7d0641124e003bd13e78da0b449c2c5"
      livecheck do
        skip "No more updated by upstream"
      end
    end
    on_intel do
      version "2.15.0" # @github-actions-macos-latest@
      url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/darwin/amd64/ydb", using: :nounzip
      sha256 "c8b766d9ea4f28971b802a2462da471ac6dbb2a09c3c5820c079e0e493ebc42f"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        version "2.33.0" # @github-actions-ubuntu-latest@
        url "https://storage.yandexcloud.net/yandexcloud-ydb/release/#{version}/linux/amd64/ydb", using: :nounzip
        sha256 "631edb9ed0851ae9c899bf91fb22f7ebe4c44b200aa5aa0c39877441e4133735"
      end
    end
  end

  def install
    bin.install "ydb"
  end

  def caveats
    <<~EOS
      For more information, please kindly consult #{homepage}/en/docs/reference/ydb-cli/
    EOS
  end
end
