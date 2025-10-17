vim.pack.add({
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
})

local cmp_nvim_lsp = require("cmp_nvim_lsp")

local lsps = { 
    { 
        "sourcekit", {
            cmd = { 'xcrun', 'sourcekit-lsp' },
            capabilities = cmp_nvim_lsp.default_capabilities(),
            on_init = function(client)
                -- HACK: to fix some issues with LSP
                -- more details: https://github.com/neovim/neovim/issues/19237#issuecomment-2237037154
                client.offset_encoding = "utf-8"
            end,
        }
    }
}

for _, lsp in ipairs(lsps) do
    local name, config = lsp[1], lsp[2]
    if config then
        vim.lsp.config(name, config)
    end
    vim.lsp.enable(name)
end

