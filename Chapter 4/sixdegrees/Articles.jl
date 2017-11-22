module Articles

export Article, save, find

using Database, MySQL, DataFrames, JSON

struct Article
  content::String
  links::Vector{String}
  title::String
  image::String
  url::String

  Article(; content = "", links = String[], title = "", image = "", url = "") = new(content, links, title, image, url)
  Article(content, links, title, image, url) = new(content, links, title, image, url)
end

function find(url) :: Vector{Article}
  mysql_stmt_prepare(CONN, "SELECT * FROM `articles` WHERE url = ?")
  result = mysql_execute(CONN, [MYSQL_TYPE_VARCHAR], [url])

  articles = Article[]
  for row in eachrow(result)
    push!(articles, Article(row[:content], JSON.parse(row[:links]), row[:title], row[:image], row[:url]))
  end

  articles
end

function save(a::Article)
  sql = "INSERT IGNORE INTO `articles` (title, content, links, image, url) VALUES (?, ?, ?, ?, ?)"
  mysql_stmt_prepare(CONN, sql)
  result = mysql_execute( CONN, 
                          [MYSQL_TYPE_VARCHAR, MYSQL_TYPE_STRING, MYSQL_TYPE_STRING, MYSQL_TYPE_VARCHAR, MYSQL_TYPE_VARCHAR], 
                          [a.title, a.content, JSON.json(a.links), a.image, a.url]
                        )
end

function create_table()
  sql = """
    CREATE TABLE `articles` (
      `title` varchar(1000),
      `content` text,
      `links` text,
      `image` varchar(500),
      `url` varchar(500),
      UNIQUE KEY `url` (`url`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
  """

  mysql_execute(CONN, sql)
end

end