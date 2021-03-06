-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement

local Line = require(script.Parent.Line)

local SECTION_LENGTH = 100

local SubCurve = Roact.PureComponent:extend("SubCurve")

function SubCurve:render()
  local points = self.props.Points
  local firstIndex = self.props.FirstIndex
  local lastIndex = self.props.LastIndex
  local elements = {}
  
  for i=firstIndex, lastIndex-1 do
    elements[i] = self.props.Mask[i] and e(Line, {
      Start = points[i],
      Stop = points[i+1],
      Width = self.props.Width,
      Color = self.props.Color,
      Rounded = self.props.Rounded,
    }) or nil
  end

  return e("ScreenGui", {}, elements)
end

function SubCurve:shouldUpdate(newProps, newState)
  if newProps.FirstIndex ~= self.props.FirstIndex then return true end
  if newProps.LastIndex ~= self.props.LastIndex then return true end
  if newProps.Width ~= self.props.Width then return true end
  if newProps.Color ~= self.props.Color then return true end
  if newProps.Rounded ~= self.props.Rounded then return true end

  for i=self.props.FirstIndex, self.props.LastIndex do
    if newProps.Points[i] ~= self.props.Points[i] then return true end
    if i < self.props.LastIndex and newProps.Mask[i] ~= self.props.Mask[i] then return true end
  end

  return false
end

local Curve = Roact.PureComponent:extend("Curve")

function Curve:render()
  local points = self.props.Points
  local onlyLastSubCurveActive = self.props.OnlyLastSubCurveActive or false
  local elements = {}

  local i = 1
  local n = #points

  while i * SECTION_LENGTH < n do
    elements[i] = e(SubCurve, {
      Points = points,
      FirstIndex = (i-1) * SECTION_LENGTH + (if i == 1 then 1 else 0),
      LastIndex = i * SECTION_LENGTH,
      Width = self.props.Width,
      Color = self.props.Color,
      Rounded = self.props.Rounded,
      Active = onlyLastSubCurveActive,
      Mask = self.props.Mask
    })
    i += 1
  end
  
  elements[i] = e(SubCurve, {
    Points = points,
    FirstIndex = (i-1) * SECTION_LENGTH + (if i == 1 then 1 else 0),
    LastIndex = n,
    Width = self.props.Width,
    Color = self.props.Color,
    Rounded = self.props.Rounded,
    Active = true,
    Mask = self.props.Mask
  })

  return e("Folder", {}, elements)
end

return Curve