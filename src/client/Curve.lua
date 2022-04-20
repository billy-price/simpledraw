-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement

local Line = require(script.Parent.Line)

return function(props)
  local points = props.Points
  local elements = {}
  
  for i=1, #points-1 do
    elements[i] = e(Line, {
      Start = points[i],
      Stop = points[i+1],
      Width = props.Width,
      Color = props.Color,
      Rounded = props.Rounded
    }) or nil
  end

  return e("Folder", {}, elements)
end