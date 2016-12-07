local HtmlBuilder = require('Module:HtmlBuilder')
local json = require('Modulis:JSON')
local Cite = require('Module:Cite')
local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')
 
jsoneol = {}
 
jsoneol.render = function ( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aeolLt = args[1] or pargs[1] or '{}'
    local peolLt = json.decode(aeolLt)
    
    local pheol = frame:preprocess("{{#get_web_data:url=http://eol.org/api/provider_hierarchies/1.0.json|format=json text}}") or '[]'
    local pheolm = json.decode(pheol)
    
    local tbl = HtmlBuilder.create()
    tbl
        .wikitext( '{| {{Graži lentelė}} class="sortable wikitable"' )
        .newline()
        .wikitext( '|+' )
        .newline()
        .tag('big')
            .wikitext( "'''Sąrašas taksonominių medžių, kuriuos jungia Gyvybės enciklopedija.'''" )
            .done()
        .newline()
        .wikitext( '|-' )
        .newline()
        .wikitext( "! Nr." )
        .newline()
        .wikitext( "! Id." )
        .wikitext(Cite._isn(frame, {}, {'Numeris pagal Gyvybės enciklopedijos registrą.'}))
        .newline()
        .wikitext( "! Taksonomija" )
        .newline()
        .wikitext( "! Anglų kalba" )
        .newline()
        .wikitext( '|-' )
        .newline()
    
    for i, pheole in ipairs( pheolm ) do
        txtl = peolLt[tostring(pheole.id)]
        txts = nil
        if txtl ~= nil then
            if txtl.short ~= nil then
                txts = ('([[' .. txtl.short .. ']])') or ''
            else
                txts = ''
            end
            txtl = ('[[' .. txtl.name .. ']]') or ''
        else 
            txts = ''
            txtl = ''
        end
        
        local pheoltaxj = frame:preprocess("{{#get_web_data:url=http://eol.org/api/hierarchies/1.0/".. tostring(pheole.id) ..".json?cache_ttl=|format=json text}}") or '{}'
        local pheoltax = json.decode(pheoltaxj)
        local lab = pheole.label
        if pheoltax.source ~= nil and pheoltax.source ~= '' and pheoltax.source ~= '0' then
            lab = '[' .. pheoltax.source .. ' ' .. lab .. ']'
        end
        
        tbl
            .wikitext( '| ' )
            .wikitext( i )
            .newline()
            .wikitext( '| ' )
            .wikitext( pheole.id )
            .newline()
            .wikitext( '| ' )
            .wikitext( txtl )
            .wikitext( ' ' )
            .wikitext( txts )
            .newline()
            .wikitext( '| ' )
            .wikitext( lab )
            .newline()
            .wikitext( '|-' )
            .newline()
    end
    
    tbl
        .wikitext( '|}' )
        .newline()
    
    return tostring(tbl)
end
 
jsoneol.get1 = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
    local gjson = args['gjson'] or pargs['gjson'] or ''
 
    return jsoneol._get1{ la = la, subst = subst, gjson = gjson }
end
 
jsoneol._get1 = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local gjson = args['gjson'] or ''
 
    local all = jsoneol._getid{ la = la, subst = subst, gjson = gjson }
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
 
jsoneol.getid = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or pargs['subst'] or ''
    local gjson = args['gjson'] or pargs['gjson'] or ''
 
    return jsoneol._getid{ la = la, subst = subst, gjson = gjson }
end
 
jsoneol._getid = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local gjson = args['gjson'] or ''
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    if la == '' then
        local la = ParmData._get{ page = page.text, parm = 'la', template = 'Auto_taxobox', subst = subst }
    end
    if la == '' or la == nil then
        return ''
    end

    local eolid = ParmData._get{ page = la, parm = 'eolid', template = 'Auto_taxobox', subst = subst } or ''
    if eolid ~= '' or gjson == 'no' then
        return mw.text.trim(eolid, ',')
    end
    local pgname = page.text
    
    local pheolidj = Parm._gettext{ page=la .. '/EOL', namespace=806, subst='subst:' }
    if pheolidj ~=nil and pheolidj ~= '' then
        --return pheolidj
        local pheolid = json.decode(pheolidj)
        local del = ''
        if pheolid ~= nil and pheolid.totalResults ~= 0 then
            for i, el in ipairs(pheolid.results) do
                eolid = eolid .. del .. el.id
                del = ','
            end
        end
        if eolid ~= '' then
            return mw.text.trim(eolid, ',')
        end
    end
 
    local mladb = mw.text.listToText(mw.text.split( la, " " ), "+", "+")
    local pheolidj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
        mladb .. "&page=1&exact=true&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    local pheolid = json.decode(pheolidj)
    local del = ''
    if pheolid ~= nil and pheolid.totalResults ~= 0 then
        for i, el in ipairs(pheolid.results) do
            eolid = eolid .. del .. el.id
            del = ','
        end
    end
    if eolid ~= '' then
        return mw.text.trim(eolid, ',')
    end
        
    pheolidj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
        mladb .. "&page=1&exact=false&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    pheolid = json.decode(pheolidj)
    del = ''
    if pheolid ~= nil and pheolid.totalResults ~= 0 then
        for i, el in ipairs(pheolid.results) do
            eolid = eolid .. del .. el.id
            del = ','
        end
    end
 
    return mw.text.trim(eolid, ',')
end
 
jsoneol.searchinfo = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or ''
    local sineolm = {}
    local mladb = mw.text.listToText(mw.text.split( la, " " ), "+", "+")
    local sineolj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
        mladb .. "&page=1&exact=true&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    if sineolj ~= nil then
        --sineolm = json.decode(sineolj)
    else
        sineolj = '{}'
    end
 
    --return mw.dumpObject(singbifm)
    return json.encode (json.decode(sineolj), { indent = true })
end

jsoneol.searchinfo2 = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args['la'] or pargs['la'] or ''
    local subst = args['subst'] or ''
    local sineolm = {}
    local mladb = mw.text.listToText(mw.text.split( la, " " ), "+", "+")
    local sineolj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
        mladb .. "&page=1&exact=false&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    if sineolj ~= nil then
        --sineolm = json.decode(sineolj)
    else
        sineolj = '{}'
    end
 
    --return mw.dumpObject(singbifm)
    return json.encode (json.decode(sineolj), { indent = true })
end

jsoneol.getinfo = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local eolid = args['eolid'] or pargs['eolid'] or ''
    local subst = args['subst'] or ''
    local sineolm = {}
    local sineolj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/pages/1.0/"..eolid..
        ".json?images=10&videos=0&sounds=0&maps=0&text=10&iucn=true&subjects=overview&licenses=all&details=true&common_names=false&synonyms=true&taxonomy=true&references=true&vetted=0&cache_ttl=|format=json text}}") or '{}'
    if sineolj ~= nil then
        --sineolm = json.decode(sineolj)
    else
        sineolj = '{}'
    end
 
    --return mw.dumpObject(singbifm)
    return json.encode (json.decode(sineolj), { indent = true })
end

jsoneol.getmedis = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local eolid = args['eolid'] or pargs['eolid'] or ''
    local subst = args['subst'] or ''
    local sineolm = {}
    local sineolj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/hierarchy_entries/1.0/"..eolid..
        ".json?common_names=true&synonyms=true&cache_ttl=&language=en|format=json text}}") or '{}'
    if sineolj ~= nil then
        --sineolm = json.decode(sineolj)
    else
        sineolj = '{}'
    end
 
    --return mw.dumpObject(singbifm)
    return json.encode (json.decode(sineolj), { indent = true })
end

return jsoneol
