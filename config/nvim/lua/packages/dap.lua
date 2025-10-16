vim.pack.add({
    { src = 'https://github.com/nvooi/xcodebuild.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-dap' }
})

local function setupListeners()
    local dap = require("dap")
    local areSet = false

    dap.listeners.after["event_initialized"]["me"] = function()
        if not areSet then
            areSet = true
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue", noremap = true })
            vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run To Cursor" })
            vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
            vim.keymap.set({ "n", "v" }, "<Leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" })
            vim.keymap.set({ "n", "v" }, "<Leader>de", require("dapui").eval, { desc = "Eval" })
        end
    end

    dap.listeners.after["event_terminated"]["me"] = function()
        if areSet then
            areSet = false
            vim.keymap.del("n", "<leader>dc")
            vim.keymap.del("n", "<leader>dC")
            vim.keymap.del("n", "<leader>ds")
            vim.keymap.del("n", "<leader>di")
            vim.keymap.del("n", "<leader>do")
            vim.keymap.del({ "n", "v" }, "<Leader>dh")
            vim.keymap.del({ "n", "v" }, "<Leader>de")
        end
    end
end

--when breakpoint is hit, it sets the focus to the buffer with the breakpoint
require("dap").defaults.fallback.switchbuf = "usetab,uselast"

setupListeners()

local xcodebuild = require("xcodebuild.integrations.dap")

local codelldb = os.getenv("XDG_DATA_HOME") .. "/codelldb/extension/adapter/codelldb"
xcodebuild.setup(codelldb)


vim.keymap.set("n", "<leader>xd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
vim.keymap.set("n", "<leader>xr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
vim.keymap.set("n", "<leader>xt", xcodebuild.debug_tests, { desc = "Debug Tests" })
vim.keymap.set("n", "<leader>xT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
vim.keymap.set("n", "<leader>xb", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>xB", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
vim.keymap.set("n", "<leader>xx", function () 
    xcodebuild.terminate_session()
    require("dap").listeners.after["event_terminated"]["me"]()
end, { desc = "Terminate Debugger" })

