local json = require('Modulis:JSON')
local Parm = require('Module:Parm')

local parmm = {}
 
parmm.get = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local pagename = args['page'] or pargs['page'] or ''
    local template = args['template'] or pargs['template'] or ''
    local parm = args['parm'] or pargs['parm'] or ''
    local intyp = args['intype'] or pargs['intype'] or 'string' -- perduodamas tipas: string (pagal nutylėjimą), json, list
    local indel = args['indel'] or pargs['indel'] or ',' -- perduodamas skirtukas
    local typ = args['outtype'] or pargs['outtype'] or 'string' -- gražinamas tipas: string (pagal nutylėjimą), json, list
    local del = args['outdel'] or pargs['outdel'] or ';' -- gražinamas skirtukas
    local subst = args['subst'] or pargs['subst'] or ''
    local rez = ''
    local prm = nil
    
    template = mw.ustring.gsub(template, ' ', '_')
    if intyp == 'json' then
        parm = json.decode( parm )
    elseif intyp == 'list' then
        parm = mw.text.split(parm,indel)
    end
        
    prm = parmm._get{ page = pagename, parm = parm, template = template, subst = subst }
    
    if typ == 'json' then
        rez = json.encode(prm, {indent=true})
        retm =  mw.text.split(rez,'<!--')
        rez = retm[1]
        retm =  mw.text.split(rez,'{{subst:')
        rez = retm[1]
    elseif typ == 'list' and type(prm) == 'table' then
        local skirt = ''
        for p, v in pairs( prm ) do
            rez = rez .. skirt .. p .. '=' .. v
            retm =  mw.text.split(rez,'<!--')
            rez = retm[1]
            retm =  mw.text.split(rez,'{{subst:')
            rez = retm[1]
            skirt = del
        end
    else
        rez = tostring( prm )
    end
    
    return rez
end
    
parmm._get = function ( args )
    local frame = mw.getCurrentFrame()
    local pagename = args['page'] or ''
    local parm = args['parm']
    local template = args['template'] or ''
    local subst = args['subst'] or ''
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local rtxt = ''
    local ret = ''
    pagename = mw.text.listToText(mw.text.split( pagename, "'" ), "''", "''")
    if pagename == '' then
        return nil
    end
    local defla = ''
    template = mw.ustring.gsub(template, ' ', '_')
    if template == 'Auto_taxobox' then
        defla = " or td.la='" .. pagename .. "'"
    elseif template == 'Sinonimas' then
        defla = " or td.`Lotyniškai`='" .. pagename .. "'"
    end
    
    local ddata, daut, d2 = '', '', ''
    
    if type(parm) == 'string' then
        ddata = parm .. '=td.`' .. parm .. '`'
        daut = '{{{' .. parm .. '}}}'
    elseif type(parm) == 'table' then
        local deldata, delaut, del2 = '', '', ''
        for i, p in ipairs(parm) do
            if p ~= '' then
                ddata = ddata .. deldata .. 'ar' .. i .. '=td.`' .. p .. '`'
                daut = daut .. delaut .. '{{{ar' .. i .. '}}}'
                d2 = d2 .. delaut
                deldata, delaut, del2 = ',', ';', ';'
            end
        end
    else
        return nil
    end
    
    local datarez = ''
    if template ~= '' then
        datarez = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ `" ..
            template .. "` td |where=td._page='"..
                pagename.."'" .. defla .."|data=".. ddata .. "}}"..
                "{{"..subst.."#for_external_table:".. daut .. "}}"..
                "{{"..subst.."#clear_external_data:}}") or ''
    end
    if datarez == '' then
        return Parm._get{ page = pagename, parm = parm }
    end
    
    if type(parm) == 'string' then
        ret = datarez
        retm =  mw.text.split(ret,'<!--')
        ret = retm[1]
        retm =  mw.text.split(ret,'{{subst:')
        ret = retm[1]
    elseif type(parm) == 'table' then
        ret = {}
        local datarezs = mw.text.split(datarez,';')
        for i, p in ipairs(parm) do
            --if p ~= '' then
            ret[p] = datarezs[i]
            retm =  mw.text.split(ret[p],'<!--')
            ret[p] = retm[1]
            retm =  mw.text.split(ret[p],'{{subst:')
            ret[p] = retm[1]
            --end
        end
    else
        ret = nil
    end

    return ret
end

return parmm
