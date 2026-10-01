-- {{< dw CHART_ID height=400 title="..." >}}

local function escape_attr(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

return {
  ["dw"] = function(args, kwargs)
    local id = pandoc.utils.stringify(args[1] or "")
    if id == "TODO" then
      return pandoc.Span("Dieses Chart folgt noch.", {class = "dw-placeholder"})
    end
    if not id:match("^%w+$") then
      error("dw shortcode: ungültige Datawrapper-ID '" .. id .. "'")
    end

    local height = pandoc.utils.stringify(kwargs["height"] or "")
    if not height:match("^%d+$") then height = "400" end

    local title = pandoc.utils.stringify(kwargs["title"] or "")
    if title == "" then title = "Datawrapper-Grafik" end

    -- without version number Datawrapper serves the latest published version
    local url = "https://datawrapper.dwcdn.net/" .. id .. "/"

    if not quarto.doc.is_format("html") then
      return pandoc.Link(title, url)
    end

    return pandoc.RawInline("html", string.format(
      '<iframe title="%s" data-dw-src="%s" src="about:blank" scrolling="no" frameborder="0" style="width: 100%%; border: none;" height="%s"></iframe>',
      escape_attr(title), url, height
    ))
  end
}
