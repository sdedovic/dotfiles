local function cd ()
  vim.api.nvim_command("lcd " .. vim.fn.expand("%:h"))
end

return {
  cd = cd
}
