vim.pack.add({
    { src = 'https://github.com/wojciech-kulik/xcodebuild.nvim' }
    { src = 'https://github.com/mfussenenegger/nvim-dap' }
})

local xcodebuild = require("xcodebuild.integrations.dap")
local codelldb = os.getenv("XDG_DATA_HOME") .. "/codelldb/extension/adapter/codelldb"

xcodebuild.setup(codelldb)

vim.keymap.set("n", "<leader>xd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
vim.keymap.set("n", "<leader>xr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
vim.keymap.set("n", "<leader>xt", xcodebuild.debug_tests, { desc = "Debug Tests" })
vim.keymap.set("n", "<leader>xT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
vim.keymap.set("n", "<leader>xb", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>xB", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
vim.keymap.set("n", "<leader>xx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })

