-- Muat warna pywal (~/.cache/wal/colors-hyprland.lua).
-- Kalau cache belum ada, pakai abu-abu supaya Hyprland tetap jalan.
local f = os.getenv("HOME") .. "/.cache/wal/colors-hyprland.lua"
local h = io.open(f, "r")
if h then h:close(); dofile(f) end

background = background or "rgb(1a1a1a)"
foreground = foreground or "rgb(cccccc)"
for i = 0, 15 do
  _G["color" .. i] = _G["color" .. i] or "rgb(888888)"
end
