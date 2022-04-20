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

local App = Roact.Component:extend("App")

function App:init()
  self:setState({
    Curves = {},
    CurrentCurveId = Roact.None,
    ZIndex = 0,
    Held = false,
  })
end

function App:render()
  local curves = self.state.Curves
  local currentCurveId = self.state.CurrentCurveId
  local zIndex = self.state.ZIndex
  local held = self.state.Held
  
  local canvas = e(Canvas, {
    
    ToolDown = function(x,y)
      
      local newCurveId = HttpService:GenerateGUID(false)
      local newCurve = {
        ZIndex = zIndex,
        Points = {Vector2.new(x,y)}
      }
      
      local newCurves = Dictionary.merge(curves, {
        [newCurveId] = newCurve
      })

      debug.profilebegin("ToolDownSetState")
      self:setState({
        CurrentCurveId = newCurveId,
        Curves = newCurves,
        ZIndex = zIndex + 1,
        Held = true,
      })
      debug.profileend()
    end,

    ToolMoved = function(x,y)
      if held then
        local currentCurve = curves[currentCurveId]
        
        local extendedPoints = table.clone(currentCurve.Points)
        table.insert(extendedPoints, Vector2.new(x,y))
        
        local extendedCurve = {
          ZIndex = currentCurve.ZIndex,
          Points = extendedPoints
        }
        
        local newCurves = Dictionary.merge(curves, {
          [currentCurveId] = extendedCurve
        })

        debug.profilebegin("ToolMovedSetState")
        self:setState({
          Curves = newCurves,
        })
        debug.profileend()
      end
    end,

    ToolUp = function()
      self:setState({
        Held = false
      })
    end,
  })

  local curveElements = {}
  for curveId, curve in pairs(curves) do
    curveElements[curveId] = e(Curve, {
      Points = curve.Points,
      Width = 5,
      Color = Color3.new(0,0,0),
      Rounded = true,
      ZIndex = curve.ZIndex
    })
  end

  return e("Folder", {}, {
    Curves = e("Folder", {}, curveElements),
    UI = e("ScreenGui", {
      IgnoreGuiInset = true,
    }, {
      Canvas = canvas
    })
  })
end

return App