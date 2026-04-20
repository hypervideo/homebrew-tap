class HyperClientSimulator < Formula
  desc "A Rust TUI for simulating Chromium-backed browser participants against hyper.video sessions."
  homepage "https://github.com/hypervideo/browser-simulator"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.2.0/hyper-client-simulator-aarch64-apple-darwin.tar.xz"
      sha256 "59115f1d2cd886d4871df5d02d7fa0e275a02b1daba8b41a1804567f5c5086c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.2.0/hyper-client-simulator-x86_64-apple-darwin.tar.xz"
      sha256 "e71203d872167e32ffa46c087af29612f8f4ba5164b9a920abdb50459df0b0eb"
    end
  end

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
    bin.install "hyper-client-simulator" if OS.mac? && Hardware::CPU.arm?
    bin.install "hyper-client-simulator" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
