-- https://github.com/kikito/inspect.lua
local inspect = require 'inspect'
-- https://bookdown.org/yihui/rmarkdown-cookbook/lua-filters.html
function Header(el)
    -- The header level can be accessed via the attribute 'level'
    -- of the element. See the Pandoc documentation later.
    if (el.level <= 1) then
        -- return Span("")
    end
    el.classes = {}
    -- if el.classes:includes("unnumbered") then
    --     el.level = 3
    -- end
    el.level = el.level - 1
    return el
  end

-- function BulletList(el)
--     el.classes = {"tight"}
--     -- print(inspect(el))
--     return el
-- end