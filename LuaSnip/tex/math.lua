local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
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
    -- Superscripts
    s(
        { trig = "([%a%)%}%]])^^", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%a%)%}%]])ee", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>e^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Subscripts
    s(
        { trig = "([%a%)%}%]])__", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>_{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%a%)%}%]])([%d])", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>_{<>}",
            { f(function(_, snip) return snip.captures[1] end),
                f(function(_, snip) return snip.captures[2] end) }),
        { condition = mathzone }
    ),

    -- Fractions
    s(
        { trig = "//", dscr = "fraction", snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}", { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%d])/", dscr = "fraction", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}",
            { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Delimiters
    s(
        { trig = "lrp", dscr = "parentheses", snippetType = "autosnippet" },
        fmta("\\left( <> \\right)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrc", dscr = "curly braces", snippetType = "autosnippet" },
        fmta("\\left{ <> \\right}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrs", dscr = "square brackets", snippetType = "autosnippet" },
        fmta("\\left[ <> \\right]", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lra", dscr = "angle brackets", snippetType = "autosnippet" },
        fmta("\\langle <> \\rangle", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Set and Relation notations
    s(
        { trig = "sub", dscr = "subset", snippetType = "autosnippet" },
        { t("\\subset") },
        { condition = mathzone }
    ),
    s(
        { trig = "in", dscr = "in", snippetType = "autosnippet" },
        { t("\\in") },
        { condition = mathzone }
    ),
    s(
        { trig = "cap", dscr = "cap", snippetType = "autosnippet" },
        { t("\\cap") },
        { condition = mathzone }
    ),
    s(
        { trig = "cup", dscr = "cup", snippetType = "autosnippet" },
        { t("\\cup") },
        { condition = mathzone }
    ),
    s(
        { trig = "bcap", dscr = "bigcap", snippetType = "autosnippet" },
        { t("\\bigcap") },
        { condition = mathzone }
    ),
    s(
        { trig = "bcup", dscr = "bigcup", snippetType = "autosnippet" },
        { t("\\bigcup") },
        { condition = mathzone }
    ),
    s(
        { trig = "compl", dscr = "complement", snippetType = "autosnippet" },
        { t("^{c}") },
        { condition = mathzone }
    ),
    s(
        { trig = "!>", dscr = "mapsto", snippetType = "autosnippet" },
        { t("\\mapsto") },
        { condition = mathzone }
    ),

    -- Relations
    s(
        { trig = "==", dscr = "equals", snippetType = "autosnippet" },
        fmta(
            [[
                &= <> \\
                <>
            ]],
            { d(1, get_visual), i(2) }),
        { condition = mathzone }
    ),
    s(
        { trig = "!=", dscr = "not equals", snippetType = "autosnippet" },
        { t("\\neq") },
        { condition = mathzone }
    ),
    s(
        { trig = "<=", dscr = "less than or equal to", snippetType = "autosnippet" },
        { t("\\leq") },
        { condition = mathzone }
    ),
    s(
        { trig = ">=", dscr = "greater than or equal to", snippetType = "autosnippet" },
        { t("\\geq") },
        { condition = mathzone }
    ),
    s(
        { trig = "=>", dscr = "implies", snippetType = "autosnippet" },
        { t("\\implies") },
        { condition = mathzone }
    ),
    s(
        { trig = "=<", dscr = "implied by", snippetType = "autosnippet" },
        { t("\\impliedby") },
        { condition = mathzone }
    ),

    -- Overline
    s(
        { trig = "ovl", dscr = "overline", snippetType = "autosnippet" },
        fmta("\\overline{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    -- Hat
    s(
        { trig = "hat", dscr = "hat", snippetType = "autosnippet" },
        fmta("\\hat{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    -- Vector
    s(
        { trig = "vec", dscr = "vector", snippetType = "autosnippet" },
        fmta("\\vec{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Misc
    s(
        { trig = "([%d%a%)%}%]])sr", dscr = "square", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>^2", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%d%a%)%}%]])cb", dscr = "square", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>^3", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
    s(
        { trig = "sqt", dscr = "square root", snippetType = "autosnippet" },
        fmta("\\sqrt{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "sqn", dscr = "nth root", snippetType = "autosnippet" },
        fmta("\\sqrt[<>]{<>}", { i(1), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ooo", dscr = "infinity", snippetType = "autosnippet" },
        { t("\\infty") },
        { condition = mathzone }
    ),
    s(
        { trig = "xx", dscr = "times", snippetType = "autosnippet" },
        { t("\\times") },
        { condition = mathzone }
    ),
    s(
        { trig = "([%d%a%)%}%]])pp", dscr = "prime", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>'", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
}
