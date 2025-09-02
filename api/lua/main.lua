-- api/lua/main.lua - Entry point for your CrewFuscator modules

-- Simple JSON parser (since json module might not be available)
local function parseJSON(str)
    -- Remove whitespace and parse basic JSON
    str = str:gsub("%s+", "")
    if str == "{}" then
        return {}
    end
    
    local result = {}
    -- Simple boolean parsing for our options
    for key, value in str:gmatch('"(%w+)":(%w+)') do
        if value == "true" then
            result[key] = true
        elseif value == "false" then
            result[key] = false
        end
    end
    return result
end

-- Import your obfuscation modules (using your exact file names)
local VariableRenamer = require('modules.Variable_renemer') -- Note: your file has "renemer" not "renamer"
local StringEncoder = require('modules.String_Encoder')
local AntiTamper = require('modules.Anti_tamper')
local ControlFlow = require('modules.Control_flow')
local Compiler = require('modules.Compiler')
local Compressor = require('modules.Compressor')
local GarbageInserter = require('modules.Garbage_inserter')
local DynamicCodeGen = require('modules.Dynamic_code_generator')
local FunctionInliner = require('modules.Function_inliner')
local ByteCodeEncoder = require('modules.ByteCode_Encoder')
local WaterMark = require('modules.Water_Mark')

-- Get command line arguments
local inputFile = arg[1]
local outputFile = arg[2] 
local optionsJson = arg[3] or "{}"

-- Parse options
local options = parseJSON(optionsJson)

-- Read input file
local function readFile(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Cannot open input file: " .. filename)
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- Write output file
local function writeFile(filename, content)
    local file = io.open(filename, "w")
    if not file then
        error("Cannot create output file: " .. filename)
    end
    file:write(content)
    file:close()
end

-- Main obfuscation function
local function obfuscate(code, opts)
    local result = code
    
    -- Add CrewFuscator header
    local header = [[-- Obfuscated by CrewFuscator
-- https://github.com/FREAKS1Z/CrewFuscator
-- Generated: ]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[

]]
    
    print("Starting obfuscation with options:", optionsJson)
    
    -- Apply obfuscation modules based on options
    if opts.variableRename ~= false then
        print("Applying variable renaming...")
        -- Make sure your module has a process function, adjust if needed
        result = VariableRenamer.obfuscate and VariableRenamer.obfuscate(result) or VariableRenamer.process and VariableRenamer.process(result) or result
    end
    
    if opts.stringEncode ~= false then
        print("Applying string encoding...")
        result = StringEncoder.obfuscate and StringEncoder.obfuscate(result) or StringEncoder.process and StringEncoder.process(result) or result
    end
    
    if opts.controlFlow ~= false then
        print("Applying control flow obfuscation...")
        result = ControlFlow.obfuscate and ControlFlow.obfuscate(result) or ControlFlow.process and ControlFlow.process(result) or result
    end
    
    if opts.garbageCode ~= false then
        print("Inserting garbage code...")
        result = GarbageInserter.obfuscate and GarbageInserter.obfuscate(result) or GarbageInserter.process and GarbageInserter.process(result) or result
    end
    
    if opts.antiTamper ~= false then
        print("Adding anti-tamper protection...")
        result = AntiTamper.obfuscate and AntiTamper.obfuscate(result) or AntiTamper.process and AntiTamper.process(result) or result
    end
    
    if opts.compression ~= false then
        print("Applying compression...")
        result = Compressor.obfuscate and Compressor.obfuscate(result) or Compressor.process and Compressor.process(result) or result
    end
    
    -- Compile/finalize
    result = Compiler.obfuscate and Compiler.obfuscate(result) or Compiler.process and Compiler.process(result) or result
    
    -- Add header
    result = header .. result
    
    print("Obfuscation completed successfully")
    return result
end

-- Main execution
local function main()
    if not inputFile or not outputFile then
        error("Usage: lua main.lua <input_file> <output_file> [options_json]")
    end
    
    local inputCode = readFile(inputFile)
    
    if not inputCode or inputCode == "" then
        error("Input file is empty or could not be read")
    end
    
    print("Input file size:", #inputCode, "bytes")
    
    local obfuscatedCode = obfuscate(inputCode, options)
    writeFile(outputFile, obfuscatedCode)
    
    print("Output file size:", #obfuscatedCode, "bytes")
    print("Success: Obfuscated code written to", outputFile)
end

-- Error handling
local success, err = pcall(main)
if not success then
    print("Error:", err)
    os.exit(1)
end

print("Process completed successfully")
