vim.g.mapleader = " "

map = vim.keymap.set

vim.textwidth = 100

----------------------------------------------------------------------------------------------------
-- Main binds
--
map("n", "<Space>", "<NOP>")

map("i", "jj", "<Esc>")
map("i", "تت", "<Esc><C-A-l>")
map("n", "<A-i>", "<C-M-l>")

map({ "n", "v" }, "aa", "^")
map({ "n", "v" }, ";;", "$")

map({ "n", "v" }, "<S-l>", "5l") -- Move 5 characters to the right
map({ "n", "v" }, "<S-h>", "5h") -- Move 5 characters to the left

map({ "n", "v" }, "<S-j>", "<C-d>") -- Scroll down
map({ "n", "v" }, "<S-k>", "<C-u>") -- Scroll up

map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

map("n", "<leader>bb", ":bufdo bdelete!<CR>")

map("n", "<leader>s", ":w<CR>")

map("n", "<leader>cc", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local is_modified = vim.bo[current_buf].modified
  if is_modified then
    vim.cmd("write")
  end
  vim.cmd("bdelete")
end, { desc = "Save if modified and close buffer" })

-- Bulk-close buffers
map("n", "<leader>io", function()
  -- Get all buffer numbers
  local bufs = vim.api.nvim_list_bufs()
  -- Get the current buffer number
  local current_buf = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(bufs) do
    -- Check if the buffer is loaded, listed, and not the current one
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted and bufnr ~= current_buf then
      vim.cmd("bdelete " .. bufnr)
    end
  end
  vim.notify("Closed all other buffers", vim.log.levels.INFO, { title = "Buffers" })
end, { desc = "Close all buffers but the current one" })

-- Navigate to the previous buffer
map("n", "<M-s>", ":bprevious<CR>", { desc = "Go to previous buffer" })
map("n", "<M-right-s>", ":bprevious<CR>", { desc = "Go to previous buffer" })

-- Navigate to the next buffer
map("n", "<M-g>", ":bnext<CR>", { desc = "Go to next buffer" })
map("n", "<M-right-g>", ":bnext<CR>", { desc = "Go to next buffer" })

----------------------------------------------------------------------------------------------------
-- Window management

map("n", "<leader>;", "<C-w>v", { desc = "Split window vertically in right" }) -- Split window in right
map("n", "<leader>a", "<C-w>v<C-w>h", { desc = "Split window vertically in left" }) -- Split window in left
map("n", "<leader>n", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>e", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>c", "<cmd>close<CR>", { desc = "Close current split" })

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

----------------------------------------------------------------------------------------------------

vim.g.VM_maps = {
  -- ["Add Cursor Up"] = "<A-d>",
  -- ["Add Cursor Down"] = "<A-f>",
  ["Skip Region"] = "s",
  ["Remove Region"] = "r",
  ["Exit"] = "<leader>q",
}

----------------------------------------------------------------------------------------------------
-- Compile
--

_G.matlab_terminal_job_id = nil

map("n", "<leader>r", function()
  -- Get the absolute path of the current file
  local file = vim.fn.expand("%:p")
  -- Get the file extension
  local ext = vim.fn.expand("%:e")
  -- Output file name (for C/C++/etc.)
  local output = vim.fn.expand("%:p:r")

  -- We'll handle most languages the same as before, but do something *special*
  -- for MATLAB so it doesn't exit each time.
  local cmd

  if ext == "cpp" then
    cmd = string.format('g++ -std=c++17 -O2 "%s" -o "%s" && "%s"', file, output, output)
    -- Always open a new terminal
    vim.cmd("vsplit")
    vim.cmd("term " .. cmd)
  elseif ext == "py" then
    cmd = "python " .. file
    vim.cmd("vsplit")
    vim.cmd("term " .. cmd)
  elseif ext == "c" then
    cmd = string.format('gcc "%s" -o "%s" && "%s"', file, output, output)
    vim.cmd("vsplit")
    vim.cmd("term " .. cmd)
  elseif ext == "go" then
    cmd = "go run " .. file
    vim.cmd("vsplit")
    vim.cmd("term " .. cmd)
  else
    -- Fallback for unsupported file types
    vim.notify("Unsupported file type: " .. ext, vim.log.levels.ERROR)
    return
  end
end)

map("n", "make", function()
  -- Save the current file
  vim.cmd("w")

  -- Get the base name of the current file without extension (e.g., 'main' from 'main.cpp')
  local filename = vim.fn.expand("%:t:r")

  -- Command to change to build directory, run make, and execute the program
  local cmd = "cd build && make && ./" .. filename

  -- Open a vertical split and run the command in a terminal
  vim.cmd("vsplit")
  vim.cmd("term " .. cmd)
  -- vim.cmd("startinsert")
end, { noremap = true })
--
--
