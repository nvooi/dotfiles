vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' }
})

require('telescope').setup({
      ensure_installed = { "swift" }
})

vim.keymap.set("n", "<leader>ff",
    "<cmd>lua require('telescope.builtin').find_files()<CR>", { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fw",
    "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })<CR>",
    { desc = "Telescope find words" })

