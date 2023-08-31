

local config = {"student"}
local rubric_count = 0
local question_count = 0
-- local recommendations_count = 0
local current_header = {""}
local current_letter = ""
local letter_sequence = {
  "", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
  "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
}
-- https://stackoverflow.com/questions/38282234/returning-the-index-of-a-value-in-a-lua-table
local letter_indices = {}
for k, v in pairs(letter_sequence) do
  letter_indices[v] = k
end

local function with_content_removed(el)
  -- quarto.utils.dump(el)
  if el.classes:includes("answer") then
    -- -- quarto.utils.dump(el.classes)
    el.content = "..."
  end
  return el
end

local function with_text_removed(el)
  -- quarto.utils.dump(el)
  if el.classes:includes("answer") then
    -- -- quarto.utils.dump(el.classes)
    el.text = "..."
  end
  return el
end

local function resolveHeadingCaption(div) 
  local capEl = div.content[1]
  if capEl ~= nil and capEl.t == 'Header' then
    div.content:remove(1)
    return capEl.content
  else 
    return nil
  end
end

local function add_question_numbering(el)
  for k, v in pairs(el.content) do
    question_count = question_count + 1
    table.insert(v, 1, pandoc.Strong("Q" ..question_count.. ": "))
  end
  return el
end

function table.copy(t)
  -- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

-- quarto.doc.add_html_dependency({
--   name = 'assignments',
--   stylesheets = {'assignments.css'}
-- })

return {
  {
    Meta = function(meta) 
      local ameta = meta.assignments
      if ameta ~= nil then
        config[1] = ameta[1].text
        quarto.doc.add_html_dependency({
          name = 'assignments',
          stylesheets = {'assignments.css'}
        })

      end
    end
  },{
    Header = function(el)
      if el.level == 1 then
        current_header = el.content
        rubric_count = rubric_count + 1
        current_letter = ""
      end
      -- quarto.utils.dump(el)
      return el
    end,
    Div = function(el)
      local view = config[1]
      if el.classes:includes("hint") then
        local h = resolveHeadingCaption(el)
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier,
        })
        -- table.insert(el.classes, "column-margin")
      elseif el.classes:includes("rubric") then
        -- rubric_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = table.copy(current_header)
        --   -- h = current_header
        end
        table.insert(h, 1, "Rubric S" ..rubric_count.. ": ")
        local w = el.attr.attributes["weight"]
        if w ~= nil then
          table.insert(h, " - " .. el.attr.attributes["weight"] .. "/100 points")
        end
        add_question_numbering(el.content[1])
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = false,
          type = "note",
          id = el.attr.identifier,
        })
      elseif el.classes:includes("subrubric") then
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = table.copy(current_header)
        end
        table.insert(h, 1, "Subrubric " ..(rubric_count).. "."..current_letter..": ")
        local w = el.attr.attributes["weight"]
        if w ~= nil then
          table.insert(h, " - " .. el.attr.attributes["weight"] .. "/100 points")
        end
        add_question_numbering(el.content[1])
        return quarto.Callout({
          appearance = nil,
          title = "Subrubric " ..(rubric_count).. "."..current_letter..")", caption = "Subrubric " ..(rubric_count).. "."..current_letter..")",
          collapse = false,
          content = el.content,
          icon = false,
          type = "note",
          id = el.attr.identifier,
        })
      elseif el.classes:includes("answer") then
        local answer_count = rubric_count
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = table.copy(current_header)
        end
        table.insert(h, 1, "Answer S" ..answer_count..": ")
        -- add_question_numbering(el.content[1])
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = true,
          content = el.content,
          icon = false,
          type = "important",
          id = el.attr.identifier,
        })
      elseif el.classes:includes("subtask") then
        -- local answer_count = rubric_count + 1
        -- local h = resolveHeadingCaption(el)
        -- if h == nil then
        --   h = table.copy(current_header)
        --   -- h = current_header
        -- end
        -- table.insert(h, 1, "Answer S" ..answer_count.. ": ")
        -- add_question_numbering(el.content[1])
        if el.attr.attributes["letter"] == nil then 
          current_letter = letter_sequence[letter_indices[current_letter]+1]
        else
          current_letter = el.attr.attributes["letter"]
        end
        local title = "Task "..(rubric_count)
        if current_letter ~= nil then
          title = "Subtask "..(rubric_count).."."..current_letter..")"
        end
        return quarto.Callout({
          appearance = nil,
          title = title, caption = title,
          collapse = false,
          content = el.content,
          icon = false,
          type = "warning",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("help") then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "Potentially helpful content inside"
        else
          table.insert(h, 1, "Potentially helpful content: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = view~="ta",
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("dev-only") then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "ONLY VISIBLE IN STUDENT HTML (PRE-SUBMISSION)"
        else
          table.insert(h, 1, "ONLY VISIBLE IN STUDENT HTML (PRE-SUBMISSION): ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "warning",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("dev-both") then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "Included in assignment and student HTML"
        else
          table.insert(h, 1, "Included in assignment and student HTML: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("both") and config[1] == "ta" then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "Included in assignment and student submission"
        else
          table.insert(h, 1, "Included in assignment and student submission: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("aalto") and config[1] == "ta" then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "Included in Aalto assignment"
        else
          table.insert(h, 1, "Included in Aalto assignment: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("gsu") and config[1] == "ta" then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "Included in GSU assignment"
        else
          table.insert(h, 1, "Included in GSU assignment: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("showcase") then
        -- local answer_count = rubric_count + 1
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "ONLY VISIBLE IN STUDENT HTML (PRE-SUBMISSION)"
        else
          table.insert(h, 1, "ONLY VISIBLE IN STUDENT HTML (PRE-SUBMISSION): ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "tip",
          id = el.attr.identifier, 
        })
      elseif el.classes:includes("tmpl") then
        local h = resolveHeadingCaption(el)
        if h == nil then
          h = "ONLY VISIBLE IN TEMPLATE" 
        else
          table.insert(h, 1, "ONLY VISIBLE IN TEMPLATE: ")
        end
        return quarto.Callout({
          appearance = nil,
          title = h, caption = h,
          collapse = false,
          content = el.content,
          icon = true,
          type = "warning",
          id = el.attr.identifier, 
        })
      end
      return el
    end
  }
}

