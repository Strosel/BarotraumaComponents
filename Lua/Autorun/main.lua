local buffer = {}

function TurbineController(signal, connection)
    if buffer[connection.Item] == nil then
        buffer[connection.Item] = {
            load=nil,
            max=nil,
        }
    end

    local item = buffer[connection.Item]

    if connection.Name == 'load' then
        item.load = signal.value
    end
    if connection.Name == 'max_engine_output' then
        item.max = signal.value
    end

    if item.load ~= nil and item.max ~=nil then
        local output = clamp(100*item.load / item.max, 0, 100)

        connection.Item.SendSignal(tostring(output), 'signal_out')

        item.load = nil
        item.max = nil
    end
end

-- NOTE formula from https://steamcommunity.com/sharedfiles/filedetails/?id=2899798076
function FissionController(signal, connection)
    if buffer[connection.Item] == nil then
        buffer[connection.Item] = {
            turbine=nil,
            heat=nil,
            temp=nil,
        }
    end

    local item = buffer[connection.Item]

    if connection.Name == 'turbine_speed' then
        item.turbine = signal.value
    end
    if connection.Name == 'heat_potential' then
        item.heat = signal.value
    end
    if connection.Name == 'reactor_temperature' then
        item.temp = signal.value
    end

    if item.turbine ~= nil and item.heat ~= nil and item.temp ~= nil then
        item.turbine = item.turbine+50.0
        item.heat = item.heat/50.0
        item.temp = clamp(1-(item.temp-5000)/1000, 0, 1.1)

        local output = item.turbine/item.heat * item.temp

        connection.Item.SendSignal(tostring(output), 'signal_out')

        item.turbine = nil
        item.heat = nil
        item.temp = nil
    end
end

if (Game.IsMultiplayer and SERVER) or not (Game.IsMultiplayer) then
	Hook.Add("signalReceived.fissioncontroller ", "fissioncontroller", FissionController)
    Hook.Add("signalReceived.turbinecontroller ", "turbinecontroller", TurbineController)
end
