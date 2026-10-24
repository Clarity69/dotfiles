---@module 'hl'

-- ##################
-- ### PROGRAMS ####
-- ##################
-- Global (tanpa `local`) supaya bisa dipakai di keybinds.lua
terminal    = "kitty"
fileManager = "nautilus"
menu        = "quickshell -c shell ipc call launcher toggle"

-- ##################
-- ### LOADER ######
-- ##################
-- Pengganti `source =`. dofile (bukan require) supaya selalu dibaca ulang saat reload.
local hypr = os.getenv("HOME") .. "/.config/hypr/"
local function load(name)
  local path = hypr .. name .. ".lua"
  local f = io.open(path, "r")
  if f then f:close(); dofile(path) end
end

load("keybinds")
load("autostart")
load("monitors")
load("colors")   -- harus sebelum look
load("look")
load("input")

-- ############################
-- ## ENVIRONMENT VARIABLES ###
-- ############################
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("LIBVA_DRIVER_NAME", "i965")

-- #############################
-- ## WINDOWS AND WORKSPACES ###
-- #############################
-- Abaikan permintaan maximize dari aplikasi
hl.window_rule({
  name  = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Override dari Quickshell Control Center (paling akhir supaya menimpa yang di atas)
load("quickshell")
