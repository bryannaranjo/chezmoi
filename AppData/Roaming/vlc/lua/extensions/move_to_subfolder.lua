-- =============================================================================
-- Move to Subfolder — VLC Lua Extension
-- =============================================================================
-- Adds an "Extensions > Move to Subfolder..." menu item.
-- While a video is playing, open the menu and pick one of the existing
-- subfolders that sit next to the file.  The file is moved immediately.
--
-- INSTALL: copy this file to
--   %APPDATA%\vlc\lua\extensions\
-- Then in VLC: Tools > Preferences > Interface > check "Enable Lua interface"
-- Restart VLC.  The item appears under the Extensions menu.
-- =============================================================================

local dlg        = nil   -- active dialog (kept module-level so we can close it)
local subfolders = {}    -- populated fresh each time the dialog opens

-- ---------------------------------------------------------------------------
-- Required VLC extension hooks
-- ---------------------------------------------------------------------------

function descriptor()
    return {
        title       = "Move to Subfolder",
        version     = "1.0",
        author      = "",
        shortdesc   = "Move the playing file into one of its sibling subfolders",
        description = "Opens a dialog listing subfolders next to the current file "
                   .. "and moves the file to whichever one you pick.",
        capabilities = { "menu" }
    }
end

function activate()   end
function deactivate() end

function close()
    close_dlg()
end

-- ---------------------------------------------------------------------------
-- Menu definition
-- ---------------------------------------------------------------------------

function menu()
    return { "Move to Subfolder..." }
end

function trigger_menu(id)
    if id == 1 then
        show_dialog()
    end
end

-- ---------------------------------------------------------------------------
-- Helper: safely close and nil-out the active dialog
-- ---------------------------------------------------------------------------

function close_dlg()
    if dlg then
        dlg:delete()
        dlg = nil
    end
end

-- ---------------------------------------------------------------------------
-- Helper: get the host file-system path for the currently playing item
-- ---------------------------------------------------------------------------

function current_file_path()
    local item = vlc.input.item()
    if not item then return nil end

    local uri = item:uri()
    if not uri then return nil end

    -- VLC gives us a percent-encoded file URI, e.g. file:///C:/foo/bar%20baz.mkv
    local decoded = vlc.strings.decode_uri(uri)

    -- Strip the file:/// scheme and normalise to backslashes
    local path = decoded:gsub("^file:///", ""):gsub("/", "\\")
    return path
end

-- ---------------------------------------------------------------------------
-- Helper: split a full path into (parent_dir, filename)
-- ---------------------------------------------------------------------------

function split_path(path)
    local parent   = path:match("^(.+)\\[^\\]+$")
    local filename = path:match("[^\\]+$")
    return parent, filename
end

-- ---------------------------------------------------------------------------
-- Helper: return a list of subdirectory names inside `dir`
-- ---------------------------------------------------------------------------

function list_subfolders(dir)
    local result = {}
    -- /AD = directories only, /B = bare names only
    local handle = io.popen('dir /AD /B "' .. dir .. '" 2>nul')
    if handle then
        for line in handle:lines() do
            local name = line:match("^%s*(.-)%s*$")   -- trim whitespace
            if name ~= "" then
                table.insert(result, name)
            end
        end
        handle:close()
    end
    return result
end

-- ---------------------------------------------------------------------------
-- Helper: show a simple error/info dialog
-- ---------------------------------------------------------------------------

function show_message(msg)
    local d = vlc.dialog("Move to Subfolder")
    d:add_label(msg, 1, 1, 2, 1)
    d:add_button("OK", function() d:delete() end, 1, 2, 2, 1)
    d:show()
end

-- ---------------------------------------------------------------------------
-- Main dialog
-- ---------------------------------------------------------------------------

function show_dialog()
    close_dlg()

    -- 1. Resolve current file
    local path = current_file_path()
    if not path then
        show_message("Nothing is playing right now.")
        return
    end

    local parent, filename = split_path(path)
    if not parent then
        show_message("Could not determine the file's folder.")
        return
    end

    -- 2. Find sibling subfolders
    subfolders = list_subfolders(parent)
    if #subfolders == 0 then
        show_message("No subfolders found in:\n" .. parent)
        return
    end

    -- 3. Build dialog
    dlg = vlc.dialog("Move to Subfolder")
    dlg:add_label("File:  " .. filename,  1, 1, 2, 1)
    dlg:add_label("Move to:", 1, 2, 2, 1)

    local dd = dlg:add_dropdown(1, 3, 2, 1)
    for i, name in ipairs(subfolders) do
        dd:add_value(name, i)
    end

    dlg:add_button("Move", function() do_move(path, parent, dd) end, 1, 4, 1, 1)
    dlg:add_button("Cancel", function() close_dlg() end, 2, 4, 1, 1)
    dlg:show()
end

-- ---------------------------------------------------------------------------
-- Perform the move
-- ---------------------------------------------------------------------------

function do_move(src_path, parent, dd)
    local idx = dd:get_value()
    if not idx or not subfolders[idx] then
        show_message("Please select a subfolder first.")
        return
    end

    local folder_name = subfolders[idx]
    local filename    = src_path:match("[^\\]+$")
    local dest_path   = parent .. "\\" .. folder_name .. "\\" .. filename

    -- os.rename works for same-drive moves and succeeds on Windows even while
    -- VLC has the file open (VLC opens files with FILE_SHARE_DELETE).
    local ok, err = os.rename(src_path, dest_path)
    close_dlg()

    if not ok then
        show_message("Move failed:\n" .. (err or "unknown error")
                  .. "\n\nTry pausing or skipping the file first.")
    end
end