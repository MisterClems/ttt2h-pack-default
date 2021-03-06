local function ConcealFunction(ply)
	if CLIENT then return end

	-- Traces a line from the players shoot position to 100 units
	local pos = ply:GetShootPos()
	local ang = ply:GetAimVector()

	local tracedata = {
		start = pos,
		endpos = pos + ang * 100,
		filter = ply
	}

	local trace = util.TraceLine(tracedata)
	local target = trace.Entity

	if not trace.HitWorld and IsValid(target) and target:GetClass() == "prop_ragdoll" then
		if SERVER then
			local role = target.was_role
			local team = target.was_team

			if role ~= ROLE_ZOMBIE then
				if team ~= TEAM_INNOCENT and ply:HasTeam(TEAM_INNOCENT) then
					ply:Give("weapon_ttt_traitor_case")
				elseif team == TEAM_INNOCENT and not ply:HasTeam(TEAM_INNOCENT) then
					local maxHealth = ply:GetMaxHealth() + 10
					local newHealth = ply:Health() + 10

					ply:SetMaxHealth(maxHealth)
					ply:SetHealth(newHealth)
				end
			end

			target:Remove()

			SendFullStateUpdate()
		end
	else
		return true -- skip cooldown
	end
end

CLASS.AddClass("CONCEAL", {
	color = Color(68, 208, 187, 255),
	OnAbilityDeactivate = ConcealFunction,
	time = 0, -- skip timer, this will skip onActivate too! Use onDeactivate instead
	cooldown = 60,
	lang = {
		name = {
			en = "Conceal",
			fr = "Dissimulateur",
			ru = "Скрыватель"
		},
		desc = {
			en = "The Conceal is able to remove corpses from the map. As an Innocent they receive a T-Suitcase by removing an evil corpse. Removing corpses as an evil player yields them 10 HP instead. They have no passive ability.",
			fr = "Le Dissimulateur est capable de retirer les cadavres sur la carte. En retirant le cadavre d'un innocent, il reçoit une tenue de traitre. En retirant le cadavre d'un traitre, il obtient 10 PV. Il n'a aucune capacité passive.",
			ru = "Скрыватель может убирать трупы с карты. За невиновного он получает Т-чемодан, удалив труп зла. Удаление трупов злым игроком вместо этого даёт ему 10 ОЗ. У него нет пассивных способностей."
		}
	}
})
