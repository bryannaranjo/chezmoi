--[[
	Copyright 2015-2023 surrim

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

function descriptor()
	return {
		title = "VLC Move File";
		version = "0.6";
		author = "surrim";
		url = "https://github.com/surrim/vlc-delete/";
		shortdesc = "&Move current file to a subfolder";
		description = [[
<h1>vlc-move-file</h1>
When you're playing a file, use VLC Move File to
move the current file to a predefined subfolder.
		]];
	}
end

local subfolders = {
	"best",
	"top",
	"again",
	"viewed",
}

local current_uri
local is_posix
local move_dialog
local old_item_id

function file_exists(file)
	local retval, err = os.execute("if exist \"" .. file .. "\" (exit 0) else (exit 1)")
	return type(retval) == "number" and retval == 0
end

function remove_from_playlist()
	-- The old item ID is now stored globally to be safe to delete later
	if old_item_id then
		vlc.playlist.delete(old_item_id)
		old_item_id = nil
	end
end

function sleep(seconds)
	local t_0 = os.clock()
	while os.clock() - t_0 <= seconds do end
end

function command_exists(command)
	local retval, err = os.execute(command)
	return retval ~= nil
end

function current_uri_and_os()
	local item = (vlc.player or vlc.input).item()
	local uri = item:uri()
	local is_posix_val = (package.config:sub(1, 1) == "/")
	if uri:find("^file:///") ~= nil then
		uri = string.gsub(uri, "^file:///", "")
		uri = vlc.strings.decode_uri(uri)
		if is_posix_val then
			uri = "/" .. uri
		else
			uri = string.gsub(uri, "/", "\\")
		end
	end
	return uri, is_posix_val
end

function perform_move(destination_folder)
	local retval, err
	local parent_dir, filename = string.match(current_uri, "^(.+)[/\\]([^/\\]+)$")
	local destination_uri = parent_dir .. (is_posix and "/" or "\\") .. destination_folder .. (is_posix and "/" or "\\") .. filename

	if is_posix then
		os.execute("mkdir -p \"" .. parent_dir .. "/" .. destination_folder .. "\"")
		retval, err = os.execute("mv \"" .. current_uri .. "\" \"" .. destination_uri .. "\"")
	else
		os.execute("mkdir \"" .. parent_dir .. "\\" .. destination_folder .. "\"")
		retval, err = os.execute("move /Y \"" .. current_uri .. "\" \"" .. destination_uri .. "\"")
	end
	
	if retval == nil then
		vlc.msg.err("[vlc-move-file] error moving file: " .. (err or "nil"))
		return false, (err or "An unknown error occurred.")
	end

	vlc.msg.info("[vlc-move-file] moved " .. filename .. " to " .. destination_folder)
	return true
end

function handle_selection(destination_folder)
	-- Store the current item's ID before we advance
	old_item_id = vlc.playlist.current()

	-- Explicitly close the dialog box first.
	if move_dialog then
		move_dialog:delete()
	end

	-- Advance the playlist and wait for a moment to ensure it starts playing
	vlc.playlist.next()
	sleep(1)

	-- Now, safely perform the file move.
	local success, err = perform_move(destination_folder)

	if success then
		-- Remove the old item from the playlist after a successful move.
		remove_from_playlist()
	else
		-- Show an error dialog.
		local d_error = vlc.dialog("VLC Move File Error")
		d_error:add_label("Could not move \"" .. current_uri .. "\"", 1, 1, 1, 1)
		d_error:add_label(err, 1, 2, 1, 1)
		d_error:add_button("OK", deactivate, 1, 3, 1, 1)
		d_error:show()
	end
	
	deactivate()
end

function activate()
	current_uri, is_posix = current_uri_and_os()
	vlc.msg.info("[vlc-move-file] preparing to move: " .. current_uri)

	move_dialog = vlc.dialog("VLC Move File")
	move_dialog:add_label("Move to which subfolder?", 1, 1, 1, 1)
	
	for i, folder in ipairs(subfolders) do
		move_dialog:add_button(folder, function() handle_selection(folder) end, 1, i + 1, 1, 1)
	end
	
	move_dialog:add_button("Cancel", deactivate, 1, #subfolders + 2, 1, 1)
	move_dialog:show()
end

function deactivate()
	vlc.deactivate()
end

function close()
	deactivate()
end

function meta_changed()
end
