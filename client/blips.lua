RegisterNetEvent('xTeritoires:blips')
AddEventHandler('xTeritoires:blips', function(pPos)
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
    local blipId = AddBlipForCoord(pPos.x, pPos.y, pPos.z)
    SetBlipSprite(blipId, 161)
    SetBlipScale(blipId, 1.2)
    SetBlipColour(blipId, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Vente de stupéfiants')
    EndTextCommandSetBlipName(blipId)
    Wait(60 * 1000)
    RemoveBlip(blipId)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
end)