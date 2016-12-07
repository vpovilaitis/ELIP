local ParmData = require('Module:ParmData')
local json = require('Modulis:JSON')
 
itisi = {}
 
itisi.get1 = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return itisi._get1{ la = la, subst = subst }
end
    
itisi._get1 = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''

    local all = itisi._getid{ la = la, subst = subst }
    local allm = mw.text.split( all, ',' )
    
    if #allm == 1 then
        retm =  mw.text.split(allm[1],'<!--')
        allm[1] = retm[1]
        retm =  mw.text.split(allm[1],'{{subst:')
        allm[1] = retm[1]
        return allm[1]
    else
        return ''
    end
end
 
itisi.getid = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return itisi._getid{ la = la, subst = subst }
end
 
itisi._getid = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    if la == '' then
        local la = ParmData._get{ page = page.text, parm = 'la', template = 'Auto_taxobox', subst = subst }
    end
    if la == '' then
        return ''
    end

    --local pages = mw.title.new(la)
    local itisid = ParmData._get{ page = la, parm = 'itisid', template = 'Auto_taxobox', subst = subst } or ''
    if itisid ~= '' then
        return mw.text.trim(itisid, ',')
    end
    local pgname = page.text

    local mladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    itisid = frame:preprocess("{{"..subst.."#get_db_data:|db=ITIS|from=/* "..pgname.." */ taxonomic_units|where=complete_name='"..
           mladb.."' |order by=tsn|data=id=tsn}}"..
           "{{"..subst.."#for_external_table:{{{id}}},}}{{"..subst.."#clear_external_data:}}") or ''
    
    return mw.text.trim(itisid, ',')
end
 
return itisi
