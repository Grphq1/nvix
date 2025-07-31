local M = {}

M.setup = function()
  vim.lsp.start {
    name = "eslint",
    cmd = { "vscode-eslint-language-server", "--stdio" },
    on_attach = function(client, bufnr)
      if client.name == "eslint" then
        vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
          if client.is_stopped() then
            vim.notify("LSP client is not active", vim.log.levels.WARN)
            return
          end
          local version = vim.lsp.util.buf_versions[bufnr] or 0
          vim.lsp.buf.execute_command({
            command = 'eslint.applyAllFixes',
            arguments = {
              {
                uri = vim.uri_from_bufnr(bufnr),
                version = version,
              },
            },
          })
        end, {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.cmd('LspEslintFixAll')
          end,
        })
      end
    end,
    -- handlers = {
    --   ["eslint/confirmESLintExecution"] = function(...) end,
    --   ["eslint/noLibrary"] = function(...) end,
    --   ["eslint/openDoc"] = function(...) end,
    --   ["eslint/probeFailed"] = function(...) end,
    -- },
    -- root_dir = vim.fs.dirname(vim.fs.find(
    --   { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml" },
    --   { upward = true }
    -- )[1]) or vim.loop.cwd(),
    settings = {
      codeAction = {
        disableRuleComment = { enable = true, location = "separateLine" },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = { enable = true, mode = "all" },
      experimental = { useFlatConfig = false },
      format = true,
      nodePath = "",
      onIgnoredFiles = "off",
      problems = { shortenToSingleLine = false },
      quiet = false,
      rulesCustomizations = {},
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = { mode = "location" },
    },
  }
end

return M
