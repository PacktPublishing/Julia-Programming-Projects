using HTTP, Gumbo

const PAGE_URL = "https://en.wikipedia.org/wiki/Julia_(programming_language)"
const LINKS = String[]

function fetch_page(url)
  response = HTTP.get(url)
  if response.status == 200 && parse(response.headers["Content-Length"]) > 0
    readstring(response.body)
  else
    ""
  end
end

function extract_links(elem)
  if  isa(elem, HTMLElement) &&
      tag(elem) == :a &&
      in("href", collect(keys(attrs(elem))))
        url = getattr(elem, "href")
        startswith(url, "/wiki/") && ! contains(url, ":") && push!(LINKS, url)
  end

  for child in children(elem)
    extract_links(child)
  end
end

content = fetch_page(PAGE_URL)

if ! isempty(content)
  dom = Gumbo.parsehtml(content)

  extract_links(dom.root)
end

display(unique(LINKS))