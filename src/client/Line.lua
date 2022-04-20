-- Imports
local Shared = game:GetService("ReplicatedStorage").Common
local Roact = require(Shared.Roact)
local e = Roact.createElement

return function(props)
  local length = (props.Stop - props.Start).Magnitude + (props.Rounded and props.Width or 0)
  local rotation = props.Start == props.Stop and 0 or math.deg(math.atan2((props.Stop - props.Start).Y, (props.Stop-props.Start).X))
  local centre = (props.Start + props.Stop)/2
  
  return e("Folder", {
    -- Size = UDim2.fromOffset(length, props.Width),
    -- AnchorPoint = Vector2.new(0.5,0.5),
    -- Position = UDim2.fromOffset(centre.X, centre.Y),
    -- Rotation = rotation,

    -- BackgroundColor3 = props.Color,
    -- BorderSizePixel = 0,

    -- [Roact.Children] = {
    --   UICorner = props.Rounded and e("UICorner", {
    --     CornerRadius = UDim.new(0.5, 0)
    --   }) or nil
    -- }
  })
end