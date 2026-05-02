class Httpee < Formula
  desc "Run HTTP requests from TOML templates"
  homepage "https://github.com/gmartsenkov/httpee"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.5/httpee-aarch64-apple-darwin.tar.xz"
      sha256 "d0895cc50229609dfdeadce7e8b09a3bdc4870b0ddf6b24ec2f83c28e170a437"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.5/httpee-x86_64-apple-darwin.tar.xz"
      sha256 "a0a043401c82a508ae0ed2207a032c5d680c3d058696d83af6e97e29c129dd7f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.5/httpee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "802a708ba1e4a9a654ee327156c4a5583b4d76ac62e8929e3994813de5562160"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmartsenkov/httpee/releases/download/v0.1.5/httpee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c04349768d23ca1b97f43beb77b3fd3dd0bc4f1821fbe42be5dbe01865314e3"
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
