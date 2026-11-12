-- Show R Markdown style chunks (```{r name}) as plain, highlighted R code.
-- The site is rendered without R (engine: markdown); students run the chunks in RStudio.
function CodeBlock(el)
  local first = el.classes[1]
  if first and first:match("^{r") then
    el.classes = pandoc.List({"r"})
    el.attributes = {}
  end
  return el
end
