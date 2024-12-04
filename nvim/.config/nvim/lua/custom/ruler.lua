M = {}

local sev = vim.diagnostic.severity

local icons = {
    ballot_x = '✘',
    up_tri = '▲',
    info_i = '¡',
    --  ballot_x = ' ',
    --  up_tri = '',
    --  info_i = '󰋼',
}

local lsp_signs = {
    [sev.ERROR] = { name = 'Error', sym = icons['ballot_x'] },
    [sev.WARN] = { name = 'Warn', sym = icons['up_tri'] },
    [sev.INFO] = { name = 'Info', sym = icons['info_i'] },
    [sev.HINT] = { name = 'Hint', sym = icons['info_i'] },
}

local diagnostics_available = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg.supports_method(diagnostics) then
            return true
        end
    end

    return false
end

M.render = function()
    local out = [[ %l,%c %p%% ]]
    if diagnostics_available() then
        local warn = vim.diagnostic.count(0, { severity = vim.diagnostic.severity.WARN })
        local err = vim.diagnostic.count(0, { severity = vim.diagnostic.severity.ERROR })
        -- out = warn .. err .. out
    end
    return out
end

vim.o.rulerformat = "%!v:lua.require('custom.ruler').render()"

return M
