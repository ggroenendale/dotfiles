vim.g.mapleader = " " -- I dont know what this does

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/Decrement numbers (I dont really care about this but it makes sense for testing, you have to exit insert
-- mode by escaping or using the jk shortcut above to then be able to use <space>+, <space>- to change the numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) -- go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) -- open new tab current buffer

-- keymap.set("n", { desc = ""})

-- Jump to definition
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })

-- Jump to type definition
keymap.set("n", "gD", vim.lsp.buf.type_definition, { desc = "[G]oto [D]efinition (Type)" })

-- Jump to implementation
keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
