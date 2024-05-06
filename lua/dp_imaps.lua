local M = {}

local sta, B = pcall(require, 'dp_base')

if not sta then return print('Dp_base is required!', debug.getinfo(1)['source']) end

-- if B.check_plugins {
--       'git@github.com:peter-lyr/dp_init',
--     } then
--   return
-- end

B.lazy_map {
  { '<F3>',      function() return vim.fn.strftime '%H%M%S-' end,            mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: time', },
  { '<F2>',      function() return vim.fn.strftime '%y%m%d-' end,            mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: date', },
  { '<F1>',      function() return vim.fn.strftime '%Y%m%d-%Hh%Mm-' end,     mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: datetime', },
  { '<F3>',      function() return vim.fn.strftime '%H%M%S' end,             mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: time', },
  { '<F2>',      function() return vim.fn.strftime '%y%m%d' end,             mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: date', },
  { '<F1>',      function() return vim.fn.strftime '%y%m%d-%Hh%Mm' end,      mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: datetime', },
  { '<F12>',     function() return vim.fn.strftime '# %y%m%d-%Hh%Mm' end,    mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: # datetime', },
  { '<c-F12>',   function() return vim.fn.strftime '## %y%m%d-%Hh%Mm' end,   mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: ## datetime', },
  { '<s-F12>',   function() return vim.fn.strftime '### %y%m%d-%Hh%Mm' end,  mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: ### datetime', },
  { '<c-s-F12>', function() return vim.fn.strftime '#### %y%m%d-%Hh%Mm' end, mode = { 'i', }, expr = true, silent = false, desc = 'my.imaps: #### datetime', },
}

B.lazy_map {
  { '<c-/>px', function() return 'sort' end, mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: 排序', },
  { '<c-/>qc', function() return [[g/^\(.*\)$\n\1$/d]] end, mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: 去重', },
  { '<c-/>pq', function() return [[sort|g/^\(.*\)$\n\1$/d]] end, mode = { 'c', }, expr = true, silent = false, desc = 'my.imaps: 排序去重', },
}

vim.fn.setreg('e', 'reg e empty')
vim.fn.setreg('3', 'reg 3 empty')

vim.g.single_quote = ''  -- ''
vim.g.double_quote = ''  -- ""
vim.g.back_quote = ''    -- ``
vim.g.parentheses = ''   -- ()
vim.g.bracket = ''       -- []
vim.g.brace = ''         -- {}
vim.g.angle_bracket = '' -- <>
vim.g.curline = ''

B.aucmd({ 'BufLeave', 'CmdlineEnter', }, 'imaps: CmdlineEnter', {
  callback = function()
    local word = vim.fn.expand '<cword>'
    if #word > 0 then vim.fn.setreg('e', word) end
    local Word = vim.fn.expand '<cWORD>'
    if #Word > 0 then vim.fn.setreg('3', Word) end
    if vim.g.telescope_entered or B.is_buf_fts { 'NvimTree', 'TelescopePrompt', 'DiffviewFileHistory', } then return end
    B.setreg()
    M.save_cursor = vim.fn.getpos '.'
  end,
})

B.aucmd({ 'CmdlineLeave', }, 'imaps: CmdlineLeave', {
  callback = function()
    vim.cmd 'norm lhjk'
    pcall(vim.fn.setpos, '.', M.save_cursor)
  end,
})

B.lazy_map {
  -- reg
  { '<c-e>',   '<c-r>e',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cword>', },
  { '<c-3>',   '<c-r>3',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste <cWORD>', },
  { '<c-t>',   '<c-r>=expand("%:t")<cr>',              mode = { 'c', 'i', },      desc = 'my.insertenter: paste %:t', },
  { '<c-b>',   '<c-r>=bufname()<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste bufname()', },
  { '<c-g>',   '<c-r>=nvim_buf_get_name(0)<cr>',       mode = { 'c', 'i', },      desc = 'my.insertenter: paste nvim_buf_get_name', },
  { '<c-d>',   '<c-r>=getcwd()<cr>',                   mode = { 'c', 'i', },      desc = 'my.insertenter: paste cwd', },
  { '<c-l>',   '<c-r>=g:curline<cr>',                  mode = { 'c', 'i', },      desc = 'my.insertenter: paste cur line', },
  { "<c-'>",   '<c-r>=g:single_quote<cr>',             mode = { 'c', 't', },      desc = "my.insertenter: paste in ''", },
  { "<c-s-'>", '<c-r>=g:double_quote<cr>',             mode = { 'c', 't', },      desc = 'my.insertenter: paste in ""', },
  { '<c-0>',   '<c-r>=g:parentheses<cr>',              mode = { 'c', 't', },      desc = 'my.insertenter: paste in ()', },
  { '<c-]>',   '<c-r>=g:bracket<cr>',                  mode = { 'c', 't', },      desc = 'my.insertenter: paste in []', },
  { '<c-s-]>', '<c-r>=g:brace<cr>',                    mode = { 'c', 't', },      desc = 'my.insertenter: paste in {}', },
  { '<c-`>',   '<c-r>=g:back_quote<cr>',               mode = { 'c', 't', },      desc = 'my.insertenter: paste in ``', },
  { '<c-s-.>', '<c-r>=g:angle_bracket<cr>',            mode = { 'c', 't', },      desc = 'my.insertenter: paste in <>', },
  { '<c-s>',   '<c-r>"',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste "', },
  { '<c-s>',   '<c-\\><c-n>pi',                        mode = { 't', },           desc = 'my.insertenter: paste "', },
  { '<c-v>',   '<c-r>+',                               mode = { 'c', 'i', },      desc = 'my.insertenter: paste +', },
  { '<c-v>',   '<c-\\><c-n>"+pi',                      mode = { 't', },           desc = 'my.insertenter: paste +', },
  { 'k',       "(v:count == 0 && &wrap) ? 'gk' : 'k'", mode = { 'n', 'v', },      desc = 'my.insertenter: k',                       silent = true, expr = true, },
  { 'j',       "(v:count == 0 && &wrap) ? 'gj' : 'j'", mode = { 'n', 'v', },      desc = 'my.insertenter: j',                       silent = true, expr = true, },
  { '<a-k>',   '<UP>',                                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: up', },
  { '<a-j>',   '<DOWN>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: down', },
  { '<a-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },
  { '<c-k>',   '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<c-j>',   '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },
  { '<c-s-k>', '<UP><UP><UP><UP><UP>',                 mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 up', },
  { '<c-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>',       mode = { 't', 'c', 'i', }, desc = 'my.insertenter: 5 down', },
  { '<a-l>',   '<RIGHT>',                              mode = { 't', 'c', 'i', }, desc = 'my.insertenter: right', },
  { '<a-h>',   '<LEFT>',                               mode = { 't', 'c', 'i', }, desc = 'my.insertenter: left', },
  { '<a-s-l>', '<c-RIGHT>',                            mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl right', },
  { '<a-s-h>', '<c-LEFT>',                             mode = { 't', 'c', 'i', }, desc = 'my.insertenter: ctrl left', },
  { '<esc>',   '<c-\\><c-n>',                          mode = { 't', },           desc = 'my.insertenter: esc', },
  { '<c-;>',   '<cr>',                                 mode = { 'c', },           desc = 'my.insertenter: cr', },
}

function M.copy_increase_up_line()
  local lnr = vim.fn.line '.'
  if lnr > 1 then
    local line = vim.fn.getline(lnr - 1)
    vim.fn.setline('.', line)
    vim.cmd [[call feedkeys("\<esc>")]]
    vim.cmd [[call feedkeys("0\<c-a>W")]]
  end
end

B.lazy_map {
  { "<c-'>", function() M.copy_increase_up_line() end, mode = { 'i', }, desc = 'my.insertenter: copy increase up line', },
}

B.lazy_map {
  { '<ScrollWheelUp>',   '<UP>',   mode = { 't', }, desc = 'my.insertenter: up', },
  { '<ScrollWheelDown>', '<DOWN>', mode = { 't', }, desc = 'my.insertenter: down', },
}

return M
