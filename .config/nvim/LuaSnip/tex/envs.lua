local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	-- New Environment
	s(
		{ trig = "beg", dscr = "Environment" },
		fmta(
			[[
              \begin{<>}
                  <>
              \end{<>}
            ]],
			{ i(1), i(2), rep(1) },
            { condition = line_begin }
		)
	),

    -- Figure
    s(
        { trig = "fig", dscr = "Figure" },
        fmta(
            [[
              \begin{figure}{<>}
                  \centering
                  \includegraphics[<>]{<>}
                  \caption{<>}
              \end{figure}
            ]],
            { i(1, "htpb"), i(2, "width=0.8\\textwidth"), i(3), rep(3) }
        )
    ),

    -- Tables
    s(
        { trig = "table", dscr = "Table" },
        fmta(
            [[
              \begin{table}[<>]
                  \centering
                  \begin{tabular}{<>}
                      \toprule
                      <>
                      \bottomrule
                  \end{tabular}
                  \caption{<>}
              \end{table}
            ]],
            { i(1, "htpb"), i(2, "c"), rep(2), i(3) }
        )
    ),

    -- Enumerates
	s(
		{ trig = "enuma", dscr = "Equation" },
		fmta(
			[[
              \begin{enumerate}[label=(\alph*)]
                  \item <>
              \end{enumerate}
            ]],
			{ i(1) }
		)
	),
	s(
		{ trig = "enumi", dscr = "Equation" },
		fmta(
			[[
              \begin{enumerate}[label=(\roman*)]
                  \item <>
              \end{enumerate}
            ]],
			{ i(1) }
		)
	),

}
