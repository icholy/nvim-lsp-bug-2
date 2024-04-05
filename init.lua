vim.o.shiftwidth = 0
vim.o.softtabstop = -1

vim.o.packpath = ".";

vim.cmd.packadd("nvim-lspconfig")
vim.cmd.packadd("nvim-dap")

local lspconfig = require("lspconfig")
local dap = require("dap")

lspconfig.pyright.setup({
  cmd = { "pyright-langserver", "--stdio" }
})

dap.adapters.python = {
  type = "executable",
  command = "python3",
  args = { "-m", "debugpy.adapter" },
  options = {
    source_filetype = "python",
  },
}

local function find_dap_repl_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "dap-repl" then
      return buf
    end
  end
end

function repro()
  dap.run({
    name = "Launch file",
    cwd = "${workspaceFolder}",
    program = "${file}",
    request = "launch",
    stopOnEntry = "true",
    type = "python",
  })
  dap.repl.open()
  local repl_buf = find_dap_repl_buf()
  vim.lsp.buf_attach_client(repl_buf, 1)
  print("Now type in dap-repl and press <CR>. Continue typing for more errors.")
end
