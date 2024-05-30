function Div(el)
  local lsg = false
  
  -- Check if quarto.doc.meta and params.lsg are available
  if quarto and quarto.doc and quarto.doc.meta and quarto.doc.meta.params and quarto.doc.meta.params.lsg then
    lsg = quarto.doc.meta.params.lsg
  end
  
  -- Process solution divs based on the lsg parameter
  if el.classes:includes('solution') and lsg then
    if quarto.doc.is_format("html") then
      return pandoc.RawBlock('html', '<details><summary>Solution</summary>' .. pandoc.utils.stringify(el) .. '</details>')
    elseif quarto.doc.is_format("pdf") then
      return pandoc.RawBlock('latex', '\\begin{solution}' .. pandoc.utils.stringify(el) .. '\\end{solution}')
    elseif quarto.doc.is_format("gfm") then
      return pandoc.Para({pandoc.Strong("Solution:"), pandoc.Space(), pandoc.utils.stringify(el)})
    end
  end
end
