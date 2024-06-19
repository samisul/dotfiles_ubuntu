vim.keymap.set('n', '<space>ed', vim.diagnostic.open_float, { desc = 'show floating diagnostics window' })
vim.keymap.set('n', '<space>ep', vim.diagnostic.goto_prev, { desc = 'previous diagnostic' })
vim.keymap.set('n', '<space>en', vim.diagnostic.goto_next, { desc = 'next diagnostic' })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'set diagnostics window location' })
