local RAW_URL = ""

local script, err = fetch(RAW_URL)

if not script then
    LogToConsole("Failed to download script.")
    return
end

local func, compileError = load(script)

if not func then
    LogToConsole("Compile Error:")
    LogToConsole(compileError)
    return
end

local success, runtimeError = pcall(func)

if not success then
    LogToConsole("Runtime Error:")
    LogToConsole(runtimeError)
end
