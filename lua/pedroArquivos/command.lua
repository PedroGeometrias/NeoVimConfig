--Run Commands:

--    Commands for running the compiled output of different file types.
--    The sp command is used to open a new split, and term is used to run the specified command in a terminal window.
--    The window is resized to 20 lines and set in insert mode.

--Custom Commands:

--   Build: Executes the appropriate build command based on the file type.
--   DebugBuild: Executes the appropriate debug build command based on the file type.
--    Run: Opens a split and runs the appropriate run command in a terminal.
--    Ha: A combined command that runs both Build and Run.
--    Config: Changes the working directory to ~/.config/nvim.
--    UpdateAll: Updates plugins (TSUpdateSync and MasonUpdate).

--Word Count:
--  Defines a function (getWords) to get the word count of the current buffer.
--    Creates a command (WordCount) to toggle the display of word count in the status line using Lualine.
--
--
-- Custom Commands
local remaps = require('pedroArquivos.remaps')
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

local function create_commands()
  -- Check if the command already exists before defining
  if not vim.api.nvim_get_commands()["Build"] then
    vim.api.nvim_create_user_command("Build", buildImplementation, {})
  end

  if not vim.api.nvim_get_commands()["DebugBuild"] then
    vim.api.nvim_create_user_command("DebugBuild", debugBuildImplementation, {})
  end

  if not vim.api.nvim_get_commands()["Run"] then
    vim.api.nvim_create_user_command("Run", runImplementation, {})
  end
end

-- Delayed command creation after VimEnter event
vim.api.nvim_exec([[
  augroup CustomCommands
    autocmd!
    autocmd VimEnter * lua require('pedroArquivos.remaps').create_commands()
  augroup END
]], false)

-- Config Command
vim.api.nvim_create_user_command("Config", function()
  vim.cmd([[cd ~/.config/nvim]])
end, {})

-- UpdateAll Command
vim.api.nvim_create_user_command("UpdateAll", function()
  vim.cmd([[TSUpdateSync]])
  vim.cmd([[MasonUpdate]])
end, {})

-- Word Count
local wordCountOn = false

local function getWords()
  if vim.fn.getfsize(vim.fn.expand("%")) > 200000 then
    return ""
  end

  local words = vim.fn.wordcount().visual_words or vim.fn.wordcount().words
  return words == 1 and "1 word" or tostring(words) .. " words"
end

vim.api.nvim_create_user_command("WordCount", function()
  if wordCountOn then
    require("lualine").setup({
      sections = {
        lualine_c = { "filename" },
      },
    })
    wordCountOn = false
  else
    require("lualine").setup({
      sections = {
        lualine_c = { "filename", { getWords } },
      },
    })
    wordCountOn = true
  end
end, {})

-- Export the create_commands function
return {
  create_commands = create_commands,
}
