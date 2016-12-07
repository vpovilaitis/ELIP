local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Switch = require('Module:Switch')
local json = require('Modulis:JSON')
--local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')
local jsoncol = require('Modulis:JSON/COL')
local jsongbif = require('Modulis:JSON/GBIF')
local jsonitis = require('Modulis:JSON/ITIS')
local jsoneol = require('Modulis:JSON/EOL')

local taxline = {}

taxline._tline = function (args, kat)
    local frame = mw.getCurrentFrame()
    local lin = HtmlBuilder.create()
    local lang = mw.language.new( 'lt' )
    local isny, _la, _lt = '', HtmlBuilder.create(), HtmlBuilder.create()
    local s_alias = mw.text.trim( args.alias or '' ) or '' -- mw.text.trim( (mw.text.split(args.la or '', ' (', true) or {''})[1] or '' )
    local s_la = mw.text.trim( args.la or '' ) or '' -- mw.text.trim( (mw.text.split(args.la or '', ' (', true) or {''})[1] or '' )
    local s_lt = mw.text.trim( (mw.text.split(args.lt or '', ' (', true) or {''})[1] or '')
    local r_lt = args.lt
    
    if args.link == nil or args.link == '' then
        args.link = args.la
    end
    
    local king = ParmData._get{ page = args.link, parm = 'karalystė', template = 'Auto_taxobox' }

    local spec_la = s_la
    if s_alias ~= nil and s_alias ~= '' and s_alias ~= spec_la then
        spec_la = s_alias
    end
    
    if args['išnykęs'] == 'taip' or args['išnykęs'] == 'yes' then 
        isny = Komentaras._kom('†', 'Išnykęs ar galimai išnykęs taksonas.', nil) .. ' '
    end
    if args.lt == nil or args.lt == '' then
        r_lt = args.link
        if  args.link ~= s_la then
            _la
                .tag('i')
                    .wikitext('[[', args.link, '|', s_la, ']]')
                    .done()
        else
            _la
                .tag('i')
                    .wikitext('[[', args.link, ']]')
                    .done()
        end
    else
        if args.rodyti ~= nil and args.rodyti ~= '' and args.rodyti ~= args.lt then
            _lt
                .wikitext('[[', args.lt, '|', args.rodyti, ']]')
                .done()
        elseif s_lt ~= args.lt then
            _lt
                .wikitext('[[', args.lt, '|', s_lt, ']]')
                .done()
        else
            _lt
                .wikitext('[[', args.lt, ']]')
                .done()
        end
    end

    if king == 'Fungi' or king == 'Plantae' or king == 'Chromista' then
        if args.laipsnis == 'tipas' then args.laipsnis = 'skyrius' end
        if args.laipsnis == 'būrys' then args.laipsnis = 'eilė' end
    end
    local levt = tonumber(Switch._switch2( 'Switch/taxrank', args.typ, 'l', 1000 ) or 1000) or 1000
    local lev = tonumber(Switch._switch2( 'Switch/taxrank', args.laipsnis, 'l', 1000 ) or 1000) or 1000
    if lev < levt then
        local levn = Switch._switch2( 'Switch/taxrank', args.laipsnis, 'n', 'taksonui' )
        frame:callParserFunction{ name = '#set', args = 'Priklauso '..levn..'='..args.la }
        if args.typ ~= '' then
            frame:callParserFunction{ name = '#set', args = args.typ..' priklauso '..levn..'='..args.la }
        end
    end
    local rank = Switch._switch2( 'Switch/taxrank', args.laipsnis, 'l', '9999' )
    local rankt = Switch._switch2( 'Switch/taxrank', args.laipsnis, 'link', 
                Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas arba klaidingas taksono tipas') )
    if rank < '0280' and rank ~= '0010' then
        rankt = '[[Sritis:' .. r_lt .. '|' .. Switch._switch2( 'Switch/taxrank', args.laipsnis, 'dv', 'Nežinomas' ) .. ']]'
    end
    lin
        --.attr('valign', 'top')
        .wikitext('|- valign="top"\n')
        .wikitext('| ')
            .wikitext(rankt )
            .wikitext(':')
            --.done()
        .wikitext(' || ')
            .wikitext(isny)
            .wikitext(_la)
            .wikitext(_lt)
            .wikitext(kat)
            .wikitext('<br />')
            .tag('i')
                .wikitext('([[Vaizdas:Wikispecies-logo.svg|12px|link=wikispecies:', s_alias, ']] ')
                .wikitext('[[:wikispecies:', s_alias, '|', s_alias, ']])')
                .done()
        --.done()
        .wikitext('\n|- valign="top"')
        .done()
    return  tostring(lin)
end

taxline.by_la = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _alias = args.alias or pargs.alias or ''
    local _typ = args.typ or pargs.typ or mw.text.trim(args[2] or pargs[2] or '')
    local _issin = args.issin or pargs.issin or mw.text.trim(args[3] or pargs[3] or '')
    local lin, tips = HtmlBuilder.create(), HtmlBuilder.create()
    local myargs = {}
    _la = mw.text.trim( _la )
    if _la == nil or _la == '' then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas lotyniškas pavadinimas') )
            .wikitext('\n|- valign="top"')
            .done()
        return tostring(lin)
    end
    if _alias == nil or _alias == '' then
        _alias = _la
    end
    local err
    myargs.la = _la
    myargs.alias = _alias
    myargs.typ = _typ
    myargs.issin = _issin
    myargs, err = taxline.getby_la( myargs )
    if err then
        return err
    end
    return taxline.parents( myargs, { myargs.la } )
end

taxline.parents = function( args, list )
    local katlin = HtmlBuilder.create()
    if args.issin ~= '' then
        if #list == 1 then
            if args.lt ~= nil and args.lt ~= '' then
                katlin.wikitext('[[Kategorija:'..args.lt..'/Sinonimai]]')
            else
                if args.la ~= nil and args.la ~= '' then
                    katlin.wikitext('[[Kategorija:'..args.la..'/Sinonimai]]')
                end
            end
        end
    else
        if #list == 2 then
            if args.lt ~= nil and args.lt ~= '' then
                katlin.wikitext('[[Kategorija:'..args.lt..']]')
            else
                if args.la ~= nil and args.la ~= '' then
                    katlin.wikitext('[[Kategorija:'..args.la..']]')
                end
            end
        end
    end
    katlin
        .done()
    if args.laipsnis == 'karalystė' then
        local dlin, klin = HtmlBuilder.create(), HtmlBuilder.create()
        domargs = {}
        domargs.laipsnis = 'domenas'
        domargs.typ = args.typ or ''
        domargs.la = args.domenas or ''
        domargs.alias = args.domenas or ''
        domargs.link = args.domenaslt or args.domenas or ''
        domargs.lt = args.domenaslt or args.domenas or ''
        domargs.rodyti = ''
        domargs['išnykęs'] = ''
        dlin
            .wikitext(taxline._tline(domargs, ''))
            .done()
        local karargs = {}
        karargs.laipsnis = args.laipsnis
        karargs.typ = args.typ or ''
        karargs.la = args.la or ''
        karargs.alias = args.alias or ''
        karargs.link = args.link or ''
        karargs.lt = args.lt or ''
        karargs.rodyti = ''
        karargs['išnykęs'] = args.mires
        klin
            .wikitext(taxline._tline(karargs, tostring(katlin)))
            .done()
        return tostring(dlin)..tostring(klin)
    else
        if args.parent == nil or args.parent == '' then
           local lin = HtmlBuilder.create()
           lin
               .wikitext('|- valign="top"\n')
               .wikitext('| ')
               .wikitext(' || ')
               .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas tėvo pavadinimas: '..args.la) )
               .wikitext(tostring(katlin))
               .wikitext('\n|- valign="top"')
               .done()
           return tostring(lin)
        else
            local pargs, mlist = {}, {}
            for i, v in pairs(list) do
                mlist[i] = v
                if args.parent == v then
                    local lin = HtmlBuilder.create()
                    lin
                        .wikitext('|- valign="top"\n')
                        .wikitext('| ')
                        .wikitext(' || ')
                        .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nurodytas ciklinis tėvas pavadinimas: '..v) )
                        .wikitext(tostring(katlin))
                        .wikitext('\n|- valign="top"')
                        .done()
                    return tostring(lin)
                end
            end
            local err
            mlist[#list+1] = args.parent
            pargs.la = args.parent
            pargs.alias = args.parent
            pargs.typ = args.typ or ''
            pargs.issin = args.issin
            pargs, err = taxline.getby_la( pargs )
            if err then
                return err
            end
            local plin = taxline.parents( pargs, mlist )
            local elin = HtmlBuilder.create()
            local eargs = {}
            eargs.laipsnis = args.laipsnis
            eargs.typ = args.typ or ''
            eargs.la = args.la or ''
            eargs.alias = args.alias or ''
            eargs.link = args.link or ''
            eargs.lt = args.lt or ''
            eargs.rodyti = ''
            eargs['išnykęs'] = args.mires
            elin
                .wikitext(taxline._tline(eargs, tostring(katlin)))
                .done()
            return plin..tostring(elin)
        end
    end
end

taxline.getby_la = function( args )
    local myargs = {}
    myargs.la = args.la
    myargs.alias = args.alias
    myargs.typ = args.typ or ''
    myargs.issin = args.issin or ''
    local pagename = args.la
    local lin = HtmlBuilder.create()
    if myargs.la == nil or myargs.la == '' then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas lotyniškas pavadinimas') )
            .wikitext('\n|- valign="top"')
            .done()
        return args, tostring(lin)
    end
    local parms = ParmData._get{ page = myargs.la, parm = {'išnykęs', 'statusas', 'la', 'alias', 'lt', 'type', 'parent', 'karalystė', 
        'karalystė lt', 'domenas', 'domenas lt' }, template = 'Auto_taxobox' }

    if parms==nil then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Negalimas puslapis: '..myargs.la) )
            .wikitext('\n|- valign="top"')
            .done()
        return args, tostring(lin)
    end

    myargs.mires = parms['išnykęs'] or mires
    local stat = parms['statusas'] or ''
    if stat == 'EX' then
        myargs.mires = 'taip'
    end
    local la_is = parms['la'] or ''
    if la_is ~= '' then
        if myargs.la ~= la_is then
            myargs.la = la_is
        end
    end
    local alias_is = parms['alias'] or ''
    if alias_is ~= nil and alias_is ~= '' then
        if myargs.alias ~= alias_is then
            myargs.alias = alias_is
        end
    end
    if myargs.alias == '' then
        myargs.alias = myargs.la
    end
    myargs.lt = parms['lt'] or ''
    myargs.laipsnis = parms['type'] or ''
    if myargs.typ == '' then
        myargs.typ = myargs.laipsnis
    end
    myargs.link = pagename
    myargs.parent = parms['parent'] or ''
    myargs.karalyste = parms['karalystė'] or ''
    myargs.karalystelt = parms['karalystė lt'] or ''
    myargs.domenas = parms['domenas'] or ''
    myargs.domenaslt = parms['domenas lt'] or ''

    return myargs, false
end

function taxline.tline(frame)
    local fargs, pargs = frame.args, (frame:getParent() or {}).args or {}
 
    args = {}
    args.laipsnis = fargs.laipsnis or pargs.laipsnis or ''
    args.typ = fargs.typ or pargs.typ or ''
    args.la = fargs.la or pargs.la or ''
    args.alias = fargs.alias or pargs.alias or ''
    if args.alias == '' then args.alias = args.la end
    args.link = fargs.link or pargs.link or args.la or ''
    if args.link == '' then args.link = args.la end
    args.lt = fargs.lt or pargs.lt or ''
    args.rodyti = fargs.rodyti or pargs.rodyti or args.lt or ''
    --args.level = fargs.level or pargs.level or '0'
    args['išnykęs'] = fargs['išnykęs'] or pargs['išnykęs'] or ''
 
    return taxline._tline(args, '')
end

-- taxline.getitis = function( frame )
--     local args, pargs = frame.args, (frame:getParent() or {}).args or {}
--     
--     local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
--     local itisid = ''
--     la = mw.text.trim( la )
--     --local pages = mw.title.new( la )
--     itisid = Parm._get{ page = la, parm = 'itisid' }
--     -- itisid = taxline.getla( pages, 'itisid' )
--     
--     local frame = mw.getCurrentFrame()
--     local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
--     local pg = mw.title.getCurrentTitle()
--     local pgname = pg.text
-- 
--     if itisid == '' then
--        local itis1 = frame:preprocess("{{#get_db_data:|db=ITIS|from=/* "..pgname.." */ taxonomic_units|where=complete_name='"..
--            ladb.."' |order by=tsn|data=id=tsn}}"..
--            "{{#for_external_table:{{{id}}};}}{{#clear_external_data:}}") or ''
--        if itis1 ~= '' and itis1 ~= nil then
--            sgb = mw.text.split(itis1,';') or {}
--            if #sgb == 2 then
--                itisid = sgb[1]
--            end
--        end
--     end
--     return itisid
-- end

taxline.refs = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    la = mw.text.trim( la )
    local typ = args['type'] or pargs['type'] or ''
    local alias = args['alias'] or pargs['alias'] or ''
    local spalva = args.spalva or pargs.spalva or ''
    local vikiteka = args.vikiteka or pargs.vikiteka or ''
    --local itisid = args.itisid or pargs.itisid or ''
    local ncbiid = args.ncbiid or pargs.ncbiid or ''
    local paleodbid = args.paleodbid or pargs.paleodbid or ''
    local wormsid = args.wormsid or pargs.wormsid or ''
    --local gbifid = args.gbifid or pargs.gbifid or ''
    --local gbifwid = args.gbifid or pargs.gbifid or ''
    local iucnid = args.iucnid or pargs.iucnid or ''
    local fbfid = args.fbfid or pargs.fbfid or ''
    local fbgid = args.fbgid or pargs.fbgid or ''
    local fbsid = args.fbsid or pargs.fbsid or ''
    local iffid = args.iffid or pargs.iffid or ''
    local ifgid = args.ifgid or pargs.ifgid or ''
    local ifsid = args.ifsid or pargs.ifsid or ''
    local plantlid = args.plantlid or pargs.plantlid or ''
    --local eolid = args.eolid or pargs.eolid or ''
    local colid, colidm, colidsk, colidrez = args.colid or pargs.colid or '', {}, 0, ''
    local gbifid, gbifidm, gbifidsk, gbifidrez = args.gbifid or pargs.gbifid or '', {}, 0, ''
    local itisid, itisidm, itisidsk, itisidrez = args.itisid or pargs.itisid or '', {}, 0, ''
    local eolid, eolidm, eolidsk, eolidrez = args.eolid or pargs.eolid or '', {}, 0, ''
    if colid == '' and la ~= '' then
        colid = jsoncol._getid{ la = la }
        colidm = mw.text.split(colid,',') or {}
        for i, id in ipairs(colidm) do
            colidm[i] = mw.text.trim(id)
            if colidm[i] ~= '' then
                colidsk = colidsk + 1
            end
        end
    elseif colid ~= '' then
        colidm = mw.text.split(colid,',') or {}
        for i, id in ipairs(colidm) do
            colidm[i] = mw.text.trim(id)
            if colidm[i] ~= '' then
                colidsk = colidsk + 1
            end
        end
    end
    if gbifid == '' and la ~= '' then
        gbifid = jsongbif._getid{ la = la }
        gbifidm = mw.text.split(gbifid,',') or {}
        for i, id in ipairs(gbifidm) do
            gbifidm[i] = mw.text.trim(id)
            if gbifidm[i] ~= '' then
                gbifidsk = gbifidsk + 1
            end
        end
    elseif gbifid ~= '' then
        gbifidm = mw.text.split(gbifid,',') or {}
        for i, id in ipairs(gbifidm) do
            gbifidm[i] = mw.text.trim(id)
            if gbifidm[i] ~= '' then
                gbifidsk = gbifidsk + 1
            end
        end
    end
    if itisid == '' and la ~= '' then
        itisid = jsonitis._getid{ la = la }
        itisidm = mw.text.split(itisid,',') or {}
        for i, id in ipairs(itisidm) do
            itisidm[i] = mw.text.trim(id)
            if itisidm[i] ~= '' then
                itisidsk = itisidsk + 1
            end
        end
    elseif itisid ~= '' then
        itisidm = mw.text.split(itisid,',') or {}
        for i, id in ipairs(itisidm) do
            itisidm[i] = mw.text.trim(id)
            if itisidm[i] ~= '' then
                itisidsk = itisidsk + 1
            end
        end
    end
    if eolid == '' and la ~= '' then
        eolid = jsoneol._getid{ la = la }
        eolidm = mw.text.split(eolid,',') or {}
        for i, id in ipairs(eolidm) do
            eolidm[i] = mw.text.trim(id)
            if eolidm[i] ~= '' then
                eolidsk = eolidsk + 1
            end
        end
    elseif eolid ~= '' then
        eolidm = mw.text.split(eolid,',') or {}
        for i, id in ipairs(eolidm) do
            eolidm[i] = mw.text.trim(id)
            if eolidm[i] ~= '' then
                eolidsk = eolidsk + 1
            end
        end
    end
    
    local sla = la
    if alias ~= '' then
        sla = alias
    end
    
    if vikiteka == '' then
        vikiteka = '* [[File:Commons-logo.svg|12px|link=:commons:Special:Search/' .. sla ..
            ']] [[:commons:Special:Search/' .. sla .. "|'''Vikiteka''']]" .. 
            '<span  class="interProject">[[commons:Special:Search/' .. sla .. '|Vikiteka]]</span>'
    else
        vikiteka = '* [[File:Commons-logo.svg|12px|link=:commons:' .. vikiteka ..
            ']] [[:commons:' .. vikiteka .. "|'''Vikiteka''']]" .. 
            '<span  class="interProject">[[commons:' .. vikiteka .. '|Vikiteka]]</span>'
    end
    
    if gbifidsk ~= 0 then
        local gbifidt = ''
        if gbifidsk > 1 then
            gbifidt = ' ???'
            gbifidrez = gbifidrez .. "[[Kategorija:Surinkti dėl GBIF ID]]\n" 
        end
        if gbifidm ~= nil then
            for i, gbifidme in ipairs( gbifidm ) do
                if gbifidme ~= '' then
                    -- gbifidrez = gbifidrez .. '* [[Vaizdas:GBIF logo.png|25px]] [[gbif:' .. sla .. 
                    --    '|GBIF data]]:' .. " '''[[gbifs:" .. gbifidme .. '|' .. gbifidme .. "]] " .. gbifidt .. "'''\n"
                    gbifidrez = gbifidrez .. '* [[Vaizdas:GBIF logo.png|25px]] [[gbifw:' .. sla .. 
                        '|GBIF]]:' .. " '''[[gbifws:" .. gbifidme .. '|' .. gbifidme .. "]] " .. gbifidt .. "'''\n"
                end
            end
        end
    else
        -- gbifidrez = gbifidrez .. '* [[Vaizdas:GBIF logo.png|25px]] [[gbif:' .. sla .. '|GBIF data: ???]]\n'
        gbifidrez = gbifidrez .. '* [[Vaizdas:GBIF logo.png|25px]] [[gbifw:' .. sla .. '|GBIF: ???]]\n'
    end
    
    if iucnid ~= '' then
        iucnid = '* IUCN:' .. " '''[[iucn:" .. iucnid .. '|' .. iucnid .. "]]'''\n"
    end
    
    if itisidsk ~= 0 then
        local itisidt = ''
        if itisidsk > 1 then
            itisidt = ' ???'
            itisidrez = itisidrez .. "[[Kategorija:Surinkti dėl ITIS ID]]\n" 
        end
        if itisidm ~= nil then
            for i, itisidme in ipairs( itisidm ) do
                if itisidme ~= '' then
                    itisidrez = itisidrez .. '* ITIS:' .. " '''[[itis:" .. itisidme .. '|' .. itisidme .. "]] " .. itisidt .. "'''\n" ..
                            '* CBIF:' .. " '''[[cbif-tsn:" .. itisidme .. '|' .. itisidme .. "]] " .. itisidt .. "'''\n" ..
                            '* ITIS-GBIF:' .. " '''[[itis-gbif:" .. itisidme .. '|' .. itisidme .. "]] " .. itisidt .. "'''\n"
                end
            end
        end
    end
    
    if ncbiid ~= '' then
        ncbiid = '* NCBI:' .. " '''[[ncbi:" .. ncbiid .. '|' .. ncbiid .. "]]'''\n"
    end
    if paleodbid ~= '' then
        paleodbid = '* PaleoDB:' .. " '''[[paleodb:" .. paleodbid .. '|' .. paleodbid .. "]]'''\n"
    end
    if wormsid ~= '' then
        wormsid = '* WoRMS:' .. " '''[[wormsd:" .. wormsid .. '|' .. wormsid .. "]]'''\n"
    end
    if fbfid ~= '' then
        fbfid = '* [[Vaizdas:LogoFB.png|13px]] FishBase:' .. " '''[[fbf:" .. fbfid .. '|' .. fbfid .. "]]'''\n"
    end
    if fbgid ~= '' then
        fbgid = '* [[Vaizdas:LogoFB.png|13px]] FishBase:' .. " '''[[fbg:" .. fbgid .. '|' .. fbgid .. "]]'''\n"
    end
    if fbsid ~= '' then
        fbsid = '* [[Vaizdas:LogoFB.png|13px]] FishBase:' .. " '''[[fbs:" .. fbsid .. '|' .. fbsid .. "]]'''\n"
    end
    if iffid ~= '' then
        iffid = '* [[Vaizdas:LogoIF.png|13px]] Fungorum:' .. " '''[[iff:" .. iffid .. '|' .. iffid .. "]]'''\n"
    end
    if ifgid ~= '' then
        ifgid = '* [[Vaizdas:LogoIF.png|13px]] Fungorum:' .. " '''[[ifg:" .. ifgid .. '|' .. ifgid .. "]]'''\n"
    end
    if ifsid ~= '' then
        ifsid = '* [[Vaizdas:LogoIF.png|13px]] Fungorum:' .. " '''[[ifs:" .. ifsid .. '|' .. ifsid .. "]]'''\n"
    end
    if plantlid ~= '' then
        plantlid = '* [[Vaizdas:PlantL.jpg|13px]] PlantL:' .. " '''[[plantl-rec:" .. plantlid .. '|' .. plantlid .. "]]'''\n"
    end
    
    if eolidsk ~= 0 then
        local eolidt = ''
        if eolidsk > 1 then
            eolidt = ' ???'
            eolidrez = eolidrez .. "[[Kategorija:Surinkti dėl EOL ID]]\n" 
        end
        if eolidm ~= nil then
            for i, eolidme in ipairs( eolidm ) do
                if eolidme ~= '' then
                    eolidrez = eolidrez .. 
                        '* [[Vaizdas:EOL logo.png|25px]] EOL:' .. " '''[[eoln:" .. eolidme .. '|' .. eolidme .. "]] " .. eolidt .. "'''\n"
                end
            end
        end
    end
    
    if colidsk ~= 0 then
        local colidt = ''
        if colidsk > 1 then
            colidt = ' ???'
            colidrez = colidrez .. "[[Kategorija:Surinkti dėl COL ID]]\n" 
        end
        if colidm ~= nil then
            for i, colidme in ipairs( colidm ) do
                if colidme ~= '' then
                    if typ == 'rūšis' then
                        colidrez = colidrez .. '* COL2013:' .. " '''[[col2013id:" .. colidme .. '|' .. colidme .. "]] " .. colidt .. "'''\n"
                    else
                        colidrez = colidrez .. '* COL2013:' .. " '''[[col2013s:" .. sla .. '|' .. colidme .. "]] " .. colidt .. "'''\n"
                    end
                end
            end
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('|- style="text-align:center;"\n')
        .wikitext('! style="background:' .. spalva .. '" |\n')
        .wikitext('{| style="margin:0 auto; text-align:left; background:none;" cellpadding="2"\n')
        .wikitext('|- valign=mid style="margin:0 auto; text-align:left; background:none;" cellpadding="2"\n')
        .wikitext('|<small>\n')
        .wikitext(vikiteka)
        .wikitext('\n</small>\n|<small>\n')
        .wikitext(gbifidrez)
        --.wikitext(gbifwid)
        .wikitext(iucnid)
        .wikitext(itisidrez)
        .wikitext(ncbiid)
        .wikitext(paleodbid)
        .wikitext(wormsid)
        .wikitext(fbfid)
        .wikitext(fbgid)
        .wikitext(fbsid)
        .wikitext(iffid)
        .wikitext(ifgid)
        .wikitext(ifsid)
        .wikitext(plantlid)
        .wikitext(eolidrez)
        .wikitext(colidrez)
        .wikitext('</small>\n|}\n')
        .done()
    
    return  tostring(root)
end

taxline.refcol2013 = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    --local alias = args.alias or pargs.alias or ''
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    
    --local sla = la
    --if alias ~= '' then
    --    sla = alias
    --end

    local colid, colidm, colidsk, colidrez = args.colid or pargs.colid or '', {}, 0, ''
    local gbifid, gbifidm, gbifidsk, gbifidrez = args.gbifid or pargs.gbifid or '', {}, 0, ''
    local itisid, itisidm, itisidsk, itisidrez = args.itisid or pargs.itisid or '', {}, 0, ''
    local eolid, eolidm, eolidsk, eolidrez = args.eolid or pargs.eolid or '', {}, 0, ''
    if colid == '' and la ~= '' then
        colid = jsoncol._getid{ la = la }
        colidm = mw.text.split(colid,',') or {}
        for i, id in ipairs(colidm) do
            colidm[i] = mw.text.trim(id)
            if colidm[i] ~= '' then
                colidsk = colidsk + 1
            end
        end
    elseif colid ~= '' then
        colidm = mw.text.split(colid,',') or {}
        for i, id in ipairs(colidm) do
            colidm[i] = mw.text.trim(id)
            if colidm[i] ~= '' then
                colidsk = colidsk + 1
            end
        end
    end
    if gbifid == '' and la ~= '' then
        gbifid = jsongbif._getid{ la = la }
        gbifidm = mw.text.split(gbifid,',') or {}
        for i, id in ipairs(gbifidm) do
            gbifidm[i] = mw.text.trim(id)
            if gbifidm[i] ~= '' then
                gbifidsk = gbifidsk + 1
            end
        end
    elseif gbifid ~= '' then
        gbifidm = mw.text.split(gbifid,',') or {}
        for i, id in ipairs(gbifidm) do
            gbifidm[i] = mw.text.trim(id)
            if gbifidm[i] ~= '' then
                gbifidsk = gbifidsk + 1
            end
        end
    end
    if itisid == '' and la ~= '' then
        itisid = jsonitis._getid{ la = la }
        itisidm = mw.text.split(itisid,',') or {}
        for i, id in ipairs(itisidm) do
            itisidm[i] = mw.text.trim(id)
            if itisidm[i] ~= '' then
                itisidsk = itisidsk + 1
            end
        end
    elseif itisid ~= '' then
        itisidm = mw.text.split(itisid,',') or {}
        for i, id in ipairs(itisidm) do
            itisidm[i] = mw.text.trim(id)
            if itisidm[i] ~= '' then
                itisidsk = itisidsk + 1
            end
        end
    end
    if eolid == '' and la ~= '' then
        eolid = jsoneol._getid{ la = la }
        eolidm = mw.text.split(eolid,',') or {}
        for i, id in ipairs(eolidm) do
            eolidm[i] = mw.text.trim(id)
            if eolidm[i] ~= '' then
                eolidsk = eolidsk + 1
            end
        end
    elseif eolid ~= '' then
        eolidm = mw.text.split(eolid,',') or {}
        for i, id in ipairs(eolidm) do
            eolidm[i] = mw.text.trim(id)
            if eolidm[i] ~= '' then
                eolidsk = eolidsk + 1
            end
        end
    end

    local sdb2013, sdbt2013, uri2013, inf2013 = '', '', '', ''
    if colid ~= '' and colidsk == 1 then
        sdb2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join taxon tx on (tx.id = tt.taxon_id) " ..
                                            "left join source_database sd on (tx.source_database_id=sd.id) " ..
                                            "left join uri_to_source_database usd on (sd.id=usd.source_database_id) " ..
                                            "left join uri on (uri.id=usd.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.."|data=txt=if( sd.id is not null,ifnull(concat('* ', ifnull(concat(sd.authors_and_editors, '. '),''), " ..
            "if(uri.id=21,concat('[http://www.itis.gov ', sd.name, '] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. ')," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', sd.name, ']. '), " ..
            "ifnull(concat(sd.name, '. '),''))), " ..
            "ifnull(concat(sd.organisation, '. '),''), " ..
            -- "ifnull(concat(sd.contact_person, '. '),''), " ..
            -- "ifnull(concat(sd.taxonomic_coverage, '. '),''), " ..
            "ifnull(concat('Versija: ',sd.version, '. '),''), " ..
            "ifnull(concat(sd.release_date, '. '),'')," ..
            "'\n'), ''), '')}}"..
            "{{#for_external_table:{{{txt}}}}}"..
            "{{#clear_external_data:}}") or ''
        
        sdbt2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join _source_database_to_taxon_tree_branch tx on (tt.taxon_id=tx.taxon_tree_id) " ..
                                            "left join taxon tx2 on (tx2.id = tt.taxon_id) " ..
                                            "left join source_database sd on (tx.source_database_id=sd.id) " ..
                                            "left join uri_to_source_database usd on (sd.id=usd.source_database_id) " ..
                                            "left join uri on (uri.id=usd.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.." and (tx.source_database_id<>tx2.source_database_id or tx2.source_database_id is null) " ..
            "|data=txt=if( sd.id is not null,ifnull(concat('* ', ifnull(concat(sd.authors_and_editors, '. '),''), " ..
            "if(uri.id=21,concat('[http://www.itis.gov ', sd.name, '] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. ')," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', sd.name, ']. '), " ..
            "ifnull(concat(sd.name, '. '),''))), " ..
            "ifnull(concat(sd.organisation, '. '),''), " ..
            -- "ifnull(concat(sd.contact_person, '. '),''), " ..
            -- "ifnull(concat(sd.taxonomic_coverage, '. '),''), " ..
            "ifnull(concat('Versija: ',sd.version, '. '),''), " ..
            "ifnull(concat(sd.release_date, '. '),'')," ..
            "'\n'), ''), '')}}"..
            "{{#for_external_table:{{{txt}}}}}"..
            "{{#clear_external_data:}}") or ''
        
        uri2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join uri_to_taxon ut on (ut.taxon_id = tt.taxon_id) " ..
                                            "left join uri on (uri.id=ut.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.." and uri.uri_scheme_id in (6, 7) |data=txt=if( uri.id is not null,ifnull(concat('* ', " ..
            "if(uri.id=21,'[http://www.itis.gov ITIS] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. '," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', " ..
            "REPLACE( REPLACE( REPLACE( uri.resource_identifier,  '#',  '' ),  'http://',  '' ),  'https://',  '' ), ']. '), " ..
            "'')), " ..
            "'\n'), ''), '')}}"..
            "{{#for_external_table:{{{txt}}}}}"..
            "{{#clear_external_data:}}") or ''
        
        inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join reference_to_taxon rt on (rt.taxon_id = tt.taxon_id) " ..
                                            "left join reference r on (r.id=rt.reference_id) |where=tt.taxon_id="..
            colid.." and r.id is not null |data=txt=concat('* ', ifnull(concat(r.authors, '. '),''), " ..
            "ifnull(concat(r.year, '. '),''), ifnull(concat(r.title, '. '),''), ifnull(concat(r.text, '. '),''),'\n')}}"..
            "{{#for_external_table:{{{txt}}}}}"..
            "{{#clear_external_data:}}") or ''
    end
    
    local infitis = ''
    if itisid ~= '' and itisidsk == 1 then
        infitis = frame:preprocess("{{#get_db_data:|db=ITIS|from=/* "..pgname.." */ reference_links rl " ..
                                            "left join `experts` e on (e.expert_id = rl.`documentation_id` and e.expert_id_prefix = rl.`doc_id_prefix`) " ..
                                            "left join `publications` p on (p.publication_id = rl.`documentation_id` and p.pub_id_prefix = rl.`doc_id_prefix`) " ..
                                            "left join `other_sources` s on (s.source_id = rl.`documentation_id` and s.source_id_prefix = rl.`doc_id_prefix`) " ..
            "|where=rl.`tsn`="..
            itisid.." or rl.`tsn` in (SELECT DISTINCT  `tsn` sl "..
            "FROM  `synonym_links` sl WHERE  sl.`tsn_accepted` ="..itisid..
            ")|data=txt=distinct if(e.expert is not null and e.expert_id_prefix='EXP', concat('* ', e.expert, '. ', e.exp_comment, '\n'), " ..
            "if(p.reference_author is not null and p.pub_id_prefix='PUB', concat('* ', p.reference_author, if(p.title <> '',concat('. ', p.title),''), '. ', p.publication_name, "..
            "   if(p.publisher <>'',concat('. ', p.publisher), ''), "..
            "   if(p.pub_place <>'',concat('. ', p.pub_place),''), if(p.isbn <>'',concat('. ISBN ', p.isbn),''), "..
            "   if(p.issn <>'',concat('. ISSN ', p.issn),''), if(p.pages <>'',concat('. ', p.pages, ' psl.'),''), if(p.pub_comment <>'',concat(' ', p.pub_comment),''), '\n'), "..
            " if(s.source is not null and s.source_id_prefix='SRC', concat('* ', s.source, '. ', s.source_comment, '\n'),''))) }}"..
            "{{#for_external_table:{{{txt}}}}}"..
            "{{#clear_external_data:}}") or ''
    end

    local infeol = ''
    if eolid ~= '' and eolidsk == 1 then 
        local refeolj = frame:preprocess("{{#get_web_data:url=http://eol.org/api/pages/1.0/"..eolid..
            ".json?images=0&videos=0&sounds=0&maps=0&text=0&iucn=false&subjects=overview&licenses=all&details=false&common_names=false&synonyms=false&references=true&vetted=0&cache_ttl=|format=json}}") or '{}'
        local refeolm = json.decode(refeolj or '')
        if refeolm ~= nil then
        for i, eref in ipairs( refeolm.references ) do
            local ereft = mw.text.listToText(mw.text.split( eref, "\\r" ), "", "")
            ereft = mw.text.listToText(mw.text.split( ereft, '\\"' ), '"', '"')
            t1 = ''
            repeat
                t1, u1, t2, t3 = mw.ustring.match( ereft, '^(.-)%<a href%=%"(.-)%"%>(.-)%<%/a%>(.-)$' )
                if t1 ~= nil then
                    ereft = t1..'['..u1..' '..t2..'] '..t3
                end
            until t1 == nil
            infeol = infeol .. '* ' .. ereft .. '\n'
        end
        end
    end
    
    local infgbif = ''
    if gbifid ~= '' and gbifidsk == 1 then 
        local refgbifj = frame:preprocess("{{#get_web_data:url=http://api.gbif.org/v1/species/"..gbifid..
            "/references?limit=100|format=json}}") or '{}'
        local refgbifm = json.decode(refgbifj)
        if refgbifm ~= nil and refgbifm.results ~= nil then
            for i, eref in ipairs( refgbifm.results ) do
                infgbif = infgbif .. '* ' .. eref.citation .. '\n'
            end
        end
    end
    
    local rez = HtmlBuilder.create()
    if sdbt2013 ~= '' or sdb2013 ~= '' or uri2013 ~= '' or inf2013 ~= '' then
        rez
            .wikitext('=== Pagal Gyvybės katalogą ===\n')
            .wikitext(sdbt2013)
            .wikitext(sdb2013)
            .wikitext(uri2013)
            .wikitext(inf2013)
    end
    if infitis ~= '' then
        rez
            .wikitext('=== Pagal ITIS ===\n')
            .wikitext(infitis)
    end
    if infeol ~= '' then
        rez
            .wikitext('=== Pagal Gyvybės enciklopediją ===\n')
            .wikitext(infeol)
    end
    if infgbif ~= '' then
        rez
            .wikitext('=== Pagal GBIF ===\n')
            .wikitext(infgbif)
    end
    
    return  tostring(rez)
end

return taxline
