return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    -- Configure fold options cleanly using vim.opt
    vim.opt.foldcolumn = '1' -- Shows fold indicators in the left sign column
    vim.opt.foldlevel = 99 -- High fold level ensures files open expanded by default
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true -- Turns on folding capabilities globally

    -- Initialize ufo to use Treesitter parsers for highly precise code folding
    require('ufo').setup {
      provider_selector = function(bufnr, filetype, buftype) return { 'treesitter', 'indent' } end,
    }
  end,
}
