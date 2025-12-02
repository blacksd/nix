{lib}: {
  # Claude configuration module
  # Provides utilities for CLAUDE.md assembly and future customizations

  # Assemble CLAUDE.md from XML prompts
  # Usage: claudeMd = (import ./claude { inherit lib; }).assembleClaudeMd { hivemqCloudXmlPath = ...; }
  assembleClaudeMd = {
    hivemqCloudXmlPath ? null,
  }: let
    promptsDir = ./prompts;

    hivemqSection = if hivemqCloudXmlPath != null then ''
      ---

      # HiveMQ Cloud Context

      @${hivemqCloudXmlPath}
    '' else "";
  in ''
    # CLAUDE.md - Assistant Configuration

    This document contains structured directives and context for Claude AI assistant.

    ---

    # Project Principles

    ${lib.readFile "${promptsDir}/project_principles.xml"}

    ---

    # Communication and Contribution Style

    ${lib.readFile "${promptsDir}/style.xml"}

    ---

    # Tooling Directives

    ${lib.readFile "${promptsDir}/tooling.xml"}
    ${hivemqSection}
  '';

  # Future: Add slash commands, skills, etc. here
  # commands = { ... };
  # skills = { ... };
}
