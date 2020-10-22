{
  busybox = import <nix/fetchurl.nix> {
    url = "https://abbradar.moe/me/pub/cydfn2khg8vd105g10g43gq997cq9s90-stdenv-bootstrap-tools-i686-unknown-linux-musl/on-server/busybox";
    sha256 = "193l4r8wm7c906wd238f5pccp48dbaxl3n2rnww7v6sdr88ccdzn";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://abbradar.moe/me/pub/cydfn2khg8vd105g10g43gq997cq9s90-stdenv-bootstrap-tools-i686-unknown-linux-musl/on-server/bootstrap-tools.tar.xz";
    sha256 = "1kc2c1gwkkc4ldyp1mkfcpxqxadmlw4fzmyd2dsmmf3viqj168hp";
  };
}
