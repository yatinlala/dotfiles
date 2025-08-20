vim.pack.add({"https://github.com/stevearc/conform.nvim"})
	
require('conform').setup{
        notify_on_error = false,
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            go = { "gofmt" },
            html = { "prettierd" },
            css = { "prettierd" },
            javascript = { "prettierd", "prettierd", stop_after_first = true },
            json = { "jq" },
            -- jsonl = { 'jq' },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        format_on_save = function(bufnr)
            if vim.g.format_on_save or vim.b[bufnr].format_on_save then
                return {
                    timeout_ms = 500,
                    -- Filetypes to use LSP formatting for.
                    -- lsp_fallback = vim.tbl_contains({ "c", "json", "jsonc", "rust" }, vim.bo[bufnr].filetype),
                }
            end
        end,
        -- Customize formatters
        formatters = { shfmt = { prepend_args = { "-i", "2" } } },
}

        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_augroup("conform.nvim", { clear = true })
        -- Configure format on save inside my dotfiles and personal projects.
        vim.api.nvim_create_autocmd("BufEnter", {
            desc = "Configure format on save",
            group = "conform.nvim",
            callback = function(args)
                local path = vim.api.nvim_buf_get_name(args.buf)
                path = vim.fs.normalize(path)
                vim.b[args.buf].format_on_save = vim.iter({ vim.env.HOME .. "/.dotfiles", vim.env.XDG_CONFIG_HOME }):any(function(
                    folder)
                    return vim.startswith(path, vim.fs.normalize(folder))
                end)
            end,
        })
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.format_on_save = false
            else
                vim.g.format_on_save = false
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.format_on_save = true
            vim.g.format_on_save = true
        end, {
            desc = "Re-enable autoformat-on-save",
        })



vim.keymap.set("n", "gQ",            function() require("conform").format({ async = true }) end, { desc = "Conform format buffer" })
vim.keymap.set("n", "<leader>S",
	function()  vim.b[vim.api.nvim_get_current_buf()].format_on_save = not vim.b[vim.api.nvim_get_current_buf()].format_on_save
         end,
	 {
             desc = "Toggle conform format on save",
        })
