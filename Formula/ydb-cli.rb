class YdbCli < Formula
  desc "Yandex DB CLI"
  homepage "https://ydb.tech"
  license "Apache-2.0"
  url "http://127.0.0.1"

  livecheck do
    url "https://storage.yandexcloud.net/yandexcloud-ydb/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      version "2.13.0"
    end
    on_intel do
      version "2.15.0"
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        version "2.15.0"
      end
    end
  end

  depends_on "ydb-cli@#{version}.to_s"

  def install
    bin.install_symlink bin/"ydb" => libexec/"ydb-#{version}.to_s"
  end

  def caveats
    <<~EOS
      For more information, please kindly consult #{homepage}/en/docs/reference/ydb-cli/
    EOS
  end
end
