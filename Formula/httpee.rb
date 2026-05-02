class Httpee < Formula
  desc "Run HTTP requests from TOML templates"
  homepage "https://github.com/gmartsenkov/httpee"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.4/httpee-aarch64-apple-darwin.tar.xz"
      sha256 "5a72f9494aba6631401feef4e43b7c74a9de52fe0f5a2fb029f57126ab9fd97c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.4/httpee-x86_64-apple-darwin.tar.xz"
      sha256 "e35dd4b94df848d91c8d4a96e8d45139be82ecb5afdb60a74048d3bc1ce42cfd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.4/httpee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "94120cb4e89f3936d63bb599993874bea7269617cf44d7828086f65e27c7f11d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.4/httpee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15e89f4058d5838fcfa4536dd49f9e739f7732f6912e010542cc85936b954a94"
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
