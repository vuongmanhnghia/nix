{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core compilers and build systems
    gcc         # GNU Compiler Collection for C/C++
    clang       # LLVM-based C/C++ compiler with better diagnostics
    cmake       # Cross-platform build system generator
    gnumake     # GNU make build automation tool
    ninja       # Fast build system focused on speed
    pkg-config  # Helper tool for compiling applications and libraries
    
    # Language Server Protocol and development tools
    gdb
    clang-tools  # Includes clangd (LSP), clang-format, clang-tidy for code analysis
  ];
}