ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_setjobmenu:getjob')
AddEventHandler('esx_setjobmenu:getjob', function()
	local job1 = MySQL.Sync.fetchAll("SELECT * FROM jobs ")
	
	TriggerClientEvent('esx_setjobmenu:insertjob', source, job1)
end)

RegisterNetEvent('esx_setjobmenu:getgrade')
AddEventHandler('esx_setjobmenu:getgrade', function(namejob)
	local _source = source
	
	MySQL.Async.fetchAll('SELECT job_name, grade, label FROM job_grades WHERE job_name = @jobname', { ['@jobname'] = namejob }, function(result)
		local grade = result
		TriggerEvent('esx_setjobmenu:getgrade2', _source, grade)
	end)
end)

RegisterNetEvent('esx_setjobmenu:getgrade2')
AddEventHandler('esx_setjobmenu:getgrade2', function(_source, grade)
	TriggerClientEvent('esx_setjobmenu:insertgrade', _source, grade)
end)

RegisterNetEvent('esx_setjobmenu:putgrade')
AddEventHandler('esx_setjobmenu:putgrade', function(jobf, gradef, gradelabel, joblabel, forme, idplayer)
	if forme then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.setJob(jobf, gradef)
		TriggerClientEvent('esx:showNotification', source, _U('notif1')..joblabel.._U('notif2')..gradelabel)
	else
		local xPlayer = ESX.GetPlayerFromId(idplayer)
		xPlayer.setJob(jobf, gradef)
		TriggerClientEvent('esx:showNotification', source, _U('notif3')..joblabel.._U('notif4')..gradelabel)
	end
end)

RegisterNetEvent('esx_setjobmenu:getplayer')
AddEventHandler('esx_setjobmenu:getplayer', function()
	local info = {}
	local player = GetPlayers()
	for k,v in pairs(player) do
		table.insert(info, {name= GetPlayerName(v), id= v})
	end
	TriggerClientEvent('esx_setjobmenu:recupinfo', source, info)
end)

if Config.AdminSystem then

	RegisterServerEvent('esx_setjobmenu:isAllowedToChange')
	AddEventHandler('esx_setjobmenu:isAllowedToChange', function()
		print('vérif')
		local allowed = false
		for i,id in ipairs(Config.Admins) do
			for x,pid in ipairs(GetPlayerIdentifiers(source)) do
				if string.lower(pid) == string.lower(id) then
					allowed = true
				end
				TriggerClientEvent('esx_setjobmenu:admin', source, allowed)
			end
		end
	end)

	ESX.RegisterServerCallback('esx_setjobmenu:allowchange', function(source, allowed)
		local allowed = false
		for i,id in ipairs(Config.Admins) do
			for x,pid in ipairs(GetPlayerIdentifiers(source)) do
				if string.lower(pid) == string.lower(id) then
					allowed = true
				end
			end
		end
	end)
end
