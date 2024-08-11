local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_visual = function(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else
        return sn(nil, i(1))
    end
end

return {
    -- Math environments
    s(
        { trig = "([^%a])mk", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>$<>$", { f(function(_, snip)
            return snip.captures[1]
        end), d(1, get_visual) })
    ),
    s(
        { trig = "mk", wordTrig = true, regTrig = false, snippetType = "autosnippet" },
        fmta("<>$<>$", { f(function(_, snip)
            return snip.captures[1]
        end), d(1, get_visual) }),
        { condition = line_begin }
    ),
    s(
        { trig = "([^%a])sdm", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>\\[<>\\]", { f(function(_, snip)
            return snip.captures[1]
        end), d(1, get_visual) })
    ),
    s(
        { trig = "sdm", wordTrig = true, regTrig = false, snippetType = "autosnippet" },
        fmta("<>\\[<>\\]", { f(function(_, snip)
            return snip.captures[1]
        end), d(1, get_visual) }),
        { condition = line_begin }
    ),
    s(
        { trig = "([^%a])dm", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
              <>\[ 
                  <>
              \]
            ]],
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        )
    ),
    s(
        { trig = "dm", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            [[
              <>\[ 
                  <>
              \]
            ]],
            { f( function(_, snip) return snip.captures[1] end ), i(1) }),
        { condition = line_begin }
    ),

	-- Equation
	s(
		{ trig = "eq", dscr = "Equation" },
		fmta(
			[[
              \begin{equation}
                  <>
              \end{equation}
            ]],
			{ i(1) }
		)
	),
	s(
		{ trig = "eq*", dscr = "Equation" },
		fmta(
			[[
              \begin{equation}
                  <>
              \end{equation}
            ]],
			{ i(1) }
		)
	),

	-- Align
	s(
		{ trig = "aln", dscr = "Equation" },
		fmta(
			[[
              \begin{align}
                  <> &= <> \\
                  <>
              \end{align}
            ]],
			{ i(1), i(2), i(3) }
		)
	),
	s(
		{ trig = "aleq", dscr = "Equation" },
		fmta(
			[[
              \begin{align*}
                  <> &= <> \\
                  <>
              \end{align*}
            ]],
			{ i(1), i(2), i(3) }
		)
	),

    -- Matrix
    s(
        { trig = "pmat", dscr = "Matrix" },
        fmta(
            [[
              \begin{pmatrix}
                  <>
              \end{pmatrix}
            ]],
            { i(1) }
        )
    ),
    s(
        { trig = "bmat", dscr = "Matrix" },
        fmta(
            [[
              \begin{bmatrix}
                  <>
              \end{bmatrix}
            ]],
            { i(1) }
        )
    ),

    ----------------------------------
    -- Math Notetaking Environments --
    ----------------------------------
    s( -- Definition 
        { trig = "def", dscr = "Definition" },
        fmta(
            [[
              \begin{definition}{<>}{}
                  <>
              \end{definition}
            ]],
            { i(1), i(2) }
        )
    ),
    s( -- Theorem
        { trig = "thrm", dscr = "Theorem" },
        fmta(
            [[
              \begin{theorem}{<>}{}
                  <>
              \end{theorem}
            ]],
            { i(1), i(2) }
        )
    ),
    s( -- Example
        { trig = "xmp", dscr = "Example" },
        fmta(
            [[
              \begin{example}{<>}{}
                  <>
              \end{example}
            ]],
            { i(1), i(2) }
        )
    ),
    s( -- Excercise
        { trig = "exc", dscr = "Excercise" },
        fmta(
            [[
              \begin{excercise}{<>}{}
                  <>
              \end{excercise}
            ]],
            { i(1), i(2) }
        )
    ),
    s( -- Note
        { trig = "nte", dscr = "Note" },
        fmta(
            [[
              \begin{note}{<>}{}
                  <>
              \end{note}
            ]],
            { i(1), i(2) }
        )
    ),
    s( -- Proof
        { trig = "prf", dscr = "Proof", snippetType = "autosnippet" },
        { t("\\underline{\\textbf{Proof:}}") },
        { condition = line_begin }
    )
}
