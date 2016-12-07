local ParmData = require('Module:ParmData')
local json = require('Modulis:JSON')
 
gbifi = {}
 
gbifi.get1 = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return gbifi._get1{ la = la, subst = subst }
end
 
gbifi._get1 = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
 
    local all = gbifi._getid{ la = la, subst = subst }
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
 
gbifi.getid = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
 
    return gbifi._getid{ la = la, subst = subst }
end
 
gbifi._getid = function ( args )
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
    local gbifid = ParmData._get{ page = la, parm = 'gbifid', template = 'Auto_taxobox', subst = subst } or ''
    if gbifid ~= '' then
        return mw.text.trim(gbifid, ',')
    end
    local pgname = page.text

    local mladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    gbifid = frame:preprocess("{{"..subst.."#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
           mladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
           "{{"..subst.."#for_external_table:{{{id}}},}}{{"..subst.."#clear_external_data:}}") or ''
    if gbifid ~= '' then
        return mw.text.trim(gbifid, ',')
    end
    
    gbifid = frame:preprocess("{{"..subst.."#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from GBIF_sk t " ..
                                     "  where t.name = '" .. mladb .. "') tt " ..
                                     "|where=tt.name='"..
            mladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            "{{"..subst.."#for_external_table:{{{gbif}}},}}"..
            "{{"..subst.."#clear_external_data:}}") or ''
    if gbifid ~= '' then
        return mw.text.trim(gbifid, ',')
    end
    
    gbifid = frame:preprocess("{{"..subst.."#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                            " (select distinct t.name, t.gbif_id " ..
                                            "  from paplitimas t " ..
                                            "  where t.name = '" .. mladb .. "') tt " ..
                                            "|where=tt.name='"..
            mladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            "{{"..subst.."#for_external_table:{{{gbif}}},}}"..
            "{{"..subst.."#clear_external_data:}}") or ''
    
    return mw.text.trim(gbifid, ',')
end
 
gbifi.getsyn = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local gbifid = args['gbifid'] or pargs['gbifid'] or ''
    local singbifm = {}
    local singbifj = frame:preprocess("{{#get_web_data:url=http://api.gbif.org/v1/species/"..gbifid..
        "/synonyms?limit=300|format=json text}}") or '{}'
    if singbifj ~= nil then
        singbifm = json.decode(singbifj)
    else
        singbifj = '{}'
    end

    --return mw.dumpObject(singbifm)
    return json.encode(singbifm)
end

return gbifi
