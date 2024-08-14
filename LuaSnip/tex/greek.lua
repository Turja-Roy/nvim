local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local greek_latex = {
    a = "\\alpha", b = "\\beta", g = "\\gamma", d = "\\delta", e = "\\epsilon",
    z = "\\zeta", h = "\\eta", q = "\\theta", i = "\\iota", k = "\\kappa",
    l = "\\lambda", m = "\\mu", n = "\\nu", x = "\\xi", o = "\\omicron",
    p = "\\pi", r = "\\rho", s = "\\sigma", t = "\\tau", u = "\\upsilon",
    f = "\\phi", c = "\\chi", y = "\\psi", w = "\\omega",
    A = "\\Alpha", B = "\\Beta", G = "\\Gamma", D = "\\Delta", E = "\\Epsilon",
    Z = "\\Zeta", H = "\\Eta", Q = "\\Theta", I = "\\Iota", K = "\\Kappa",
    L = "\\Lambda", M = "\\Mu", N = "\\Nu", X = "\\Xi", O = "\\Omicron",
    P = "\\Pi", R = "\\Rho", S = "\\Sigma", T = "\\Tau", U = "\\Upsilon",
    F = "\\Phi", C = "\\Chi", Y = "\\Psi", W = "\\Omega",

    ve = "\\varepsilon", vt = "\\vartheta", vp = "\\varpi", vr = "\\varrho",
    vs = "\\varsigma", vf = "\\varphi", vG = "\\varGamma", vD = "\\varDelta",
    vQ = "\\varTheta", vL = "\\varLambda", vX = "\\varXi", vP = "\\varPi",
    vS = "\\varSigma", vU = "\\varUpsilon", vF = "\\varPhi", vY = "\\varPsi",
    vW = "\\varOmega",
}

local greek_snippets = {}
for key, value in pairs(greek_latex) do
    table.insert(
        greek_snippets,
        s(
            { trig = ";"..key, snippetType="autosnippet" },
            { t(value) }
        )
    )
    table.insert(
        greek_snippets,
        s(
            { trig = "@"..key },
            { t(value) }
        )
    )
end

return greek_snippets
