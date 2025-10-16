vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim' }
})

require('oil').setup({
    columns = {
        'icon',
        'size',
        'mtime'
    },
    view_options = {
        show_hidden = true
    },
    watch_for_changes = true
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil file explorer" })

