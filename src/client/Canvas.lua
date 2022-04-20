-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement


return function(props)

  local toolDown = props.ToolDown
  local toolMoved = props.ToolMoved
  local toolUp = props.ToolUp

  return e("TextButton", {
    Text = "",
    AutoButtonColor = false,
    Size = UDim2.new(1,0, 1, 0),
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,

    [Roact.Event.MouseButton1Down] = function(rbx, x, y)
      toolDown(x,y-36)
    end,
    [Roact.Event.MouseMoved] = function(rbx, x, y)
      toolMoved(x,y-36)
    end,
    [Roact.Event.MouseButton1Up] = function(rbx, x, y)
      toolUp()
    end,
    [Roact.Event.MouseLeave] = function(rbx)
      toolUp()
    end
  })
end