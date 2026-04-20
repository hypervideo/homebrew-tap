class ClientSimulator < Formula
  desc "A Rust TUI for simulating Chromium-backed browser participants against hyper.video sessions."
  homepage "https://github.com/hypervideo/browser-simulator"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.1.0/client-simulator-aarch64-apple-darwin.tar.xz"
      sha256 "803bcd53b463bde253c1fa06551adb868ea54f5678dfc2b2c464179ac9eaf3df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hypervideo/browser-simulator/releases/download/v0.1.0/client-simulator-x86_64-apple-darwin.tar.xz"
      sha256 "21e655a3c0eab50e6e50ce849e82fd7525025a1f38632a139be50b6e68d54bed"
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
    bin.install "client-simulator" if OS.mac? && Hardware::CPU.arm?
    bin.install "client-simulator" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
