local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local get_visual = require('personal.luasnip-helper-funcs').get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return
    {
        -- GENERIC ENVIRONMENT
        s({trig="beg", snippetType="autosnippet"},
            fmta(
                [[
        \begin{<>}
            <>
        \end{<>}
      ]],
                {
                    i(1),
                    d(2, get_visual),
                    rep(1),
                }
            ),
            {condition = line_begin}
        ),
        -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
        s({trig="beg2", snippetType="autosnippet"},
            fmta(
                [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
                {
                    i(1),
                    i(2),
                    d(3, get_visual),
                    rep(1),
                }
            ),
            { condition = line_begin }
        ),
        -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
        s({trig="beg3", snippetType="autosnippet"},
            fmta(
                [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
                {
                    i(1),
                    i(2),
                    i(3),
                    d(4, get_visual),
                    rep(1),
                }
            ),
            { condition = line_begin }
        ),
        -- SECTION
        s({trig="sec", snippetType="autosnippet"},
            fmta(
                "\\section{<>}",
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="sub", snippetType="autosnippet"},
            fmta(
                "\\subsection{<>}",
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="subsub", snippetType="autosnippet"},
            fmta(
                "\\subsubsection{<>}",
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="subsubsub", snippetType="autosnippet"},
            fmta(
                "\\subsubsubsection{<>}",
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        -- TOPIC ENVIRONMENT (my custom tcbtheorem environment)
        s({trig="def", snippetType="autosnippet"},
            fmta(
                [[
        \begin{definition}{<>}{}
            <>
        \end{definition}
      ]],
                {
                    i(1),
                    i(2),
                    d(3, get_visual),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="thm", snippetType="autosnippet"},
            fmta(
                [[
        \begin{theorem}{<>}{}
            <>
        \end{theorem}
      ]],
                {
                    i(1),
                    i(2),
                    d(3, get_visual),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="xmp", snippetType="autosnippet"},
            fmta(
                [[
        \begin{example}{<>}{}
            <>
        \end{example}
      ]],
                {
                    i(1),
                    i(2),
                    d(3, get_visual),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="exc", snippetType="autosnippet"},
            fmta(
                [[
        \begin{exercise}{<>}{}
            <>
        \end{exercise}
      ]],
                {
                    i(1),
                    i(2),
                    d(3, get_visual),
                }
            ),
            { condition = line_begin }
        ),
        -- EQUATION
        s({trig="eq", snippetType="autosnippet"},
            fmta(
                [[
        \begin{equation}
            <>
        \end{equation}
      ]],
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        s({trig="eq*", snippetType="autosnippet"},
            fmta(
                [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
                {
                    i(1),
                }
            ),
            { condition = line_begin }
        ),
        -- SPLIT EQUATION
        s({trig="split", snippetType="autosnippet"},
            fmta(
                [[
            \begin{split}
                <>
            \end{split}
      ]],
                {
                    d(1, get_visual),
                }
            ),
            { condition = line_begin }
        ),
        -- ALIGN
        s({trig="aleq", snippetType="autosnippet"},
            fmta(
                [[
        \begin{align*}
            <> &= <> \\
            <>
        \end{align*}
      ]],
                {
                    i(1), i(2), i(3),
                }
            ),
            {condition = line_begin}
        ),
        -- ITEMIZE
        s({trig="item", snippetType="autosnippet"},
            fmta(
                [[
        \begin{itemize}
            \item <>
        \end{itemize}
      ]],
                {
                    i(0),
                }
            ),
            {condition = line_begin}
        ),
        -- ENUMERATE
        s({trig="enum", snippetType="autosnippet"},
            fmta(
                [[
        \begin{enumerate}
            \item <>
        \end{enumerate}
      ]],
                {
                    i(0),
                }
            )
        ),
        s({trig="enuma", snippetType="autosnippet"},
            fmta(
                [[
        \begin{enumerate}[(a)]
            \item <>
        \end{enumerate}
      ]],
                {
                    i(0),
                }
            )
        ),
        s({trig="enumi", snippetType="autosnippet"},
            fmta(
                [[
        \begin{enumerate}[(i)]
            \item <>
        \end{enumerate}
      ]],
                {
                    i(0),
                }
            )
        ),
        -- INLINE MATH
        s({trig = "([^%l])mm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
            fmta(
                "<>$<>$",
                {
                    f( function(_, snip) return snip.captures[1] end ),
                    d(1, get_visual),
                }
            )
        ),
        s({trig = "mk", regTrig = true, wordTrig = false, snippetType="autosnippet"},
            fmta(
                "$<>$",
                {
                    d(1, get_visual),
                }
            )
        ),
        -- INLINE MATH ON NEW LINE
        s({trig = "dm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
            fmta(
                [[
                \[
                    <>
                \]
                ]] ,
                {
                    d(1, get_visual),
                }
            )
        ),
        s({trig = "sdm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
            fmta(
                "\\[ <> \\]",
                {
                    d(1, get_visual),
                }
            )
        ),
        -- FIGURE
        s({trig = "fig"},
            fmta(
                [[
        \begin{figure}[htpb]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
                {
                    i(1),
                    i(2),
                    i(3),
                    i(4),
                }
            ),
            { condition = line_begin }
        ),
    }
