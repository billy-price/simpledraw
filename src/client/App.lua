-- Services
local Shared = game:GetService("ReplicatedStorage").Common
local HttpService = game:GetService("HttpService")

-- Imports
local Roact = require(Shared.Roact)
local e = Roact.createElement
local Llama = require(Shared.Llama)
local Dictionary = Llama.Dictionary

-- Components
local Canvas = require(script.Parent.Canvas)
local Curve = require(script.Parent.Curve)
local CatRomCurve = require(script.Parent.CatRomCurve)

local RED = Color3.new(1,0,0)
local BLUE = Color3.new(0,0,1)
local RADIUS = 100
local WIDTH = 2

local App = Roact.Component:extend("App")

function App:init()
  self:setState({
    Curves = {},
    CurrentCurveId = Roact.None,
    ZIndex = 0,
    Held = false,
    RightHeld = false,
    Color = RED,
    ToolPos = nil
  })
end

local function intersects(line, centre, radius)
  -- Vector from the start of the line to pos
	local u = centre - line.Start
	-- Vector from the start of the line to the end of the line
	local v = line.Stop - line.Start
	
	-- the magnitude (with sign) of the projection of u onto v
	local m = u:Dot(v.Unit)

	if m <= 0 or line.Start == line.Stop then
		-- The closest point on the line to pos is lineInfo.Start
		return u.Magnitude <= radius + line.Width/2
	elseif m >= v.Magnitude then
		-- The closest point on the line to pos is lineInfo.Stop
		return (centre - line.Stop).Magnitude <= radius + line.Width/2
	else
		-- The vector from pos to it's closest point on the line makes a perpendicular with the line
		return math.abs(u:Cross(v.Unit)) <= radius + line.Width/2
	end
end

local function eraseAt(self, curves, x, y)
  local changedCurves = {}

  for curveId, curve in pairs(curves) do
    curve = changedCurves[curveId] or curve

    for i=1, #curve.Points-1 do
      if curve.Mask[i] and intersects({
        Start = curve.Points[i],
        Stop = curve.Points[i+1],
        Width = WIDTH,
      }, Vector2.new(x,y), RADIUS) then

        local newMask = table.clone(curve.Mask)
        newMask[i] = false

        curve = Dictionary.merge(curve, {
          Mask = newMask
        })
      end
    end

    changedCurves[curveId] = curve

  end

  self:setState({
    Curves = Dictionary.merge(curves, changedCurves)
  })
end

function App:render()
  local curves = self.state.Curves
  local currentCurveId = self.state.CurrentCurveId
  local zIndex = self.state.ZIndex
  local held = self.state.Held
  local rightHeld = self.state.RightHeld
  local color = self.state.Color
  
  local canvas = e(Canvas, {

    ToolPos = self.state.ToolPos,
    CursorRadius = RADIUS,
    
    LeftToolDown = function(x,y)
      
      local newCurveId = HttpService:GenerateGUID(false)
      local newCurve = {
        ZIndex = zIndex,
        Points = {Vector2.new(x,y)},
        Color = color,
        Mask = {},
        Width = WIDTH
      }
      
      local newCurves = Dictionary.merge(curves, {
        [newCurveId] = newCurve
      })

      self:setState({
        CurrentCurveId = newCurveId,
        Curves = newCurves,
        ZIndex = zIndex + 1,
        Held = true,
      })
    end,

    RightToolDown = function(x,y)
      eraseAt(self, curves, x, y)
      self:setState({
        RightHeld = true
      })
    end,

    ToolMoved = function(x,y)
      if held then
        local currentCurve = curves[currentCurveId]
        
        local extendedPoints = table.clone(currentCurve.Points)
        table.insert(extendedPoints, Vector2.new(x,y))
        
        local extendedMask = table.clone(currentCurve.Mask)
        table.insert(extendedMask, true)
        
        local extendedCurve = Dictionary.merge(currentCurve, {
          Points = extendedPoints,
          Mask = extendedMask,
        })
        
        local newCurves = Dictionary.merge(curves, {
          [currentCurveId] = extendedCurve
        })

        self:setState({
          Curves = newCurves,
        })
      end

      if rightHeld then
        eraseAt(self, curves, x, y)
      end

      self:setState({
        ToolPos = Vector2.new(x,y)
      })
    end,

    LeftToolUp = function()
      self:setState({
        Held = false,
        CurrentCurveId = Roact.None,
        Color = color == RED and BLUE or RED
      })
    end,

    RightToolUp = function()
      self:setState({
        RightHeld = false,
      })
    end,
  })

  local curveElements = {}
  for curveId, curve in pairs(curves) do
    curveElements[curveId] = e(CatRomCurve, {
      Points = curve.Points,
      Width = curve.Width,
      Color = curve.Color,
      Rounded = true,
      ZIndex = curve.ZIndex,
      Mask = curve.Mask
    })
  end

  return e("Folder", {}, {
    UI = e("ScreenGui", {
      IgnoreGuiInset = true,
    }, {
      Canvas = canvas,
      Curves = e("Folder", {}, curveElements),
    })
  })
end


return App