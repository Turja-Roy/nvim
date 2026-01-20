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

-- Dynamic matrix generator
local generate_matrix = function(rows, cols, mat_type)
    local nodes = {}
    local row_strs = {}
    local insert_index = 1

    for r = 1, rows do
        local col_strs = {}
        for c = 1, cols do
            table.insert(col_strs, "<>")
            table.insert(nodes, i(insert_index))
            insert_index = insert_index + 1
        end
        table.insert(row_strs, table.concat(col_strs, " & "))
    end

    local matrix_content = table.concat(row_strs, " \\\\\n    ")
    local template = string.format("\\begin{%s}\n    %s\n\\end{%s}", mat_type, matrix_content, mat_type)

    return fmta(template, nodes)
end

return {
    -- Dynamic Matrices (pmatrix)
    s(
        { trig = "pmat_(%d)(%d)", dscr = "mxn matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(_, snip)
            local rows = tonumber(snip.captures[1])
            local cols = tonumber(snip.captures[2])
            return sn(nil, generate_matrix(rows, cols, "pmatrix"))
        end),
        { condition = mathzone }
    ),

    -- Dynamic Matrices (bmatrix)
    s(
        { trig = "bmat_(%d)(%d)", dscr = "mxn bracket matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(_, snip)
            local rows = tonumber(snip.captures[1])
            local cols = tonumber(snip.captures[2])
            return sn(nil, generate_matrix(rows, cols, "bmatrix"))
        end),
        { condition = mathzone }
    ),

    -- Dynamic Matrices (vmatrix - for determinants)
    s(
        { trig = "vmat_(%d)(%d)", dscr = "mxn determinant matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(_, snip)
            local rows = tonumber(snip.captures[1])
            local cols = tonumber(snip.captures[2])
            return sn(nil, generate_matrix(rows, cols, "vmatrix"))
        end),
        { condition = mathzone }
    ),

    -- Dynamic Matrices (Bmatrix - curly braces)
    s(
        { trig = "Bmat_(%d)(%d)", dscr = "mxn curly brace matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(_, snip)
            local rows = tonumber(snip.captures[1])
            local cols = tonumber(snip.captures[2])
            return sn(nil, generate_matrix(rows, cols, "Bmatrix"))
        end),
        { condition = mathzone }
    ),

    -- Dynamic Augmented matrix
    s(
        { trig = "amat_(%d)(%d)(%d)", dscr = "mxn|p augmented matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(_, snip)
            local rows = tonumber(snip.captures[1])
            local left_cols = tonumber(snip.captures[2])
            local right_cols = tonumber(snip.captures[3])
            
            -- Generate column alignment string (ccc|cc format)
            local left_align = string.rep("c", left_cols)
            local right_align = string.rep("c", right_cols)
            local col_spec = left_align .. "|" .. right_align
            
            -- Generate matrix content
            local nodes = {}
            local row_strs = {}
            local insert_index = 1
            local total_cols = left_cols + right_cols
            
            for r = 1, rows do
                local col_strs = {}
                for c = 1, total_cols do
                    table.insert(col_strs, "<>")
                    table.insert(nodes, i(insert_index))
                    insert_index = insert_index + 1
                end
                table.insert(row_strs, table.concat(col_strs, " & "))
            end
            
            local matrix_content = table.concat(row_strs, " \\\\\n    ")
            local template = string.format("\\left[\\begin{array}{%s}\n    %s\n\\end{array}\\right]", col_spec, matrix_content)
            
            return sn(nil, fmta(template, nodes))
        end),
        { condition = mathzone }
    ),

    -- Vectors
    s(
        { trig = "bvec", dscr = "bold vector", snippetType = "autosnippet" },
        fmta("\\mathbf{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "vcmp", dscr = "vector components", snippetType = "autosnippet" },
        fmta("\\begin{pmatrix} <> \\\\ <> \\end{pmatrix}", { i(1, "x"), i(2, "y") }),
        { condition = mathzone }
    ),
    s(
        { trig = "v3cmp", dscr = "3D vector components", snippetType = "autosnippet" },
        fmta("\\begin{pmatrix} <> \\\\ <> \\\\ <> \\end{pmatrix}", { i(1, "x"), i(2, "y"), i(3, "z") }),
        { condition = mathzone }
    ),
    s(
        { trig = "vcmpn", dscr = "n-D vector components", snippetType = "autosnippet" },
        fmta("\\begin{pmatrix} <> \\\\ <> \\\\ \\vdots \\\\ <> \\end{pmatrix}", { i(1, "x_1"), i(2, "x_2"), i(3, "x_n") }),
        { condition = mathzone }
    ),

    -- Transpose and Inverse
    s(
        { trig = "([A-Za-z])TT", dscr = "transpose", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>^{\\top}", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
    s(
        { trig = "([A-Za-z])II", dscr = "inverse", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta("<>^{-1}", { f(function(_, snip) return snip.captures[1] end) }),
        { condition = mathzone }
    ),
    s(
        { trig = "invs", dscr = "inverse", snippetType = "autosnippet" },
        fmta("<>^{-1}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "trns", dscr = "transpose", snippetType = "autosnippet" },
        fmta("<>^{\\top}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "herm", dscr = "hermitian", snippetType = "autosnippet" },
        fmta("<>^{\\dagger}", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Vector Operations
    s(
        { trig = "dot", dscr = "dot product", snippetType = "autosnippet" },
        fmta("<> \\cdot <>", { i(1, "a"), i(2, "b") }),
        { condition = mathzone }
    ),
    s(
        { trig = "cross", dscr = "cross product", snippetType = "autosnippet" },
        fmta("<> \\times <>", { i(1, "a"), i(2, "b") }),
        { condition = mathzone }
    ),
    s(
        { trig = "inner", dscr = "inner product", snippetType = "autosnippet" },
        fmta("\\langle <>, <> \\rangle", { i(1, "u"), i(2, "v") }),
        { condition = mathzone }
    ),
    s(
        { trig = "norm", dscr = "norm", snippetType = "autosnippet" },
        fmta("\\lVert <> \\rVert", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "normp", dscr = "p-norm", snippetType = "autosnippet" },
        fmta("\\lVert <> \\rVert_{<>}", { d(1, get_visual), i(2, "p") }),
        { condition = mathzone }
    ),

    -- Spaces
    s(
        { trig = "span", dscr = "span", snippetType = "autosnippet" },
        fmta("\\text{span}\\{<>\\}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "nullsp", dscr = "null space", snippetType = "autosnippet" },
        fmta("\\text{null}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "colsp", dscr = "column space", snippetType = "autosnippet" },
        fmta("\\text{col}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "rowsp", dscr = "row space", snippetType = "autosnippet" },
        fmta("\\text{row}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "range", dscr = "range", snippetType = "autosnippet" },
        fmta("\\text{range}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "kernel", dscr = "kernel", snippetType = "autosnippet" },
        fmta("\\text{ker}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "img", dscr = "image", snippetType = "autosnippet" },
        fmta("\\text{im}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Dimension
    s(
        { trig = "dim", dscr = "dimension", snippetType = "autosnippet" },
        fmta("\\dim(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Orthogonality
    s(
        { trig = "perp", dscr = "perpendicular", snippetType = "autosnippet" },
        { t("\\perp") },
        { condition = mathzone }
    ),
    s(
        { trig = "orth", dscr = "orthogonal", snippetType = "autosnippet" },
        { t("^{\\perp}") },
        { condition = mathzone }
    ),
    s(
        { trig = "proj", dscr = "projection", snippetType = "autosnippet" },
        fmta("\\text{proj}_{<>}(<>)", { i(1, "u"), i(2, "v") }),
        { condition = mathzone }
    ),

    -- Eigenvalues and Eigenvectors
    s(
        { trig = "eval", dscr = "eigenvalue", snippetType = "autosnippet" },
        fmta("\\lambda_{<>}", { i(1, "i") }),
        { condition = mathzone }
    ),
    s(
        { trig = "evec", dscr = "eigenvector", snippetType = "autosnippet" },
        fmta("\\mathbf{v}_{<>}", { i(1, "i") }),
        { condition = mathzone }
    ),
    s(
        { trig = "eigspace", dscr = "eigenspace", snippetType = "autosnippet" },
        fmta("E_{<>}", { i(1, "\\lambda") }),
        { condition = mathzone }
    ),
    s(
        { trig = "charpoly", dscr = "characteristic polynomial", snippetType = "autosnippet" },
        fmta("\\det(<> - \\lambda I)", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Special Matrices
    s(
        { trig = "imat", dscr = "identity matrix", snippetType = "autosnippet" },
        fmta("I_{<>}", { i(1, "n") }),
        { condition = mathzone }
    ),
    s(
        { trig = "zmat", dscr = "zero matrix", snippetType = "autosnippet" },
        fmta("\\mathbf{0}_{<>}", { i(1, "n") }),
        { condition = mathzone }
    ),
    s(
        { trig = "diag", dscr = "diagonal matrix", snippetType = "autosnippet" },
        fmta("\\text{diag}(<>)", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Matrix Decompositions
    s(
        { trig = "svd", dscr = "SVD" },
        fmta("<> = U\\Sigma V^{\\top}", { i(1, "A") }),
        { condition = mathzone }
    ),
    s(
        { trig = "qr", dscr = "QR decomposition" },
        fmta("<> = QR", { i(1, "A") }),
        { condition = mathzone }
    ),
    s(
        { trig = "lu", dscr = "LU decomposition" },
        fmta("<> = LU", { i(1, "A") }),
        { condition = mathzone }
    ),
    s(
        { trig = "evd", dscr = "eigenvalue decomposition" },
        fmta("<> = PDP^{-1}", { i(1, "A") }),
        { condition = mathzone }
    ),

    -- Dynamic Systems of Equations
    s(
        { trig = "sysmat_(%d)", dscr = "system of n equations", regTrig = true, wordTrig = false },
        d(1, function(_, snip)
            local num_eqs = tonumber(snip.captures[1])
            
            local nodes = {}
            local eq_strs = {}
            
            for j = 1, num_eqs do
                if j < num_eqs then
                    table.insert(eq_strs, "<> \\\\")
                else
                    table.insert(eq_strs, "<>")
                end
                table.insert(nodes, i(j))
            end
            
            local equations = table.concat(eq_strs, "\n    ")
            local template = string.format("\\begin{cases}\n    %s\n\\end{cases}", equations)
            
            return sn(nil, fmta(template, nodes))
        end),
        { condition = mathzone }
    ),

    -- Basis
    s(
        { trig = "basis", dscr = "basis", snippetType = "autosnippet" },
        fmta("\\{<>\\}", { d(1, get_visual) }),
        { condition = mathzone }
    ),

    -- Gram-Schmidt
    s(
        { trig = "gramsch", dscr = "Gram-Schmidt process" },
        fmta(
            [[
            \mathbf{u}_{<>} = \mathbf{v}_{<>} - \sum_{<>=1}^{<>} \text{proj}_{\mathbf{u}_{<>}}(\mathbf{v}_{<>})
            ]],
            { i(1, "k"), i(1), i(2, "j"), i(3, "k-1"), i(2), i(1) }
        ),
        { condition = mathzone }
    ),
}
