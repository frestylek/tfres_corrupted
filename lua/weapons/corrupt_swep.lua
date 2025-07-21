AddCSLuaFile()
SWEP.Category = "Corrupted"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.HoldType = "normal"
SWEP.PrintName = "Corruption"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.holding = 0
SWEP.MaxHolding = 50
SWEP.IconOverride = "entities/corrupt_swep"
function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
    if IsValid(self:GetOwner()) then self:GetOwner():SetMaterial("gmod_shader_guide/example6") end
    self:EmitSound("corruption.wav")
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    local tr = owner:GetEyeTrace()
    local ent = tr.Entity
    if not IsValid(ent) then return end
    if not ent:IsPlayer() and not ent:IsNPC() then return end
    if ent:IsNPC() then ent:SetMaterial("gmod_shader_guide/example6") ent:SetHealth(-1) ent:TakeDamage(1,owner) return end
        
        
    if ent:GetPos():DistToSqr(owner:GetPos()) > 200 * 200 then -- 200 units range
        return
    end

    if ent:GetMaterial() == "gmod_shader_guide/example6" then return end
    -- Give the target player the corrupted swep if they don't have it
    if not ent:HasWeapon(self:GetClass()) then
        ent:Give(self:GetClass())
        ent:SelectWeapon(self:GetClass())
        ent:SetMaterial("gmod_shader_guide/example6")
        self:EmitSound("corruption.wav")
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

if SERVER then
    function SWEP:Think()
        local owner = self:GetOwner()
        if not IsValid(owner) or not owner:Alive() then return end
        for _, ent in ipairs(ents.FindInSphere(owner:GetPos(), 40)) do
            if ent ~= owner and not ent:IsPlayer() and ent.SetMaterial then
                if ent:IsWorld() then continue end
                -- Pomijaj jeśli nie jest propem (prop_physics, prop_ragdoll, prop_dynamic, gmod_*, sent_*, npc_*)
                local class = ent:GetClass()
                if (class:find("^gmod_") or class:find("^sent_") or class:find("^npc_") or ent:IsWeapon()) then continue end
                -- Pomijaj jeśli jest podmodelem gracza bez tekstury
                if IsValid(ent:GetParent()) and ent:GetParent():IsPlayer() and ent:GetParent():GetMaterial() ~= "gmod_shader_guide/example6" then continue end
                if IsValid(ent:GetParent()) and IsValid(ent:GetParent():GetParent()) and ent:GetParent():GetParent():IsPlayer() and ent:GetParent():GetParent():GetMaterial() ~= "gmod_shader_guide/example6" then continue end
                if ent:GetMaterial() == "gmod_shader_guide/example6" then continue end
                local min1, max1 = owner:WorldSpaceAABB()
                local min2, max2 = ent:WorldSpaceAABB()
                if max1.x > min2.x and min1.x < max2.x and max1.y > min2.y and min1.y < max2.y and max1.z > min2.z and min1.z < max2.z then
                    ent:SetMaterial("gmod_shader_guide/example6")
                    ent:EmitSound("corruption.wav", 80, nil, nil, CHAN_AUTO)
                    if !IsValid(ent:GetParent()) or !ent:GetParent():IsPlayer() then
                        if IsValid(ent:GetParent()) and IsValid(ent:GetParent():GetParent()) and ent:GetParent():GetParent():IsPlayer() then continue end
                        timer.Simple(30, function() if IsValid(ent) then ent:SetMaterial() end end)
                    end
                end
            end
        end
    end
end

function SWEP:Equip(ply)
    if CLIENT then return end
    if IsValid(ply) then ply:SetMaterial("gmod_shader_guide/example6") end
end

function SWEP:Deploy()
    if CLIENT then return end
    if IsValid(self:GetOwner()) then self:GetOwner():SetMaterial("gmod_shader_guide/example6") end
end

function SWEP:OnRemove()
    if IsValid(self:GetOwner()) then self:GetOwner():SetMaterial() end
    if self.s then self:StopLoopingSound(self.s) end
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Holster(wep)
    return true
end