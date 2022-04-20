-- Services
local Shared = game:GetService("ReplicatedStorage").Common

-- Imports
local Roact = require(Shared.Roact)
local e = Roact.createElement
local App = require(script.Parent.App)

return function( target )
  
  local handle = Roact.mount(e(App), target)

  return function()
    Roact.unmount(handle)
  end
end