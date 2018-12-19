module Wikipedia

using HTTP, Gumbo, Cascadia
import Cascadia: matchFirst

include("Articles.jl")
using .Articles

const PROTOCOL = "https://"
const DOMAIN_NAME = "en.m.wikipedia.org"
const RANDOM_PAGE_URL = PROTOCOL * DOMAIN_NAME * "/wiki/Special:Random"

export fetchrandom, fetchpage, articleinfo, persistedarticle

# function fetchpage(url)
#   url = startswith(url, "/") ? buildurl(url) : url
#
#   response = HTTP.get(url)
#
#   if response.status == 200 && length(response.body) > 0
#     String(response.body)
#   else
#     ""
#   end
# end

function fetchpage(url)
  url = startswith(url, "/") ? buildurl(url) : url
  response = HTTP.get(url)
  content = if response.status == 200 && length(response.body) > 0
              String(response.body)
            else
              ""
            end
  relative_url = collect(eachmatch(r"/wiki/(.*)$", (response.request.parent == nothing ? url : Dict(response.request.parent.headers)["Location"])))[1].match

  content, relative_url
end


function extractlinks(elem)
  map(eachmatch(Selector("a[href^='/wiki/']:not(a[href*=':'])"), elem)) do e
    e.attributes["href"]
  end |> unique
end

function extracttitle(elem)
  matchFirst(Selector("#section_0"), elem) |> nodeText
end

function extractimage(elem)
  e = matchFirst(Selector(".content a.image img"), elem)
  isa(e, Nothing) ? "" : e.attributes["src"]
end

function extractcontent(elem)
  matchFirst(Selector("#bodyContent"), elem) |> string
end

function fetchrandom()
  fetchpage(RANDOM_PAGE_URL)
end

function articledom(content)
  if ! isempty(content)
    return Gumbo.parsehtml(content)
  end

  error("Article content can not be parsed into DOM")
end

# function articleinfo(content)
#   dom = articledom(content)
#
#   Dict( :content => content,
#         :links => extractlinks(dom.root),
#         :title => extracttitle(dom.root),
#         :image => extractimage(dom.root)
#   )
# end

# function articleinfo(content)
#   dom = articledom(content)
#   Article(content,
#           extractlinks(dom.root),
#           extracttitle(dom.root),
#           extractimage(dom.root))
# end

# function articleinfo(content)
#   dom = articledom(content)
#   (content, extractlinks(dom.root), extracttitle(dom.root), extractimage(dom.root))
# end

function articleinfo(content)
  dom = articledom(content)
  (extractcontent(dom.root), extractlinks(dom.root), extracttitle(dom.root), extractimage(dom.root))
end

function persistedarticle(article_content, url)
  article = Article(articleinfo(article_content)..., url)
  save(article)

  article
end

function buildurl(article_url)
  PROTOCOL * DOMAIN_NAME * article_url
end

end
