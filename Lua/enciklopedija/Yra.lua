myra = {}
 
myra.valstybe = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local yra = args['yra'] or pargs['yra'] or ''
 
    return myra._valstybe{ yra = yra }
end
 
myra._valstybe = function ( args )
    local yra = args['yra'] or ''
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    if yra == '' then
        return ''
    end

    local pgname = page.text

    yrap = frame:preprocess("{{#get_db_data:|db=wikidata|from=/* "..pgname.." */ `ŠaliesLentelė` b "..
        "|where=b._page='"..
        yra.."'|data=pg=b._page}}"..
        "{{#for_external_table:{{{pg}}}}}"..
        "{{#clear_external_data:}}") or ''
    if yrap ~= yra then
        return 'ne'
    else
        return 'taip'
    end
    
end
 
return myra
