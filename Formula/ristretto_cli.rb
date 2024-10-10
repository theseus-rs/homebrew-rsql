class RistrettoCli < Formula
  desc "A Java Virtual Machine (JVM) CLI."
  homepage "https://theseus-rs.github.io/ristretto/ristretto_cli/"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theseus-rs/ristretto/releases/download/v0.8.0/ristretto_cli-aarch64-apple-darwin.tar.xz"
      sha256 "42cd073a54a2731d41eeb92b9e3354880d033b5812f7af18486095f20bb69792"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theseus-rs/ristretto/releases/download/v0.8.0/ristretto_cli-x86_64-apple-darwin.tar.xz"
      sha256 "9e72a1677677da59bde63ba598d0a883388e3b9290a3e75811c7b55031b4e95b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/theseus-rs/ristretto/releases/download/v0.8.0/ristretto_cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "19febfb0654a5fe7b53bf4919cf2f56d112bad3274e4d411587f259be30244ec"
  end
  license any_of: ["Apache-2.0", "MIT"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "java" if OS.mac? && Hardware::CPU.arm?
    bin.install "java" if OS.mac? && Hardware::CPU.intel?
    bin.install "java" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
