-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement


return function(props)

  local leftToolDown = props.LeftToolDown
  local leftToolUp = props.LeftToolUp
  local rightToolDown = props.RightToolDown
  local rightToolUp = props.RightToolUp
  local toolMoved = props.ToolMoved
  local toolPos = props.ToolPos

  return e("TextButton", {
    Text = "",
    AutoButtonColor = false,
    Size = UDim2.new(1,0, 1, 0),
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 0,
    BorderSizePixel = 0,

    [Roact.Event.MouseButton1Down] = function(rbx, x, y)
      leftToolDown(x,y-36)
    end,
    [Roact.Event.MouseButton2Down] = function(rbx, x, y)
      rightToolDown(x,y-36)
    end,
    [Roact.Event.MouseMoved] = function(rbx, x, y)
      toolMoved(x,y-36)
    end,
    [Roact.Event.MouseButton1Up] = function(rbx, x, y)
      leftToolUp()
    end,
    [Roact.Event.MouseButton2Up] = function(rbx, x, y)
      rightToolUp()
    end,
    [Roact.Event.MouseLeave] = function(rbx)
      leftToolUp()
      rightToolUp()
    end, 

    [Roact.Children] = {
      Cursor = toolPos and e("Frame", {
        Size = UDim2.fromOffset(props.CursorRadius * 2, props.CursorRadius * 2),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromOffset(toolPos.X, toolPos.Y+36),
        BackgroundTransparency = 0.5,

        [Roact.Children] = {
          UICorner = e("UICorner", { CornerRadius = UDim.new(0.5,0) })
        }
      }) or nil
    }
  })
end