class Cfw < Formula
  desc "Local-first context firewall for coding agents"
  homepage "https://github.com/nik1t7n/context-firewall"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.2.0/cfw-aarch64-apple-darwin.tar.xz"
      sha256 "0ae93869d50dcd9eb5c1fba45a0c1ba064b57710f12c6776fdd31588db44d1fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.2.0/cfw-x86_64-apple-darwin.tar.xz"
      sha256 "ffe3b26a441a863e4f49a174f9be33cdf7a062f22ba6fcf4ee8d33cb78ff0d16"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.2.0/cfw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c9b4019e7b8d716a4eccef0faaa490198ce9404e2dea5cf1bf6a74f572209da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.2.0/cfw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06465d3fea784aef332095b17b5c287988d4c2e5e8e97a5c2597d360aa823574"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cfw" if OS.mac? && Hardware::CPU.arm?
    bin.install "cfw" if OS.mac? && Hardware::CPU.intel?
    bin.install "cfw" if OS.linux? && Hardware::CPU.arm?
    bin.install "cfw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
