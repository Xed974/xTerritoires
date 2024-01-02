local function CanSellToPed(ped)
	if not IsPedAPlayer(ped) and not IsEntityAMissionEntity(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and IsPedHuman(ped) and GetEntityModel(ped) ~= GetHashKey("s_m_y_cop_01") and GetEntityModel(ped) ~= GetHashKey("s_m_y_dealer_01") and GetEntityModel(ped) ~= GetHashKey("mp_m_shopkeep_01") and ped ~= PlayerPedId() then 
		return true
	end
	return false
end

local function animsAction(animObj, player)
    Citizen.CreateThread(function()
        if not playAnim then
            if DoesEntityExist(player) then
                RequestAnimDict(animObj.lib)
                while not HasAnimDictLoaded(animObj.lib) do
                    Citizen.Wait(0)
                end
                if HasAnimDictLoaded(animObj.lib) then
                    local flag = 0
                    if animObj.loop ~= nil and animObj.loop then
                        flag = 1
                    elseif animObj.move ~= nil and animObj.move then
                        flag = 49
                    end
  
                    TaskPlayAnim(player, animObj.lib, animObj.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
                    playAnimation = true
                end
            end
        end
    end)
end

local function MakeEntityFaceEntity(entity1, entity2)
    local p1, p2 = GetEntityCoords(entity1, true), GetEntityCoords(entity2, true)
    local dx, dy = p2.x - p1.x, p2.y - p1.y

    SetEntityHeading( entity1, GetHeadingFromVector_2d(dx, dy) )
end

local function RequestAndWaitDict(dictName) -- Request une animation (dict)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

local function RequestAndWaitModel(modelName) -- Request un modèle de véhicule
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do Citizen.Wait(100) end
	end
end

local pnj, currentSell, open = nil, false, false
local mainMenu = RageUI.CreateMenu("Vente drogue", "Choix drogue", nil, nil, cfg.TextureDictionary, cfg.TextureName)
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(pnj, false)
end

RegisterCommand(cfg.cmdSell, function()
    if not currentSell then
        ESX.TriggerServerCallback("xTerritoires:getCops", function(can)
            if can then
                currentSell = true
                ESX.ShowNotification("(~y~Information~s~)\nMode vente drogue ~g~activer~s~.")
            else
                ESX.ShowNotification("(~y~Information~s~)\nPas assez de policier en ville.")
            end
        end)
    else
        currentSell = false
        ESX.ShowNotification("(~y~Information~s~)\nMode vente drogue ~r~désactiver~s~.")
    end
end)
TriggerEvent('chat:addSuggestion', ('/%s'):format(cfg.cmdSell), 'Vous permet d\'activer et de désactiver le mode vente de drogue.', nil)

local function MenuSelection(outEntity, pPos)
    pnj = outEntity
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    for _,v in pairs(cfg.Drugs) do
                        RageUI.Button(("~%s~→~s~ %s"):format(cfg.CouleurMenu, v.Label), nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                            onActive = function()
                                DrawMarker(0, GetEntityCoords(outEntity).x, GetEntityCoords(outEntity).y, GetEntityCoords(outEntity).z + 1.1, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.2, 0.2, 0.2, cfg.MarkerColorR, cfg.MarkerColorG, cfg.MarkerColorB, cfg.MarkerOpacite, cfg.MarkerSaute, true, false, cfg.MarkerTourne)
                            end,
                            onSelected = function()
                                RageUI.CloseAll()
        			            ESX.TriggerServerCallback("xTerritoires:getCops", function(cops)
                                    if cops then
                                        if math.random(1, 7) == 1 then
                                            FreezeEntityPosition(PlayerPedId(), true)
                                            ESX.ShowAdvancedNotification("Citoyen", "Discussion", "Attendez un instant, je réfléchis.", "CHAR_ARTHUR", 1)
                                            if math.random(1, 2) == 2 then TriggerServerEvent("xTerritoires:Call", pPos) end
                                            local pCreate = CreateObject(GetHashKey('prop_phone_cs_frank'), 0, 0, 0, true)
                                            AttachEntityToEntity(pCreate, outEntity, GetPedBoneIndex(outEntity, 57005), 0.13, 0.02, 0.0, 90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                                            animsAction({ lib = "cellphone@", anim = "cellphone_text_read_base" }, outEntity)
                                            Wait(4000)
                                            ESX.ShowAdvancedNotification("Citoyen", "Discussion", cfg.messageRefus[math.random(#cfg.messageRefus)], "CHAR_ARTHUR", 1)
                                            FreezeEntityPosition(PlayerPedId(), false)
                                            FreezeEntityPosition(outEntity, false)
                                            DeleteObject(pCreate)
                                        else
                                            ESX.TriggerServerCallback("xTerritoires:getDrug", function(drug)
                                            if drug then
                                                RequestAndWaitDict("mp_common")
                                                RequestAndWaitModel("prop_meth_bag_01")                
                                                SetPedTalk(outEntity)
                                                PlayAmbientSpeech1(outEntity, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')                     
                                                local cCreate = CreateObject(GetHashKey("prop_meth_bag_01"), 0, 0, 0, true)
                                                AttachEntityToEntity(cCreate, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                                                TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 1, false, false, false)
                                                TaskPlayAnim(outEntity, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 1, false, false, false)
                                                Wait(1000)
                                                PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                                                TaskWanderStandard(outEntity, 10.0, 10)
                                                PlayAmbientSpeech1(outEntity, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                                                SetEntityAsMissionEntity(outEntity, true, true)
                                                SetPedCanRagdollFromPlayerImpact(outEntity, true)
                                                DeleteObject(cCreate)
                                                FreezeEntityPosition(outEntity, false)
                                            else
                                                FreezeEntityPosition(outEntity, false)
                                            end
                                            end, v, GetNameOfZone(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z), GetStreetNameFromHashKey(GetNameOfZone(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z)))
                                        end
                                    end
        			            end)
                            end
                        })
                    end
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local pPos = GetEntityCoords(PlayerPedId())

        if currentSell and not IsPedInAnyVehicle(PlayerPedId()) then 
            wait = 250
            local retval, outEntity = FindFirstPed()
            local succesPed = nil 
            repeat
                pPos = GetEntityCoords(PlayerPedId())
                succesPed, outEntity = FindNextPed(retval)
                local cPos = GetEntityCoords(outEntity)
                local dst = Vdist(pPos.x, pPos.y, pPos.z, cPos.x, cPos.y, cPos.z)

                if dst <= 5.0 and CanSellToPed(outEntity) then 
                    wait = 5
                    SetBlockingOfNonTemporaryEvents(outEntity, true)
					PlayAmbientSpeech2(outEntity, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
					SetPedCanRagdollFromPlayerImpact(outEntity, false)

                    if dst <= 2.5 then 
                        ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour ~%s~vendre votre drogue~s~."):format(cfg.CouleurMenu))
                        if IsControlJustPressed(1, 51) then
                            FreezeEntityPosition(outEntity, true)
                            ClearPedTasksImmediately(outEntity)
                            MakeEntityFaceEntity(PlayerPedId(), outEntity)
                            MakeEntityFaceEntity(outEntity, PlayerPedId())
                            MenuSelection(outEntity, pPos)
                        end
                    end
                end
            until not succesPed
            EndFindPed(retval)
        end
        Wait(wait)
    end
end)