local json = require('Modulis:JSON')

local parmm = {}
 
parmm.getr = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local pagename = args['page'] or pargs['page'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    local parm = args['parm'] or pargs['parm'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
    local prm = parmm._get{ page = pagename, parm = parm, namespace = namespace, subst=subst }
    if prm == '' then
        prm = pagename
    end
    return prm
end
    
parmm.get = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local pagename = args['page'] or pargs['page'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    local parm = args['parm'] or pargs['parm'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
    local intyp = args['intype'] or pargs['intype'] or 'string' -- perduodamas tipas: string (pagal nutylėjimą), json, list
    local indel = args['indel'] or pargs['indel'] or ',' -- perduodamas skirtukas
    local typ = args['outtype'] or pargs['outtype'] or 'string' -- gražinamas tipas: string (pagal nutylėjimą), json, list
    local del = args['outdel'] or pargs['outdel'] or ';' -- gražinamas skirtukas
    local rez = ''
    local prm = nil
    
    if intyp == 'json' then
        parm = json.decode( parm )
    elseif intyp == 'list' then
        parm = mw.text.split(parm,indel)
    end
        
    prm = parmm._get{ page = pagename, parm = parm, namespace = namespace, subst=subst }
    
    if typ == 'json' then
        rez = json.encode(prm, {indent=true})
    elseif typ == 'list' and type(prm) == 'table' then
        local skirt = ''
        for p, v in pairs( prm ) do
            rez = rez .. skirt .. p .. '=' .. v
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
    local namespace = args['namespace'] or '0'
    local parm = args['parm']
    local subst = args['subst'] or ''
    local rtxt = ''
    local ret = ''
    if pagename ~= '' then
        pagename = mw.ustring.gsub(pagename, ' ', '_')
        pagename = mw.ustring.gsub(pagename, "'", "''")
        rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
        if rtxt == '' then
            return nil
        end
        local redirect = mw.ustring.match( rtxt, "#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" ) or ''
        if redirect == '' then
            redirect = mw.ustring.match( rtxt, "#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" ) or ''
        end
        if redirect ~= '' then
            pagename = mw.ustring.gsub(redirect, ' ', '_')
            pagename = mw.ustring.gsub(pagename, "'", "''")
            if pagename == '' then
                return nil
            end
            rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if rtxt == '' then
                return nil
            end
        end
        --local rpage, err = mw.title.new(pagename)
        --if rpage and rpage.id ~= 0 then
        --    rtxt = rpage:getContent() or ""
        --    if rpage.isRedirect then
        --        local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
        --
        --        if not redirect then
        --            redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
        --        end
        --        if redirect then
        --            pagename = redirect
        --            local page, err = mw.title.new(pagename)
        --            if page and page.id ~= 0 then
        --                rtxt = page:getContent() or ""
        --            else
        --                return nil
        --            end
        --        end
        --    end
        --else
        --    return nil
        --end
     
        if type(parm) == 'string' and rtxt ~= '' then
            ret = mw.ustring.match( rtxt, "%c%s*%|%s*"..parm.."%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
            retm =  mw.text.split(ret,'<!--')
            ret = retm[1]
            retm =  mw.text.split(ret,'{{subst:')
            ret = retm[1]
        elseif type(parm) == 'string' and rtxt == '' then
            ret = ''
        elseif type(parm) == 'table' and rtxt ~= '' then
            ret = {}
            for i, p in ipairs(parm) do
                if p ~= '' then
                    ret[p] = mw.ustring.match( rtxt, "%c%s*%|%s*"..p.."%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
                    retm =  mw.text.split(ret[p],'<!--')
                    ret[p] = retm[1]
                    retm =  mw.text.split(ret[p],'{{subst:')
                    ret[p] = retm[1]
                end
            end
        elseif type(parm) == 'table' and rtxt == '' then
            ret = {}
        elseif type(parm) == 'boolean' and parm then
            ret = rtxt
        elseif type(parm) == 'boolean' and not parm then
            ret = rtxt ~= ''
        elseif type(parm) == 'nil' then
            ret = nil
        end
    else
        ret = nil
    end

    return ret
end

parmm.istemplate = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local pagename = args['page'] or pargs['page'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    local template = args['template'] or pargs['template'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
    local prm = nil
    
    prm = parmm._istemplate{ page = pagename, template = template, namespace = namespace, subst=subst }
    
    return prm
end
    
parmm._istemplate = function ( args )
    local frame = mw.getCurrentFrame()
    local pagename = args['page'] or ''
    local namespace = args['namespace'] or '0'
    local template = args['template'] or ''
    local subst = args['subst'] or ''
    local rtxt = ''
    local ret = ''
    if pagename ~= '' then
        pagename = mw.ustring.gsub(pagename, ' ', '_')
        pagename = mw.ustring.gsub(pagename, "'", "''")
        rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
        if rtxt == '' then
            return nil
        end
        local redirect = mw.ustring.match( rtxt, "#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" ) or ''
        if redirect == '' then
            redirect = mw.ustring.match( rtxt, "#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" ) or ''
        end
        if redirect ~= '' then
            pagename = mw.ustring.gsub(redirect, ' ', '_')
            pagename = mw.ustring.gsub(pagename, "'", "''")
            if pagename == '' then
                return nil
            end
            rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if rtxt == '' then
                return nil
            end
        end
     
        if template ~= '' and rtxt ~= '' then
            ret = mw.ustring.match( rtxt, "%{%{%s*"..template.."%s*[%c%|%}]" )
        else
            ret = nil
        end
    else
        ret = nil
    end
    
    if ret ~= nil then ret = 'true' else ret = 'false' end

    return ret
end

parmm._gettext = function ( args )
    local frame = mw.getCurrentFrame()
    local pagename = args['page'] or ''
    local namespace = args['namespace'] or '0'
    local subst = args['subst'] or ''
    local rtxt = nil
    if pagename ~= '' then
        pagename = mw.ustring.gsub(pagename, ' ', '_')
        pagename = mw.ustring.gsub(pagename, "'", "''")
        rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
        if rtxt == '' then
            return nil
        end
        local redirect = mw.ustring.match( rtxt, "#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" ) or ''
        if redirect == '' then
            redirect = mw.ustring.match( rtxt, "#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" ) or ''
        end
        if redirect ~= '' then
            pagename = mw.ustring.gsub(redirect, ' ', '_')
            pagename = mw.ustring.gsub(pagename, "'", "''")
            if pagename == '' then
                return nil
            end
            rtxt = frame:preprocess("{{"..subst.."#get_db_data:|db=enc|from=/* "..pagename.." */ encpage p "..
                    " left join enciklopedija.encrevision r on p.page_latest=r.rev_id and p.page_id=r.rev_page "..
                    " left join enciklopedija.enctext t on t.old_id=r.rev_text_id |where=p.page_namespace="..namespace.." and p.page_title='"..pagename.."'|data=txt=t.old_text}}"..
                    "{{"..subst.."#for_external_table:{{{txt}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if rtxt == '' then
                return nil
            end
        end
     
    end

    return rtxt
end

return parmm
