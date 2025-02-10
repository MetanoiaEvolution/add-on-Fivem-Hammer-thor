-- Hammer Laser Interact Script with DAMN and Tarik Tambang Animations + Force Push

-- Variabel untuk mengatur status laser
local laserActive = false
local explodeKey = 51 -- Tombol E untuk meledakkan objek
local pullKey = 58 -- Tombol G untuk menarik objek/pemain
local forcePushKey = 23 -- Tombol F untuk Force Push

-- Fungsi untuk mengaktifkan/menonaktifkan laser
function ToggleHammerLaser()
    laserActive = not laserActive

    if laserActive then
        TriggerEvent('enableLaser') -- Men-trigger event untuk menampilkan laser
    else
        TriggerEvent('disableLaser') -- Men-trigger event untuk menonaktifkan laser
    end
end

-- Command /togglehammer
RegisterCommand("togglehammer", function()
    ToggleHammerLaser()
end, false)

-- Event untuk mengaktifkan laser
RegisterNetEvent('enableLaser')
AddEventHandler('enableLaser', function()
    Citizen.CreateThread(function()
        while laserActive do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local weapon = GetSelectedPedWeapon(playerPed)

            -- Mengecek apakah pemain menggunakan hammer
            if weapon == GetHashKey("WEAPON_HAMMER") then
                -- Mengambil koordinat yang ditunjuk oleh mouse (raycast dari kamera)
                local hit, hitCoords, hitEntity = GetMouseWorldCoords()

                -- Jika berhasil mendapatkan koordinat dari arah kursor mouse
                if hit then
                    -- Menggambar laser (DrawMarker type 28 untuk membuat garis)
                    DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, false, 2, false, nil, nil, false)

                    -- Cek apakah pemain menekan tombol meledak (tombol E)
                    if IsControlJustPressed(0, explodeKey) then
                        HandleExplosion(hitEntity, hitCoords)
                    end

                    -- Cek apakah pemain menekan tombol tarik (tombol G)
                    if IsControlJustPressed(0, pullKey) then
                        HandlePullInteraction(hitEntity, hitCoords)
                    end

                    -- Cek apakah pemain menekan tombol Force Push (tombol F)
                    if IsControlJustPressed(0, forcePushKey) then
                        HandleForcePush(hitEntity, hitCoords)
                    end
                end
            else
                -- Nonaktifkan laser jika pemain mengganti senjata
                TriggerEvent('disableLaser')
            end
        end
    end)
end)

-- Event untuk menonaktifkan laser
RegisterNetEvent('disableLaser')
AddEventHandler('disableLaser', function()
    laserActive = false
end)

-- Fungsi untuk mendapatkan koordinat arah mouse (world coordinates)
function GetMouseWorldCoords()
    -- Mengambil koordinat dan rotasi dari kamera gameplay
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)

    -- Menghitung arah dari kamera dan posisi mouse (hitung raycast)
    local forwardVector = RotAnglesToVec(camRot)
    local cursorPos = GetGameplayCursorPosition()
    
    -- Raycast untuk menentukan titik di mana laser berhenti
    local maxDist = 1000.0 -- Jarak maksimal raycast
    local targetCoords = camCoords + (forwardVector * maxDist)
    local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, PlayerPedId(), 0)
    local _, hit, hitCoords, _, hitEntity = GetShapeTestResult(rayHandle)

    return hit, hitCoords, hitEntity
end

-- Fungsi untuk menghitung vektor dari rotasi kamera
function RotAnglesToVec(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))

    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- Fungsi untuk mendapatkan posisi kursor (untuk simulasi)
function GetGameplayCursorPosition()
    -- Kamu bisa menggunakan logika ini untuk simulasi posisi kursor jika tidak ada API langsung untuk menangkapnya.
    return GetGameplayCamCoord() -- Sebagai placeholder
end

-- Fungsi untuk menangani ledakan
function HandleExplosion(hitEntity, hitCoords)
    if DoesEntityExist(hitEntity) then
        local entityType = GetEntityType(hitEntity)

        -- Jika target adalah kendaraan atau objek
        if entityType == 2 or entityType == 3 then
            -- Ledakkan objek tersebut
            PlayExplosionAnimation() -- Tambahkan animasi DAMN
            ExplodeEntity(hitEntity)
        end
    end
end

-- Fungsi untuk meledakkan entitas
function ExplodeEntity(entity)
    local entityCoords = GetEntityCoords(entity)
    AddExplosion(entityCoords.x, entityCoords.y, entityCoords.z, 2, 1.0, true, false, 1.0)
end

-- Fungsi untuk menangani interaksi tarik
function HandlePullInteraction(hitEntity, hitCoords)
    if DoesEntityExist(hitEntity) then
        local entityType = GetEntityType(hitEntity)

        -- Jika target adalah pemain atau objek
        if entityType == 1 or entityType == 2 or entityType == 3 then
            -- Menarik objek/pemain ke arah pemain
            PlayPullAnimation() -- Tambahkan animasi tarik tambang
            PullEntityTowardsPlayer(hitEntity)
        else
            -- Jika entitas adalah objek besar atau tidak bisa di-interaksi, tarik pemain ke target
            PlayPullAnimation() -- Tambahkan animasi tarik tambang
            PullPlayerToCoords(hitCoords)
        end
    else
        -- Jika tidak ada entitas, tetap tarik pemain ke target (misal gedung)
        PlayPullAnimation() -- Tambahkan animasi tarik tambang
        PullPlayerToCoords(hitCoords)
    end
end

-- Fungsi untuk menangani Force Push
function HandleForcePush(hitEntity, hitCoords)
    if DoesEntityExist(hitEntity) then
        local entityType = GetEntityType(hitEntity)

        -- Jika target adalah pemain atau objek
        if entityType == 1 or entityType == 2 or entityType == 3 then
            PlayForcePushAnimation() -- Tambahkan animasi Force Push
            ForcePushEntity(hitEntity, hitCoords)
        end
    end
end

-- Fungsi untuk mendorong entitas dengan Force Push
function ForcePushEntity(entity, hitCoords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local direction = (hitCoords - playerCoords)

    -- Terapkan gaya dorong ke objek/pemain yang disorot
    ApplyForceToEntity(entity, 1, direction.x * 10.0, direction.y * 10.0, direction.z * 5.0, 0.0, 0.0, 0.0, 1, false, true, true, false, true)
end

-- Fungsi untuk menarik pemain atau entitas ke arah pemain
function PullEntityTowardsPlayer(entity)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local entityCoords = GetEntityCoords(entity)

    -- Buat force ke arah pemain
    ApplyForceToEntity(entity, 1, playerCoords.x - entityCoords.x, playerCoords.y - entityCoords.y, playerCoords.z - entityCoords.z, 0.0, 0.0, 0.0, 1, false, true, true, false, true)
end

-- Fungsi untuk menarik pemain ke arah target (misal gedung atau objek besar)
function PullPlayerToCoords(coords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Terapkan force ke arah target
    ApplyForceToEntity(playerPed, 1, coords.x - playerCoords.x, coords.y - playerCoords.y, coords.z - playerCoords.z, 0.0, 0.0, 0.0, 1, false, true, true, false, true)
end

-- Fungsi untuk memutar animasi ledakan DAMN
function PlayExplosionAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("missfam5_yoga")
    while not HasAnimDictLoaded("missfam5_yoga") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "missfam5_yoga", "f_yogapose_damn", 8.0, -8.0, -1, 50, 0, false, false, false)
end

-- Fungsi untuk memutar animasi tarik tambang
function PlayPullAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("mini@triathlon")
    while not HasAnimDictLoaded("mini@triathlon") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "mini@triathlon", "pull_up", 8.0, -8.0, -1, 50, 0, false, false, false)
end

-- Fungsi untuk memutar animasi Force Push
function PlayForcePushAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("gestures@m@standing@casual")
    while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_nod_yes_hard", 8.0, -8.0, -1, 50, 0, false, false, false)
end
