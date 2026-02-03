# ⭐ STARSHIP PROMPT CONFIGURATION
# Modern, fast, and customizable shell prompt
{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    
    settings = {
      # Don't print a new line at the start of the prompt
      add_newline = false;
      
      # Custom format with icons and clean layout
      format = ''
        $cmd_duration 󰜥 $directory $git_branch
        $character'';
      
      # Character configuration
      character = {
        success_symbol = "[   ](bold fg:blue)";
        error_symbol = "[   ](bold fg:red)";
      };
      
      # Disable package module
      package = {
        disabled = true;
      };
      
      # Git branch styling
      git_branch = {
        style = "bg: cyan";
        symbol = "󰘬";
        truncation_length = 12;
        truncation_symbol = "";
        format = "󰜥 [](bold fg:cyan)[$symbol $branch(:$remote_branch)](fg:black bg:cyan)[ ](bold fg:cyan)";
      };
      
      # Git commit configuration
      git_commit = {
        commit_hash_length = 4;
        tag_symbol = " ";
      };
      
      # Git state indicators
      git_state = {
        format = "[\($state( $progress_current of $progress_total)\)]($style) ";
        cherry_pick = "[🍒 PICKING](bold red)";
      };
      
      # Git status symbols
      git_status = {
        conflicted = " 🏳 ";
        ahead = " 🏎💨 ";
        behind = " 😰 ";
        diverged = " 😵 ";
        untracked = " 🤷 ‍";
        stashed = " 📦 ";
        modified = " 📝 ";
        staged = "[++\($count\)](green)";
        renamed = " ✍️ ";
        deleted = " 🗑 ";
      };
      
      # Directory configuration
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = " ~";
        read_only_style = "197";
        read_only = "  ";
        format = "at [$path]($style)[$read_only]($read_only_style) ";
      };
      
      # Command duration
      cmd_duration = {
        format = " [$duration]($style) ";
        style = "yellow";
      };
      
      # Language-specific modules
      python = {
        symbol = "󰌠 ";
        python_binary = ["./venv/bin/python" "python" "python3" "python2"];
      };
      
      nodejs = {
        symbol = "󰎙 ";
      };
      
      rust = {
        symbol = "󱘗 ";
      };
      
      golang = {
        symbol = "󰟓 ";
      };
      
      docker_context = {
        symbol = "󰡨 ";
      };
      
      # System info
      hostname = {
        ssh_only = false;
        format = "[$hostname](bold red) ";
        disabled = false;
      };
      
      username = {
        style_user = "green bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
    };
  };
} 