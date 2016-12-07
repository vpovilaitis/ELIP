local Klaida = require('Module:Klaida')

pswitch = {}

function pswitch.switch( frame )
    local list = frame.args[1] or frame.args.list
    local case = frame.args[2] or frame.args.case
    local default = frame.args[3] or frame.args.default
    
    return pswitch._switch( list, case, default )
end

function pswitch._switch( list, case, default )
    local result
    
    list = mw.loadData( 'Modulis:' .. list )
    
    if case ~= nil then
        if tonumber( case ) ~= nil then
            case = tonumber( case )
        end
        
        result = list[ case ]
    else
        return Klaida.klaida( {"Nenurodytas pasirinkimas"} )
    end
    
    if result == nil then
        if default ~= nil then
            return default
        else
            result = list[ '#default' ]
            if result == nil then 
                return Klaida.klaida( {"Pasirinkimas nerastas"} )
            end
        end
    end

    return result
end

function pswitch.switch2( frame )
    local list = frame.args[1] or frame.args.list
    local case = frame.args[2] or frame.args.case
    local case2 = frame.args[3] or frame.args.case2
    local default = frame.args[4] or frame.args.default
    
    return pswitch._switch2( list, case, case2, default )
end

function pswitch._switch2( list, case, case2, default )
    local result
    local result2
    
    list = mw.loadData( 'Modulis:' .. list )
    
    if case ~= nil then
        if tonumber( case ) ~= nil then
            case = tonumber( case )
        end
        
        result = list[ case ]
    else
        return Klaida.klaida( {"Nenurodytas pasirinkimas"} )
    end
    
    if result == nil then
        if default ~= nil then
            return default
        else
            result = list[ '#default' ]
            if result == nil then 
                return Klaida.klaida( {"Pasirinkimas nerastas"} )
            end
        end
    end

    if case2 ~= nil then
        if tonumber( case2 ) ~= nil then
            case2 = tonumber( case2 )
        end
        
        result2 = result[ case2 ]
    else
        return Klaida.klaida( {"Nenurodytas antras pasirinkimas"} )
    end
    
    if result2 == nil then
        if default ~= nil then
            return default
        else
            result2 = result[ '#default' ]
            if result2 == nil then 
                return Klaida.klaida( {"Pasirinkimas nerastas"} )
            end
        end
    end

    return result2
end

return pswitch;
