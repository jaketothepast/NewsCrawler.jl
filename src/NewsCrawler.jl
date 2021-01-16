module NewsCrawler

import HTTP
using Gumbo
using AbstractTrees

TOUSE = [:div, :p, :cite]

function get_my_content(url)
    get = (url) -> HTTP.request("GET", url)
    (find_text ∘ get_probable_root ∘ parsehtml ∘ String ∘ get)(url)
end

"""
    full_text(sentences)

Join everything together.
"""
function full_text(sentences)
    if isnothing(sentences)
        return nothing
    end

    join(sentences, "")
end

"""
    crawl(urls::Array{String})::Array{Gumbo.HTMLDocument}

Crawl URLs and grab the html from the page.
"""
function crawl(urls::Array{String})
    full_text.(get_my_content.(urls))
end

"""
    get_probable_root(doc::Gumbo.HTMLDocument)::Gumbo.HTMLElement

Get the root article in the document. Based on the assumption that the article
element has the most things in it.
"""
function get_probable_root(doc::Gumbo.HTMLDocument)::Gumbo.HTMLElement
    for node ∈ PreOrderDFS(doc.root)
        tag(node) == :article && return node
    end
    return nothing
end

"""
    find_text(doc::Gumbo.HTMLDocument)

Find text that is in an HTMLDocument, and return a list.
"""
function find_text(doc::Union{Gumbo.HTMLDocument, Gumbo.HTMLElement})
    isnothing(doc) && return nothing
    filter((x) -> !isnothing(x), [extract_text(node) for node ∈ PreOrderDFS(doc)])
end

"""
    tag(elem::Gumbo.HTMLText)

Provide an implementation of tag for text nodes
"""
function tag(elem::Gumbo.HTMLText)
    :text
end

function extract_text(elem::Gumbo.HTMLText)
    tag(elem.parent) ∈ TOUSE && return elem.text
    return nothing
end

extract_text(elem) = nothing

end # module
