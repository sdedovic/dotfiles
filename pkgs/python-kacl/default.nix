{
  lib,
  python3,
  fetchFromGitLab,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "python-kacl";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "schmieder.matthias";
    repo = "python-kacl";
    rev = "v${version}";
    hash = "sha256-kTLaZNDNuijIJY0NRP6R5fhbWVH9bW2wpyVng6saSAw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    semver
    gitpython
    pyyaml
    jira
  ];

  # Tests require pytest and snapshot testing
  doCheck = false;

  meta = with lib; {
    description = "Python module and CLI tool for validating and modifying Changelogs in keep-a-changelog format";
    homepage = "https://gitlab.com/schmieder.matthias/python-kacl";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "kacl-cli";
  };
}
