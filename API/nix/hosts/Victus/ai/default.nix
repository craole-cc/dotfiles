{pkgs, ...}: {
  _.resolved.ai.agents.ollama.explicit = {
    enable = true;
    package = pkgs.ollama-cpu;
    service = {
      host = "127.0.0.1";
      loadModels = ["qwen3:4b-instruct"];
      environmentVariables = {
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_CONTEXT_LENGTH = "8192";
      };
    };
  };

  home-manager.users.craole = import ./hermes;
}
