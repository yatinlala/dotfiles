local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[Nvim_Lua]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer", max_item_count = 10 },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
      documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      }
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}


--local cmp = require "cmp"
--
--local lspkind = require('lspkind')
--lspkind.init()
--
--cmp.setup {
  --mapping = {
    --["<C-d>"] = cmp.mapping.scroll_docs(-4),
    --["<C-f>"] = cmp.mapping.scroll_docs(4),
    --["<C-e>"] = cmp.mapping.close(),
    --["<c-y>"] = cmp.mapping(
      --cmp.mapping.confirm {
        --behavior = cmp.ConfirmBehavior.Insert,
        --select = true,
      --},
      --{ "i", "c" }
    --),
--
    --["<c-space>"] = cmp.mapping {
      --i = cmp.mapping.complete(),
      --c = function(
        --_ --[[fallback]]
      --)
        --if cmp.visible() then
          --if not cmp.confirm { select = true } then
            --return
          --end
        --else
          --cmp.complete()
        --end
      --end,
    --},
--
--
    ---- Testing
    --["<c-q>"] = cmp.mapping.confirm {
      --behavior = cmp.ConfirmBehavior.Replace,
      --select = true,
    --},
--
  --},
--
  ---- Youtube:
  ----    the order of your sources matter (by default). That gives them priority
  ----    you can configure:
  ----        keyword_length
  ----        priority
  ----        max_item_count
  ----        (more?)
  --sources = {
    ---- { name = "gh_issues" },
    ---- { name = "tn" },
--
    ---- Youtube: Could enable this only for lua, but nvim_lua handles that already.
    --{ name = "nvim_lua" },
--
    --{ name = "nvim_lsp" },
    --{ name = "path" },
    ---- { name = "luasnip" },
    --{ name = "buffer", keyword_length = 5 },
  --},
--
  --sorting = {
    ---- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
    --comparators = {
      --cmp.config.compare.offset,
      --cmp.config.compare.exact,
      --cmp.config.compare.score,
--
      ---- copied from cmp-under, but I don't think I need the plugin for this.
      ---- I might add some more of my own.
      --function(entry1, entry2)
        --local _, entry1_under = entry1.completion_item.label:find "^_+"
        --local _, entry2_under = entry2.completion_item.label:find "^_+"
        --entry1_under = entry1_under or 0
        --entry2_under = entry2_under or 0
        --if entry1_under > entry2_under then
          --return false
        --elseif entry1_under < entry2_under then
          --return true
        --end
      --end,
--
      --cmp.config.compare.kind,
      --cmp.config.compare.sort_text,
      --cmp.config.compare.length,
      --cmp.config.compare.order,
    --},
  --},
--
--
  --formatting = {
    ---- Youtube: How to set up nice formatting for your sources.
    --format = lspkind.cmp_format {
      --with_text = true,
      --menu = {
        --buffer = "[buf]",
        --nvim_lsp = "[LSP]",
        --nvim_lua = "[api]",
        --path = "[path]",
        ---- luasnip = "[snip]",
        ---- gh_issues = "[issues]",
        ---- tn = "[TabNine]",
      --},
    --},
  --},
--
  --experimental = {
    ---- I like the new menu better! Nice work hrsh7th
    --native_menu = false,
--
    ---- Let's play with this for a day or two
    --ghost_text = false,
  --},
--}
--
--cmp.setup.cmdline("/", {
  --completion = {
    ---- Might allow this later, but I don't like it right now really.
    ---- Although, perhaps if it just triggers w/ @ then we could.
    ----
    ---- I will have to come back to this.
    --autocomplete = false,
  --},
  --sources = cmp.config.sources({
    --{ name = "nvim_lsp_document_symbol" },
  --}, {
    ---- { name = "buffer", keyword_length = 5 },
  --}),
--})
--
--cmp.setup.cmdline(":", {
  --completion = {
    --autocomplete = false,
  --},
--
  --sources = cmp.config.sources({
    --{
      --name = "path",
    --},
  --}, {
    --{
      --name = "cmdline",
      --max_item_count = 20,
      --keyword_length = 4,
    --},
  --}),
--})
--
--
--
--
----[[
--" Disable cmp for a buffer
--autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
----]]
