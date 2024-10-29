class SosAT4.8.0 < Formula
  include Language::Python::Virtualenv

  desc "Unified tool for collecting system logs and other debug information"
  homepage "https://github.com/sosreport/sos"
  url "https://github.com/sosreport/sos.git",
    tag: "4.8.0"
  license "GPL-2.0-or-later"

  head "https://github.com/sosreport/sos.git"

  livecheck do
    url :stable
    strategy :github_releases
  end

  option "without-magic", "Disable python magic module"
  option "without-requests", "Disable python requests module"
  option "with-boto3", "Enable python boto3 module"

  depends_on "python"

  uses_from_macos "python"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  unless build.without? "magic"
    depends_on "libmagic"

    resource "python-magic" do
      url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
      sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
    end
  end

  unless build.without? "requests"
    resource "certifi" do
      url "https://files.pythonhosted.org/packages/c2/02/a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbea/certifi-2024.7.4.tar.gz"
      sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
    end

    resource "charset-normalizer" do
      url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
      sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
    end

    resource "idna" do
      url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
      sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
    end

    resource "requests" do
      url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
      sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
    end
  end

  if (build.with? "requests") || (build.with? "boto3")
    resource "urllib3" do
      url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
      sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
    end
  end

  if build.with? "boto3"
    resource "boto3" do
      url "https://files.pythonhosted.org/packages/fd/a8/e825d84cdcf9136cedc89c1f317f80023179685f83469a6ad04b3b0709f4/boto3-1.35.0.tar.gz"
      sha256 "bdc242e3ea81decc6ea551b04b2c122f088c29269d8e093b55862946aa0fcfc6"
    end

    resource "botocore" do
      url "https://files.pythonhosted.org/packages/38/f5/2b9df08eb22ecc0407e08086ec5c1a424ce66237f3b9fc0b6686712be247/botocore-1.35.0.tar.gz"
      sha256 "6ab2f5a5cbdaa639599e3478c65462c6d6a10173dc8b941bfc69b0c9eb548f45"
    end

    resource "jmespath" do
      url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
      sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
    end

    resource "python-dateutil" do
      url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
      sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
    end

    resource "s3transfer" do
      url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
      sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
    end

    resource "six" do
      url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
      sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end
  end

  patch do
    url "https://gist.githubusercontent.com/sazriel26/756813ef520f399956597c292a807104/raw/430f4d32a15e4cd316ec433ac119196818ba7b43/4.8.0-darwin-support.diff"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Consult homepage: #{homepage}

      Current MacOS support is EXPERIMENTAL
      See https://github.com/sazriel26/sos-forked/tree/macos-support
    EOS
  end
end
