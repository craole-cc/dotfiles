#~@ Section header
#> Summary of what a setting does, or an action to take
#? Additional info: enum options, caveats, defaults
_: {
  name = "template";
  description = "Template for mkEntry";
  enable = false;

  extensions = [
    "publisher.extension-id"
  ];

  keybindings = [
    #? A leading "-" on the command removes a default binding
    {
      key = "ctrl+alt+x";
      command = "workbench.action.example";
      when = "editorTextFocus && !editorReadonly";
    }
  ];

  settings = {
    #~@ Example Section
    example = {
      #> Plain value with a summary
      enabled = true;

      #> Enum value with options listed
      #? - off: Disable the feature.
      #? - auto: Let the extension decide.
      mode = "auto";

      #> Nested keys group by dotted prefix
      #? Becomes example.nested.size
      nested.size = 4;

      #> Object-valued settings must stay as real attrsets, do not flatten
      associations = {
        "*.ext" = "language";
      };
    };
  };
}
