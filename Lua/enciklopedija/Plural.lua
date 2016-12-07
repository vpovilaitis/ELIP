local Klaida = require('Module:Klaida')

local plural = {}

plural._plural = function (args)
    local n = tonumber(args[1])
    
    if n ~= nil then
        local n10 =  n%10 
        local n100 = n%100 
        
        if n10 == 1  and n100 ~= 11 then
            return args[2]
        end
        if n10 >= 2 and (n100 < 10 or n100 >= 20) then
            return args[3]
        else
            return args[4]
        end
    else
        return Klaida.klaida( {"Nenurodytas skaičius"} )
    end
end

function plural.plural(frame)
    local fargs, pargs = frame.args, (frame:getParent() or {}).args or {}
 
    args = {}
    args[1] = tonumber(fargs[1] or pargs[1]) or 0
    args[2] = fargs[2] or pargs[2]
    args[3] = fargs[3] or pargs[3] or fargs[2] or pargs[2]
    args[4] = fargs[4] or pargs[4] or fargs[3] or pargs[3] or fargs[2] or pargs[2]
 
    return plural._plural(args)
end
 
return plural
