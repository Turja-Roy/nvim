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
        { trig = "dot", dscr = "Derivative", snippetType = "autosnippet" },
        fmta("\\dot{<>}", { i(1, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "ddot", dscr = "Derivative", snippetType = "autosnippet" },
        fmta("\\ddot{<>}", { i(1, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "dddot", dscr = "Derivative", snippetType = "autosnippet" },
        fmta("\\dddot{<>}", { i(1, "x") }),
        { condition = mathzone }
    ),
	s(
		{ trig = "ddx", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv{<>}{<>}", { i(1, "y"), i(2, "x") }),
        { condition = mathzone }
	),
	s(
		{ trig = "dvx", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv{}{<>} <> ", { i(1, "x"), i(2, "y") }),
        { condition = mathzone }
	),
	s(
		{ trig = "dvn", dscr = "Derivative", snippetType = "autosnippet" },
		fmta("\\dv[<>]{<>}{<>}", { i(1, "order"), i(2, "nom"), i(3, "denom") }),
        { condition = mathzone }
	),

	-- Partial Derivative
	s(
		{ trig = "pdv", dscr = "Partial Derivative", snippetType = "autosnippet" },
		fmta("\\pdv{<>}{<>}", { i(1, "nom"), i(2, "denom") }),
        { condition = mathzone }
	),
	s(
		{ trig = "pdx", dscr = "Partial Derivative", snippetType = "autosnippet" },
		fmta("\\pdv{}{<>} <>", { i(1, "denom"), i(2, "nom") }),
        { condition = mathzone }
	),
	s(
		{ trig = "pdn", dscr = "Partial Derivative", snippetType = "autosnippet" },
		fmta("\\pdv[<>]{<>}{<>}", { i(1, "order"), i(2, "nom"), i(3, "denom") }),
        { condition = mathzone }
	),

    -- Partial Derivative sign
    s(
        { trig = "par", dscr = "partial sign", snippetType = "autosnippet" },
        fmta("\\partial", {}),
        { condition = mathzone }
    ),

	-- SI Unit
	s(
		{ trig = "SI", dscr = "SI Unit", snippetType = "autosnippet" },
		fmta("\\si{<> <>}", { i(1, "val"), i(2, "unit") })
	),

    -- Integration
    s(
        { trig = "int", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\int <> \\dd{<>}",
            { d(1, get_visual), i(2, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "dint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\int_{<>}^{<>} <> \\dd{<>}",
            { i(1, "a"), i(2, "b"), d(3, get_visual), i(4, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "iint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\iint <> \\dd{<>}",
            { d(1, get_visual), i(2, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "diint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\iint\\limits_{<>}^{<>} <> \\dd{<>}",
            { i(1, "a"), i(2, "b"), d(3, get_visual), i(4, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "iiint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\int <> \\dd{<>}",
            { d(1, get_visual), i(2, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "diiint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\iiint\\limits_{<>}^{<>} <> \\dd{<>}",
            { i(1, "a"), i(2, "b"), d(3, get_visual), i(4, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "oint", dscr = "indefinite integral", snippetType = "autosnippet" },
        fmta("\\oint <> \\dd{<>}",
            { d(1, get_visual), i(2, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "doint", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\oint\\limits_{<>}^{<>} <> \\dd{<>}",
            { i(1, "a"), i(2, "b"), d(3, get_visual), i(4, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "ddd", dscr = "definite integral", snippetType = "autosnippet" },
        fmta("\\dd{<>}",
            { i(1, "x") }),
        { condition = mathzone }
    ),
    s(
        { trig = "ilim", dscr = "integral limit", snippetType = "autosnippet" },
        fmta("\\limits_{<>}",
            { i(1, "R") }),
        { condition = mathzone }
    ),

    -- Summation
    s(
        { trig = "sum", dscr = "Summation", snippetType = "autosnippet" },
        fmta("\\sum <>",
            { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "nsum", dscr = "Summation", snippetType = "autosnippet" },
        fmta("\\sum_{<>}^{<>} <>",
            { i(1, "n=0"), i(2, "\\infty"), d(3, get_visual) }),
        { condition = mathzone }
    ),

    -- Binomial Coefficient
    s(
        { trig = "nCk", dscr = "Binomial Coefficient", snippetType = "autosnippet" },
        fmta("\\binom{<>}{<>}",
            { i(1, "n"), i(2, "k") }),
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
