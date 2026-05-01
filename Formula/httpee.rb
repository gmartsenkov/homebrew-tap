class Httpee < Formula
  desc "Run HTTP requests from TOML templates"
  homepage "https://github.com/gmartsenkov/httpee"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.3/httpee-aarch64-apple-darwin.tar.xz"
      sha256 "e80e81912331fc5c81e0448b40771a3f8fb254e18fb2a3b9df89839f6d6ab0c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.3/httpee-x86_64-apple-darwin.tar.xz"
      sha256 "ad3c8d7cadea1dfdbe401c6b9780823a1e0e30df09c42f2130053e8e2b47ec1a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.3/httpee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b18e796c08cc56fed3c4d32121cd106167c7edd3072766a9f33b5919b1a1e59a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.3/httpee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab96227063022b0bac6672a0ba6cb124e2db109d942663d3f5d92b5864df7f95"
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
