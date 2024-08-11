local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
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
    s({ trig = "it", dscr = "visual italic" }, fmta("\\textit{<>}", { d(1, get_visual) })),
    s({ trig = "tt", dscr = "visual typescript" }, fmta("\\textit{<>}", { d(1, get_visual) })),
    s({ trig = "bf", dscr = "visual bold" }, fmta("\\textit{<>}", { d(1, get_visual) })),
    s({ trig = "un", dscr = "visual underline" }, fmta("\\textit{<>}", { d(1, get_visual) })),

    s({ trig = "hr", dscr = "hyperref" }, fmta([[\href{<>}{<>}]], { i(1, "url"), i(2, "display name") })),

    -- Sections
    s({ trig = "sec", dscr = "section" }, fmta([[\section{<>}]], { i(1) }), { condition = line_begin }),
    s({ trig = "sec*", dscr = "section" }, fmta([[\section*{<>}]], { i(1) }), { condition = line_begin }),
    s({ trig = "sub", dscr = "section" }, fmta([[\subsection{<>}]], { i(1) }), { condition = line_begin }),
    s({ trig = "subsub", dscr = "section" }, fmta([[\subsubsection{<>}]], { i(1) }), { condition = line_begin }),
    s({ trig = "subsubsub", dscr = "section" }, fmta([[\subsubsubsection{<>}]], { i(1) }), { condition = line_begin }),
}
