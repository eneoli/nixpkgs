{ lib
, buildPythonPackage
, fetchFromGitHub
, isodate
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, responses
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pysolcast";
  version = "1.0.15";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "refs/tags/v${version}";
    hash = "sha256-CvijYl6zSwQ6BrGZPJWp75jAApc2y/7cPdZxMq5AjmI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    isodate
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [
    "pysolcast"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Solcast API";
    homepage = "https://github.com/mcaulifn/solcast";
    changelog = "https://github.com/mcaulifn/solcast/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
