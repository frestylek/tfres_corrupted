
-----------------------------------------------------------
------------------------ Example 6 ------------------------
-----------------------------------------------------------
local material6 = Material("gmod_shader_guide/example6.vmt")
local dummy_model = ClientsideModel("models/shadertest/vertexlit.mdl")
dummy_model:SetModelScale(0)	-- make it invisible
local function set_vertex_metadata(x, y, z)
	-- make sure to supress engine lighting before setting it up, otherwise we won't override anything
	render.SuppressEngineLighting(true)

	render.SetModelLighting(0, x, y, z)
	material6:SetFloat("$c0_x", CurTime())
	-- Forces sourceengine to set up our custom lighting
	dummy_model:DrawModel()
	dummy_model:SetPos(LocalPlayer():EyePos() + LocalPlayer():GetForward() * 0)

	-- Don't forget to reenable lighting!
	render.SuppressEngineLighting(false)
end
CORRUPTrendermanual = {}
local dontmakeitlag = CurTime()
hook.Add("PreDrawOpaqueRenderables", "corruptplayer", function(_, _, sky3d)
	if dontmakeitlag > CurTime() then return end
	dontmakeitlag = CurTime() + 2
	for v,k in ipairs(ents.GetAll()) do
		if IsValid(k) and k:GetMaterial() == "gmod_shader_guide/example6" then
			if k:IsPlayer() then continue end
			if k:GetNoDraw() then continue end
			if k:IsNextBot() then continue end
			if k:GetClass() == "gmod_hands" then
				continue end
			if k:IsWeapon() and k:GetParent() ~= LocalPlayer() then continue end
			CORRUPTrendermanual[k] = true
			k:SetNoDraw(true)
		end
	end
	
end)
hook.Add("PostDrawOpaqueRenderables", "corruptplayer", function(_, _, sky3d)
	if sky3d then return end	-- avoid rendering in skybox
	set_vertex_metadata(CurTime(), 0, 0)
		-- make sure to supress engine lighting before setting it up, otherwise we won't override anything
	render.SuppressEngineLighting(true)

	render.SetModelLighting(0, CurTime(), 0, 0)
	for k,v in pairs(CORRUPTrendermanual) do
		if IsValid(k) and k:GetMaterial() == "gmod_shader_guide/example6" then
			k:DrawModel()
		else
			if !IsValid(k) then
				CORRUPTrendermanual[k] = nil
				continue
			else
				CORRUPTrendermanual[k] = nil
				k:SetNoDraw(false)
				k:SetRenderMode(RENDERMODE_NORMAL)
				k:SetColor(Color(255,255,255,255))
				continue
			end
			
		end
	end
	render.SuppressEngineLighting(false)
	
end)