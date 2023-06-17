# This formulae is largely based on the formula definition on brewsci/homebrew-science at:
#   https://github.com/brewsci/homebrew-science/blob/5d14d2fda3934c0eb8243c1cbdb9fb4621ec110b/Formula/geant4.rb
#
# We also got useful information from the Geant4 forum over at:
#   https://geant4-forum.web.cern.ch/t/geant4-in-macbook-19/3642/7.
#
# We also leveraged the official installation instructions accessible at:
#   https://geant4-userdoc.web.cern.ch/UsersGuides/InstallationGuide/html/installguide.html

class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.1.1/geant4-v11.1.1.tar.gz"
  version "11.1.1"
  sha256 "c5878634da9ba6765ce35a469b2893044f4a6598aa948733da8436cdbfeef7d2"
  license :public_domain

  # We need CMake for building and testing...
  depends_on "cmake" => [:build, :test]

  # We'll compile with Qt5 support for graphics and such.
  depends_on "qt@5"

  # We'll need some XML validation...
  depends_on "xerces-c"

  # We'll use macOS' own expat release for XML parsing.
  uses_from_macos "expat"

  # These resources are the data files needed by Geant4 which can be retrieved
  # from the links displayed on https://geant4.web.cern.ch/download/11.1.1.html.
  # Note we downloaded each of them to compute the associated SHA-256 hash.
  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.7.tar.gz"
    sha256 "7e7d3d2621102dc614f753ad928730a290d19660eed96304a9d24b453d670309"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.8.2.tar.gz"
    sha256 "3d7768264ff5a53bcb96087604bbe11c60b7fea90aaac8f7d1252183e1a8e427"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.7.tar.gz"
    sha256 "761e42e56ffdde3d9839f9f9d8102607c6b4c0329151ee518206f4ee9e77e7e5"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.6.tar.gz"
    sha256 "3886077c9c8e5a98783e6718e1c32567899eeb2dbb33e402d4476bc2fe4f0df1"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.4.0.tar.gz"
    sha256 "9381039703c3f2b0fd36ab4999362a2c8b4ff9080c322f90b4e319281133ca95"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.0.tar.gz"
    sha256 "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.3.tar.gz"
    sha256 "9444c5e0820791abd3ccaace105b0e47790fadce286e11149834e79c4a8e9203"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz"
    sha256 "9954dee0012f5331267f783690e912e72db5bf52ea9babecd12ea22282176820"
  end

  resource "G4TENDL" do
    url "https://cern.ch/geant4-data/datasets/G4TENDL.1.4.tar.gz"
    sha256 "4b7274020cc8b4ed569b892ef18c2e088edcdb6b66f39d25585ccee25d9721e0"
  end

  # Time to compile and still Geant4!
  def install
    # Create the `geant-build` directory and `cd` into it within the block.
    mkdir "geant-build" do
      # Let's build the arguments by concatenating stuff. The `std_cmake_args`
      # variable is defined in:
      #
      #   https://github.com/Homebrew/brew/blob/2c95aa49563dbf322672423cbfcf3d17ea434d2c/Library/Homebrew/formula.rb#L1561
      #
      # We'll just add a few Geant4-specific flags controlling the generated binaries:
      #
      #   - GEANT4_USE_GDML: Allows Geant4 to leverage the GDML language for describing geometry. This is what
      #     introduces the XML-based dependencies at the beginning of the formula. You can find more info on
      #     GDML on https://gdml.web.cern.ch/GDML/.
      #
      #   - GEANT4_BUILD_MULTITHREADED: Make Geant4 support multithreading. It's on by default, so we didn't really
      #     have to include explicitly but still.
      #
      #   - GEANT4_USE_QT: Let's build the Qt5-based GUI and visualization drivers. This introduces the dependency
      #     on Qt5 we declared at the beginning of the formula...
      #
      # Anyway, you can get more information on what all the above (and other compilation flags) do by taking a look
      # at https://geant4-userdoc.web.cern.ch/UsersGuides/InstallationGuide/html/installguide.html#standardoptions.
      args = std_cmake_args + %w[
        ../
        -DGEANT4_USE_GDML=ON
        -DGEANT4_BUILD_MULTITHREADED=ON
        -DGEANT4_USE_QT=ON
      ]

      # Let's run CMake with the arguments we've just crafted!
      system "cmake", *args

      # Time to install the generated binaries with good ol' `make`
      system "make", "install"
    end

    # Time to move the downloaded resources to a place where Geant4 will look for them when running...
    resources.each do |r|
      (share/"Geant4/data/#{r.name}#{r.version}").install r
    end
  end

  # Tell the users they'll need to source a script before leveraging a Geant4-enabled program so that
  # they know what script to source.
  def caveats
    <<~EOS
      Because Geant4 expects a set of environment variables for
      datafiles, you should source:
        . #{HOMEBREW_PREFIX}/bin/geant4.sh (or .csh)
      before running an application built with Geant4.
    EOS
  end

  # Run a toy Geant4 program to check everything from compilation to running and sourcing the appropriate
  # file works as expected!
  test do
    system "cmake", share/"Geant4/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end
