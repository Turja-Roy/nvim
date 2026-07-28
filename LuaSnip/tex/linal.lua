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

local mat_types = {
    m = "matrix",
    p = "pmatrix",
    b = "bmatrix",
    v = "vmatrix",
    B = "Bmatrix",
    V = "Vmatrix",
}

local function generate_matrix(rows, cols, mat_type, inline)
    local nodes, row_strs, insert_index = {}, {}, 1

    for r = 1, rows do
        local col_strs = {}
        for c = 1, cols do
            table.insert(col_strs, "<>")
            table.insert(nodes, i(insert_index))
            insert_index = insert_index + 1
        end
        table.insert(row_strs, table.concat(col_strs, " & "))
    end

    local row_sep = inline and " \\\\ " or " \\\\\n    "
    local matrix_content = table.concat(row_strs, row_sep)
    local template = inline
        and string.format("\\begin{%s} %s \\end{%s}", mat_type, matrix_content, mat_type)
        or string.format("\\begin{%s} \n    %s \n \\end{%s}", mat_type, matrix_content, mat_type)

    return sn(nil, fmta(template, nodes))
end

local function generate_augmatrix(rows, left_cols, right_cols, inline)
    local total_cols = left_cols + right_cols
    local nodes, row_strs, insert_index = {}, {}, 1

    for r = 1, rows do
        local col_strs = {}
        for c = 1, total_cols do
            table.insert(col_strs, "<>")
            table.insert(nodes, i(insert_index))
            insert_index = insert_index + 1
        end
        table.insert(row_strs, table.concat(col_strs, " & "))
    end

    local col_spec = string.rep("c", left_cols) .. "|" .. string.rep("c", right_cols)
    local row_sep = inline and "\\\\ " or " \\\\\n    "
    local matrix_content = table.concat(row_strs, row_sep)
    local template = inline
        and string.format("\\left[\\begin{array}{%s}%s\\end{array}\\right]", col_spec, matrix_content)
        or string.format("\\left[\\begin{array}{%s}\n    %s\n\\end{array}\\right]", col_spec, matrix_content)

    return sn(nil, fmta(template, nodes))
end

return {
    -- Dynamic Matrices
    s(
        { trig = "([mpbBvV])mat_%d%d", dscr = "dynamic matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(args, parent)
            local t = parent.snippet.env.LS_TRIGGER
            local mat_char = string.match(t, "^([mpbBvV])")
            local inline = false
            local digits = string.match(t, "_([%d]+)$") or string.match(t, "_([%d]+)")
            local rows = tonumber(string.sub(digits, 1, 1))
            local cols = tonumber(string.sub(digits, 2, 2))
            local mat_env = mat_types[mat_char]
            return generate_matrix(rows, cols, mat_env, inline)
        end),
        { condition = mathzone }
    ),

    -- Dynamic Inline Matrices
    s(
        { trig = "([pPbBvV])mati_%d%d", dscr = "dynamic inline matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(args, parent)
            local t = parent.snippet.env.LS_TRIGGER
            local mat_char = string.match(t, "^([pPbBvV])")
            local inline = true
            local digits = string.match(t, "_([%d]+)$") or string.match(t, "_([%d]+)")
            local rows = tonumber(string.sub(digits, 1, 1))
            local cols = tonumber(string.sub(digits, 2, 2))
            local mat_env = mat_types[mat_char]
            return generate_matrix(rows, cols, mat_env, inline)
        end),
        { condition = mathzone }
    ),

    -- Dynamic Augmented Matrix
    s(
        { trig = "amat_%d%d%d", dscr = "augmented matrix", regTrig = true, snippetType = "autosnippet" },
        d(1, function(args, parent)
            local t = parent.snippet.env.LS_TRIGGER
            local digits = string.match(t, "_([%d]+)$") or string.match(t, "_([%d]+)")
            local rows = tonumber(string.sub(digits, 1, 1))
            local lc = tonumber(string.sub(digits, 2, 2))
            local rc = tonumber(string.sub(digits, 3, 3))
            return generate_augmatrix(rows, lc, rc, false)
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
        fmta("<>^{T}", { f(function(_, snip) return snip.captures[1] end) }),
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

    -- Bracket Notation
    s(
        { trig = "bra", dscr = "bra vector", snippetType = "autosnippet" },
        fmta("\\bra{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "ket", dscr = "ket vector", snippetType = "autosnippet" },
        fmta("\\ket{<>}", { d(1, get_visual) }),
        { condition = mathzone }
    ),
    s(
        { trig = "bkt", dscr = "braket", snippetType = "autosnippet" },
        fmta("\\braket{<>}{<>}", { i(1, "U"), i(2, "V") }),
        { condition = mathzone }
    ),
    s(
        { trig = "bkkt", dscr = "braket", snippetType = "autosnippet" },
        fmta("\\bra{<>}<>\\ket{<>}", { i(1, "U"), i(2, "\\Omega"), i(3, "V") }),
        { condition = mathzone }
    ),
}
