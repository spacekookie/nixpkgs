
{ pkgs }:
''
set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path


${builtins.readFile ./fish/functions/__fancy_history.fish }

${builtins.readFile ./fish/config.fish }
${builtins.readFile ./fish/alias.fish }

${builtins.readFile ./fish/functions/fish_prompt.fish }
${builtins.readFile ./fish/functions/fish_right_prompt.fish }
${builtins.readFile ./fish/functions/k.fish }
${builtins.readFile ./fish/functions/restart.fish }
${builtins.readFile ./fish/functions/rvm.fish }
${builtins.readFile ./fish/functions/fish_user_key_bindings.fish }
${builtins.readFile ./fish/functions/__history_previous_command_arguments.fish }
${builtins.readFile ./fish/functions/__history_previous_command.fish }
${builtins.readFile ./fish/functions/__skim_cd.fish }
${builtins.readFile ./fish/functions/__kakoune.fish }
${builtins.readFile ./fish/functions/search.fish }

${builtins.readFile ./fish/binds.fish}
''
