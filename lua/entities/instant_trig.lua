AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Instant Trigger"
ENT.Author			= "TFA"
ENT.Contact			= "Don't"
ENT.Purpose			= "MapAdd"
ENT.Instructions	= "Use with keyvalues"

function ENT:Initialize()
    if CLIENT then return end
    self.kv = self:GetKeyValues()
end

function ENT:Think()
    if CLIENT then return end
    local kv = self.kv
    local t = {
        ["origin"] = self:GetPos()
    }
    for k,v in pairs(kv) do
        if k == "label" then
            t.labels = string.Explode(":",v)
        elseif k == "timer" then 
            t.expireTime = CurTime() + v
        else
            t[k] = v
        end
    end
    if t.radius and not t.touchname then
        t.touchname = "player"
    end
    table.insert(MapAdd.Triggers,result)
    self:Remove()
    self:Remove()
end

function ENT:Draw()
end