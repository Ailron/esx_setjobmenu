ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('powx_tuto:getjob')
AddEventHandler('powx_tuto:getjob', function()
	local job1 = MySQL.Sync.fetchAll("SELECT * FROM jobs ")
	
	TriggerClientEvent('powx_tuto:insertjob', source, job1)
end)

RegisterNetEvent('powx_tuto:getgrade')
AddEventHandler('powx_tuto:getgrade', function(namejob)
	local _source = source
	
	MySQL.Async.fetchAll('SELECT job_name, grade, label FROM job_grades WHERE job_name = @jobname', { ['@jobname'] = namejob }, function(result)
		local grade = result
		TriggerEvent('powx_tuto:getgrade2', _source, grade)
	end)
end)

RegisterNetEvent('powx_tuto:getgrade2')
AddEventHandler('powx_tuto:getgrade2', function(_source, grade)
	TriggerClientEvent('powx_tuto:insertgrade', _source, grade)
end)

RegisterNetEvent('powx_tuto:putgrade')
AddEventHandler('powx_tuto:putgrade', function(jobf, gradef, gradelabel, joblabel, forme, idplayer)
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

RegisterNetEvent('essai:getplayer')
AddEventHandler('essai:getplayer', function()
	local info = {}
	local player = GetPlayers()
	for k,v in pairs(player) do
		table.insert(info, {name= GetPlayerName(v), id= v})
	end
	TriggerClientEvent('essai:recupinfo', source, info)
end)
