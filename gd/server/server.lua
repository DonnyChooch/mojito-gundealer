ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('mojito-gundealer:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.Weapons

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('mojito-gundealer: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		if type == 1 then
			if Config.UseDirty then
				if xPlayer.getAccount('black_money').money >= selectedWeapon.price then
					xPlayer.removeAccountMoney('black_money', selectedWeapon.price)
					xPlayer.addWeapon(weaponName, 100)

					cb(true)
				else
					cb(false)
				end
			else
				if xPlayer.getMoney() >= selectedWeapon.price then
					xPlayer.removeMoney(selectedWeapon.price)
					xPlayer.addWeapon(weaponName, 100)

					cb(true)
				else
					cb(false)
				end
			end

		-- Weapon Component
		elseif type == 2 then
			local price = selectedWeapon.components[componentNum]
			local weaponNum, weapon = ESX.GetWeapon(weaponName)

			local component = weapon.components[componentNum]

			if component then
				if Config.UseDirty then
					if xPlayer.getAccount('black_money').money >= price then
						xPlayer.removeAccountMoney('black_money', price)
						xPlayer.addWeaponComponent(weaponName, component.name)

						cb(true)
					else
						cb(false)
					end
				else
					if xPlayer.getMoney() >= price then
						xPlayer.removeMoney(price)
						xPlayer.addWeaponComponent(weaponName, component.name)

						cb(true)
					else
						cb(false)
					end
				end
			else
				print(('mojito-gundealer: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
				cb(false)
			end
		end
	end
end)

DealerLocationRand = math.random(1,4)

DealerLocation = DealerLocationRand


print("Current Location is: ^1"..DealerLocation.."^0")

RegisterServerEvent('mojito-gundealer:getLocationFromServer')
	AddEventHandler('mojito-gundealer:getLocationFromServer', function()
	TriggerClientEvent("mojito-gundealer:setLocationFromServer", source, DealerLocation)
end)
