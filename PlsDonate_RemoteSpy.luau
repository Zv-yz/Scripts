--[[
    @Name          PD RemoteSpy
    @Author        Zv_yz
--]]

if not game:IsLoaded() then game.Loaded:Wait(); end
if game.GameId ~= 3317679266 then return; end
if getgenv().PD_LOADED then return; end

getgenv().PD_LOADED = true
pcall(rconsoleclear) -- Potassium func
pcall(rconsolecreate) -- also potassium func
rconsolename("Pls Donate - Remote Spy")

local Serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zv-yz/Scripts/refs/heads/Rework/Modules/Serializer.luau"))();
local Remotes = require(game:GetService("ReplicatedStorage"):WaitForChild("Remotes", math.huge));

local OldFunction = clonefunction(Remotes.Function)
local OldClientEvent = clonefunction(Remotes.OnClientEvent)

function Print(Remote: string, Method: string, ...)
	local Args = {...};

	rconsoleprint(
		string.format("\n\nName: %s\nMethod: %s\nArguments: %s",
			tostring(Remote),
			tostring(Method),
			Serializer(Args, { Prettify = true })
		));
end

Remotes.Function = function(Name: string)
	local Proxy = OldFunction(Name);
	local Meta = getmetatable(Proxy);

	if Meta and Meta.__index then
		local OrgIndex = Meta.__index;

		Meta.__index = function(self, Key: string)
			local Func = OrgIndex[self] or OrgIndex[Key];

			if Key == "InvokeClient" or Key == "InvokeServer" then
				return function(self, ...)
					Print(Name, Key, table.unpack({...}));
					return Func(self, ...);
				end
			end

			return Func;
		end
	end

	return Proxy;
end

Remotes.OnClientEvent = function(Name: string)
	local Proxy = OldClientEvent(Name);
	local OrgFunc = clonefunction(Proxy.Connect);

	Proxy.Connect = function(self, Callback)
		return OrgFunc(self, function(...)
			Print(Name, "OnClientEvent", ...);
			Callback(...);
		end)
	end

	return Proxy;
end
