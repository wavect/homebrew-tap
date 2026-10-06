class Semaprax < Formula
  desc "Systems language: meaning in, verified machine code out"
  homepage "https://github.com/wavect/semaprax"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/wavect/semaprax/releases/download/v0.8.0/semaprax-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "c281aa274650e9003487f738a349fb746b27bc5575276cae63f50cc81a155ff6"
    end
  end

  def install
    bin.install "semaprax", "semapraxd"
    pkgshare.install "release-manifest.json"
    prefix.install "LICENSE"
  end

  test do
    # Both executables ship in the same archive, so they are the same release.
    assert_path_exists bin/"semapraxd"
    assert_predicate bin/"semapraxd", :executable?
    assert_match version.to_s, shell_output("#{bin}/semaprax --version")
    assert_match version.to_s, (pkgshare/"release-manifest.json").read

    system bin/"semaprax", "new", "first-semaprax"
    system bin/"semaprax", "check", "first-semaprax/semaprax.toml"
    system bin/"semaprax", "test", "first-semaprax/semaprax.toml"
    assert_equal "42", shell_output("#{bin}/semaprax run first-semaprax/semaprax.toml").strip
  end
end
