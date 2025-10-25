{pkgs, ...}: {
  homebrew = {
    masApps = {
      PerplexityAI = 6714467650;
    };

    casks = [
      "chatgpt"
      "claude"
    ];
  };
}
