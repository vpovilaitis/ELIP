local Switch = require('Module:Switch')
local Komentaras = require('Module:Komentaras')

psalviet = {}

function psalviet.viet( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local sal = args.sal or pargs.sal or mw.text.trim(args[1] or pargs[1] or '')
    local default = args.default or pargs.default or mw.text.trim(args[2] or pargs[2] or '') or ''
    local link = args.link or pargs.link or mw.text.trim(args[3] or pargs[3] or '')
    
    return psalviet._viet( sal, default, link )
end

function psalviet._viet( sal, default, link )
    local viet, cat = false, '[[Kategorija:Į modulį neįtraukta šalis]]'
    
    if link == '#default' then
        link = Switch._switch2( 'Switch/šalys', sal, 'link', '' )
    end
    if link == '' then link = sal end
    
    if default == nil then
        default = ''
    end
    if default == link then
        default = false
    elseif default == '' then
        default = false
    elseif default == '' and link ~= '' then
        default = sal
    end
    
    local issal = Switch._switch( 'Switch/šalys', sal, false )
    if issal then
        viet = Switch._switch2( 'Switch/šalys', sal, 'vietininkas', false )
        if viet then
            if viet ~= '' then
                return '[['..link..'|'..viet..']]'
            end
        end
    end
    
    if default then
        return Komentaras._kom('[['..link..'|'..default..']]', 'Į modulį neįtraukta šalis')..cat
    else
        if link ~= sal then
            return Komentaras._kom('[['..link..'|'..sal..']]', 'Į modulį neįtraukta šalis')..cat
        else
            return Komentaras._kom('[['..link..']]', 'Į modulį neįtraukta šalis')..cat
        end
    end
end

return psalviet;
