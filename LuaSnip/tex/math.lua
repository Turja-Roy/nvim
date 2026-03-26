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
        { trig = "([%d%)%}%]])^^", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%a%)%}%]])^^", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ee", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>e^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%a%)%}%]])ee", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>e^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "deg", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>^{\\circ}<>", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
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
        fmta("<>_<>",
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
        { trig = "([^%s=<>%&]+)/", dscr = "fraction", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
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
        fmta("\\left\\{ <> \\right\\}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrC", dscr = "curly braces for set", snippetType = "autosnippet" },
        fmta("\\{ <> \\}", { d(1, get_visual) }),
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
    s(
        { trig = "lrv", dscr = "vertical bar", snippetType = "autosnippet" },
        fmta("\\lvert <> \\rvert", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrV", dscr = "vertical bar", snippetType = "autosnippet" },
        fmta("\\lVert <> \\rVert", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Big Right Delimiters
    s(
        { trig = "rrb", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\bigr|_{<>}^{<>}", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "rrB", dscr = "big brackets" },
        fmta("\\Bigr|_{<>}^{<>}", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "rrBB", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\Biggr|_{<>}^{<>}", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),

    -- Big Delimiters
    s(
        { trig = "lrb", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\bigl <> \\bigr", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrB", dscr = "big brackets" },
        fmta("\\Bigl <> \\Bigr", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrBB", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\Biggl <> \\Biggr", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrba", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\bigl\\langle <> \\bigr\\rangle", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrBa", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\Bigl\\langle <> \\Bigr\\rangle", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lrBBa", dscr = "big brackets", snippetType = "autosnippet" },
        fmta("\\Biggl\\langle <> \\Biggr\\rangle", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Set and Relation notations
    s(
        { trig = "st", dscr = "such that notation", snippetType = "autosnippet" },
        { t("\\mid ") },
        { condition = mathzone }
    ),
    s(
        { trig = "sst", dscr = "such that text", snippetType = "autosnippet" },
        { t("\\text{ s.t. } ") },
        { condition = mathzone }
    ),
    s(
        { trig = "sub", dscr = "subset", snippetType = "autosnippet" },
        { t("\\subset ") },
        { condition = mathzone }
    ),
    s(
        { trig = "nsub", dscr = "subset", snippetType = "autosnippet" },
        { t("\\not\\subset ") },
        { condition = mathzone }
    ),
    s(
        { trig = "seq", dscr = "subset equal", snippetType = "autosnippet" },
        { t("\\subseteq ") },
        { condition = mathzone }
    ),
    s(
        { trig = "nseq", dscr = "subset equal", snippetType = "autosnippet" },
        { t("\\not\\subseteq ") },
        { condition = mathzone }
    ),
    s(
        { trig = "fall", dscr = "in", snippetType = "autosnippet" },
        { t("\\forall ") },
        { condition = mathzone }
    ),
    s(
        { trig = "ext", dscr = "exists", snippetType = "autosnippet" },
        { t("\\exists ") },
        { condition = mathzone }
    ),
    s(
        { trig = "next", dscr = "exists", snippetType = "autosnippet" },
        { t("\\not\\exists ") },
        { condition = mathzone }
    ),
    s(
        { trig = "inn", dscr = "in", snippetType = "autosnippet" },
        { t("\\in ") },
        { condition = mathzone }
    ),
    s(
        { trig = "ninn", dscr = "not in", snippetType = "autosnippet" },
        { t("\\not\\in ") },
        { condition = mathzone }
    ),
    s(
        { trig = "cap", dscr = "cap", snippetType = "autosnippet" },
        { t("\\cap ") },
        { condition = mathzone }
    ),
    s(
        { trig = "cup", dscr = "cup", snippetType = "autosnippet" },
        { t("\\cup ") },
        { condition = mathzone }
    ),
    s(
        { trig = "bcap", dscr = "bigcap", snippetType = "autosnippet" },
        { t("\\bigcap ") },
        { condition = mathzone }
    ),
    s(
        { trig = "bcup", dscr = "bigcup", snippetType = "autosnippet" },
        { t("\\bigcup ") },
        { condition = mathzone }
    ),
    s(
        { trig = "compl", dscr = "complement", snippetType = "autosnippet" },
        { t("^{c}") },
        { condition = mathzone }
    ),
    s(
        { trig = "!>", dscr = "mapsto", snippetType = "autosnippet" },
        { t("\\mapsto ") },
        { condition = mathzone }
    ),
    s(
        { trig = "->", dscr = "to", snippetType = "autosnippet" },
        { t("\\to ") },
        { condition = mathzone }
    ),

    -- Relations
    s(
        { trig = "==", dscr = "equals", snippetType = "autosnippet" },
        fmta(
            [[
                &= <>
            ]],
            { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "&= =", dscr = "equals", snippetType = "autosnippet" },
        { t("\\equiv ") },
        { condition = mathzone }
    ),
    s(
        { trig = "!=", dscr = "not equals", snippetType = "autosnippet" },
        { t("\\neq ") },
        { condition = mathzone }
    ),
    s(
        { trig = "app", dscr = "approx", snippetType = "autosnippet" },
        { t("\\approx ") },
        { condition = mathzone }
    ),
    s(
        { trig = "<=", dscr = "less than or equal to", snippetType = "autosnippet" },
        { t("\\leq ") },
        { condition = mathzone }
    ),
    s(
        { trig = ">=", dscr = "greater than or equal to", snippetType = "autosnippet" },
        { t("\\geq ") },
        { condition = mathzone }
    ),
    s(
        { trig = "=>", dscr = "implies", snippetType = "autosnippet" },
        { t("\\implies ") },
        { condition = mathzone }
    ),
    s(
        { trig = "=<", dscr = "implied by", snippetType = "autosnippet" },
        { t("\\impliedby ") },
        { condition = mathzone }
    ),
    s(
        { trig = "ppm", dscr = "plus minus", snippetType = "autosnippet" },
        { t("\\pm") },
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
    -- Tilde
    s(
        { trig = "til", dscr = "tilde", snippetType = "autosnippet" },
        fmta("\\tilde{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    -- Bar
    s(
        { trig = "bar", dscr = "bar", snippetType = "autosnippet" },
        fmta("\\bar{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    -- Vector
    s(
        { trig = "vec", dscr = "vector", snippetType = "autosnippet" },
        fmta("\\vec{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    -- Functions
    s(
        { trig = "sin", dscr = "sine", snippetType = "autosnippet" },
        fmta("\\sin<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "cos", dscr = "cosine", snippetType = "autosnippet" },
        fmta("\\cos<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "tan", dscr = "tangent", snippetType = "autosnippet" },
        fmta("\\tan<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "nsin", dscr = "sine", snippetType = "autosnippet" },
        fmta("\\sin^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ncos", dscr = "cosine", snippetType = "autosnippet" },
        fmta("\\cos^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ntan", dscr = "tangent", snippetType = "autosnippet" },
        fmta("\\tan^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "asin", dscr = "sine", snippetType = "autosnippet" },
        fmta("\\sin^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "acos", dscr = "cosine", snippetType = "autosnippet" },
        fmta("\\cos^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "atan", dscr = "tangent", snippetType = "autosnippet" },
        fmta("\\tan^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "sinh", dscr = "hyperbolic sine", snippetType = "autosnippet" },
        fmta("\\sinh<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "cosh", dscr = "hyperbolic cosine", snippetType = "autosnippet" },
        fmta("\\cosh<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "tanh", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\tanh<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "asinh", dscr = "hyperbolic sine", snippetType = "autosnippet" },
        fmta("\\sinh^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "acosh", dscr = "hyperbolic cosine", snippetType = "autosnippet" },
        fmta("\\cosh^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "atanh", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\tanh^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "sec", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\sec<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "csc", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\csc<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "cot", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\cot<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "nsec", dscr = "sine", snippetType = "autosnippet" },
        fmta("\\sec^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ncsc", dscr = "cosine", snippetType = "autosnippet" },
        fmta("\\csc^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ncot", dscr = "tangent", snippetType = "autosnippet" },
        fmta("\\cot^<>(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "asec", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\sec^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "acsc", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\csc^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "acot", dscr = "hyperbolic tangent", snippetType = "autosnippet" },
        fmta("\\cot^{-1}<>", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ln", dscr = "logarithm", snippetType = "autosnippet" },
        fmta("\\ln(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "lln", dscr = "logarithm", snippetType = "autosnippet" },
        fmta("\\ln\\lvert <> \\rvert", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "log", dscr = "logarithm", snippetType = "autosnippet" },
        fmta("\\log(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "blog", dscr = "logarithm", snippetType = "autosnippet" },
        fmta("\\log_{<>}(<>)", { d(1, get_visual), d(2, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "llog", dscr = "logarithm", snippetType = "autosnippet" },
        fmta("\\log\\lvert <> \\rvert", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "exp", dscr = "exponential", snippetType = "autosnippet" },
        fmta("\\exp(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "abs", dscr = "absolute value", snippetType = "autosnippet" },
        fmta("\\lvert <> \\rvert", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "Abs", dscr = "absolute value", snippetType = "autosnippet" },
        fmta("\\left| <> \\right|", { d(1, get_visual) }),
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
        { trig = "([%d%)%}%]])deg", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>^{\\circ}<>", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([%d%a%)%}%]])pp", dscr = "prime", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>'", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
    s(
        { trig = "tf", dscr = "therefore", snippetType = "autosnippet" },
        { t("\\therefore") },
        { condition = mathzone }
    ),
    s(
        { trig = "txt", dscr = "text", snippetType = "autosnippet" },
        fmta("\\text{<>}", { i(1) }),
        { condition = mathzone }
    ),
    s(
        { trig = "dps", dscr = "displaystyle", snippetType = "autosnippet" },
        fmta("\\displaystyle <>", { i(1) }),
        { condition = mathzone }
    ),
    s(
        { trig = "mod", dscr = "modulo", snippetType = "autosnippet" },
        fmta("\\pmod{<>}", { i(1) }),
        { condition = mathzone }
    ),
}
