class Cfw < Formula
  desc "Local-first context firewall for coding agents"
  homepage "https://github.com/nik1t7n/context-firewall"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.3.0/cfw-aarch64-apple-darwin.tar.xz"
      sha256 "6b92665015c3d66cb0514be9c417dfcdd1c9ac114c285069b0bf0f2522592d55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.3.0/cfw-x86_64-apple-darwin.tar.xz"
      sha256 "e2a55f2ab1fe1be50c8a878872153e45e37e9484a5973508b13516727eeeddf9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.3.0/cfw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c70919645262aecca7647b94b553551d18eafb166f0f5e60e4739b1398961a5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik1t7n/context-firewall/releases/download/v0.3.0/cfw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0781e9f58b2b8614612381dde5567e450d099283f7979566ae497418671b238f"
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
