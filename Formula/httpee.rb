class Httpee < Formula
  desc "Run HTTP requests from TOML templates"
  homepage "https://github.com/gmartsenkov/httpee"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.6/httpee-aarch64-apple-darwin.tar.xz"
      sha256 "3bf26d76cd5b0e6f6de87662f690cf5e36a7239622cede7136f77489acfdc396"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.6/httpee-x86_64-apple-darwin.tar.xz"
      sha256 "599d0f3a82b558bb6375324f4bc14136d8df4ae04b96664b213bfddeff4b249a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.6/httpee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7171ffe260751825b16204154284676722684e8134f3cb6c9d590df81e4a061"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.6/httpee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49adabfa4850a49e7d7d6fd9391c454f119ec10d0e6e0e44446a1118e5f2bf04"
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
