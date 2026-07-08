class FluxReconciler < Formula
  desc "Dependency-ordered force reconciliation for Flux Kustomizations"
  homepage "https://github.com/rksm/flux-reconciler"
  version "0.1.0"

  url "https://github.com/rksm/flux-reconciler/archive/8d44c88e0e188e50adf1d0a4d52a9de115485a76.tar.gz"
  sha256 "0f5e8c4ba4a705a462b79d08249c77e0bc511ecbd3f5c1e0e8014bd2d1bf40c5"

  depends_on "rust" => :build
  depends_on "fluxcd/tap/flux"
  depends_on "kubernetes-cli"

  def install
    system "cargo", "install", "--locked", "--path", ".", "--root", prefix
  end

  test do
    assert_match "Reconcile Flux Kustomizations in dependency order", shell_output("#{bin}/flux-reconciler --help")
  end
end
