class RsqlCli < Formula
  desc "rsql is a CLI for CockroachDB, DuckDB, LibSQL, MariaDB, MySQL, PostgreSQL, Redshift, Snowflake, SQLite3 and SQL Server."
  homepage "https://theseus-rs.github.io/rsql/rsql_cli/"
  version "0.14.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theseus-rs/rsql/releases/download/v0.14.1/rsql_cli-aarch64-apple-darwin.tar.xz"
      sha256 "42b898d0e297da4359407bc855c96041f22764de5dce6668568e64a18d1c5a90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theseus-rs/rsql/releases/download/v0.14.1/rsql_cli-x86_64-apple-darwin.tar.xz"
      sha256 "210a8d715046537a9e280c859678bb3d94045fd886015b6a8e2b95366c1982ee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/theseus-rs/rsql/releases/download/v0.14.1/rsql_cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d7c1a1258f7088423ce693fcec0e982dde0db36805eaddd34aeebb05319c2f64"
  end
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "xz"
  depends_on "xz"

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
    bin.install "rsql" if OS.mac? && Hardware::CPU.arm?
    bin.install "rsql" if OS.mac? && Hardware::CPU.intel?
    bin.install "rsql" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
