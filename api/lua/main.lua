-- api/lua/main.lua - Entry point for your CrewFuscator modules

local json = require('json') -- You might need to install lua-json or use alternative

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

-- Parse options (simple JSON parser alternative if json module not available)
local options = {}
if optionsJson then
    local success, parsed = pcall(function()
        return loadstring("return " .. optionsJson)()
    end)
    if success then
        options = parsed
    end
end

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
        result = VariableRenamer.process(result)
    end
    
    if opts.stringEncode ~= false then
        print("Applying string encoding...")
        result = StringEncoder.process(result)
    end
    
    if opts.controlFlow ~= false then
        print("Applying control flow obfuscation...")
        result = ControlFlow.process(result)
    end
    
    if opts.garbageCode ~= false then
        print("Inserting garbage code...")
        result = GarbageInserter.process(result)
    end
    
    if opts.antiTamper ~= false then
        print("Adding anti-tamper protection...")
        result = AntiTamper.process(result)
    end
    
    if opts.compression ~= false then
        print("Applying compression...")
        result = Compressor.process(result)
    end
    
    -- Compile/finalize
    result = Compiler.process(result)
    
    -- Add header
    result = header .. result
    
    print("Obfuscation completed successfully")
    return result
end

-- Main execution
local function main()
