local holstered = true
local lastWeapon = nil

local weapons = {
	"WEAPON_KNIFE",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_MICROSMG",
	"WEAPON_MACHINEPISTOl",
	"WEAPON_DBSHOTGUN",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_SNSPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_SNSPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_ASSAULTSMG",
	"WEAPON_MICROSMG",
	"WEAPON_SMG",
	"WEAPON_MG",
	"WEAPON_GUSENBERG",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_HAVYSHOTGUN",
	"WEAPON_RPG",
	"WEAPON_GRENADE",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_MOLOTOV",
	"WEAPON_GOLFCLUB",
	"WEAPON_HATCHET",
	"WEAPON_KNUCKLEDUSTER",
	"WEAPON_HAMMER",
	"WEAPON_MOLOTOV",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_CARBINERIFLE_MK2",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local ped = GetPlayerPed(-1)

		if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
			loadAnimDict("reaction@intimidation@1h")

			if CheckWeapon(ped) then
				if holstered then
					local weapon = GetSelectedPedWeapon(ped)

					SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

					TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					
					Citizen.Wait(1200)

					SetCurrentPedWeapon(ped, weapon, true)
					DisablePlayerFiring(ped, true)

					Citizen.Wait(800)

					DisablePlayerFiring(ped, false)

					ClearPedTasks(ped)

					holstered = false
				end
			elseif not CheckWeapon(ped) then
				if not holstered then
					if lastWeapon ~= nil then
						SetCurrentPedWeapon(ped, lastWeapon, true)
					end

					TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					
					Citizen.Wait(1500)

					SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
					
					ClearPedTasks(ped)
					holstered = true
				end
			end

			lastWeapon = GetSelectedPedWeapon(ped)
		end
	end
end)

function CheckWeapon(ped)
	for i=1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end

	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		
		Citizen.Wait(0)
	end
end