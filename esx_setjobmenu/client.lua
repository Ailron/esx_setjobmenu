ESX = nil
Job = {}
Grade = {}
NameJobfornotification = nil 
Joueur = {}
Id = nil
forme = nil  
local allowed

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

if Config.AdminSystem == true then

	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function(playerData)
		TriggerServerEvent('esx_setjobmenu:isAllowedToChange')
	end)
	
	RegisterNetEvent('esx_setjobmenu:admin')
	AddEventHandler('esx_setjobmenu:admin', function(allow)
		print(allow)
		if allow then
			allowed = true
		end
	end)
end

RMenu.Add('example', 'main', RageUI.CreateMenu(_U('attribuerjobmenu'), _U('attribuerjobmenu1')))
RMenu.Add('example', 'id', RageUI.CreateMenu(_U('choisiridmenu'), _U('choisiridmenu1')))
RMenu.Add('example', 'metier', RageUI.CreateSubMenu(RMenu:Get('example', 'main'), _U('metiermenu'), _U('metiermenu1')))
RMenu.Add('example', 'grade', RageUI.CreateSubMenu(RMenu:Get('example', 'main'), _U('grademenu'), _U('grademenu1')))

RegisterNetEvent('esx_setjobmenu:insertjob')
AddEventHandler('esx_setjobmenu:insertjob', function(namejob)
	Job = namejob
end)

RegisterNetEvent('esx_setjobmenu:insertgrade')
AddEventHandler('esx_setjobmenu:insertgrade', function(gradejob)
	Grade = gradejob
end)

RegisterNetEvent('esx_setjobmenu:openmenu')
AddEventHandler('esx_setjobmenu:openmenu', function()
	RageUI.Visible(RMenu:Get('example', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))
end)

RegisterNetEvent('esx_setjobmenu:recupinfo')
AddEventHandler('esx_setjobmenu:recupinfo', function(player)
	Joueur = player
end)

Citizen.CreateThread(function()
	TriggerServerEvent('esx_setjobmenu:getjob')
	TriggerServerEvent('esx_setjobmenu:getplayer')
	TriggerServerEvent('esx_setjobmenu:isAllowedToChange')
    while true do
		if Config.AdminSystem == true then
			if Config.ActiveControl == true then
				if allowed then
					if IsControlJustPressed(0, 57) then -- It's F10
						TriggerEvent('esx_setjobmenu:openmenu')
					end
				end
			end
			if Config.ActiveCommand == true then
				if allowed then
					RegisterCommand("jobmenu", function(source, args, rawCommand)
						RageUI.Visible(RMenu:Get('example', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))
					end)
				end
			end
		else
			if Config.ActiveControl == true then
				if IsControlJustPressed(0, 57) then -- It's F10
					TriggerEvent('esx_setjobmenu:openmenu')
				end
			end
			if Config.ActiveCommand == true then
				RegisterCommand("jobmenu", function(source, args, rawCommand)
					RageUI.Visible(RMenu:Get('example', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))
				end)
			end
		end
		
        RageUI.IsVisible(RMenu:Get('example', 'main'), true, true, true, function()
		
            RageUI.Button(_U('attribuerjobme'), _U('attribuerjobme'), {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
				if (Selected) then
					forme = true
				end
            end, RMenu:Get('example', 'metier'))

            RageUI.Button(_U("attribuerjob"), _U("attribuerjob"), {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
				if (Selected) then
					forme = false
				end				
            end, RMenu:Get('example', 'id'))

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('example', 'id'), true, true, true, function()
			for k,v in ipairs(Joueur) do
				RageUI.Button(v.name, _U("choisirid")..v.name, {RightLabel = ""}, true, function(Hovered, Active, Selected)
					if (Selected) then
						Id = v.id
					end
				end, RMenu:Get('example', 'metier'))
			end
		end, function()
		end)

        RageUI.IsVisible(RMenu:Get('example', 'metier'), true, true, true, function()
		
			for k,v in ipairs(Job) do
				RageUI.Button(v.label, _U("choisirmetier")..v.label, {RightLabel = ""}, true, function(Hovered, Active, Selected)
					if (Selected) then
						NameJobfornotification = v.label
						TriggerServerEvent('esx_setjobmenu:getgrade', v.name)
					end
				end, RMenu:Get('example', 'grade'))
			end
		end, function()
		end)
		
		RageUI.IsVisible(RMenu:Get('example', 'grade'), true, true, true, function()
			for k,v in ipairs(Grade) do
				RageUI.Button(v.label, _U("choisirgrade")..v.label, {RightLabel = ""}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('esx_setjobmenu:putgrade', v.job_name, v.grade, v.label, NameJobfornotification, forme, Id)
					end
				end)
			end
		end, function()
		end)
        Citizen.Wait(0)
    end
end)