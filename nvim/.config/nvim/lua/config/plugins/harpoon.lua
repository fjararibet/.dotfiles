local harpoon = require("harpoon")

harpoon:setup({})
-- basic telescope configuration

vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[H]arpoon [L]ist" })
vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "[H]arpoon [A]ppend" })

vim.keymap.set("n", "<M-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-l>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
