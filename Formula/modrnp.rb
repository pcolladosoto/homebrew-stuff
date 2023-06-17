# This formula has been adapted from https://github.com/rnpgp/homebrew-rnp/blob/main/Formula/rnp.rb.
# We just wanted to leverage Botan 3 (instead of Botan 2) as a crypto backend.
class Modrnp < Formula
  desc "High-performance OpenPGP command-line tools and library"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "aba1ac6db628b7fe570c2e14f50a9df8786a706b1951ae904390fa3d1cce04b0"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_TESTING=OFF",
           "-DCRYPTO_BACKEND=botan3",
           *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testin = testpath / "message.txt"
    testin.write "hello"
    encr = "#{testpath}/enc.rnp"
    decr = "#{testpath}/dec.rnp"
    shell_output("#{bin}/rnpkeys --generate-key --password=PASSWORD")
    shell_output(
      "#{bin}/rnp -c --password DUMMY --output #{encr} #{testin}",
    )
    shell_output(
      "#{bin}/rnp --decrypt --password DUMMY --output #{decr} #{encr}",
    )
    cmp testin, decr
  end
end
