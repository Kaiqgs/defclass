# defclass
Lua prototype-based OOP disguised as classes. Lua has no classes. defclass uses metatables to make tables look and feel like them.

When you read `player.name` and `player` doesn't have `name`,
Lua checks the table pointed to by `__index`. That table is your "class".
```
player  __index -->  Player table (methods, defaults)
```
The class is a table fallback.

Inheritance is not directly supported.

## API

```lua
---@param typetbl table
---@return table
defclass.Class(typetbl)
```
Sets up `typetbl` as a prototype. Calling `MyClass(...)` will call `MyClass.new(...)`.

```lua
---@param typeclass table
---@param object table|nil
---@return table
defclass.NewInstance(typeclass, object)
```
Similar to `setmetatable` for now.

## Example

```lua
local defclass = require("defclass.class")

---@class Player
local Player = defclass.Class({ healthpoints = 10 })

---@param name string
---@return Player
function Player.new(name)
    ---@class Player
    local player_data = {
        name = name,
        healthpoints = Player.healthpoints,
        hitpoints = 10,
    }
    return setmetatable(player_data, Player)
end

---@param target Player
function Player:attack(target)
    target.healthpoints = target.healthpoints - self.hitpoints
end

local hero = Player("Dovahkiin")
hero:attack(some_enemy)
```

`Player("Dovahkiin")` triggers `__call`, which calls `Player.new("Dovahkiin")`.

`hero:attack(...)` looks for `attack` on `hero`, doesn't find it,
follows `__index` to `Player`, finds it there.

## Good to know

- Use dot for `new`: `function MyClass.new(...)`.
  `__call` does `cls.new(...)` without passing the class as first argument,
  so colon style `new` would shift all arguments.

- Data you set in `new` lives on the instance.
  Methods you define with `:` live on the class table.
  Writing to an instance never touches the prototype.
