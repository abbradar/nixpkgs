{ stdenv, writeScriptBin, lib, fetchurl, fetchgit
, erlang, openssl, expat, libyaml, bash, gnused, gnugrep, coreutils, utillinux, procps
, withMysql ? false
, withPgsql ? false
, withSqlite ? false, sqlite
, withPam ? false, pam
, withZlib ? true, zlib
, withRiak ? false
, withElixir ? false, elixir
, withIconv ? true
, withLager ? true
, withTools ? false
, withRedis ? false
}:

let
  ctlpath = lib.makeSearchPath "bin" [ bash gnused gnugrep coreutils utillinux procps ];

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    exit 0
  '';

  # These can be extracted from `rebar.config.script`
  # Some dependencies are from another packages. Try commenting them out; then during build
  # you'll get necessary revision information.
  ejdeps = {
    p1_cache_tab = fetchgit {
      url = "https://github.com/processone/cache_tab";
      rev = "f7ea12b0ba962a3d2f9a406d2954cf7de4e27230";
      sha256 = "043rz66s6vhcbk02qjhn1r8jv8yyy4gk0gsknmk7ya6wq2v1farw";
    };
    p1_tls = fetchgit {
      url = "https://github.com/processone/tls";
      rev = "e56321afd974e9da33da913cd31beebc8e73e75f";
      sha256 = "0k8dx8mww2ilr4y5m2llhqh673l0z7r73f0lh7klyf57wfqy7hzk";
    };
    p1_stringprep = fetchgit {
      url = "https://github.com/processone/stringprep";
      rev = "3c640237a3a7831dc39de6a6d329d3a9af25c579";
      sha256 = "0mwlkivkfj16bdv80jr8kqa0vcqglxkq90m9qn0m6zp4bjc3jm3n";
    };
    p1_xml = fetchgit {
      url = "https://github.com/processone/xml";
      rev = "1c8b016b0ac7986efb823baf1682a43565449e65";
      sha256 = "1an66577bi3h16g6j2z9q896q2mn2r9ps6rfgm0ns97ax982ffjn";
    };
    esip = fetchgit {
      url = "https://github.com/processone/p1_sip";
      rev = "d662d3fe7f6288b444ea321d854de0bd6d40e022";
      sha256 = "09qar01m0lviv14m84f8cdv9pjb0kbz1ywwl80pvlqga1w47b68v";
    };
    p1_stun = fetchgit {
      url = "https://github.com/processone/stun";
      rev = "061bdae484268cbf0457ad4797e74b8516df3ad1";
      sha256 = "0zaw8yq4sk7x4ybibcq93k9b6rb7fn03i0k8gb2dnlipmbcdd8cf";
    };
    p1_yaml = fetchgit {
      url = "https://github.com/processone/p1_yaml";
      rev = "79f756ba73a235c4d3836ec07b5f7f2b55f49638";
      sha256 = "05jjw02ay8v34izwgi5zizqp1mj68ypjilxn59c262xj7c169pzh";
    };
    p1_utils = fetchgit {
      url = "https://github.com/processone/p1_utils";
      rev = "d7800881e6702723ce58b7646b60c9e4cd25d563";
      sha256 = "14nsbnf444r0zw9r5mbgvz4hyy37gw7dpsh2hbhy9jd26iwvlh1f";
    };
    jiffy = fetchgit {
      url = "https://github.com/davisp/jiffy";
      rev = "cfc61a2e952dc3182e0f9b1473467563699992e2";
      sha256 = "1pl9fn1s7qba07rfgdryfn3ifff3547hdq83sfaz9vjamp6la9h3";
    };
    oauth2 = fetchgit {
      url = "https://github.com/prefiks/oauth2.git";
      rev = "e6da9912e5d8f658e7e868f41a102d085bdbef59";
      sha256 = "192l3pidsf9fyfaipkk6b7hgqi56arl4g4k3vfpamccw6wh2k7ak";
    };
    xmlrpc = fetchgit {
      url = "https://github.com/rds13/xmlrpc.git";
      rev = "42e6e96a0fe7106830274feed915125feb1056f3";
      sha256 = "0v1xv1km86qq059y6cbl9gnvbkl9xx0bpk8fpw291hwb2v1zy9xm";
    };

    p1_mysql = fetchgit {
      url = "https://github.com/processone/mysql";
      rev = "dfa87da95f8fdb92e270741c2a53f796b682f918";
      sha256 = "1nw7n1xvid4yqp57s94drdjf6ffap8zpy8hkrz9yffzkhk9biz5y";
    };
    p1_pgsql = fetchgit {
      url = "https://github.com/processone/pgsql";
      rev = "e72c03c60bfcb56bbb5d259342021d9cb3581dac";
      sha256 = "0y89995h7g8bi12qi1m4cdzcswsljbv7y8zb43rjg5ss2bcq7kb6";
    };
    sqlite3 = fetchgit {
      url = "https://github.com/alexeyr/erlang-sqlite3";
      rev = "8350dc603804c503f99c92bfd2eab1dd6885758e";
      sha256 = "1l6v7kh4m05csd8ggx3pja47kvzkk6gny20k0j9ybyqvzd71dwnw";
    };
    p1_pam = fetchgit {
      url = "https://github.com/processone/epam";
      rev = "d3ce290b7da75d780a03e86e7a8198a80e9826a6";
      sha256 = "0s0czrgjvc1nw7j66x8b9rlajcap0yfnv6zqd4gs76ky6096qpb0";
    };
    p1_zlib = fetchgit {
      url = "https://github.com/processone/zlib";
      rev = "e3d4222b7aae616d7ef2e7e2fa0bbf451516c602";
      sha256 = "034drcdvnhkk6anljvvi32kasx98y6q1pz7xw2ilw3r3wga2px64";
    };
    riakc = fetchgit {
      url = "https://github.com/basho/riak-erlang-client";
      rev = "refs/tags/1.4.2";
      sha256 = "07f0igzrw3gssgzcx0pw525cn5rjhxmjylrzcnimq77b0d11s9hn";
    };
    # dependency of riakc
    riak_pb = fetchgit {
      url = "https://github.com/basho/riak_pb";
      rev = "refs/tags/1.4.4.0";
      sha256 = "03hxcbl8jhm93z0w6wa3raaszn4jysmdm7j535knhqzjg0qlblci";
    };
    # dependency of riak_pb
    protobuffs = fetchgit {
      url = "https://github.com/basho/erlang_protobuffs";
      rev = "refs/tags/0.8.1p1";
      sha256 = "1rzmkxh8ksfqfgq0n71lvvgd1hc70nladgxcc9s9j13sirjdwgqf";
    };
    rebar_elixir_plugin = fetchgit {
      url = "https://github.com/yrashk/rebar_elixir_plugin";
      rev = "7058379b7c7e017555647f6b9cecfd87cd50f884";
      sha256 = "0dmgm9hcwn6nynp80dd96ypq4civfdsx8amqffmdl2xkb04i6i2g";
    };
    elixir = fetchgit {
      url = "https://github.com/elixir-lang/elixir";
      rev = "1d9548fd285d243721b7eba71912bde2ffd1f6c3";
      sha256 = "1c975n39iy3689wwp03m8kp5h895kysn7kscdyrp5x6l88lyq5yb";
    };
    p1_iconv = fetchgit {
      url = "https://github.com/processone/eiconv";
      rev = "8b7542b1aaf0a851f335e464956956985af6d9a2";
      sha256 = "1w3k41fpynqylc2vnirz0fymlidpz0nnym0070f1f1s3pd6g5906";
    };
    lager = fetchgit {
      url = "https://github.com/basho/lager";
      rev = "4d2ec8c701e1fa2d386f92f2b83b23faf8608ac3";
      sha256 = "0zz72k56m73x235q32nb6mx18pml1q6rcxrsvsdzcv1i80d35685";
    };
    # dependency of lager
    goldrush = fetchgit {
      url = "https://github.com/DeadZen/goldrush";
      rev = "refs/tags/0.1.7";
      sha256 = "1a2mjka1sdc3wsv89qczq4pai3mxckdx9w3lfign7axkp66ikvkj";
    };
    p1_logger = fetchgit {
      url = "https://github.com/processone/p1_logger";
      rev = "3e19507fd5606a73694917158767ecb3f5704e3f";
      sha256 = "0mq86gh8x3bgqcpwdjkdn7m3bj2006gbarnj7cn5dfs21m2h2mdn";
    };
    meck = fetchgit {
      url = "https://github.com/eproxus/meck";
      rev = "fc362e037f424250130bca32d6bf701f2f49dc75";
      sha256 = "1cislsllyhi61a84i531ra60d8zqfsp7x5vfzqwf6x4sdd42yhgk";
    };
    eredis = fetchgit {
      url = "https://github.com/wooga/eredis";
      rev = "770f828918db710d0c0958c6df63e90a4d341ed7";
      sha256 = "1127dak3rcmjkz398xcvc9cbdx3n0hiz2vlp71khjwx5kx8867ay";
    };

  };

in stdenv.mkDerivation rec {
  version = "15.11";
  name = "ejabberd-${version}";

  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "0sll1si9pd4v7yibzr8hp18hfrbxsa5nj9h7qsldvy7r4md4n101";
  };

  nativeBuildInputs = [ fakegit ];

  buildInputs = [ erlang openssl expat libyaml ]
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withPam pam
    ++ lib.optional withZlib zlib
    ++ lib.optional withElixir elixir
    ;

  # Apparently needed for Elixir
  LANG = "en_US.UTF-8";

  depsNames =
    [ "p1_cache_tab" "p1_tls" "p1_stringprep" "p1_xml" "esip" "p1_stun" "p1_yaml" "p1_utils" "jiffy" "oauth2" "xmlrpc" ]
    ++ lib.optional withMysql "p1_mysql"
    ++ lib.optional withPgsql "p1_pgsql"
    ++ lib.optional withSqlite "sqlite3"
    ++ lib.optional withPam "p1_pam"
    ++ lib.optional withZlib "p1_zlib"
    ++ lib.optionals withRiak [ "riakc" "riak_pb" "protobuffs" ]
    ++ lib.optionals withElixir [ "rebar_elixir_plugin" "elixir" ]
    ++ lib.optional withIconv "p1_iconv"
    ++ lib.optionals withLager [ "lager" "goldrush" ]
    ++ lib.optional (!withLager) "p1_logger"
    ++ lib.optional withTools "meck"
    ++ lib.optional withRedis "eredis"
  ;

  configureFlags =
    [ "--enable-nif"
      (lib.enableFeature withMysql "mysql")
      (lib.enableFeature withPgsql "pgsql")
      (lib.enableFeature withSqlite "sqlite")
      (lib.enableFeature withPam "pam")
      (lib.enableFeature withZlib "zlib")
      (lib.enableFeature withRiak "riak")
      (lib.enableFeature withElixir "elixir")
      (lib.enableFeature withIconv "iconv")
      (lib.enableFeature withLager "lager")
      (lib.enableFeature withTools "tools")
      (lib.enableFeature withRedis "redis")
    ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite}";

  depsPaths = map (x: builtins.getAttr x ejdeps) depsNames;

  enableParallelBuilding = true;

  preBuild = ''
    mkdir deps
    depsPathsA=( $depsPaths )
    depsNamesA=( $depsNames )
    for i in {0..${toString (builtins.length depsNames - 1)}}; do
      cp -R ''${depsPathsA[$i]} deps/''${depsNamesA[$i]}
    done
    chmod -R +w deps
    touch deps/.got
    patchShebangs .
  '';

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e 's,\(^ *FLOCK=\).*,\1${utillinux}/bin/flock,' \
      -e 's,\(^ *JOT=\).*,\1,' \
      -e 's,\(^ *CONNLOCKDIR=\).*,\1/var/lock/ejabberdctl,' \
      $out/sbin/ejabberdctl
  '';

  meta = {
    description = "Open-source XMPP application server written in Erlang";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.ejabberd.im;
    maintainers = [ lib.maintainers.sander ];
  };
}
