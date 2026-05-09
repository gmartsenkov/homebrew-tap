class Httpee < Formula
  desc "Run HTTP requests from TOML templates"
  homepage "https://github.com/gmartsenkov/httpee"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.9/httpee-aarch64-apple-darwin.tar.xz"
      sha256 "fb47c5c91661b371345d42037fc175394b86d7a03f364bd39f6fb30fb8188547"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.9/httpee-x86_64-apple-darwin.tar.xz"
      sha256 "da19ecdf178f17645b84eef70883cdc5ffabd34a28fb8f191998e6bacaad0d46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.9/httpee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "962de8b05719dbec5497ec89b59776facd3e245451bcd5f55a02abaed3d2e7af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.9/httpee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d742447e2856f29a056c732d7935162f6bd51b682c1e2d069ecf5a8eecadab1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "httpee" if OS.mac? && Hardware::CPU.arm?
    bin.install "httpee" if OS.mac? && Hardware::CPU.intel?
    bin.install "httpee" if OS.linux? && Hardware::CPU.arm?
    bin.install "httpee" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
