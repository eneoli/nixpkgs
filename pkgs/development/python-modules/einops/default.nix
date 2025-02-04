{ lib
, buildPythonPackage
, chainer
, fetchFromGitHub
, hatchling
, jupyter
, nbconvert
, numpy
, parameterized
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "einops";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+TaxaxOc5jAm79tIK0NHZ58HgcgdCANrSo/602YaF8E=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    chainer
    jupyter
    nbconvert
    numpy
    parameterized
    pillow
    pytestCheckHook
  ];

  env.EINOPS_TEST_BACKENDS = "numpy,chainer";

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "einops"
  ];

  disabledTests = [
    # Tests are failing as mxnet is not pulled-in
    # https://github.com/NixOS/nixpkgs/issues/174872
    "test_all_notebooks"
    "test_dl_notebook_with_all_backends"
    "test_backends_installed"
  ];

  disabledTestPaths = [
    "tests/test_layers.py"
  ];

  meta = with lib; {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}

