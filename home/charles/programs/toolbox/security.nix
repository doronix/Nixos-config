{pkgs, ...}: {
  home.packages = with pkgs; [
    # Container / dependency vulnerability scanning
    trivy
    grype

    # SBOM generation
    syft

    # Container signing / verification
    cosign

    # Source-code static analysis
    semgrep
  ];
}
