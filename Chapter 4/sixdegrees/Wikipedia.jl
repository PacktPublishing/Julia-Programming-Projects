module Wikipedia

using HTTP, Gumbo, Cascadia
import Cascadia: matchFirst

include("Articles.jl")
using .Articles

const PROTOCOL = "https://"
const DOMAIN_NAME = "en.m.wikipedia.org"
const RANDOM_PAGE_URL = PROTOCOL * DOMAIN_NAME * "/wiki/Special:Random"

export fetch_random, fetch_page, article_info, persisted_article

function fetch_page(url)
  url = startswith(url, "/") ? build_url(url) : url

  response = HTTP.get(url)

  content = if response.status == 200 && response.body.len > 0
              readstring(response.body)
            else 
              ""
            end
  
  relative_url = matchall(r"/wiki/(.*)$", (isempty(response.history) ? url : response.history[end].headers["Location"]))[1]
  
  content, relative_url
end

function extract_links(elem)
  map(matchall(Selector("a[href^='/wiki/']:not(a[href*=':'])"), elem)) do e
    e.attributes["href"]
  end |> unique
end

function extract_title(elem)
  matchFirst(Selector("#section_0"), elem) |> nodeText
end

function extract_image(elem)
  e = matchFirst(Selector(".content a.image img"), elem)
  isa(e, Void) ? "" : e.attributes["src"]
end

function fetch_random()
  fetch_page(RANDOM_PAGE_URL)
end

function article_dom(content)
  if ! isempty(content)
    return Gumbo.parsehtml(content)
  end

  error("Article content can not be parsed into DOM")
end

function article_info(content)
  dom = article_dom(content)
  (content, extract_links(dom.root), extract_title(dom.root), extract_image(dom.root))
end

function build_url(article_url)
  PROTOCOL * DOMAIN_NAME * article_url
end

function persisted_article(article_content, url)
  article = Article(article_info(article_content)..., url)
  save(article)

  article
end

end