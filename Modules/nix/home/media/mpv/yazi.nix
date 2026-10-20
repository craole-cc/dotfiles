{
  pkgs,
  terminal,
}: let
  terminalCommand = terminal.command;
  terminalExecFlag = terminal.wrap.execFlag or "-e";
in
  pkgs.writeTextDir "share/mpv/scripts/yazi.lua" ''
    local mp = require "mp"

    local function media_directory()
        local path = mp.get_property("path", "")
        local home = os.getenv("HOME") or "."
        if path == "" or path:match("^%a[%w+.-]*://") then
            return home
        end

        local directory = path:match("^(.*)/[^/]*$")
        if directory == "" then
            return "/"
        end
        return directory or mp.get_property("working-directory", home)
    end

    local function read_selection(path)
        local file = io.open(path, "r")
        if not file then
            return nil
        end
        local selection = file:read("*l")
        file:close()
        return selection
    end

    local function open_with_yazi()
        local choice_file = os.tmpname()
        os.remove(choice_file)
        local cwd_file = choice_file .. ".cwd"

        mp.command_native_async({
            name = "subprocess",
            args = {
                "${terminalCommand}",
                "${terminalExecFlag}",
                "yazi",
                "--chooser-file=" .. choice_file,
                "--cwd-file=" .. cwd_file,
                media_directory(),
            },
            playback_only = false,
        }, function(success, result, error)
            local selection = read_selection(choice_file)
            os.remove(choice_file)
            os.remove(cwd_file)

            if not success then
                mp.osd_message("Could not open Yazi: " .. tostring(error), 5)
            elseif selection and selection ~= "" then
                mp.commandv("loadfile", selection, "replace")
            elseif result and result.status and result.status ~= 0 then
                mp.osd_message("Yazi exited with an error", 5)
            end
        end)
    end

    mp.add_key_binding("Ctrl+o", "open-with-yazi", open_with_yazi)
  ''
