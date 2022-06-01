-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement

local Line = require(script.Parent.Line)
local CatRom = require(Shared.CatRom)

local SECTION_LENGTH = 4
local FACTOR = 1

local SubCatRomCurve = Roact.PureComponent:extend("SubCatRomCurve")

function SubCatRomCurve:render()
  local points = self.props.Points
  local firstIndex = self.props.FirstIndex
  local lastIndex = self.props.LastIndex
  local elements = {}
  
  local subsectionPoints = {}
  table.move(points, firstIndex, lastIndex, 1, subsectionPoints)
  local catRom = CatRom.new(subsectionPoints)

  local n = FACTOR * #points
  
  for i=0, n-1 do
    elements[i] = e(Line, {
      Start = catRom:SolvePosition(i / n),
      Stop = catRom:SolvePosition((i+1) / n),
      Width = self.props.Width,
      Color = self.props.Color,
      Rounded = self.props.Rounded,
    })
  end

  return e("ScreenGui", {}, elements)
end

function SubCatRomCurve:shouldUpdate(newProps, newState)
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

local CatRomCurve = Roact.PureComponent:extend("CatRomCurve")

function CatRomCurve:render()
  local points = self.props.Points
  local onlyLastSubCurveActive = self.props.OnlyLastSubCurveActive or false
  local elements = {}

  local i = 1
  local n = #points

  local color = Color3.new(1,0,0)

  while i * SECTION_LENGTH < n do
    elements[i] = e(SubCatRomCurve, {
      Points = points,
      FirstIndex = (i-1) * SECTION_LENGTH + (if i == 1 then 1 else 0),
      LastIndex = i * SECTION_LENGTH,
      Width = self.props.Width,
      Color = color,
      Rounded = self.props.Rounded,
      Active = onlyLastSubCurveActive,
      Mask = self.props.Mask
    })
    i += 1
    color = color ==Color3.new(1,0,0) and Color3.new(0,0,1) or Color3.new(1,0,0)
  end
  
  elements[i] = e(SubCatRomCurve, {
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

return CatRomCurve