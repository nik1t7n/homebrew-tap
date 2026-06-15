class Cfw < Formula
  desc "Local-first context firewall for coding agents"
  homepage "https://github.com/nik1t7n/context-firewall"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.1.0/cfw-aarch64-apple-darwin.tar.xz"
      sha256 "7b2ef2eb240fac8f6846a2359659ed9b80ca919161b87cecb8bc3de64ce45b08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.1.0/cfw-x86_64-apple-darwin.tar.xz"
      sha256 "d03ccb27d6cc3889c0e210330d65c192c0481f23189ad74b00183a0d703e01a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.1.0/cfw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "725eaf157abdf4dc77cf0280c69841f2162d793f6e92fe30650afc7766b46061"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.1.0/cfw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d82e895f3da1bfc3fe5485ba3b17f4d75697deb43d9706108e604d787d7eb7c"
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
