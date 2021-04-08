class SeaboltM1 < Formula
  desc "Seabolt for the M1 chip and Big Sur."
  homepage "https://github.com/teomores/seabolt-M1"
  url "https://github.com/teomores/seabolt-M1/releases/download/v1.7.4-M1/seabolt-M1.tar.gz"
  sha256 "67453537f44bbc0afbd109cb3bbe2aa5e78696b0c143723306369b623a9eeb09"
  license :public_domain

  depends_on "cmake" => :build
  depends_on "pkg-config"
  depends_on "openssl" => [:build, :test]

  patch :DATA  if MacOS.version == :big_sur || MacOS.version == :mojave || MacOS.version == :catalina

  def install
    system "mkdir", "build"
    Dir.chdir('build')
    system "cmake", "..", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
    
    bin.install "bin/seabolt-cli"
  end

  test do
    require "open3"
    Open3.popen3("BOLT_USER= #{bin}/seabolt-cli run \"UNWIND range(1, 3) AS n RETURN n\"") do |_, _, stderr|
      assert_equal "FATAL: Failed to connect", stderr.read.strip
    end
  end
end
