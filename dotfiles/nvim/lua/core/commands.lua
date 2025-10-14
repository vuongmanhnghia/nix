local command = vim.api.nvim_create_user_command

command("RemoveTrailingSpaces", function()
  vim.cmd(":%s/s+$//e")
end, { desc = "Remove all trailing spaces" })

command("JoinEmptyLines", function(args)
  -- We need silent! because if no match pattern, it will notify error
  if args.fargs[1] ~= nil then
    vim.cmd("silent! g/^$/,/./-" .. args.fargs[1] .. "j") -- Max "n" empty line(s)
  elseif args.bang then
    vim.cmd("silent! g/^$/-j") -- No empty line
  else
    vim.cmd("silent! g/^$/,/./-1j") -- Join max 1 empty line
  end
  vim.cmd([[%s/\_s*\%$//e]]) -- remove the last empty lines
  vim.cmd("nohlsearch")
end, { desc = "Join empty lines", bang = true, nargs = "?" })

-- Clear registers command
-- Note: Number registers (0-9) are read-only and managed by Vim automatically
-- They cannot be cleared manually, only overwritten by yank/delete operations
command("ClearRegister", function(args)
  if #args.fargs == 0 then
    -- Build list of clearable registers
    local registers = { '"', "-", "/", "*", "+", "=", "_" }
    
    -- Add named registers a-z
    for i = 97, 122 do
      table.insert(registers, string.char(i))
    end
    
    -- Clear each register
    for _, reg in ipairs(registers) do
      vim.fn.setreg(reg, "")
    end

    vim.notify("All clearable registers have been cleared (note: number registers 0-9 are read-only)", vim.log.levels.INFO)
    vim.notify("All clearable registers have been cleared (note: number registers 0-9 are read-only)", vim.log.levels.INFO)
    return
  end
  
  -- Clear specific registers
  for _, reg in ipairs(args.fargs) do
    local content = vim.fn.getreg(reg)
    if content ~= "" then
      vim.fn.setreg(reg, "")
      vim.notify("Cleared register: " .. reg, vim.log.levels.INFO)
    else
      vim.notify("Register '" .. reg .. "' is empty or read-only", vim.log.levels.WARN)
    end
  end
end, { desc = "Clear register data", nargs = "*" })
