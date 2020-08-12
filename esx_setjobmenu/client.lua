ESX = nil
Job = {}
Grade = {}
NameJobfornotification = nil 
Joueur = {}
Id = nil
forme = nil  

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('example', 'main', RageUI.CreateMenu(_U('attribuerjobmenu'), _U('attribuerjobmenu1')))
RMenu.Add('example', 'id', RageUI.CreateMenu(_U('choisiridmenu'), _U('choisiridmenu1')))
RMenu.Add('example', 'metier', RageUI.CreateSubMenu(RMenu:Get('example', 'main'), _U('metiermenu'), _U('metiermenu1')))
RMenu.Add('example', 'grade', RageUI.CreateSubMenu(RMenu:Get('example', 'main'), _U('grademenu'), _U('grademenu1')))

RegisterNetEvent('powx_tuto:insertjob')
AddEventHandler('powx_tuto:insertjob', function(namejob)
	Job = namejob
end)

RegisterNetEvent('powx_tuto:insertgrade')
AddEventHandler('powx_tuto:insertgrade', function(gradejob)
	Grade = gradejob
end)

RegisterNetEvent('powx_tuto:openmenu')
AddEventHandler('powx_tuto:openmenu', function()
	RageUI.Visible(RMenu:Get('example', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))
end)

RegisterNetEvent('essai:recupinfo')
AddEventHandler('essai:recupinfo', function(player)
	Joueur = player
end)

Citizen.CreateThread(function()
	TriggerServerEvent('powx_tuto:getjob')
	TriggerServerEvent('essai:getplayer')
    while true do
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
						TriggerServerEvent('powx_tuto:getgrade', v.name)
					end
				end, RMenu:Get('example', 'grade'))
			end
		end, function()
		end)
		
		RageUI.IsVisible(RMenu:Get('example', 'grade'), true, true, true, function()
			for k,v in ipairs(Grade) do
				RageUI.Button(v.label, _U("choisirgrade")..v.label, {RightLabel = ""}, true, function(Hovered, Active, Selected)
					if (Selected) then
						TriggerServerEvent('powx_tuto:putgrade', v.job_name, v.grade, v.label, NameJobfornotification, forme, Id)
					end
				end)
			end
		end, function()
		end)
        Citizen.Wait(0)
    end
end)