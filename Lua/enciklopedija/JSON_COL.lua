local ParmData = require('Module:ParmData')
--local json = require('Modulis:JSON')
 
coli = {}
 
coli.get1 = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return coli._get1{ la = la, subst = subst }
end
 
coli._get1 = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
 
    local all = coli._getid{ la = la, subst = subst }
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
 
coli.getid = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return coli._getid{ la = la, subst = subst }
end
 
coli._getid = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    if la == '' then
        local la = ParmData._get{ page = page.text, parm = 'la', template = 'Auto_taxobox', subst = subst }
    end
    if la == '' or la == nil then
        return ''
    end

    local colid = ParmData._get{ page = la, parm = 'colid', template = 'Auto_taxobox', subst = subst } or ''
    if colid ~= '' then
        return mw.text.trim(colid, ',')
    end
    local pgname = page.text

    local mladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    colid = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ base.x_col2013taxon b "..
        "|where=b.c_name='"..
        mladb.."'|data=tid=b.c_taxon_id}}"..
        "{{"..subst.."#for_external_table:{{{tid}}},}}"..
        "{{"..subst.."#clear_external_data:}}") or ''
    if colid ~= '' then
        return mw.text.trim(colid, ',')
    end
    
    colid = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree b "..
        "|where=b.name='"..
        mladb.."'|data=tid=b.taxon_id}}"..
        "{{"..subst.."#for_external_table:{{{tid}}},}}"..
        "{{"..subst.."#clear_external_data:}}") or ''
    
    return mw.text.trim(colid, ',')
end
 
return coli
