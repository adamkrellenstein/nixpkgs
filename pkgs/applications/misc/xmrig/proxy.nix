{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, libuuid
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-proxy-${version}";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    sha256 = "1f573shf0qv1kh0sb9sljagpb2q1rn8h7qc1hxlb5nlchs9qcnnn";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd libuuid ];

  # Set default donation level to 0%. Can be increased at runtime via --donate-level option.
  postPatch = ''
    substituteInPlace src/donate.h --replace "kDonateLevel = 2;" "kDonateLevel = ${toString donateLevel};"
  '';

  installPhase = ''
    install -vD xmrig-proxy $out/bin/xmrig-proxy
  '';

  meta = with lib; {
    description = "Monero (XMR) Stratum protocol proxy";
    homepage = "https://github.com/xmrig/xmrig-proxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aij ];
  };
}
