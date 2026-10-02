class HyperClientSimulator < Formula
  desc "A Rust TUI for simulating Chromium-backed browser participants against hyper.video sessions."
  homepage "https://github.com/hypervideo/browser-simulator"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.6.2/hyper-client-simulator-aarch64-apple-darwin.tar.xz"
      sha256 "e15f037311457d1d48dac36a4a4158811286056c7e72ee69b3aab82a6811ecf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.6.2/hyper-client-simulator-x86_64-apple-darwin.tar.xz"
      sha256 "9472031b911fa89382647ecdb96e93632fe7d61183fdf0d364e5fe7b7d6d75dd"
    end
  end
  depends_on "ffmpeg"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hyper-client-simulator"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hyper-client-simulator"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
