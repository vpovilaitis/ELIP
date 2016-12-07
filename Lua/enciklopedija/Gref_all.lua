local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Gref = require('Module:Gref')
local Grefv = require('Module:Grefv')
local Cite = require('Module:Cite')
local ValVietininkas = require('Module:ValstybėsVietininkas')
local Plural = require('Module:Plural')
local Switch = require('Module:Switch')
local json = require('Modulis:JSON')
local ParmData = require('Module:ParmData')
local jsoncol = require('Modulis:JSON/COL')
local jsongbif = require('Modulis:JSON/GBIF')

grefap = {}

-- grefap.getparm = function( rpage, parm )
--     local pagename = rpage.text
--     local rtxt = ''
--     local ret = ''
--     if rpage and rpage.id ~= 0 then
--         rtxt = rpage:getContent() or ""
--         if rpage.isRedirect then
--             local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
--  
--             if not redirect then
--                 redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
--             end
--             if redirect then
--                 pagename = redirect
--                 local page, err = mw.title.new(pagename)
--                 if page and page.id ~= 0 then
--                     rtxt = page:getContent() or ""
--                 end
--             end
--         end
--     end
--  
--     if rtxt ~= '' then
--         ret = mw.ustring.match( rtxt, "%c%s*%|%s*"..parm.."%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
--     end
--  
--     return ret
-- end

grefap._cell = function( lst )
    local tbl = HtmlBuilder.create('table')
    for lstel in mw.text.gsplit(lst,',') do
        if lstel ~= '' then
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext(Grefv.refla(lstel, '', '', '', '', '', '', ''))
                        .done()
                    .done()
        else
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext('<!--  -->')
                        .done()
                    .done()
        end
    end
    tbl.done()
    return tostring(tbl)
end

grefap._celltab = function( lst )
    local tbl = HtmlBuilder.create('table')
    for i, lstel in ipairs(lst) do
        if lstel ~= '' then
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext(Grefv.refla(lstel, '', '', '', '', '', '', ''))
                        .done()
                    .done()
        else
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext('<!--  -->')
                        .done()
                    .done()
        end
    end
    tbl.done()
    return tostring(tbl)
end

grefap._celltab2 = function( lst )
    local tbl = HtmlBuilder.create('table')
    for i, lstel in ipairs(lst) do
        if lstel ~= '' then
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext("'''[["..lstel.."]]'''")
                        .done()
                    .tag('td')
                        .wikitext(Grefv.refla(lstel, '', '', '', '', '', '', ''))
                        .done()
                    .done()
        else
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext('<!--  -->')
                        .done()
                    .done()
        end
    end
    tbl.done()
    return tostring(tbl)
end

grefap._all = function( la, kam, kas, nuo, kiek, frame )
    local root = HtmlBuilder.create()
    local _la, _kam, _kas, _nuo, _kiek = la or '', kam or '', kas, nuo, kiek
    local _div, _mod = math.modf( _kiek/2 )
    if _mod ~= 0 then _div = _div + 1 end
    _kiek = _div
    _div, _mod = math.modf( kiek/2 )
    local _kiek2
    if _mod ~= 0 then 
        _kiek2 = kiek+2
    else
        _kiek2 = kiek+1
    end
    
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    else
        local frame = mw.getCurrentFrame()
        local _ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
        local pg = mw.title.getCurrentTitle()
        local pgname = pg.text
        -- local dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",".._kiek..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        -- _nuo = _nuo + _kiek
        -- local dal2 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",".._kiek..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        -- _nuo = _nuo + _kiek
        -- local dal3 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",1"..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        local dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
            _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",".._kiek2..
            ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        local dal1atbl = mw.text.split(dal1, ',')
        local dal1tbl, dal2tbl = {}, {}
        local tit = mw.title.getCurrentTitle()
        local pgnamelist = mw.text.split(tit.fullText, '/')
        local pgnamelistK = mw.text.split(tit.text, '/')
        local nex = pgnamelist[1] .. '/'
        if #pgnamelist == 1 then
            nex = nex .. '1'
        else
            nnn = tonumber(pgnamelist[2])
            if nnn ~= nil then
                nex = nex .. tostring(nnn+1)
            elseif #pgnamelist > 2 then
                nnn = tonumber(pgnamelist[3])
                if nnn ~= nil then
                    nex = nex .. pgnamelist[2] .. '/' .. tostring(nnn+1)
                else
                    nex = nex .. pgnamelist[2] .. '/' .. '1'
                end
            else
                nex = nex .. '1'
            end
        end
        local tesinys = ''
        for i, lstel in ipairs(dal1atbl) do
            if lstel~='' then
                if i<=_kiek then
                    table.insert(dal1tbl, lstel)
                elseif i<=_kiek*2 then
                    table.insert(dal2tbl, lstel)
                else
                    tesinys = '[['..nex..'|Daugiau]]'
                    local pagenex, err = mw.title.new(nex)
                    rtxtnex = pagenex:getContent()
                    if rtxtnex == nil then
                        tesinys = tesinys .. '[[Kategorija:Nesukurtas sekantis puslapis]]'
                    end
                end
            end
        end
        root
            .grazilentele()
                .tag('th')
                    .attr('colspan', '2')
                    .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
                    .wikitext( ' ', _kam, ' priklauso:' )
                    
                    .newline()
                    .wikitext( '[[Kategorija:' .. pgnamelistK[1] .. '|Ξ]]' )
                    .done()
                .tag('tr')
                    .attr('valign', 'top')
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._celltab(dal1tbl))
                            .done()
                        .done()
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._celltab(dal2tbl))
                            .done()
                        .done()
                    .done()
                .tag('tr')
                    .tag('td')
                        .attr('colspan', '2')
                        .attr('align', 'right')
                        .wikitext( tesinys )
                        .done()
                    .done()
                .done()
            .done()
    end

    root.done()
     
    return tostring(root)
end

grefap.all = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _kam = args.kam or pargs.kam or mw.text.trim(args[2] or pargs[2] or '')
    local _kas = args.kas or pargs.kas or mw.text.trim(args[3] or pargs[3] or '')
    local nuo, _nuo = args.nuo or pargs.nuo, tonumber(args.nuo or pargs.nuo) or 0
    local kiek, _kiek = args.kiek or pargs.kiek, tonumber(args.kiek or pargs.kiek) or 50
    --local _div, _mod = math.modf( _kiek/2 )
    --if _mod ~= 0 then _div = _div + 1 end
    
    return grefap._all( _la, _kam, _kas, _nuo, _kiek, frame )
end

grefap._GGElist = function( la, kam, kas, nuo, kiek, frame )
    local root = HtmlBuilder.create()
    local _la, _kam, _kas, _nuo, _kiek = la or '', kam or '', kas, nuo, kiek
    local _div, _mod = math.modf( _kiek/2 )
    if _mod ~= 0 then _div = _div + 1 end
    _kiek = _div
    _div, _mod = math.modf( kiek/2 )
    local _kiek2
    if _mod ~= 0 then 
        _kiek2 = kiek+2
    else
        _kiek2 = kiek+1
    end
    
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas pavadinimas')
    else
        local frame = mw.getCurrentFrame()
        local _ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
        local pg = mw.title.getCurrentTitle()
        local pgname = pg.text
        -- local dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",".._kiek..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        -- _nuo = _nuo + _kiek
        -- local dal2 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",".._kiek..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        -- _nuo = _nuo + _kiek
        -- local dal3 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s join (select b.la, 1 sk FROM `tax_rel` b WHERE b.`parent` = '"..
        --     _ladb.."' AND b.`type` = '".._kas.."' order by b.la limit ".._nuo..",1"..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.la|data=tax=a.la}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        --local dal1 = frame:preprocess("{{#get_db_data:|db=ggetree|from=/* "..pgname.." */ Skaiciai s join (select b.s_title, 1 sk FROM `ggelist` b WHERE b.`o_title` = '"..
        --    _ladb.."' AND b.`stipas` = '".._kas.."' order by b.s_title limit ".._nuo..",".._kiek2..
        --    ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.s_title|data=tax=a.s_title}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        local dal1 = frame:preprocess("{{#get_db_data:|db=ggetree|from=/* "..pgname.." */ ggelist b|where=b.o_title = '"..
            _ladb.."' AND b.stipas = '".._kas.."' |order by=b.s_title limit ".._nuo..",".._kiek2..
            "|data=tax=b.s_title}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        local dal1atbl = mw.text.split(dal1, ',')
        local dal1tbl, dal2tbl = {}, {}
        local tit = mw.title.getCurrentTitle()
        local pgnamelist = mw.text.split(tit.fullText, '/')
        local pgnamelistK = mw.text.split(tit.text, '/')
        local nex = pgnamelist[1] .. '/'
        if #pgnamelist == 1 then
            nex = nex .. '1'
        else
            nnn = tonumber(pgnamelist[2])
            if nnn ~= nil then
                nex = nex .. tostring(nnn+1)
            elseif #pgnamelist > 2 then
                nnn = tonumber(pgnamelist[3])
                if nnn ~= nil then
                    nex = nex .. pgnamelist[2] .. '/' .. tostring(nnn+1)
                else
                    nex = nex .. pgnamelist[2] .. '/' .. '1'
                end
            else
                nex = nex .. '1'
            end
        end
        local tesinys = ''
        for i, lstel in ipairs(dal1atbl) do
            if lstel~='' then
                if i<=_kiek then
                    table.insert(dal1tbl, lstel)
                elseif i<=_kiek*2 then
                    table.insert(dal2tbl, lstel)
                else
                    -- tesinys = '[['..nex..'|Daugiau]]'
                    -- local pagenex, err = mw.title.new(nex)
                    -- rtxtnex = pagenex:getContent()
                    -- if rtxtnex == nil then
                    --     tesinys = tesinys .. '[[Kategorija:Nesukurtas sekantis puslapis]]'
                    -- end
                end
            end
        end
        root
            .grazilentele()
                .tag('th')
                    .attr('colspan', '2')
                    .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
                    .wikitext( ' ', _kam, ' priklauso:' )
                    
                    .newline()
                    .wikitext( '[[Kategorija:' .. pgnamelistK[1] .. '|Ξ]]' )
                    .done()
                .tag('tr')
                    .attr('valign', 'top')
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._celltab2(dal1tbl))
                            .done()
                        .done()
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._celltab2(dal2tbl))
                            .done()
                        .done()
                    .done()
                .tag('tr')
                    .tag('td')
                        .attr('colspan', '2')
                        .attr('align', 'right')
                        .wikitext( tesinys )
                        .done()
                    .done()
                .done()
            .done()
    end

    root.done()
     
    return tostring(root)
end

grefap.GGElist = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _kam = args.kam or pargs.kam or mw.text.trim(args[2] or pargs[2] or '')
    local _kas = args.kas or pargs.kas or mw.text.trim(args[3] or pargs[3] or '')
    local nuo, _nuo = args.nuo or pargs.nuo, tonumber(args.nuo or pargs.nuo) or 0
    local kiek, _kiek = args.kiek or pargs.kiek, tonumber(args.kiek or pargs.kiek) or 50
    --local _div, _mod = math.modf( _kiek/2 )
    --if _mod ~= 0 then _div = _div + 1 end
    
    return grefap._GGElist( _la, _kam, _kas, _nuo, _kiek, frame )
end

grefap._col2013 = function( la, kam, kas, nuo, kiek, frame, col2013id )
    local root = HtmlBuilder.create()
    local _la, _kam, _kas, _nuo, _kiek = la or '', kam or '', kas, nuo, kiek
    local gbif = ''
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    else
        local frame = mw.getCurrentFrame()
        
        local dal1 = ''
        local dal2 = ''
        local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
        local parms = ParmData._get{ page = ladb, parm = {'colid', 'gbifid' }, template = 'Auto_taxobox' }
        if col2013id == '' and parms ~= nil then
           --local pages = mw.title.new( ladb )
           col2013id = parms['colid'] or ''
        end
           retm =  mw.text.split(col2013id,'%<%!%-%-')
           col2013id = retm[1]
           retm =  mw.text.split(col2013id,'{{subst:')
           col2013id = mw.text.trim(retm[1])
        if gbif == '' and parms ~= nil then
           --local pages = mw.title.new( ladb )
           gbif = parms['gbifid'] or ''
        end
           retm =  mw.text.split(gbif,'<!--')
           gbif = retm[1]
           retm =  mw.text.split(gbif,'{{subst:')
           gbif = mw.text.trim(retm[1])
        local colid, colidm, colidsk, colidrez = col2013id, {}, 0, ''
        local gbifid, gbifidm, gbifidsk, gbifidrez = gbif, {}, 0, ''
        local parms = ParmData._get{ page = ladb, parm = {'karalystė', 'type' }, template = 'Auto_taxobox' }
        if colid == '' and la ~= '' then
            colid = jsoncol._get1{ la = la }
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
            gbifid = jsongbif._get1{ la = la }
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
        col2013id = colidm[1]
        gbif = gbifidm[1]
        --if col2013id == '' then
            -- local inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree b "..
            --     "left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id)|where=b.name='"..
            --     ladb.."' and c.c_name is null|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
            --     "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
            --     "{{#clear_external_data:}}") or ',,,,,'
            -- local inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
            -- if inf2013s[1] == '' then
            --     inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ base.x_col2013taxon c left join _taxon_tree b on (b.taxon_id=c.c_taxon_id)|where=c.c_name='"..
            --         ladb.."'|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
            --         "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
            --         "{{#clear_external_data:}}") or ',,,,,'
            --     inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
            -- end
    
            -- if gbif == '' then
            --    local gbif1 = frame:preprocess("{{#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
            --        ladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
            --        "{{#for_external_table:{{{id}}}}}{{#clear_external_data:}}") or ''
            --    if gbif1 ~= '' and gbif1 ~= nil then
            --       gbif = gbif1
            --    end
            -- end
            -- if gbif == '' then
            --    local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
            --                                  " (select distinct t.name, t.gbif_id " ..
            --                                  "  from GBIF_sk t " ..
            --                                  "  where t.name = '" .. ladb .. "') tt " ..
            --                                  "|where=tt.name='"..
            --         ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            --         "{{#for_external_table:{{{gbif}}};}}"..
            --         "{{#clear_external_data:}}") or ''
         -- 
            --    sgb = mw.text.split(sgbifid,';') or {}
            --    if sgbifid ~= '' then
            --      if #sgb == 3 then
            --         if sgb[2] == '0' then
            --            gbif = sgb[1]
            --         end
            --      elseif #sgb == 2 then
            --         gbif = sgb[1]
            --      end
            --    end
            -- end
         -- 
            -- if gbif == '' then
            --    local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
            --                                  " (select distinct t.name, t.gbif_id " ..
            --                                  "  from paplitimas t " ..
            --                                  "  where t.name = '" .. ladb .. "') tt " ..
            --                                  "|where=tt.name='"..
            --         ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            --         "{{#for_external_table:{{{gbif}}};}}"..
            --         "{{#clear_external_data:}}") or ''
         -- 
            --    sgb = mw.text.split(sgbifid,';') or {}
            --    if sgbifid ~= '' then
            --      if #sgb == 3 then
            --         if sgb[2] == '0' then
            --            gbif = sgb[1]
            --         end
            --      elseif #sgb == 2 then
            --         gbif = sgb[1]
            --      end
            --    end
            -- end
            -- if true then
            --     return '--'..tostring(col2013id)..'--'
            -- end
            if col2013id ~= '' and gbif ~= '' then
                dal1 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join ( " ..
                    " select distinct u.name, case u.`rank` " ..
                    "         			when 1 then 'karalystė' " ..
                    " 					when 2 then 'tipas' " ..
                    " 					when 3 then 'klasė' " ..
                    " 					when 4 then 'būrys' " ..
                    " 					when 5 then 'antšeimis' " ..
                    " 					when 6 then 'šeima' " ..
                    " 					when 7 then 'gentis' " ..
                    " 					when 8 then 'rūšis' " ..
                    " 					when 9 then 'porūšis' " ..
                    " 					when 10 then 'variatetas' " ..
                    " 					when 11 then 'forma' " ..
                    " 					else 'kita' " ..
                    " 				end `rank`, u.`rank` ranknr, 1 sk  " ..
                    " from ( " ..
                    " SELECT ifnull(gc.c_name, gt.name) name,  " ..
                    "         		case gt.`rank` " ..
                    " 					when 'karalystė' then 1 " ..
                    " 					when 'tipas' then 2 " ..
                    " 					when 'klasė' then 3 " ..
                    " 					when 'būrys' then 4 " ..
                    " 					when 'antšeimis' then 5 " ..
                    " 					when 'šeima' then 6 " ..
                    " 					when 'gentis' then 7 " ..
                    " 					when 'rūšis' then 8 " ..
                    " 					when 'porūšis' then 9 " ..
                    " 					when 'variatetas' then 10 " ..
                    " 					when 'forma' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM Paplitimas.`GBIF_tree` gt  " ..
                    " 	left join base.x_GBIFtax gc on (gc.c_taxon_id = gt.`key`) " ..
                    " 	WHERE gt.parentKey = "..
                    gbif..
                    " union " ..
                    " SELECT ifnull(tc.c_name,  " ..
                    " 				case tt.name " ..
                    " 					when 'Superfamily unassigned' then '" .. 
                        ladb .. " (nepriskirti antšeimiui)' " ..
                    " 					when 'Not assigned' then '" .. 
                        ladb .. " (nepriskirti)'  " ..
                    " 					else tt.name " ..
                    " 				end) name,  " ..
                    " 				case tt.`rank` " ..
                    " 					when 'kingdom' then 1 " ..
                    " 					when 'phylum' then 2 " ..
                    " 					when 'class' then 3 " ..
                    " 					when 'order' then 4 " ..
                    " 					when 'superfamily' then 5 " ..
                    " 					when 'family' then 6 " ..
                    " 					when 'genus' then 7 " ..
                    " 					when 'species' then 8 " ..
                    " 					when 'subspecies' then 9 " ..
                    " 					when 'variety' then 10 " ..
                    " 					when 'form' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM col2013ac.`_taxon_tree` tt " ..
                    " 	left join base.x_col2013taxon tc on (tt.taxon_id=tc.c_taxon_id) " ..
                    " 	WHERE tt.`parent_id` = "..
                    col2013id..
                    " ) u " ..
                    " order by u.`rank`, u.name " ..
                    " limit ".._nuo..",".._kiek..
                    " ) a on (s.nr=a.sk)|where=s.nr=1" ..
                    "|order by=a.`ranknr`, a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
                _nuo = _nuo + _kiek
                dal2 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join ( " ..
                    " select distinct u.name, case u.`rank` " ..
                    "     				when 1 then 'karalystė' " ..
                    " 					when 2 then 'tipas' " ..
                    " 					when 3 then 'klasė' " ..
                    " 					when 4 then 'būrys' " ..
                    " 					when 5 then 'antšeimis' " ..
                    " 					when 6 then 'šeima' " ..
                    " 					when 7 then 'gentis' " ..
                    " 					when 8 then 'rūšis' " ..
                    " 					when 9 then 'porūšis' " ..
                    " 					when 10 then 'variatetas' " ..
                    " 					when 11 then 'forma' " ..
                    " 					else 'kita' " ..
                    " 				end `rank`, u.`rank` ranknr, 1 sk  " ..
                    " from ( " ..
                    " SELECT ifnull(gc.c_name, gt.name) name,  " ..
                    "         		case gt.`rank` " ..
                    " 					when 'karalystė' then 1 " ..
                    " 					when 'tipas' then 2 " ..
                    " 					when 'klasė' then 3 " ..
                    " 					when 'būrys' then 4 " ..
                    " 					when 'antšeimis' then 5 " ..
                    " 					when 'šeima' then 6 " ..
                    " 					when 'gentis' then 7 " ..
                    " 					when 'rūšis' then 8 " ..
                    " 					when 'porūšis' then 9 " ..
                    " 					when 'variatetas' then 10 " ..
                    " 					when 'forma' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM Paplitimas.`GBIF_tree` gt  " ..
                    " 	left join base.x_GBIFtax gc on (gc.c_taxon_id = gt.`key`) " ..
                    " 	WHERE gt.parentKey = "..
                    gbif..
                    " union " ..
                    " SELECT ifnull(tc.c_name,  " ..
                    " 				case tt.name " ..
                    " 					when 'Superfamily unassigned' then '" .. 
                        ladb .. " (nepriskirti antšeimiui)' " ..
                    " 					when 'Not assigned' then '" .. 
                        ladb .. " (nepriskirti)'  " ..
                    " 					else tt.name " ..
                    " 				end) name,  " ..
                    " 				case tt.`rank` " ..
                    " 					when 'kingdom' then 1 " ..
                    " 					when 'phylum' then 2 " ..
                    " 					when 'class' then 3 " ..
                    " 					when 'order' then 4 " ..
                    " 					when 'superfamily' then 5 " ..
                    " 					when 'family' then 6 " ..
                    " 					when 'genus' then 7 " ..
                    " 					when 'species' then 8 " ..
                    " 					when 'subspecies' then 9 " ..
                    " 					when 'variety' then 10 " ..
                    " 					when 'form' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM col2013ac.`_taxon_tree` tt " ..
                    " 	left join base.x_col2013taxon tc on (tt.taxon_id=tc.c_taxon_id) " ..
                    " 	WHERE tt.`parent_id` = "..
                    col2013id..
                    " ) u " ..
                    " order by u.`rank`, u.name " ..
                    " limit ".._nuo..",".._kiek..
                    " ) a on (s.nr=a.sk)|where=s.nr=1" ..
                    "|order by=a.`ranknr`, a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
            elseif gbif ~= '' then
                dal1 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join ( " ..
                    " select distinct u.name, case u.`rank` " ..
                    "         			when 1 then 'karalystė' " ..
                    " 					when 2 then 'tipas' " ..
                    " 					when 3 then 'klasė' " ..
                    " 					when 4 then 'būrys' " ..
                    " 					when 5 then 'antšeimis' " ..
                    " 					when 6 then 'šeima' " ..
                    " 					when 7 then 'gentis' " ..
                    " 					when 8 then 'rūšis' " ..
                    " 					when 9 then 'porūšis' " ..
                    " 					when 10 then 'variatetas' " ..
                    " 					when 11 then 'forma' " ..
                    " 					else 'kita' " ..
                    " 				end `rank`, u.`rank` ranknr, 1 sk  " ..
                    " from ( " ..
                    " SELECT ifnull(gc.c_name, gt.name) name,  " ..
                    "         		case gt.`rank` " ..
                    " 					when 'karalystė' then 1 " ..
                    " 					when 'tipas' then 2 " ..
                    " 					when 'klasė' then 3 " ..
                    " 					when 'būrys' then 4 " ..
                    " 					when 'antšeimis' then 5 " ..
                    " 					when 'šeima' then 6 " ..
                    " 					when 'gentis' then 7 " ..
                    " 					when 'rūšis' then 8 " ..
                    " 					when 'porūšis' then 9 " ..
                    " 					when 'variatetas' then 10 " ..
                    " 					when 'forma' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM Paplitimas.`GBIF_tree` gt  " ..
                    " 	left join base.x_GBIFtax gc on (gc.c_taxon_id = gt.`key`) " ..
                    " 	WHERE gt.parentKey = "..
                    gbif..
                    " ) u " ..
                    " order by u.`rank`, u.name " ..
                    " limit ".._nuo..",".._kiek..
                    " ) a on (s.nr=a.sk)|where=s.nr=1" ..
                    "|order by=a.`ranknr`, a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
                _nuo = _nuo + _kiek
                dal2 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join ( " ..
                    " select distinct u.name, case u.`rank` " ..
                    "     				when 1 then 'karalystė' " ..
                    " 					when 2 then 'tipas' " ..
                    " 					when 3 then 'klasė' " ..
                    " 					when 4 then 'būrys' " ..
                    " 					when 5 then 'antšeimis' " ..
                    " 					when 6 then 'šeima' " ..
                    " 					when 7 then 'gentis' " ..
                    " 					when 8 then 'rūšis' " ..
                    " 					when 9 then 'porūšis' " ..
                    " 					when 10 then 'variatetas' " ..
                    " 					when 11 then 'forma' " ..
                    " 					else 'kita' " ..
                    " 				end `rank`, u.`rank` ranknr, 1 sk  " ..
                    " from ( " ..
                    " SELECT ifnull(gc.c_name, gt.name) name,  " ..
                    "         		case gt.`rank` " ..
                    " 					when 'karalystė' then 1 " ..
                    " 					when 'tipas' then 2 " ..
                    " 					when 'klasė' then 3 " ..
                    " 					when 'būrys' then 4 " ..
                    " 					when 'antšeimis' then 5 " ..
                    " 					when 'šeima' then 6 " ..
                    " 					when 'gentis' then 7 " ..
                    " 					when 'rūšis' then 8 " ..
                    " 					when 'porūšis' then 9 " ..
                    " 					when 'variatetas' then 10 " ..
                    " 					when 'forma' then 11 " ..
                    " 					else 12 " ..
                    " 				end `rank`  " ..
                    " 	FROM Paplitimas.`GBIF_tree` gt  " ..
                    " 	left join base.x_GBIFtax gc on (gc.c_taxon_id = gt.`key`) " ..
                    " 	WHERE gt.parentKey = "..
                    gbif..
                    " ) u " ..
                    " order by u.`rank`, u.name " ..
                    " limit ".._nuo..",".._kiek..
                    " ) a on (s.nr=a.sk)|where=s.nr=1" ..
                    "|order by=a.`ranknr`, a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
            elseif col2013id ~= '' then
                dal1 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ Skaiciai s left join (SELECT case when b.`name`='Superfamily unassigned' then '" .. 
                        ladb .. " (nepriskirti antšeimiui)' when b.name='Not assigned' then '" .. 
                        ladb .. " (nepriskirti)' else ifnull(c.c_name,b.`name`) end name, 1 sk FROM `_taxon_tree` b left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id) WHERE b.`parent_id` = "..
                    col2013id.." ORDER BY 1 ASC limit ".._nuo..",".._kiek..
                    ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
                _nuo = _nuo + _kiek
                dal2 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ taxon.Skaiciai s left join (SELECT case when b.`name`='Superfamily unassigned' then '" .. 
                        ladb .. " (nepriskirti antšeimiui)' when b.name='Not assigned' then '" .. 
                        ladb .. " (nepriskirti)' else ifnull(c.c_name,b.`name`) end name, 1 sk FROM `_taxon_tree` b left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id) WHERE b.`parent_id` = "..
                    col2013id.." ORDER BY 1 ASC limit ".._nuo..",".._kiek..
                    ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
            end
        -- else
        --     dal1 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ Skaiciai s left join (SELECT case when b.`name`='Superfamily unassigned' then '" .. 
        --             ladb .. " (nepriskirti antšeimiui)' when b.name='Not assigned' then '" .. 
        --             ladb .. " (nepriskirti)' else ifnull(c.c_name,b.`name`) end name, 1 sk FROM `_taxon_tree` b left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id) WHERE b.`parent_id` = "..
        --         col2013id.." ORDER BY 1 ASC limit ".._nuo..",".._kiek..
        --         ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        --     _nuo = _nuo + _kiek
        --     dal2 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ taxon.Skaiciai s left join (SELECT case when b.`name`='Superfamily unassigned' then '" .. 
        --             ladb .. " (nepriskirti antšeimiui)' when b.name='Not assigned' then '" .. 
        --             ladb .. " (nepriskirti)' else ifnull(c.c_name,b.`name`) end name, 1 sk FROM `_taxon_tree` b left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id) WHERE b.`parent_id` = "..
        --         col2013id.." ORDER BY 1 ASC limit ".._nuo..",".._kiek..
        --         ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        -- end
        local tit = mw.title.getCurrentTitle()
        local pgnamelist = mw.text.split(tit.text, '/')
        root
            .grazilentele()
                .tag('th')
                    .attr('colspan', '2')
                    .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
                    .wikitext( ' ', _kam, ' priklauso:' )
                    .newline()
                    .wikitext( '[[Kategorija:' .. pgnamelist[1] .. '|Ξ]]' )
                    .done()
                .tag('tr')
                    .attr('valign', 'top')
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._cell(dal1))
                            .done()
                        .done()
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._cell(dal2))
                            .done()
                        .done()
                    .done()
                .done()
            .done()
    end

    root.done()
     
    return tostring(root)
end

grefap.col2013 = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _col2013id = args.col2013id or pargs.col2013id or ''
    local _kam = args.kam or pargs.kam or mw.text.trim(args[2] or pargs[2] or '')
    local _kas = args.kas or pargs.kas or mw.text.trim(args[3] or pargs[3] or '')
    local nuo = tonumber(args.nuo) or tonumber(pargs.nuo) or 0
    local _kiek = tonumber(args.kiek) or tonumber(pargs.kiek) or 20
    local _div, _mod = math.modf( (_kiek+1)/2 )
    if _mod ~= 0 then _div = _div end
    
    return grefap._col2013( _la, _kam, _kas, nuo, _div, frame, _col2013id )
end

grefap.pages = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _viso = tonumber(args.viso or pargs.viso) or 0
    local _kiek = tonumber(args.kiek or pargs.kiek) or 0
    local _puslmax, _mod1 = grefap._pages( _viso, _kiek )
    return tostring(_puslmax)
end
    
grefap._pages = function( _viso, _kiek )
       local _div1, _mod1 = math.modf( tonumber(_viso)/tonumber(_kiek) )
       local puslmax = 1
       if _mod1 ~= 0 then
          puslmax = _div1+1
       else
           puslmax = _div1
       end
       return puslmax, _mod1
end

grefap.prevpg = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _max = tonumber(args.max or pargs.max or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._prevpg( _nr, _max, _page )
end
    
grefap._prevpg = function( _pgnr, _puslmax, _pgname )
    local rez = ""
        if _pgnr == 0 and _puslmax == 1 then
           rez = ""
        elseif _pgnr == 0 and _puslmax > 1 then
           rez = "[[Sritis:" .. _pgname .. '/' .. tostring(_puslmax-1) .. '|' .. tostring(_puslmax) .. ' dalis]]'
        elseif _pgnr == 1 and _puslmax >= 2 then
           rez = "[[Sritis:" .. _pgname .. '|' .. tostring(_pgnr) .. ' dalis]]'
        elseif _pgnr > 1 and _puslmax > 2 then
           rez = "[[Sritis:" .. _pgname .. '/' .. tostring(_pgnr-1) .. '|' .. tostring(_pgnr) .. ' dalis]]'
        end
    return rez
end

grefap.nextpg = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _max = tonumber(args.max or pargs.max or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._nextpg( _nr, _max, _page )
end
    
grefap._nextpg = function( _pgnr, _puslmax, _pgname )
    local rez = ""
        if _pgnr == 0 and _puslmax == 1 then
           rez = ""
        elseif _puslmax > _pgnr+1 then
           rez = "[[Sritis:" .. _pgname .. '/' .. tostring(_pgnr+1) .. '|' .. tostring(_pgnr+2) .. ' dalis]]'
        elseif _puslmax == _pgnr+1 then
           rez = "[[Sritis:" .. _pgname .. '|' .. tostring(1) .. ' dalis]]'
        end
    return rez
end

grefap.pagelist = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _visi = tonumber(args.visi or pargs.visi or 0) or 0
    local _kiek = tonumber(args.kiek or pargs.kiek or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._pagelist( _page, _nr, _visi, _kiek )
end
    
grefap._pagelist = function( _page, _nr, _visi, _kiek )
    local cnr
    local rez = ""
    for cnr = 0,9 do
        local vpage = ""
        if (cnr * _kiek) < _visi then
            if _nr == cnr then
                rez =  rez .. "'''"
            end
            if cnr == 0 then 
                vpage = ""
            else
                vpage = "/" .. tostring(cnr)
            end
            rez = rez .. "[[Sritis:" .. _page .. vpage .. "|" .. tostring(cnr+1) .. " psl.]]"
            if _nr == cnr then
                rez =  rez .. "'''"
            end
            if (((cnr + 1) * _kiek) < _visi) and (cnr < 9) then
                rez = rez .. ",&nbsp;"
            end
        end
    end
    local pmax, _mod = grefap._pages ( _visi, _kiek )
    if 2 < _nr and _nr < (pmax - 2) then
        if 10 < (_nr - 9) then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
        for cnr = -9,9 do
            local vpage = "/" .. tostring(cnr+_nr)
            if (((cnr+_nr) * _kiek) < _visi) and ((cnr+_nr) > 9) and ((cnr+_nr) < (pmax - 9)) then
                if cnr==0 then
                    rez =  rez .. "'''"
                end
                rez = rez .. "[[Sritis:" .. _page .. vpage .. "|" .. tostring(cnr+_nr+1) .. " psl.]]"
                if cnr==0 then
                    rez =  rez .. "'''"
                end
                if (((cnr+_nr + 1) * _kiek) < _visi) and (cnr < 9) and ((cnr+_nr) < (pmax - 10)) then
                    rez = rez .. ",&nbsp;"
                end
            end
        end
        if _nr < (pmax - 10) then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
    else
        if pmax > 19 then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
    end
    for cnr = -9,0 do
        local vpage = "/" .. tostring(cnr+pmax)
        if (((cnr+pmax) * _kiek) < _visi) and ((cnr+pmax) > 9) then
            if (cnr+pmax)==_nr then
                rez =  rez .. "'''"
            end
            rez = rez .. "[[Sritis:" .. _page .. vpage .. "|" .. tostring(cnr+pmax+1) .. " psl.]]"
            if (cnr+pmax)==_nr then
                rez =  rez .. "'''"
            end
            if (((cnr+pmax + 1) * _kiek) < _visi) and (cnr < 0) then
                rez = rez .. ",&nbsp;"
            end
        end
    end
    return rez
end

grefap.prevpg2 = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _max = tonumber(args.max or pargs.max or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._prevpg2( _nr, _max, _page )
end
    
grefap._prevpg2 = function( _pgnr, _puslmax, _pgname )
    local rez = ""
        if _pgnr == 0 and _puslmax == 1 then
           rez = ""
        elseif _pgnr == 0 and _puslmax > 1 then
           rez = "[[" .. _pgname .. '/' .. tostring(_puslmax-1) .. '|' .. tostring(_puslmax) .. ' dalis]]'
        elseif _pgnr == 1 and _puslmax >= 2 then
           rez = "[[" .. _pgname .. '|' .. tostring(_pgnr) .. ' dalis]]'
        elseif _pgnr > 1 and _puslmax > 2 then
           rez = "[[" .. _pgname .. '/' .. tostring(_pgnr-1) .. '|' .. tostring(_pgnr) .. ' dalis]]'
        end
    return rez
end

grefap.nextpg2 = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _max = tonumber(args.max or pargs.max or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._nextpg2( _nr, _max, _page )
end
    
grefap._nextpg2 = function( _pgnr, _puslmax, _pgname )
    local rez = ""
        if _pgnr == 0 and _puslmax == 1 then
           rez = ""
        elseif _puslmax > _pgnr+1 then
           rez = "[[" .. _pgname .. '/' .. tostring(_pgnr+1) .. '|' .. tostring(_pgnr+2) .. ' dalis]]'
        elseif _puslmax == _pgnr+1 then
           rez = "[[" .. _pgname .. '|' .. tostring(1) .. ' dalis]]'
        end
    return rez
end

grefap.pagelist2 = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _nr = tonumber(args.nr or pargs.nr or 0) or 0
    local _visi = tonumber(args.visi or pargs.visi or 0) or 0
    local _kiek = tonumber(args.kiek or pargs.kiek or 0) or 0
    local _page = args.page or pargs.page
    
    return grefap._pagelist2( _page, _nr, _visi, _kiek )
end
    
grefap._pagelist2 = function( _page, _nr, _visi, _kiek )
    local cnr
    local rez = ""
    for cnr = 0,9 do
        local vpage = ""
        if (cnr * _kiek) < _visi then
            if _nr == cnr then
                rez =  rez .. "'''"
            end
            if cnr == 0 then 
                vpage = ""
            else
                vpage = "/" .. tostring(cnr)
            end
            rez = rez .. "[[" .. _page .. vpage .. "|" .. tostring(cnr+1) .. " psl.]]"
            if _nr == cnr then
                rez =  rez .. "'''"
            end
            if (((cnr + 1) * _kiek) < _visi) and (cnr < 9) then
                rez = rez .. ",&nbsp;"
            end
        end
    end
    local pmax, _mod = grefap._pages ( _visi, _kiek )
    if 2 < _nr and _nr < (pmax - 2) then
        if 10 < (_nr - 9) then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
        for cnr = -9,9 do
            local vpage = "/" .. tostring(cnr+_nr)
            if (((cnr+_nr) * _kiek) < _visi) and ((cnr+_nr) > 9) and ((cnr+_nr) < (pmax - 9)) then
                if cnr==0 then
                    rez =  rez .. "'''"
                end
                rez = rez .. "[[" .. _page .. vpage .. "|" .. tostring(cnr+_nr+1) .. " psl.]]"
                if cnr==0 then
                    rez =  rez .. "'''"
                end
                if (((cnr+_nr + 1) * _kiek) < _visi) and (cnr < 9) and ((cnr+_nr) < (pmax - 10)) then
                    rez = rez .. ",&nbsp;"
                end
            end
        end
        if _nr < (pmax - 10) then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
    else
        if pmax > 19 then
            rez = rez .. "&nbsp;...&nbsp;"
        else
            rez = rez .. ",&nbsp;"
        end
    end
    for cnr = -9,0 do
        local vpage = "/" .. tostring(cnr+pmax)
        if (((cnr+pmax) * _kiek) < _visi) and ((cnr+pmax) > 9) then
            if (cnr+pmax)==_nr then
                rez =  rez .. "'''"
            end
            rez = rez .. "[[" .. _page .. vpage .. "|" .. tostring(cnr+pmax+1) .. " psl.]]"
            if (cnr+pmax)==_nr then
                rez =  rez .. "'''"
            end
            if (((cnr+pmax + 1) * _kiek) < _visi) and (cnr < 0) then
                rez = rez .. ",&nbsp;"
            end
        end
    end
    return rez
end

grefap._gbif = function( la, valst, kam, kas, nuo, kiek, frame, gbifid )
    local root = HtmlBuilder.create()
    local _la, _valst, _kam, _kas, _nuo, _kiek, _gbifid = la or '', valst or '', kam or '', kas or '', nuo or '', kiek or '', gbifid or ''
    local frame = mw.getCurrentFrame()
    
    local tit = mw.title.getCurrentTitle()
    local pgname = tit.text
    local pgnamelist = mw.text.split(tit.text, '/')
    if _valst == '' and #pgnamelist > 1 then _valst = pgnamelist[2] end
    if _valst == '' then
        return Komentaras._kom('?', 'Nenurodyta valstybė') ..
               '[[Kategorija:Surinkti]]'
    end
    local pgnr = 0
    local pgnrs = '0'
    if #pgnamelist == 3 then pgnr = tonumber(pgnamelist[3]) end
    if _kiek == '' then _kiek = '20' end
    local _div, _mod = math.modf( tonumber(_kiek)/2 )
    if _mod ~= 0 then
       _div = _div + 1
       _kiek = tostring(_div * 2)
    end
    if _nuo == '' then _nuo = tostring(pgnr * tonumber(_kiek)) end

    local parms = ParmData._get{ page = tit.rootText, parm = {'la', 'lt', 'parent', 'type', 'gbifid'}, template = 'Auto_taxobox' }
    -- local rpage, err = mw.title.new(tit.rootText)
    -- local rtxt = ''
    -- if rpage and rpage.id ~= 0 then
    --     rtxt = rpage:getContent() or ""
    --     if rpage.isRedirect then
    --         local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
    -- 
    --         if not redirect then
    --             redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
    --         end
    --         if redirect then
    --             pagename = redirect
    --             local page, err = mw.title.new(pagename)
    --             if page and page.id ~= 0 then
    --                 rtxt = page:getContent() or ""
    --             end
    --         end
    --     end
    -- end

    local lt, parent, typ, pav, byname = '', '', '', '', 0
    if parms ~= nil then
        if _la == '' then
           _la = parms['la'] or ''
        end
        lt = parms['lt'] or ''
        parent = parms['parent'] or ''
        typ = parms['type'] or ''
        if _gbifid == '' then
           _gbifid = parms['gbifid'] or ''
        end
    else
        _la=tit.rootText
        local ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
        local gtxt = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id, t.taxType " ..
                                     "  from paplitimas t " ..
                                     "  where t.name = '" .. ladb .. "') tt " ..
                                     "|where=tt.name='"..
            ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id,typ=tt.taxType}}"..
            "{{#for_external_table:{{{gbif}}}/{{{typ}}};}}"..
            "{{#clear_external_data:}}") or ''
        
        byname = 1
        typ = 'nežinomas'
       gtx = mw.text.split(gtxt,';') or {}
       if gtxt ~= '' then
         if #gtx == 3 then
             gtx2 = mw.text.split(gtx[2],'/') or {}
            if gtx2[1] == '0' then
                gtx2 = mw.text.split(gtx[1],'/') or {}
               _gbifid = gtx2[1]
               typ = gtx2[2]
               byname = 0
            end
         elseif #gtx == 2 then
                gtx2 = mw.text.split(gtx[1],'/') or {}
               _gbifid = gtx2[1]
               typ = gtx2[2]
               byname = 0
         end
       end
        
    end
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas') ..
               '[[Kategorija:Surinkti]]'
    end

    if lt ~= '' then pav = lt else pav = la end
    local typs = { ['karalystė'] = 'kingdom',
                   ['skyrius'] = 'phylum',
                   ['tipas'] = 'phylum',
                   ['klasė'] = 'class',
                   ['būrys'] = 'order',
                   ['eilė'] = 'order',
                   ['šeima'] = 'family',
                   ['gentis'] = 'genus'
                 }
    local typskam = { ['karalystė'] = 'šios karalystės',
                      ['skyrius'] = 'šio skyriaus',
                      ['tipas'] = 'šio tipo',
                      ['potipis'] = 'šio potipio',
                      ['infratipas'] = 'šio infratipo',
                      ['antklasis'] = 'šio antklasio',
                      ['klasė'] = 'šios klasės',
                      ['poklasis'] = 'šio poklasio',
                      ['infraklasė'] = 'šios infraklasės',
                      ['antbūris'] = 'šio antbūrio',
                      ['būrys'] = 'šio būrio',
                      ['pobūris'] = 'šio pobūrio',
                      ['infrabūrys'] = 'šio infrabūrio',
                      ['eilė'] = 'šios eilės',
                      ['antšeimis'] = 'šio antšeimio',
                      ['šeima'] = 'šios šeimos',
                      ['pošeimis'] = 'šio pošeimio',
                      ['gentis'] = 'šios genties',
                      ['nežinomas'] = 'nežinomas'
                    }
    local typskam3 = { ['karalystė'] = 'karalystės',
                      ['skyrius'] = 'skyriaus',
                      ['tipas'] = 'tipo',
                      ['potipis'] = 'potipio',
                      ['infratipas'] = 'infratipo',
                      ['antklasis'] = 'antklasio',
                      ['klasė'] = 'klasės',
                      ['poklasis'] = 'poklasio',
                      ['infraklasė'] = 'infraklasės',
                      ['antbūris'] = 'antbūrio',
                      ['būrys'] = 'būrio',
                      ['pobūris'] = 'pobūrio',
                      ['infrabūrys'] = 'infrabūrio',
                      ['eilė'] = 'eilės',
                      ['antšeimis'] = 'antšeimio',
                      ['šeima'] = 'šeimos',
                      ['pošeimis'] = 'pošeimio',
                      ['gentis'] = 'genties',
                     ['nežinomas'] = 'nežinomas'
                     }
    local typskam2 = { ['karalystė'] = 'šiai karalystei',
                      ['skyrius'] = 'šiam skyriui',
                      ['tipas'] = 'šiam tipui',
                      ['potipis'] = 'šiam potipiui',
                      ['infratipas'] = 'šiam infratipui',
                      ['antklasis'] = 'šiam antklasiui',
                      ['klasė'] = 'šiai klasei',
                      ['poklasis'] = 'šiam poklasiui',
                      ['infraklasė'] = 'šiai infraklasei',
                      ['antbūriss'] = 'šiam antbūriui',
                      ['būrys'] = 'šiam būriui',
                      ['pobūris'] = 'šiam pobūriui',
                      ['infrabūrys'] = 'šiam infrabūriui',
                      ['eilė'] = 'šiai eilei',
                      ['antšeimis'] = 'šiam antšeimiui',
                      ['šeima'] = 'šiai šeimai',
                      ['pošeimis'] = 'šiam pošeimiui',
                      ['gentis'] = 'šiai genčiai',
                     ['nežinomas'] = 'nežinomas'
                     }

    local ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
    local elipsktax = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ tax_sal_taxr|where=pla='"..
           ladb.."' and ctype='rūšis' and salis = '" .. _valst .. "' |order by=pla|data=sktax=kiek}}"..
           "{{#for_external_table:{{{sktax}}}}}{{#clear_external_data:}}") or ''
    if typs[typ] == nil and elipsktax == '' and byname == 0 then
        return Komentaras._kom('?', 'Taksono tipas, kuriam nėra aptikimo informacijos pagal šalis') ..
               '[[Kategorija:Surinkti]]'
    end

    _kam3 = _kam
    if _kam == '' then 
       _kam = typskam[typ] 
       _kam3 = typskam3[typ] 
    end

    if typs[typ] ~= nil then
        root
            .wikitext( "'''", ValVietininkas._viet( _valst, '', '#default' ), "''' –", ' aptinkamos ', _kam3, ' (' )
            .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
            .wikitext( ') rūšys.' )
            .newline()
            .newline()
            .wikitext( ":Sąrašas yra sudarytas remiantis [[Globalios biologinės įvairovės informacijos priemonė|Globalios biologinės įvairovės informacijos priemonės]] (''GBĮIP, Global Biodiversity Information Facility, GBIF'') pateikiamą informaciją." )
            .newline()
            .newline()
            .wikitext( "== Sąrašas ==" )
            .newline()
    else
        root
            .wikitext( "'''", ValVietininkas._viet( _valst, '', '#default' ), "''' –", ' aptinkamos ', _kam3, ' (' )
            .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
            .wikitext( ') rūšys.' )
            .newline()
            .newline()
            .wikitext( "== Sąrašas ==" )
            .newline()
    end

    if _gbifid == '' then
       local gbif1 = frame:preprocess("{{#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
           ladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
           "{{#for_external_table:{{{id}}}}}{{#clear_external_data:}}") or ''
       if gbif1 ~= '' and gbif1 ~= nil then
          _gbifid = gbif1
       end
    end
   if _gbifid == '' then
       local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from paplitimas t " ..
                                     "  where t.name = '" .. ladb .. "') tt " ..
                                     "|where=tt.name='"..
            ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            "{{#for_external_table:{{{gbif}}};}}"..
            "{{#clear_external_data:}}") or ''
 
       sgb = mw.text.split(sgbifid,';') or {}
       if sgbifid ~= '' then
         if #sgb == 3 then
            if sgb[2] == '0' then
               _gbifid = sgb[1]
            end
         elseif #sgb == 2 then
            _gbifid = sgb[1]
         end
       end
    end
 
    if _gbifid == '' and elipsktax == '' then
        return tostring(root) .. '\n\n' .. Komentaras._kom('?', 'Nenurodytas GBIF identifikatorius') ..
               '[[Kategorija:Surinkti]]'
    end
        
    local sgbifidk = ''
    if _gbifid ~= '' then
       sgbifidk = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ paplitimas t |where=t.gbif_id="..
            _gbifid .. " and t.country='" .. _valst .. "' |order by=t.gbif_id desc|data=spec=t.species,specs=t.speciessyn}}"..
            "{{#for_external_table:{{{spec}}}~{{{specs}}}~;}}"..
            "{{#clear_external_data:}}") or ''
    end

    if sgbifidk == '' and elipsktax == '' then
        return tostring(root) .. '\n\n' .. Komentaras._kom('?', 'Nerastas šaliai GBIF elementas') ..
               '[[Kategorija:Surinkti]]'
    end

    local spec, viso = '', ''
    if sgbifidk ~= '' then
       sgbk = mw.text.split(sgbifidk,'~')
       spec, viso = sgbk[1], sgbk[2]

       local textne = ''
       if spec ~= viso then
          textne = '\n\nKadangi GBĮIP kai kurios rūšys registruotos skirtingais [[Binarinė nomenklatūra|binariniais]] rūšių pavadinimais, tai šį sąrašą sudaro ' ..
                   viso .. ' ' .. Plural._plural( {viso, 'taksonas', 'taksonai', 'taksonų'} ) .. '. Dalis iš jų gali būti laikomi sinonimais tam tikrų rūšių, kurios nebūtinai priklauso ' .. typskam2[typ] .. '.'
       end
    else
       spec, viso = elipsktax, elipsktax
    end

    local headargs = {}
    local puslmax, _mod1 = grefap._pages( viso, _kiek )
       -- local _div1, _mod1 = math.modf( (tonumber(viso)+tonumber(_kiek)-1)/tonumber(_kiek) )
       -- local puslmax = 1
       -- 
       -- if _mod1 ~= 0 then
       --    puslmax = _div1
       -- end
       pagelength = tostring(tonumber(_kiek) / 2)
       if puslmax == pgnr+1 or (puslmax == 1) then
          local _div9, _mod9 = math.modf( _mod1*tonumber(_kiek)+0.9999 )
          local _div5, _mod5 = math.modf( (_div9+1)/2 )
          if _mod5 ~= 0 then
             _div5 = _div5 + 1
          end
          pagelength = tostring(_div5)
       end

        local dal1 = ''
        local dal2 = ''
    if sgbifidk ~= '' and typs[typ] ~= nil then
            dal1 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join (SELECT ifnull(c.c_name,b.`name`)" ..
                " name, 1 sk FROM `paplitimas` b left join base.x_GBIFtax c on (b.gbif_id=c.c_taxon_id) WHERE b.`".. typs[typ] .."_id` = "..
                _gbifid.." and country = '" .. _valst .. "' and taxType = 'rūšis' ORDER BY 1 ASC limit ".._nuo..","..pagelength..
                ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
            _nuo = _nuo + pagelength
            dal2 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ Skaiciai s left join (SELECT ifnull(c.c_name,b.`name`)" ..
                " name, 1 sk FROM `paplitimas` b left join base.x_GBIFtax c on (b.gbif_id=c.c_taxon_id) WHERE b.`".. typs[typ] .."_id` = "..
                _gbifid.." and country = '" .. _valst .. "' and taxType = 'rūšis' ORDER BY 1 ASC limit ".._nuo..","..pagelength..
                ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
    else
            dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s left join (SELECT b.cla" ..
                " name, 1 sk FROM tax_sal_taxr_all b WHERE b.pla = '"..
                ladb.."' and b.salis = '" .. _valst .. "' and ctype = 'rūšis' ORDER BY 1 ASC limit ".._nuo..","..pagelength..
                ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
            _nuo = _nuo + pagelength
            dal2 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ Skaiciai s left join (SELECT b.cla" ..
                " name, 1 sk FROM tax_sal_taxr_all b WHERE b.pla = '"..
                ladb.."' and b.salis = '" .. _valst .. "' and ctype = 'rūšis' ORDER BY 1 ASC limit ".._nuo..","..pagelength..
                ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
    end

    if (dal1 == ',' or dal1 == '') and (dal2 == ',' or dal2 == '') then
        root
            .newline()
            .newline()
            .wikitext( '\n\n', Komentaras._kom('?', 'Sąraše nėra arba jau nėra elementų'),
               '[[Kategorija:Surinkti]]')
            .newline()
            .newline()
    end

        local vel = Switch._switch2( 'Switch/šalys', _valst, 'vėliava', '' )
        if vel ~= '' then
           vel = '[[Vaizdas:' .. vel .. '|25px|' .. _valst .. '|link=' .. _valst .. ']]'
        end
        headargs['title'] = Gref.getla(_la, '', '', '', '', '', '') .. '<br />' ..
                            vel .. ' [[' .. _valst .. ']] (' .. spec .. ' ' .. Plural._plural( {spec, 'rūšis', 'rūšys', 'rūšių'} ) .. ')'
        headargs['author'] = ''
        if puslmax == 1 then
           headargs['section'] = "'''Rūšių sąrašas'''"
        else
           headargs['section'] = "'''Rūšių sąrašo " .. tostring(pgnr+1) .. " dalis''' (iš " .. tostring(puslmax) .. ' ' ..
                                 Plural._plural( {spec, 'dalies', 'dalių', 'dalių'} ) .. ').'
        end
        headargs['previous'] = grefap._prevpg( pgnr, puslmax, pgnamelist[1] .. '/' .. pgnamelist[2] )
        headargs['next'] = grefap._nextpg( pgnr, puslmax, pgnamelist[1] .. '/' .. pgnamelist[2] )
        --if pgnr == 0 and puslmax == 1 then
        --   headargs['previous'] = ""
        --   headargs['next'] = ""
        --elseif pgnr == 0 and puslmax > 1 then
        --   headargs['previous'] = ""
        --   headargs['next'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(pgnr+1) .. '|' .. tostring(pgnr+2) .. ' dalis]]'
        --elseif pgnr == 1 and puslmax == 2 then
        --   headargs['previous'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '|' .. tostring(pgnr) .. ' dalis]]'
        --   headargs['next'] = ""
        --elseif pgnr == 1 and puslmax > 2 then
        --   headargs['previous'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '|' .. tostring(pgnr) .. ' dalis]]'
        --   headargs['next'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(pgnr+1) .. '|' .. tostring(pgnr+2) .. ' dalis]]'
        --elseif pgnr > 1 and puslmax == pgnr+1 then
        --   headargs['previous'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(pgnr-1) .. '|' .. tostring(pgnr) .. ' dalis]]'
        --   headargs['next'] = ""
        --else
        --   headargs['previous'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(pgnr-1) .. '|' .. tostring(pgnr) .. ' dalis]]'
        --   headargs['next'] = "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(pgnr+1) .. '|' .. tostring(pgnr+2) .. ' dalis]]'
        --end
        if puslmax == 1 then
           headargs['notes'] = ""
        else
           headargs['notes'] = "Rūšių sąrašo dalys: "
           for i = 1,puslmax do
               if i > 1 then
                  headargs['notes'] = headargs['notes'] .. ', '
                  headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(i-1) .. '|' .. tostring(i) .. ' d.]]'
               --elseif i > puslmax - 4 then
               --   headargs['notes'] = headargs['notes'] .. ', '
               --   headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(i-1) .. '|' .. tostring(i) .. ' d.]]'
               --elseif i == puslmax - 4 then
                  --headargs['notes'] = headargs['notes'] .. ', '
               --   headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(i-1) .. '|' .. tostring(i) .. ' d.]]'
               --elseif pgnr - 4 == i then
                  --headargs['notes'] = headargs['notes'] .. ', '
               --   headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(i-1) .. '|' .. tostring(i) .. ' d.]]'
               --elseif pgnr - 4 > i and i > pgnr + 5 then
               --   headargs['notes'] = headargs['notes'] .. ', '
               --   headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(i-1) .. '|' .. tostring(i) .. ' d.]]'
               --elseif i == 6 then
               --   headargs['notes'] = headargs['notes'] .. " ... "
               --elseif i == puslmax - 5 then
               --   headargs['notes'] = headargs['notes'] .. " ... "
               elseif i == 1 then
                  headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '|' .. tostring(i) .. ' d.]]'
               end
           end
           headargs['notes'] = headargs['notes'] .. '\n\nRūšių sąrašo dalys pagal abėcėlę: '
           abc = ''
    if _gbifid ~= '' and typs[typ] ~= nil then
            abc = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ abc_".. typs[typ] .." a |where=a.".. typs[typ] .."_id="..
                _gbifid.." and a.country = '" .. _valst .. 
                "'|order by=a.abc|data=abc=a.abc,abck=a.kiek}}{{#for_external_table:{{{abc}}}:{{{abck}}};}}{{#clear_external_data:}}") or ''
    else
            abc = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ tax_sal_taxr_abc a |where=a.pla = '"..
                ladb.."' and a.salis = '" .. _valst .. 
                "'|order by=a.abc|data=abc=a.abc,abck=a.kiek}}{{#for_external_table:{{{abc}}}:{{{abck}}};}}{{#clear_external_data:}}") or ''
    end
           abclist = mw.text.split(abc,';')

           abce = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                   'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
           abckiek = 0
           abcln = 1
           for abci, abcv in ipairs( abce ) do
               if abci ~= 1 then
                  headargs['notes'] = headargs['notes'] .. ', '
               end
               abcpg, _mod2 = math.modf( abckiek/tonumber(_kiek) ) 
               if abcpg == 0 then
                  headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '|' .. abcv .. ']]'
               else
                  headargs['notes'] = headargs['notes'] .. "[[Sritis:" .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '/' .. tostring(abcpg) .. '|' .. abcv .. ']]'
               end
               if abcln < #abclist then
                  abcliste = mw.text.split(abclist[abcln],':')
                  if abcliste[1] == abcv then
                     abckiek = abckiek + tonumber(abcliste[2])
                     abcln = abcln + 1
                  end
               end
           end
        end

        root
            .wikitext( ValVietininkas._viet( _valst, '', '#default' ), " yra ", Plural._plural( {spec, 'aptinkama', 'aptinkamos', 'aptinkama'} ),
                       ' ', spec, ' ', _kam, ' ', Plural._plural( {spec, 'rūšis', 'rūšys', 'rūšių'} ), '. ', textne )
            .newline()
            .wikitext( frame:expandTemplate{ title = 'header', args = headargs } )
            .grazilentele()
                .tag('th')
                    .attr('colspan', '2')
                    .wikitext( ValVietininkas._viet( _valst, '', '#default' ), ' aptinkamos ', _kam, ' (' )
                    .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
                    .wikitext( ') rūšys:' )
                    .wikitext( '[[Kategorija:' .. pgnamelist[1] .. '/' .. pgnamelist[2] .. '|Ω]]' )
                    .newline()
                    .done()
                .tag('tr')
                    .attr('valign', 'top')
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._cell(dal1))
                            .done()
                        .done()
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefap._cell(dal2))
                            .done()
                        .done()
                    .done()
                .done()
            .done()

    root.done()
     
    return tostring(root)
end

grefap.gbif = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or ''
    local _gbifid = args.gbifid or pargs.gbifid or ''
    local _valst = args.valst or pargs.valst or ''
    local _kam = args.kam or pargs.kam or ''
    local _kas = args.kas or pargs.kas or ''
    local _nuo = args.nuo or pargs.nuo or ''
    local _kiek = args.kiek or pargs.kiek or ''
    
    return grefap._gbif( _la, _valst, _kam, _kas, _nuo, _kiek, frame, _gbifid )
end

return grefap
