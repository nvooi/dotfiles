vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/kdheepak/lazygit.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' }
})

require('telescope').setup()
require('telescope').load_extension('lazygit')

vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Lazygit" })

