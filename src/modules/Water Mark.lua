-- modules/watermark.lua
local Watermark = {}

function Watermark.process(code)
    return "--[Obfuscated by CrewFuscator v1.6.2 ]\n" .. code
end

return Watermark
