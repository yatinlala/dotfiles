local config_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/config", "*.lua", false, true)

for _, file in ipairs(config_files) do
    local mod = file:match("lua/(.*)%.lua$")
    if mod ~= "config/init" then
        require(mod)
    end
end
