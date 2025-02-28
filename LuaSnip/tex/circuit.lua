local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    -- circuitikz environment 
    s(
        { trig = "circuit", wordTrig = true, regTrig = false },
        fmta(
            [[
              \begin{circuitikz} \draw
                  <>
              \end{circuitikz}
            ]],
            { i(1) }
        )
    ),
    -- Node
    s(
        { trig = "node", wordTrig = true, regTrig = false },
        fmta(
            [[
              (<>) node[<>] {<>}
            ]],
            { i(1, "0,0"), i(2, "draw"), i(3) }
        )
    ),
}
