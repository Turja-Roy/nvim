local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local mathzone = function()
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local get_visual = function(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else
        return sn(nil, i(1))
    end
end

return {
	-- Derivative
	s(
		{ trig = "ddx", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv{<>}{<>}", { i(1, "y"), i(2, "x") })
	),
	s(
		{ trig = "dvx", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv{}{<>} <> ", { i(1, "x"), i(2, "y") })
	),
	s(
		{ trig = "dvn", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv[<>]{<>}{<>}", { i(1, "order"), i(2, "nom"), i(3, "denom") })
	),

	-- Partial Derivative
	s(
		{ trig = "pdv", dscr = "Partial Derivative", snippetType = "autosnippet" },
		fmta("\\pdv{<>}{<>}", { i(2, "nom"), i(3, "denom") })
	),
	s(
		{ trig = "pdn", dscr = "Partial Derivative", snippetType = "autosnippet" },
		fmta("\\pdv[<>]{<>}{<>}", { i(1, "order"), i(2, "nom"), i(3, "denom") })
	),

	-- SI Unit
	s(
		{ trig = "SI", dscr = "SI Unit", snippetType = "autosnippet" },
		fmta("\\si{<> <>}", { i(1, "val"), i(2, "unit") })
	),

    -- Integrals
    s(
        { trig = "int", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\int <> \\: d{<>}",
            { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "dint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\int_{<>}^{<>} <> \\: d{<>}",
            { i(1), i(2), d(3, get_visual), i(4) }),
        { condition = mathzone }
    ),
    s(
        { trig = "iint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\iint <> \\: d{<>}",
            { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "diint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\iint_{<>}^{<>} <> \\: d{<>}",
            { i(1), i(2), d(3, get_visual), i(4) }),
        { condition = mathzone }
    ),
    s(
        { trig = "iiint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\int <> \\: d{<>}",
            { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "diiint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\int_{<>}^{<>} <> \\: d{<>}",
            { i(1), i(2), d(3, get_visual), i(4) }),
        { condition = mathzone }
    ),
    s(
        { trig = "oint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\oint <> \\: d{<>}",
            { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "doint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\oint_{<>}^{<>} <> \\: d{<>}",
            { i(1), i(2), d(3, get_visual), i(4) }),
        { condition = mathzone }
    ),

    -- Summation
    s(
        { trig = "sum", dscr = "Summation", snippetType = "autosnippet" },
        fmta("\\sum_{<>}^{<>} <>",
            { i(1, "n=0"), i(2, "\\infty"), d(3, get_visual) }),
        { condition = mathzone }
    ),

    -- Limits 
    s(
        { trig = "lim", dscr = "Limit", snippetType = "autosnippet" },
        fmta("\\lim_{<> \\to <>} <>",
            { i(1, "x"), i(2, "a"), d(3, get_visual) }),
        { condition = mathzone }
    ),

    -- Taylor Series 
    s(
        { trig = "tylor", dscr = "Taylor Series", snippetType = "autosnippet" },
        fmta(
            [[
              \sum_{<> = <>}^{<>} c_{<>} (x - a)^{<>} <>
            ]],
            { i(1, "k"), i(2, "0"), i(3, "\\infty"), i(4), i(1), i(0) }
        ),
        { condition = mathzone }
    ),
    s(
        { trig = "taylor", dscr = "Taylor Series", snippetType = "autosnippet" },
        { t("\\sum_{n=0}^{\\infty} \\frac{f^{(n)}(a)}{n!} (x-a)^n") },
        { condition = mathzone }
    ),

    -- Product 
    s(
        { trig = "prod", dscr = "Product", snippetType = "autosnippet" },
        fmta("\\prod_{<>}^{<>} <>",
            { i(1, "n=0"), i(2, "\\infty"), d(3, get_visual) }),
        { condition = mathzone }
    ),
}
