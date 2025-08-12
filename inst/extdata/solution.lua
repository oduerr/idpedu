-- Quarto filter to conditionally render solution content
-- Supports both inline spans and block divs with classes: solution, lsg, or sol

-- Will be populated from document metadata once
local LSG = false

local function to_bool(v)
  local t = type(v)
  if t == "boolean" then return v end
  if t == "string" then
    local s = v:lower()
    return s == "true" or s == "yes" or s == "1"
  end
  if t == "table" and v.t then
    if v.t == "MetaBool" and v[1] ~= nil then return v[1] end
    if v.t == "MetaString" and v.text then return to_bool(v.text) end
    if v.t == "MetaInlines" then return to_bool(pandoc.utils.stringify(v)) end
  end
  return nil
end

function Meta(meta)
  local b = nil
  if meta and meta.params and meta.params.lsg ~= nil then
    b = to_bool(meta.params.lsg)
  end
  if b == nil and meta and meta.lsg ~= nil then
    b = to_bool(meta.lsg)
  end
  if b == nil and quarto and quarto.doc and quarto.doc.meta then
    local m = quarto.doc.meta
    if m and m.params and m.params.lsg ~= nil then
      b = to_bool(m.params.lsg)
    end
    if b == nil and m and m.lsg ~= nil then
      b = to_bool(m.lsg)
    end
  end
  if b == nil then b = false end
  LSG = b
  return meta
end

local function get_lsg()
  -- Prefer live meta from Quarto if available
  if quarto and quarto.doc and quarto.doc.meta then
    local m = quarto.doc.meta
    local b = nil
    if m and m.params and m.params.lsg ~= nil then
      b = to_bool(m.params.lsg)
    end
    if b == nil and m and m.lsg ~= nil then
      b = to_bool(m.lsg)
    end
    if b ~= nil then return b end
  end
  -- Fallback to env var if provided by caller
  local env = os.getenv('IDPEDU_LSG')
  if env ~= nil then
    local be = to_bool(env)
    if be ~= nil then return be end
  end
  return LSG or false
end

local function is_solution_class(classes)
  return classes:includes('solution') or classes:includes('lsg') or classes:includes('sol')
end

local function is_html_format()
  if quarto and quarto.doc and quarto.doc.is_format then
    if quarto.doc.is_format("html") then return true end
  end
  if FORMAT and type(FORMAT) == "string" then
    return FORMAT:match("html") ~= nil
  end
  return false
end

local function is_pdf_format()
  if quarto and quarto.doc and quarto.doc.is_format then
    if quarto.doc.is_format("pdf") or quarto.doc.is_format("latex") then return true end
  end
  if FORMAT and type(FORMAT) == "string" then
    return FORMAT:match("latex") ~= nil or FORMAT:match("pdf") ~= nil
  end
  return false
end

-- Inline solutions: [ ... ]{.solution}
function Span(el)
  if not is_solution_class(el.classes) then
    return nil
  end

  if not get_lsg() then
    return {} -- drop when lsg is false
  end

  if is_html_format() then
    -- Preserve as span with class so Quarto emits class="solution"
    return pandoc.Span(el.content, el.attr)
  elseif is_pdf_format() then
    -- Leave inline content as-is so it typesets normally (e.g., '42')
    return el.content
  elseif quarto.doc.is_format("gfm") then
    return pandoc.Span(el.content, {class = "solution"})
  end

  return nil
end

-- Block solutions: ::: solution ... :::
function Div(el)
  if not is_solution_class(el.classes) then
    return nil
  end

  if not get_lsg() then
    return {} -- drop when lsg is false
  end

  if is_html_format() then
    -- Keep the div with its classes so it renders as <div class="solution">...</div>
    return el
  elseif is_pdf_format() then
    local open = pandoc.RawBlock('latex', '\\begingroup\\color{blue}')
    local close = pandoc.RawBlock('latex', '\\endgroup')
    local blocks = {open}
    for _, b in ipairs(el.content) do table.insert(blocks, b) end
    table.insert(blocks, close)
    return blocks
  elseif quarto.doc.is_format("gfm") then
    local label = pandoc.Para({pandoc.Strong("Solution:")})
    local blocks = {label}
    for _, b in ipairs(el.content) do table.insert(blocks, b) end
    return blocks
  end

  return nil
end


