{ config, pkgs, ... }:

{
  # Minimal C/C++ setup for occasional DSA and competitive programming
  environment.systemPackages = with pkgs; [
    # === ESSENTIAL COMPILER ===
    gcc         # GNU Compiler Collection for C/C++ (sufficient for DSA)
    
    # === BASIC BUILD TOOLS ===
    cmake       # Build system for larger projects
    gnumake     # GNU make for simple compilation
    
    # === DEBUGGING ===
    gdb         # GNU Debugger for debugging DSA code
    
    # === CODE INTELLIGENCE ===
    clang-tools # Provides clangd LSP for VSCode C++ IntelliSense
  ];
}
