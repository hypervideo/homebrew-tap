class HyperClientSimulator < Formula
  desc "A Rust TUI for simulating Chromium-backed browser participants against hyper.video sessions."
  homepage "https://github.com/hypervideo/browser-simulator"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.4.0/hyper-client-simulator-aarch64-apple-darwin.tar.xz"
      sha256 "add8519c51cf3480a774548542cb041cf5c5f932dab3324a65e22fb8c597bb2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.4.0/hyper-client-simulator-x86_64-apple-darwin.tar.xz"
      sha256 "6a3a4b16a863ac45d8700366dff418faeb3906d45d2de47a3f40e8b20a482195"
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
