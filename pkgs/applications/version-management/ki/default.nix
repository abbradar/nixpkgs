{ lib
, buildPythonPackage
, fetchFromGitHub
, GitPython
, more-itertools
, beartype
, tqdm
, whatthepatch
, click
, colorama
, anki
, lark
, pytest
, loguru
, bitstring
, checksumdir
, pytest-mock
, html-tidy
}:

buildPythonPackage rec {
  pname = "ki";
  version = "unstable-git-2023-01-25";

  src = fetchFromGitHub {
    owner = "langfield";
    repo = "ki";
    rev = "fed9977fac349eedc0268427d0be7b979fd49651";
    sha256 = "sha256-eTrnQ9pWOCVlO0QWuiOPRuuIZSvPB6hvTUFzGiBbTMM=";
  };

  postPatch = ''
    sed -i \
      -e 's,^\(gitpython\) .*,\1,' \
      -e 's,^\([^= ><]*\).*,\1,' \
      requirements.txt
  '';

  propagatedBuildInputs = [
    GitPython
    more-itertools
    beartype
    tqdm
    whatthepatch
    click
    colorama
    anki
    lark
    html-tidy
  ];

  checkInputs = [
    pytest
    loguru
    bitstring
    checksumdir
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://github.com/langfield/ki";
    description = "Version control for Anki collections";
    license = licenses.agpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
