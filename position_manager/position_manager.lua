--Copyright (c) 2020, Lili
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of position_manager nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL Lili BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'position_manager'
_addon.author = 'Lili'
_addon.version = '0.0.2'
_addon.command = 'pm'

if not windower.file_exists(windower.windower_path .. '\\plugins\\WinControl.dll') then
    print('position_manager: error - Please install the WinControl plugin in the launcher.')
    windower.send_command('lua u position_manager')
    return
end

config = require 'config'

default = {
    x = 0,
    y = 0,
}

settings = config.load(default)

function move(settings)
    windower.send_command('load wincontrol')
    coroutine.sleep(0.2)
    windower.send_command('wincontrol move %s %s':format(settings.x,settings.y))
    coroutine.sleep(0.3)
    windower.send_command('unload wincontrol')
end

function handle_commands(cmd,name,pos_x,pos_y)
    local cmd = cmd or 'help'
    
    if cmd == 'r' then
        windower.send_command('lua r position_manager')
    elseif cmd == 'set' then
        if name and pos_x and pos_y then
            settings.x = tonumber(pos_x)
            settings.y = tonumber(pos_y)
            config.save(settings,name)
            
            if windower.ffxi.get_info().logged_in then
                player_name = windower.ffxi.get_player().name
                if name:lower() == player_name:lower() then
                    move(settings)
                end
            -- elseif name ~= 'all' then
            end
        end
    elseif cmd == 'help' then
        windower.add_to_chat(207,'position_manager: Usage: //pm set <Character|all> <x> <y> ')
    else 
        windower.add_to_chat(207,'position_manager: %s command not found.':format(cmd))
        windower.send_command('pm help')
    end    
end

config.register(settings,move)
windower.register_event('addon command',handle_commands)
