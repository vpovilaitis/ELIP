local Parm = require('Modulis:Parm')
local ParmData = require('Modulis:ParmData')
local Komentaras = require('Module:Komentaras')
local HtmlBuilder = require('Module:HtmlBuilder')
local Switch = require('Module:Switch')

local admv = {}
 
admv.list = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or ''
    local kiek = args['kiek'] or pargs['kiek'] or '20'
    local nuo = args['nuo'] or pargs['nuo'] or '0'
    
    return admv._list{ page=page, nuo=nuo, kiek=kiek, frame=frame }
end

admv._list = function ( args )
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local frame=args.frame
    local rez = HtmlBuilder.create()
    local lent = HtmlBuilder.create()
    
    local sar = frame:preprocess("{{#get_db_data:|db=ggetree|from=/* "..pgname.." */ gyvlist t |where=t.o_title='" .. args.page ..
                "' |order by=t.s_title limit "..args.nuo..","..args.kiek.."|data=gyv=t.s_title}}"..
                "{{#for_external_table:{{{gyv}}}~}}{{#clear_external_data:}}") or ''
    if sar ~= '' and sar ~= ';' then
        local sarl = mw.text.split(sar, '~')
        for i, sarle in ipairs(sarl) do
            if sarle ~= '' then
                local parms = ParmData._get{ page = sarle, parm = {'paveikslėlis%-1', 'admVienetas', 'įkurtas', 'gyventojumetai', 'gyventoju', 'lat', 'long', 'PL', 'IL', 'deleted' } }
                if parms ~= nil then
                    local sarlen = '[[' .. sarle .. ']]'
                    local vaizd = ''
                    if parms['paveikslėlis%-1'] ~= nil and parms['paveikslėlis%-1'] ~= '' then
                        vaizd = '[[Vaizdas:' .. parms['paveikslėlis%-1'] .. '|350px|link=' .. sarle .. ']]'
                    end
                    local admv1 = ''
                    local admv2 = HtmlBuilder.create()
                    if parms['admVienetas'] ~= nil and parms['admVienetas'] ~= '' then
                        admv1 = '[[' .. parms['admVienetas'] .. ']]'
                        local parent, level, pUTC, pUTCv
                        parent, level, pUTC, pUTCv = admv._admv{ admv=parms['admVienetas'], namespace=0, sritis='Gyvenvietės', setsritis='false', frame=frame, page=pgname, otipas='', dtipas='', valst='', UTC='', UTCv='' }
                        if parent ~= '' then
                            admv2
                                .newline()
                                .wikitext( '{|' )
                                .newline()
                                .wikitext( '|-' )
                                .newline()
                                .wikitext( parent )
                                .newline()
                                .wikitext( '|}' )
                                .newline()
                        else
                            admv2
                                .wikitext( admv1 )
                        end
                    end
                    local ikur = ''
                    if parms['įkurtas'] ~= nil and parms['įkurtas'] ~= '' then
                        ikur = parms['įkurtas']
                    end
                    local delet = ''
                    if parms['deleted'] ~= nil and parms['deleted'] ~= '' then
                        delet = parms['deleted']
                    end
                    local gyventm = ''
                    if parms['gyventojumetai'] ~= nil and parms['gyventojumetai'] ~= '' then
                        gyventm = parms['gyventojumetai']
                    end
                    local gyvent = ''
                    if parms['gyventoju'] ~= nil and parms['gyventoju'] ~= '' and parms['gyventoju'] ~= '0' then
                        gyvent = parms['gyventoju'] .. ' (' .. gyventm .. ')'
                    end
                    --local lat = ''
                    --local long = ''
                    local zem = ''
                    if parms['lat'] ~= nil and parms['lat'] ~= '' and parms['long'] ~= nil and parms['long'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    elseif parms['PL'] ~= nil and parms['PL'] ~= '' and parms['IL'] ~= nil and parms['IL'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    end
                    lent
                        .tag('tr')
                            .tag('td').wikitext( sarlen ).done()
                            .tag('td').wikitext( vaizd ).done()
                            .tag('td').wikitext( tostring(admv2) ).done()
                            .tag('td').wikitext( ikur ).done()
                            .tag('td').wikitext( delet ).done()
                            .tag('td').wikitext( gyvent ).done()
                            .tag('td').wikitext( zem ).done()
                            .done()
                end
            end
        end
        rez
            .tag('table')
                .grazilentele()
                .tag('tr')
                    .tag('th').wikitext( 'Gyvenvietė' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Vaizdas' ).done()
                    .tag('th').wikitext( 'Priklauso' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Įkurta' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Panaikinta' ).done()
                    .tag('th').wikitext( 'Gyventojų skaičius<br />(Metai)' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Žemėlapis' ).done()
                    .done()
                .wikitext(tostring(lent))
                .done()
    end
    
    return tostring(rez)
end
    
admv.ilist = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or ''
    local kiek = args['kiek'] or pargs['kiek'] or '20'
    local nuo = args['nuo'] or pargs['nuo'] or '0'
    
    return admv._ilist{ page=page, nuo=nuo, kiek=kiek, frame=frame }
end

admv._ilist = function ( args )
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local frame=args.frame
    local rez = HtmlBuilder.create()
    local lent = HtmlBuilder.create()
    
    local sar = frame:preprocess("{{#get_db_data:|db=ggetree|from=/* "..pgname.." */ igyvlist t |where=t.o_title='" .. args.page ..
                "' |order by=t.s_title limit "..args.nuo..","..args.kiek.."|data=gyv=t.s_title}}"..
                "{{#for_external_table:{{{gyv}}}~}}{{#clear_external_data:}}") or ''
    if sar ~= '' and sar ~= ';' then
        local sarl = mw.text.split(sar, '~')
        for i, sarle in ipairs(sarl) do
            if sarle ~= '' then
                local parms = ParmData._get{ page = sarle, parm = {'paveikslėlis%-1', 'admVienetas', 'įkurtas', 'gyventojumetai', 'gyventoju', 'lat', 'long', 'PL', 'IL', 'deleted' } }
                if parms ~= nil then
                    local sarlen = '[[' .. sarle .. ']]'
                    local vaizd = ''
                    if parms['paveikslėlis%-1'] ~= nil and parms['paveikslėlis%-1'] ~= '' then
                        vaizd = '[[Vaizdas:' .. parms['paveikslėlis%-1'] .. '|300px|link=' .. sarle .. ']]'
                    end
                    local admv1 = ''
                    local admv2 = HtmlBuilder.create()
                    if parms['admVienetas'] ~= nil and parms['admVienetas'] ~= '' then
                        admv1 = '[[' .. parms['admVienetas'] .. ']]'
                        local parent, level, pUTC, pUTCv
                        parent, level, pUTC, pUTCv = admv._admv{ admv=parms['admVienetas'], namespace=0, sritis='išnykusios gyvenvietės', setsritis='false', frame=frame, page=pgname, otipas='', dtipas='', valst='', UTC='', UTCv='' }
                        if parent ~= '' then
                            admv2
                                .newline()
                                .wikitext( '{|' )
                                .newline()
                                .wikitext( '|-' )
                                .newline()
                                .wikitext( parent )
                                .newline()
                                .wikitext( '|}' )
                                .newline()
                        else
                            admv2
                                .wikitext( admv1 )
                        end
                    end
                    local ikur = ''
                    if parms['įkurtas'] ~= nil and parms['įkurtas'] ~= '' then
                        ikur = parms['įkurtas']
                    end
                    local delet = ''
                    if parms['deleted'] ~= nil and parms['deleted'] ~= '' then
                        delet = parms['deleted']
                    end
                    local gyventm = ''
                    if parms['gyventojumetai'] ~= nil and parms['gyventojumetai'] ~= '' then
                        gyventm = parms['gyventojumetai']
                    end
                    local gyvent = ''
                    if parms['gyventoju'] ~= nil and parms['gyventoju'] ~= '' and parms['gyventoju'] ~= '0' then
                        gyvent = parms['gyventoju'] .. ' (' .. gyventm .. ')'
                    end
                    --local lat = ''
                    --local long = ''
                    local zem = ''
                    if parms['lat'] ~= nil and parms['lat'] ~= '' and parms['long'] ~= nil and parms['long'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    elseif parms['PL'] ~= nil and parms['PL'] ~= '' and parms['IL'] ~= nil and parms['IL'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    end
                    lent
                        .tag('tr')
                            .tag('td').wikitext( sarlen ).done()
                            .tag('td').wikitext( vaizd ).done()
                            .tag('td').wikitext( tostring(admv2) ).done()
                            .tag('td').wikitext( ikur ).done()
                            .tag('td').wikitext( delet ).done()
                            --.tag('td').wikitext( gyvent ).done()
                            .tag('td').wikitext( zem ).done()
                            .done()
                end
            end
        end
        rez
            .tag('table')
                .grazilentele()
                .tag('tr')
                    .tag('th').wikitext( 'Gyvenvietė' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Vaizdas' ).done()
                    .tag('th').wikitext( 'Priklauso' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Įkurta' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Panaikinta' ).done()
                    --.tag('th').wikitext( 'Gyventojų skaičius<br />(Metai)' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Žemėlapis' ).done()
                    .done()
                .wikitext(tostring(lent))
                .done()
    end
    
    return tostring(rez)
end
    
admv.dlist = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or ''
    local kiek = args['kiek'] or pargs['kiek'] or '20'
    local nuo = args['nuo'] or pargs['nuo'] or '0'
    
    return admv._dlist{ page=page, nuo=nuo, kiek=kiek, frame=frame }
end

admv._dlist = function ( args )
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local frame=args.frame
    local rez = HtmlBuilder.create()
    local lent = HtmlBuilder.create()
    
    local sar = frame:preprocess("{{#get_db_data:|db=ggetree|from=/* "..pgname.." */ dgyvlist t |where=t.o_title='" .. args.page ..
                "' |order by=t.s_title limit "..args.nuo..","..args.kiek.."|data=gyv=t.s_title}}"..
                "{{#for_external_table:{{{gyv}}}~}}{{#clear_external_data:}}") or ''
    if sar ~= '' and sar ~= ';' then
        local sarl = mw.text.split(sar, '~')
        for i, sarle in ipairs(sarl) do
            if sarle ~= '' then
                local parms = ParmData._get{ page = sarle, parm = {'paveikslėlis%-1', 'admVienetas', 'įkurtas', 'gyventojumetai', 'gyventoju', 'lat', 'long', 'PL', 'IL', 'deleted' } }
                if parms ~= nil then
                    local sarlen = '[[' .. sarle .. ']]'
                    local vaizd = ''
                    if parms['paveikslėlis%-1'] ~= nil and parms['paveikslėlis%-1'] ~= '' then
                        vaizd = '[[Vaizdas:' .. parms['paveikslėlis%-1'] .. '|300px|link=' .. sarle .. ']]'
                    end
                    local admv1 = ''
                    local admv2 = HtmlBuilder.create()
                    if parms['admVienetas'] ~= nil and parms['admVienetas'] ~= '' then
                        admv1 = '[[' .. parms['admVienetas'] .. ']]'
                        local parent, level, pUTC, pUTCv
                        parent, level, pUTC, pUTCv = admv._admv{ admv=parms['admVienetas'], namespace=0, sritis='panaikintos gyvenvietės', setsritis='false', frame=frame, page=pgname, otipas='', dtipas='', valst='', UTC='', UTCv='' }
                        if parent ~= '' then
                            admv2
                                .newline()
                                .wikitext( '{|' )
                                .newline()
                                .wikitext( '|-' )
                                .newline()
                                .wikitext( parent )
                                .newline()
                                .wikitext( '|}' )
                                .newline()
                        else
                            admv2
                                .wikitext( admv1 )
                        end
                    end
                    local ikur = ''
                    if parms['įkurtas'] ~= nil and parms['įkurtas'] ~= '' then
                        ikur = parms['įkurtas']
                    end
                    local delet = ''
                    if parms['deleted'] ~= nil and parms['deleted'] ~= '' then
                        delet = parms['deleted']
                    end
                    local gyventm = ''
                    if parms['gyventojumetai'] ~= nil and parms['gyventojumetai'] ~= '' then
                        gyventm = parms['gyventojumetai']
                    end
                    local gyvent = ''
                    if parms['gyventoju'] ~= nil and parms['gyventoju'] ~= '' and parms['gyventoju'] ~= '0' then
                        gyvent = parms['gyventoju'] .. ' (' .. gyventm .. ')'
                    end
                    --local lat = ''
                    --local long = ''
                    local zem = ''
                    if parms['lat'] ~= nil and parms['lat'] ~= '' and parms['long'] ~= nil and parms['long'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    elseif parms['PL'] ~= nil and parms['PL'] ~= '' and parms['IL'] ~= nil and parms['IL'] ~= '' then
                    --    lat = parms['lat']
                    --    long = parms['long']
                        zem = frame:preprocess("{{#ask:[[" .. sarle .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=12|width=350|height=350|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}")
                    end
                    lent
                        .tag('tr')
                            .tag('td').wikitext( sarlen ).done()
                            .tag('td').wikitext( vaizd ).done()
                            .tag('td').wikitext( tostring(admv2) ).done()
                            .tag('td').wikitext( ikur ).done()
                            .tag('td').wikitext( delet ).done()
                            --.tag('td').wikitext( gyvent ).done()
                            .tag('td').wikitext( zem ).done()
                            .done()
                end
            end
        end
        rez
            .tag('table')
                .grazilentele()
                .tag('tr')
                    .tag('th').wikitext( 'Gyvenvietė' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Vaizdas' ).done()
                    .tag('th').wikitext( 'Priklauso' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Įkurta' ).done()
                    .tag('th').attr('width', '100px').wikitext( 'Panaikinta' ).done()
                    --.tag('th').wikitext( 'Gyventojų skaičius<br />(Metai)' ).done()
                    .tag('th').attr('width', '350px').wikitext( 'Žemėlapis' ).done()
                    .done()
                .wikitext(tostring(lent))
                .done()
    end
    
    return tostring(rez)
end
    
admv.tipas = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    
    return admv._tipas{ page=page, namespace=namespace }
end

admv._tipas = function ( args )
    local rez = 'Klaida'
    local prm = nil
    
    prm = Parm._istemplate{ page = args.page, template = 'ŠaliesLentelė', namespace = args.namespace }
    
    if prm == 'true' then
        rez = 'Valstybė'
    else
    
        prm = Parm._istemplate{ page = args.page, template = 'Miestas', namespace = args.namespace }
        
        if prm == 'true' then
            rez = 'Gyvenvietė'
        else
        
            prm = Parm._istemplate{ page = args.page, template = 'Administracinis vienetas', namespace = args.namespace }
            
            if prm == 'true' then
                rez = Parm._get{ page = args.page, parm = 'tipas', namespace = args.namespace }
            end
        end
    end
    
    return rez
end
    
admv.admv = function ( frame )
    local pg = mw.title.getCurrentTitle()
    local page = pg.text
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local otipas = args['otipas'] or pargs['otipas'] or ''
    local dtipas = args['dtipas'] or pargs['dtipas'] or ''
    local padmv = args['admv'] or pargs['admv'] or ''
    local sritis = args['sritis'] or pargs['sritis'] or ''
    local setsritis = args['setsritis'] or pargs['setsritis'] or 'true'
    local valst = args['valstybė'] or pargs['valstybė'] or ''
    local UTC = args['UTC'] or pargs['UTC'] or ''
    local UTCv = args['UTCv'] or pargs['UTCv'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    local background = args['background'] or pargs['background'] or '#e0efef'
    local parent, level, pUTC, pUTCv
    local txt = ''
    
    if padmv ~= '' then
        parent, level, pUTC, pUTCv = admv._admv{ admv=padmv, namespace=namespace, sritis=sritis, setsritis=setsritis, frame=frame, page=page, otipas=otipas, dtipas=dtipas, valst=valst, UTC=UTC, UTCv=UTCv }
    elseif valst ~= '' then
        parent, level, pUTC, pUTCv = admv._admv{ admv=valst, namespace=namespace, sritis=sritis, setsritis=setsritis, frame=frame, page=page, otipas=otipas, dtipas=dtipas, valst=valst, UTC=UTC, UTCv=UTCv }
    else
        return ''
    end
    if otipas ~= '' then
        -- txt = txt .. frame:preprocess("{{#set:ADMV tipas=" .. otipas .. "}}")
        txt = txt .. frame:preprocess("{{#set:Yra=" .. otipas .. "}}")
    end
    if dtipas ~= '' then
        -- txt = txt .. frame:preprocess("{{#set:ADMV tipas=" .. otipas .. "}}")
        txt = txt .. frame:preprocess("{{#set:Yra=" .. dtipas .. "}}")
    end
    if otipas ~= '' and padmv ~= '' then
        txt = txt .. frame:preprocess("{{#set:" .. otipas .. " tiesiogiai priklauso=" .. padmv .. "}}")
    elseif otipas ~= '' and padmv == '' and valst ~= '' then
        txt = txt .. frame:preprocess("{{#set:" .. otipas .. " tiesiogiai priklauso=" .. valst .. "}}")
    end
    if dtipas ~= '' and padmv ~= '' then
        txt = txt .. frame:preprocess("{{#set:" .. dtipas .. " tiesiogiai priklauso=" .. padmv .. "}}")
    elseif dtipas ~= '' and padmv == '' and valst ~= '' then
        txt = txt .. frame:preprocess("{{#set:" .. dtipas .. " tiesiogiai priklauso=" .. valst .. "}}")
    end
    if sritis == 'Gyvenvietės' then
        local utcvasaros = ''
        if pUTCv ~= '' then
            utcvasaros = '<br>[[Vasaros laikas|------ vasaros]]: ([[Vasaros laikas::UTC' .. pUTCv .. ']]'
        end
        if pUTC ~= '' then
            local utct = HtmlBuilder.create()
            utct
                .newline()
                .wikitext( '| align="center" colspan="2" style="line-height:14px;" |<small>[[Laiko juosta]]: ([[Laiko juosta::UTC' .. pUTC .. ']])' .. utcvasaros .. '</small>' )
                .newline()
                .wikitext( '|-' )
                .newline()
                .wikitext( '! align="center" colspan="2" style="background:' .. background .. ';" |' )
                .newline()
                .wikitext( '|-' )
                .newline()
            txt = txt .. tostring(utct)
        end
    end
    return txt .. parent
end

admv._admv = function ( args )
    if args.page == '' then
        return ''
    end
    if args.admv == '' then
        return ''
    end
    
    local root = HtmlBuilder.create()
    local parent, level, UTC, UTCv = '', 0, '', ''
    local parms = ParmData._get{ page = args.admv, parm = {'vėliava', 'herbas', 'tipas', 'admVienetas', 'valstybė', 'UTC', 'UTCv', 'laikoJuosta', 'vasarosLaikas' } }
    if parms ~= nil then
        if parms['admVienetas'] ~= '' then
            parent, level, UTC, UTCv = admv._admv{ admv=parms['admVienetas'], namespace=args.namespace, sritis=args.sritis, setsritis=args.setsritis, frame=args.frame, page=args.page, otipas=args.otipas, dtipas=args.dtipas, valst=args.valst, UTC=args.UTC, UTvC=args.UTCv }
            root
                .wikitext( parent )
        elseif parms['valstybė'] ~= '' then
            parent, level, UTC, UTCv = admv._admv{ admv=parms['valstybė'], namespace=args.namespace, sritis=args.sritis, setsritis=args.setsritis, frame=args.frame, page=args.page, otipas=args.otipas, dtipas=args.dtipas, valst=args.valst, UTC=args.UTC, UTvC=args.UTCv }
            root
                .wikitext( parent )
        else
            level = 0
        end
        if parms.UTC ~= '' then
            UTC = parms.UTC
        end
        if parms.laikoJuosta ~= '' then
            UTC = parms.laikoJuosta
        end
        if args.UTC ~= nil and args.UTC ~= '' then
            UTC = args.UTC
        end
        if UTC == nil then
            UTC = ''
        end
        
        if parms.UTCv ~= '' then
            UTCv = parms.UTCv
        end
        if parms.vasarosLaikas ~= '' then
            UTCv = parms.vasarosLaikas
        end
        if args.UTCv ~= nil and args.UTCv ~= '' then
            UTCv = args.UTCv
        end
        if UTCv == nil then
            UTCv = ''
        end
        
        local vel = ''
        if mw.text.trim(parms['vėliava'] or '') ~= '' then
            vel = parms['vėliava']
        end
        if vel == '' and mw.text.trim(parms['herbas'] or '') ~= '' then
            vel = parms['herbas']
        end
        if vel ~= '' then
            vel = '[[Vaizdas:' .. vel .. '|22x20px|border|Vėliava|link=' .. args.admv .. ']]'
        end
        levelt = 'ADMV' .. tostring(level)
        level = level + 1
        local tipas = parms.tipas
        if tipas == '' then
            tipas = admv._tipas{ page=args.admv, namespace=args.namespace }
        end
        local sritiesTipas = ''
        if args.setsritis == 'true' then
            if args.sritis == 'Gyvenvietės' then
                sritiesTipas = sritiesTipas .. args.frame:preprocess("{{#set:ADMV gyvenviečių sritis=Sritis:" .. args.admv .. "/" .. args.sritis .. "}}")
            elseif args.sritis == 'piliakalniai' then
                sritiesTipas = sritiesTipas .. args.frame:preprocess("{{#set:ADMV piliakalnių sritis=Sritis:" .. args.admv .. "/" .. args.sritis .. "}}")
            elseif args.sritis == 'šventyklos' then
                sritiesTipas = sritiesTipas .. args.frame:preprocess("{{#set:ADMV šventyklų sritis=Sritis:" .. args.admv .. "/" .. args.sritis .. "}}")
            end
            if args.sritis ~= 'Gyvenvietės' then
                if tipas == 'Seniūnija' or tipas == 'seniūnija' then
                    sritiesTipas = sritiesTipas .. '[[Kategorija:' .. args.admv .. ']]'
                elseif tipas == 'Savivaldybė' or tipas == 'savivaldybė' then
                    sritiesTipas = sritiesTipas .. '[[Kategorija:' .. args.sritis .. ' ' .. args.admv .. 'je]]'
                end
            end
            if args.otipas ~= '' then
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.otipas .. ' priklauso=' .. args.admv .. '}}')
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.otipas .. ' priklauso ' .. levelt .. '=' .. args.admv .. '}}')
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.otipas .. ' priklauso ' .. Switch._switch2( 'Switch/admvrank', tipas, 'n', tipas ) .. '=' .. args.admv .. '}}')
            end
            if args.dtipas ~= '' then
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.dtipas .. ' priklauso=' .. args.admv .. '}}')
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.dtipas .. ' priklauso ' .. levelt .. '=' .. args.admv .. '}}')
                sritiesTipas = sritiesTipas .. args.frame:preprocess('{{#set:' .. args.dtipas .. ' priklauso ' .. Switch._switch2( 'Switch/admvrank', tipas, 'n', tipas ) .. '=' .. args.admv .. '}}')
            end
        end
        root
            .newline()
            .wikitext( "! '''[[Sritis:", args.admv, "/", args.sritis, "|", tipas, "]]''':" )
            .wikitext( sritiesTipas )
            .newline()
            .wikitext( '| ' .. vel .. ' [[' .. args.admv .. ']]' )
            .newline()
            .wikitext( '|-' )
            .newline()
    end
    return tostring(root), level, UTC, UTCv
end

admv.icon = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or mw.text.trim(args[1] or pargs[1] or '') or ''
    local text = args['text'] or pargs['text'] or mw.text.trim(args[2] or pargs[2] or '') or ''
    local savyb = args['savybė'] or pargs['savybė'] or ''
    local link = args['link'] or pargs['link'] or ''
    local namespace = args['namespace'] or pargs['namespace'] or '0'
    
    return admv._icon{ page=page, namespace=namespace, text=text, savyb=savyb, link=link }
end

admv._icon = function ( args )
    local frame = mw.getCurrentFrame()
    if args.page == '' then
        return ''
    end
    
    local vel = ''
    local parms = ParmData._get{ page = args.page, parm = {'vėliava', 'herbas' } }
    if parms ~= nil then
        if mw.text.trim(parms['vėliava'] or '') ~= '' then
            vel = parms['vėliava']
        end
        if vel == '' and mw.text.trim(parms['herbas'] or '') ~= '' then
            vel = parms['herbas']
        end
    end
    
    local link = args.link
    if link == '' then
        link = args.page
    end
    local txt = ''
    if vel ~= '' then
        txt = '[[Vaizdas:' .. vel .. '|22x20px|border|Vėliava|link=' .. link .. ']]'
    end
    if args.text == '-' and args.savyb ~= '' then
        txt = txt .. frame:preprocess('{{#set:' .. args.savyb .. '=' .. args.page .. '}}')
    elseif args.text == '-' and args.savyb == '' then
        txt = txt
    elseif args.text == '' and args.savyb ~= '' then
        txt = txt .. '&nbsp;[[' .. args.savyb .. '::' .. link .. '|' .. args.page .. ']]'
    elseif args.text ~= '' and args.savyb ~= '' then
        txt = txt .. '&nbsp;[[' .. args.savyb .. '::' .. link .. '|' .. args.text .. ']]'
    elseif args.text ~= '' and args.savyb == '' then
        txt = txt .. '&nbsp;[[' .. link .. '|' .. args.text .. ']]'
    elseif args.text == '' and args.savyb == '' then
        txt = txt .. '&nbsp;[[' .. link .. '|' .. args.page .. ']]'
    end
    
    return txt
end
    
admv.tipasl = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local page = args['page'] or pargs['page'] or ''
    local tipas = args['tipas'] or pargs['tipas'] or ''
    local link = args['link'] or pargs['link'] or ''
    
    return admv._tipasl{ page=page, tipas=tipas, link=link }
end

admv._tipasl = function ( args )
    local rez = ''
    
    if args.tipas ~= nil and args.tipas ~= '' then
        if args.link == nil or args.link == '' or args.link == '-' then
            rez = args.tipas
        else
            rez = '[[' .. args.link .. '|' .. args.tipas .. ']]'
        end
    else
        rez = Komentaras._kom( '?', 'Nenurodytas ADMV tipas (' .. args.page .. ')', args.page ) 
    end
    
    return rez
end
    
return admv
