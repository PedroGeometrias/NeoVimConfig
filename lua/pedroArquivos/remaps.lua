-- Neovim key mapping module
-- This Lua module provides functions for creating key mappings in Neovim for different modes.

-- Create a Lua module for managing key mappings in Neovim
local M = {}

-- Key Mapping Function Generator
local function bind(op, outer_opts)
  -- If outer options are not provided, set default options for non-recursive mapping
  outer_opts = outer_opts or { noremap = true }

  -- Return a function for creating key mappings
  return function(lhs, rhs, opts)
    -- Combine outer options with provided options using vim.tbl_extend
    opts = vim.tbl_extend("force", outer_opts, opts or {})

    -- Set the key mapping using Neovim's keymap API
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

-- Define key mapping functions for different modes

-- Normal mode mapping
M.nmap = bind("n", { noremap = false })

-- Normal mode non-recursive mapping
M.nnoremap = bind("n")

-- Visual mode non-recursive mapping
M.vnoremap = bind("v")

-- Visual mode non-recursive mapping (same as vnoremap)
M.xnoremap = bind("x")

-- Insert mode non-recursive mapping
M.inoremap = bind("i")

-- Terminal mode non-recursive mapping
M.tnoremap = bind("t")

function M.create_commands()
  local function executeCommand(command)
    local success, err = pcall(vim.cmd, command)
    if not success then
      print("Error executing command:", err)
    end
  end

  local function buildImplementation()
    local filetype = vim.bo.filetype
    local command = build_commands[filetype]
    if command then
      executeCommand(command)
    end
  end

  local function debugBuildImplementation()
    local filetype = vim.bo.filetype
    local command = debug_build_commands[filetype]
    if command then
      executeCommand(command)
    end
  end

  local function runImplementation()
    local filetype = vim.bo.filetype
    local command = run_commands[filetype]
    if command then
      vim.cmd("sp")
      vim.cmd("term " .. command)
      vim.cmd("resize 20N")
      local keys = vim.api.nvim_replace_termcodes("i", true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end
  end

  -- Check if the command already exists before defining
  local existing_commands = vim.api.nvim_get_commands({}).Build
  if not existing_commands or vim.tbl_isempty(existing_commands) then
    vim.api.nvim_create_user_command("Build", buildImplementation, {})
   end

  existing_commands = vim.api.nvim_get_commands({}).DebugBuild
  if not existing_commands or vim.tbl_isempty(existing_commands) then
    vim.api.nvim_create_user_command("DebugBuild", debugBuildImplementation, {})
  end

  existing_commands = vim.api.nvim_get_commands({}).Run
  if not existing_commands or vim.tbl_isempty(existing_commands) then
    vim.api.nvim_create_user_command("Run", runImplementation, {})
  end
end

return M



