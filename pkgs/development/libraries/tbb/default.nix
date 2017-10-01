{ stdenv, fetchurl }:

let
  SHLIB_EXT = if stdenv.isDarwin then "dylib" else "so";
  COMPILER = if stdenv.cc.isGNU then "gcc" else "clang";
in
stdenv.mkDerivation {
  name = "tbb-2018-u1";

  src = fetchurl {
    url = "https://github.com/01org/tbb/archive/2018_U1.tar.gz";
    sha256 = "c6462217d4ecef2b44fce63cfdf31f9db4f6ff493869899d497a5aef68b05fc5";
  };

  checkTarget = "test";
  doCheck = false;

  makeFlags = "stdver=c++0x compiler="+COMPILER;

  installPhase = ''
    mkdir -p $out/{lib,share/doc}
    cp "build/"*release*"/"*${SHLIB_EXT}* $out/lib/
    mv include $out/
    rm $out/include/index.html
    mv doc/html $out/share/doc/tbb
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "https://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ peti thoughtpolice ];
  };
}
