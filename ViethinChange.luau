local self = {}
local Storage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer;
local DefaultTable = {
    BoolValue = true;
    StringValue = string.rep("Zv_yz - https://discord.gg/Wgw9uG2CPJ | ", 5);
    NumberValue = -math.huge;
    IntValue = -math.huge;
}

shared.Viethin = shared.Viethin or {
    Pending = false,
    Key = nil,
    Connections = {},

    Remotes = {}
}

-- [[ Functions ]] --
local function FindRemote(Name, Class)
    for _, Item in ipairs(Storage:GetDescendants()) do
        if Item:IsA(Class) and tostring(Item) == tostring(Name) then
            return Item
        end
    end

    return nil
end

local function CreateHint(Text, Timer)
    local Hint = Instance.new("Hint")
    Hint.Name = HttpService:GenerateGUID(false)
    Hint.Text = Text
    Hint.Parent = workspace

    task.wait(Timer)
    Hint:Destroy()
end

-- [[ Main ]] --
local Remotes = {
    GetKey = shared.Viethin.Remotes["Change"] or FindRemote("SendKey", "RemoteEvent");
    Change = shared.Viethin.Remotes["Change"] or FindRemote("ChangeVal", "RemoteEvent")
}

if not Remotes["GetKey"] or not Remotes["Change"] then
    CreateHint("Viethin não encontrado, se foi um erro por favor encontre contato com \"zv_yz\"", 7)
    return
end

shared.Viethin.Remotes["GetKey"] = Remotes.GetKey;
shared.Viethin.Remotes["Change"] = Remotes.Change;

if not shared.Viethin.Connections["Receiver"] then
    shared.Viethin.Connections["Receiver"] = shared.Viethin.Remotes["GetKey"].OnClientEvent:Connect(function(Key: string)
        shared.Viethin.Key = Key;
    end);

    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end

shared.Viethin.Pending = false

function self:Change(Table)
    if shared.Viethin.Pending then return end;
    shared.Viethin.Pending = true;

    repeat
        task.wait()
    until shared.Viethin.Key ~= nil;

    Table = Table or DefaultTable

    for Key, Value in pairs(DefaultTable) do
        if Table[Key] == nil then
            Table[Key] = Value
        end
    end

    for _, Item in ipairs(game:GetDescendants()) do
        if Table[Item.ClassName] then
            pcall(task.spawn, shared.Viethin.Remotes["Change"].FireServer, shared.Viethin.Remotes["Change"], shared.Viethin.Key, Item, Table[Item.ClassName]);
        end
    end

    shared.Viethin.Pending = false;
end

return self;