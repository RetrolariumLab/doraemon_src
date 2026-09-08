-- Deterministic FCEUX trace for Doraemon reset, NMI, dispatch, and GNROM writes.

local output_path = assert(os.getenv("DORAEMON_RUNTIME_TRACE"))
local scenario = assert(os.getenv("DORAEMON_RUNTIME_SCENARIO"))
local max_frames = assert(tonumber(os.getenv("DORAEMON_RUNTIME_MAX_FRAMES")))
local encoded_inputs = os.getenv("DORAEMON_RUNTIME_INPUTS") or ""
local encoded_patches = os.getenv("DORAEMON_RUNTIME_MEMORY_PATCHES") or ""
local screenshot_path = os.getenv("DORAEMON_RUNTIME_SCREENSHOT")
local output = assert(io.open(output_path, "w"))

local MAPPER_SELECTION = 0x0017
local NMI_BUSY = 0x0015
local PPU_CTRL_SHADOW = 0x0019
local PPU_MASK_SHADOW = 0x001A
local CONTROLLER_1 = 0x001F
local MAPPER_TABLE = 0x8261
local WORLD2_SCROLL_ACTIVE = 0x0041
local WORLD2_SCREEN_POINTER = 0x0046
local WORLD2_SCREEN_ROW = 0x0056
local WORLD2_SCREEN_ID = 0x0058

local fingerprints = {
    ["07A91020"] = 0,
    ["A51A8D01"] = 1,
    ["41454D4F"] = 2,
    ["4C888A4C"] = 3,
}

local function byte(address)
    return memory.readbyte(address)
end

local function active_bank()
    local signature = string.format(
        "%02X%02X%02X%02X",
        byte(0x8280), byte(0x8281), byte(0x8282), byte(0x8283)
    )
    local bank = fingerprints[signature]
    assert(bank ~= nil, "unknown PRG bank fingerprint: " .. signature)
    return bank
end

local function emit(event, detail, selector, address, rom_value, pc)
    local selection = selector or byte(MAPPER_SELECTION)
    output:write(string.format(
        "%d,%s,%s,%d,%02X,%d,%d,%04X,%04X,%02X,%02X,%02X,%02X,%02X\n",
        emu.framecount(), event, detail or "", active_bank(), selection,
        bit.band(selection, 0x03), bit.band(bit.rshift(selection, 2), 0x03),
        address or 0, pc or 0, rom_value or 0, byte(NMI_BUSY),
        byte(PPU_CTRL_SHADOW), byte(PPU_MASK_SHADOW), byte(CONTROLLER_1)
    ))
    output:flush()
end

local input_ranges = {}
for first, last, buttons in string.gmatch(encoded_inputs, "(%d+)%-(%d+):([^;]+)") do
    table.insert(input_ranges, {
        first = tonumber(first),
        last = tonumber(last),
        buttons = buttons,
    })
end

local memory_patches = {}
for frame, address, value, name in string.gmatch(
    encoded_patches, "(%d+):(%x+):(%x+):([^;]+)"
) do
    table.insert(memory_patches, {
        frame = tonumber(frame),
        address = tonumber(address, 16),
        value = tonumber(value, 16),
        name = name,
    })
end

local function input_for_frame(frame)
    local result = {}
    for _, range in ipairs(input_ranges) do
        if frame >= range.first and frame <= range.last then
            for button in string.gmatch(range.buttons, "[^+]+") do
                result[button] = true
            end
        end
    end
    return result
end

output:write(
    "frame,event,detail,bank,selector,target_prg,target_chr,address," ..
    "pc,rom_value,nmi_busy,ppu_ctrl,ppu_mask,controller1\n"
)
emit("trace_start", scenario)

memory.registerexecute(0x8098, function()
    emit("reset", "Reset", nil, nil, nil, 0x8098)
end)

memory.registerexecute(0x813C, function()
    emit("nmi", "Nmi", nil, nil, nil, 0x813C)
end)

memory.registerexecute(0x81BB, function()
    local selector = byte(MAPPER_SELECTION)
    local address = MAPPER_TABLE + selector
    emit("mapper_write", "WriteMapper", selector, address, byte(address), 0x81BB)
end)

memory.registerexecute(0x81C4, function()
    emit("mapper_commit", "post-STA", nil, nil, nil, 0x81C4)
end)

for _, address in ipairs({0x8271, 0x8274, 0x8277, 0x827A, 0x827D, 0x8280, 0x8283, 0x8286}) do
    memory.registerexecute(address, function()
        emit("dispatch", string.format("%04X", address), nil, nil, nil, address)
    end)
end

local probes = {
    [0x828E] = {name = "world1_main_entry", bank = 0},
    [0x82C1] = {name = "world1_city_frame_loop", bank = 0},
    [0xCE55] = {name = "world1_underground_frame_loop", bank = 0},
    [0x82F6] = {name = "world3_main_entry", bank = 2},
    [0x838E] = {name = "world3_frame_loop", bank = 2},
    [0xAB3B] = {name = "world3_revision_step_x", bank = 2},
    [0xAB47] = {name = "world3_revision_step_y", bank = 2},
    [0xAB53] = {name = "world3_revision_encounter_step", bank = 2},
    [0xAF40] = {name = "world3_revision_room3f_marker", bank = 2},
    [0xAF51] = {name = "world3_revision_diagnostic", bank = 2},
    [0x8A88] = {name = "ending_entry", bank = 3},
    [0x8B18] = {name = "ending_credits_loop", bank = 3},
    [0x88A4] = {name = "world2_main_entry", bank = 1},
    [0x8959] = {name = "world2_frame_loop", bank = 1},
    [0x8A32] = {name = "world2_completion_exit", bank = 1},
    [0x8C43] = {name = "world2_to_world3_transition", bank = 3},
    [0xAE12] = {name = "world3_completion_sequence", bank = 2},
    [0xCC7F] = {name = "world1_portal_check", bank = 0},
    [0xCC8C] = {name = "world1_portal_entered", bank = 0},
    [0xCD42] = {name = "world1_portal_destination", bank = 0},
    [0xD237] = {name = "world1_manhole_check", bank = 0},
    [0xD244] = {name = "world1_manhole_entered", bank = 0},
    [0xCDB5] = {name = "world1_sideview_init", bank = 0},
}
for address, probe in pairs(probes) do
    memory.registerexecute(address, function()
        if active_bank() == probe.bank then
            emit("probe", probe.name, nil, nil, nil, address)
        end
    end)
end

memory.registerexecute(0x83CE, function()
    if active_bank() ~= 1 or byte(WORLD2_SCREEN_ID) ~= 0x7F then
        return
    end
    local pointer = byte(WORLD2_SCREEN_POINTER) +
        0x100 * byte(WORLD2_SCREEN_POINTER + 1)
    emit(
        "world2_terminal_select",
        string.format(
            "id=7F;ptr=%04X;scroll=%02X",
            pointer, byte(WORLD2_SCROLL_ACTIVE)
        )
    )
end)

memory.registerexecute(0x8444, function()
    if active_bank() ~= 1 or byte(WORLD2_SCREEN_ID) ~= 0x7F then
        return
    end
    local pointer = byte(WORLD2_SCREEN_POINTER) +
        0x100 * byte(WORLD2_SCREEN_POINTER + 1)
    local offset = memory.getregister("y")
    local token_address = bit.band(pointer + offset, 0xFFFF)
    local token = byte(token_address)
    local operand = "--"
    if token >= 0xF1 then
        operand = string.format("%02X", byte(bit.band(token_address + 1, 0xFFFF)))
    end
    emit(
        "world2_terminal_token_read",
        string.format(
            "id=7F;ptr=%04X;row=%02X;off=%02X;token=%02X;operand=%s",
            pointer, byte(WORLD2_SCREEN_ROW), offset, token, operand
        )
    )
end)

while emu.framecount() < max_frames do
    for _, patch in ipairs(memory_patches) do
        if emu.framecount() == patch.frame then
            memory.writebyte(patch.address, patch.value)
            emit("memory_patch", patch.name, nil, patch.address, patch.value)
        end
    end
    joypad.set(1, input_for_frame(emu.framecount()))
    emu.frameadvance()
    if emu.framecount() % 60 == 0 then
        emit("heartbeat", "frame")
    end
end

emit("trace_end", scenario)
if screenshot_path ~= nil and screenshot_path ~= "" then
    gui.savescreenshotas(screenshot_path)
end
output:close()
emu.exit()
