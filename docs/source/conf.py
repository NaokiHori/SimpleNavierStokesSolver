# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
# sys.path.insert(0, os.path.abspath("."))


# -- Project information -----------------------------------------------------

project = "Simple Navier-Stokes Solver"
copyright = "2022, Naoki Hori"
author = "Naoki Hori"

# The full version, including alpha/beta/rc tags
release = "1.0"


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named "sphinx.ext.*") or your custom
# ones.
sys.path.append(os.path.abspath("./ext"))
extensions = [
        "myliteralinclude",
        "details",
        "sphinx.ext.mathjax",
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ["_templates"]

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "alabaster"
html_theme_options = {
    "fixed_sidebar": "true",
    "github_user": "NaokiHori",
    "github_repo": "SimpleNavierStokesSolver",
    "github_type": "true",
}


# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ["_static"]

rst_prolog = """
.. role:: c-lang(code)
    :language: c
.. role:: python(code)
    :language: python
.. role:: sh(code)
    :language: sh
"""

mathjax_path = "https://cdn.jsdelivr.net/npm/mathjax@2/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
mathjax3_config = {
    "TeX": {
        "Macros": {
            "der": ["{\\frac{\\partial #1}{\\partial #2}}", 2], # derivative
            "dder": ["{\\frac{\\delta #1}{\\delta #2}}", 2],    # discrete derivative
            "mst": ["{\\gamma^{#1 #2}}", 2], # mesh skewness tensor
            "gx": ["{\\xi}"],
            "gy": ["{\\eta}"],
            "ux": ["{u_x}"],
            "uy": ["{u_y}"],
            "intrp": ["{\\overline{#1}^{#2}}", 2], # interpolation
            "diffe": ["{\\delta_{#2} {#1}}", 2],   # differentiation
            "vat": ["{\\left. {#1} \\right|_{#2}}", 2], # value at
            "ave": ["{\\left\\langle {#1} \\right\\rangle_{#2}}", 2],
            # indices, pressure, x-face, y-face in two directions
            "pimm": ["i-1           "],
            "pim":  ["i-\\frac{1}{2}"],
            "pic":  ["i             "],
            "pip":  ["i+\\frac{1}{2}"],
            "pipp": ["i+1           "],
            "pjmm": ["j-1           "],
            "pjm":  ["j-\\frac{1}{2}"],
            "pjc":  ["j             "],
            "pjp":  ["j+\\frac{1}{2}"],
            "pjpp": ["j+1           "],
            "ximm": ["i-\\frac{1}{2}"],
            "xim":  ["i             "],
            "xic":  ["i+\\frac{1}{2}"],
            "xip":  ["i+1           "],
            "xipp": ["i+\\frac{3}{2}"],
            "xjmm": ["j-1           "],
            "xjm":  ["j-\\frac{1}{2}"],
            "xjc":  ["j             "],
            "xjp":  ["j+\\frac{1}{2}"],
            "xjpp": ["j+1           "],
            "yimm": ["i-1           "],
            "yim":  ["i-\\frac{1}{2}"],
            "yic":  ["i             "],
            "yip":  ["i+\\frac{1}{2}"],
            "yipp": ["i+1           "],
            "yjmm": ["j-\\frac{1}{2}"],
            "yjm":  ["j             "],
            "yjc":  ["j+\\frac{1}{2}"],
            "yjp":  ["j+1           "],
            "yjpp": ["j+\\frac{3}{2}"],
            "dintrpa": ["{\\overline{#1}^{#2}}", 2],   # discrete arithmetic average
            "dintrpv": ["{\\widehat {#1}^{#2}}", 2],   # discrete volume average
            "dintrpu": ["{\\widetilde {#1}^{#2}}", 2], # discrete average, unknown
        }
    }
}

