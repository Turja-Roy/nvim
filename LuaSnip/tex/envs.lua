local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
    -- Comment box
    s(
        { trig = "box", dscr = "Comment box" },
        fmta(
            [[
              <border>
              %  <text>  %
              <border>
              <end_line>
            ]],
            {
                text = i(1, "Heading"),
                border = f(function(args)
                    local len = string.len(args[1][1]) + 6  -- Adjust length for '%  %'
                    return string.rep("%", len)
                end, { 1 }),
                end_line = i(0)
            })
    ),

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
              \begin{figure}[<>]
                  \centering
                  \includegraphics[width=<>\textwidth]{<>}
                  \caption{<>}
                  \label{fig:<>}
              \end{figure}
            ]],
            { i(1, "htpb"), i(2, "0.8"), i(3), i(4), rep(3) }
        )
    ),

    -- Subfigure
    s(
        { trig = "subfig", dscr = "Subfigure" },
        fmta(
            [[
              \begin{subfigure}{<>\textwidth}
                  \includegraphics[width=<>\textwidth]{<>}
                  \caption{<>}
              \end{subfigure}
            ]],
            { i(1, "0.4"), i(2, "0.8"), i(3), rep(3) }
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

    -- Minipage
    s(
        { trig = "minip", dscr = "Minipage" },
        fmta(
            [[
              \begin{minipage}{<>}
                  <>
              \end{minipage}
            ]],
            { i(1, "0.5\\textwidth"), i(2) }
        )
    ),
}
