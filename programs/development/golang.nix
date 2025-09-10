{ config, pkgs, ... }:

{
  # === GO DEVELOPMENT ENVIRONMENT ===
  
  # Go development environment packages
  environment.systemPackages = with pkgs; [
    # === GO CORE ===
    go                           # Go compiler and tools
    gopls                        # Go Language Server Protocol
    
    # === GO DEVELOPMENT TOOLS ===
    # Debugging
    delve                        # Go debugger (dlv)
    
    # Testing and benchmarking
    golangci-lint               # Fast Go linters runner
    gotests                     # Generate Go tests
    
    # Code formatting and linting
    gofumpt                     # Stricter gofmt
    gotools                     # Additional Go tools (includes goimports, guru, gorename, etc.)
    
    # Build and dependency management
    go-migrate                  # Database migration tool
    protobuf                    # Protocol buffer compiler
    protoc-gen-go              # Go protobuf plugin
    
    # Development utilities
    air                         # Live reload for Go apps
    goconvey                    # BDD testing framework
  ];

  # === GO ENVIRONMENT VARIABLES ===
  environment.variables = {
    # Go workspace configuration
    GOPATH = "$HOME/go";                    # Go workspace directory
    GOBIN = "$HOME/go/bin";                # Go binaries directory
    GO111MODULE = "on";                     # Enable Go modules
    GOPROXY = "https://proxy.golang.org";   # Go module proxy
    GOSUMDB = "sum.golang.org";            # Go checksum database
  };
} 