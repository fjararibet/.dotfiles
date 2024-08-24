local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {
  s('comp', {
    t('#include <bits/stdc++.h>'),
    t({ '', 'using namespace std;' }),
    t({ '', 'int main() {', '' }),
    t('  '), i(1),
    t({ '', '}' }),
  })
})
