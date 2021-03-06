CLASS.AddClass("BREACH", {
	color = Color(200, 70, 35, 255),
	passiveItems = {
		"item_ttt_armor"
	},
	avoidWeaponReset = true,
	surpressKeepOnRespawn = true,
	OnAbilityActivate = function(ply)
		if not SERVER then return end

		local weps = ply:GetWeapons()

		ply.breachStoredWEPS = {}

		for _, wep in pairs(weps) do
			if wep.Kind == WEAPON_HEAVY then
				local cls = WEPS.GetClass(wep)

				ply.breachStoredWEPS[#ply.breachStoredWEPS + 1] = {cls = cls, clip1 = wep:Clip1(), clip2 = wep:Clip2()}

				ply:StripWeapon(cls)
			end
		end

		ply:GiveEquipmentWeapon("weapon_ttt_bulldozer") -- GiveEquipmentWeapon handles giving a weapon like buying it
	end,
	OnAbilityDeactivate = function(ply)
		if not SERVER then return end

		ply:StripWeapon("weapon_ttt_bulldozer")

		if ply.breachStoredWEPS then
			for _, tbl in ipairs(ply.breachStoredWEPS) do
				if tbl.cls then
					local wep = ply:Give(tbl.cls)

					if IsValid(wep) then
						wep:SetClip1(tbl.clip1 or 0)
						wep:SetClip2(tbl.clip2 or 0)
					end
				end
			end

			ply.breachStoredWEPS = nil
		end
	end,
	time = 30,
	amount = 1,
	lang = {
		name = {
			en = "Breach",
			fr = "Breach"
		},
		desc = {
			en = "The Breach always wears some body armor. Once and only once they can activate their ability, granting them 50 more health and a heavy shotgun to blast himself through the world!",
			fr = "The Breach porte toujours un gilet pare-balles. Une fois et seulement une fois, il peut activer sa capacité, ce qui lui donne 50 points de vie supplémentaires et un fusil a pompe  pour  exploser ce beau monde!",
			ru = "Breach всегда носит бронежилет. Один и только один раз он может активировать свою способность, давая ему на 50 больше здоровья и тяжёлый дробовик, чтобы прорваться через весь мир!"
		}
	}
})
