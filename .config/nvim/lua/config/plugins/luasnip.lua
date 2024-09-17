local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
-- local i = ls.insert_node

ls.add_snippets("cpp", {
  s('comp', {
    t('#include <bits/stdc++.h>'),
    t({ '', 'using namespace std;' }),
    t({ '', 'void solve() {' }),
    t({ '', '}' }),
    t({ '', 'int main() {' }),
    t({ '', '  ios::sync_with_stdio(0);' }),
    t({ '', '  cin.tie(0);' }),
    t({ '', '  int t;' }),
    t({ '', '  t = 1;' }),
    t({ '', '  // cin >> t;' }),
    t({ '', '  while (t--)' }),
    t({ '', '    solve();' }),
    t(''),
    t({ '', '}' }),
  })
})
