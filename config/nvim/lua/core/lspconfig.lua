local lsps = { 
}

for _, lsp in ipairs(lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)
    if config then
        vim.lsp.config(name, config)
    end
end

vim.keymap.set("n", "gD", "<CMD>Telescope lsp_definitions trim_text=true<CR>",
{ desc = "Show LSP definitions" })
vim.keymap.set("n", "gd", "<CMD>vsplit | Telescope lsp_definitions trim_text=true<CR>",
{ desc = "Show LSP definitions in vsplit" })
vim.keymap.set("n", "gr", "<CMD>Telescope lsp_references trim_text=true<CR>",
{ desc = "Show LSP references" })
vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>",
{ desc = "Show LSP implementations" })
vim.keymap.set("n", "rn", vim.lsp.buf.rename,
{ desc = "Smart rename" })
vim.keymap.set("n", "G", vim.lsp.buf.hover,
{ desc = "Go to documentation in vsplit" })

