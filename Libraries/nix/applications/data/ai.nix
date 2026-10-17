_: {
  chatgpt = {
    aliases = [
      "openai"
      "chatgpt-desktop"
    ];
    package = {
      source = "llm-agents";
      attribute = "chatgpt";
    };
    names = {
      package = "chatgpt";
      command = "chatgpt";
      title = "ChatGPT";
    };
    exec = "chatgpt";
    categories = ["ai"];
    family = "openai";
  };

  hermes-desktop = {
    aliases = [
      "hermes"
      "hermes-ui"
    ];
    package = {
      source = "llm-agents";
      attribute = "hermes-desktop";
    };
    names = {
      package = "hermes-desktop";
      command = "hermes-desktop";
      class = "hermes";
      title = "Hermes";
    };
    exec = "hermes-desktop";
    categories = ["ai"];
    family = "nous";
  };

  claude-desktop = {
    aliases = [
      "claude"
      "anthropic"
    ];
    package = {
      source = "llm-agents";
      attribute = "claude-desktop";
    };
    names = {
      package = "claude-desktop";
      command = "claude-desktop";
      class = "claude-desktop";
      title = "Claude";
    };
    exec = "claude-desktop";
    categories = ["ai"];
    family = "anthropic";
  };

  claude-code = {
    package = {
      source = "llm-agents";
      attribute = "claude-code";
    };
    names = {
      package = "claude-code";
      title = "Claude Code";
    };
    exec = "claude";
    categories = ["ai"];
    family = "anthropic";
    needsTerminal = true;
  };

  codex = {
    package = {
      source = "llm-agents";
      attribute = "codex";
    };
    names = {
      package = "codex";
      command = "codex";
      title = "Codex";
    };
    exec = "codex";
    categories = ["ai"];
    family = "openai";
    needsTerminal = true;
  };

  ollama = {
    names = {
      package = "ollama";
      command = "ollama";
      title = "Ollama";
    };
    exec = "ollama";
    categories = ["ai"];
    needsTerminal = true;
  };
}
