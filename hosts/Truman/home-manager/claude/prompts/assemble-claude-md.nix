{ lib, ... }:

let
  promptsDir = ./.;
in
{
  text = ''
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

    ---

    # HiveMQ Cloud Context

    ${lib.readFile "${promptsDir}/hivemq_cloud.xml"}
  '';
}
