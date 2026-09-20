vim.api.nvim_create_user_command('BufCurOnly', function()
  vim.cmd '%bd|edit#|bd#'
end, {})
vim.api.nvim_create_user_command('BufDelAll', function()
  vim.cmd '%bd'
end, {})
