local HtmlBuilder = require('Module:HtmlBuilder')
local json = require('Modulis:JSON')
local jsoncol = require('Modulis:JSON/COL')
local jsongbif = require('Modulis:JSON/GBIF')
local jsonitis = require('Modulis:JSON/ITIS')
local jsoneol = require('Modulis:JSON/EOL')

local litm = {}
 
litm.get = function ( frame )
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local subst = args['subst'] or pargs['subst'] or ''
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    local typ = args['outtype'] or pargs['outtype'] or 'string' -- gražinamas tipas: string (pagal nutylėjimą), json, list
    local del = args['outdel'] or pargs['outdel'] or '\n* ' -- gražinamas skirtukas
    local prm = nil
    
    prm = litm._get{ la = ladb, subst = subst }
    
    local rez = ''
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
    
litm._getcol = function ( args )
    local frame = mw.getCurrentFrame()
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local ret = {}
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    local colid = ''
    if ladb ~= '' then
        colid = jsoncol._get1{ la = ladb }
    end
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text

    local sdb2013, sdbt2013, uri2013, inf2013 = {}, {}, {}, {}
    if colid ~= '' then
        sdb2013 = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join taxon tx on (tx.id = tt.taxon_id) " ..
                                            "left join source_database sd on (tx.source_database_id=sd.id) " ..
                                            "left join uri_to_source_database usd on (sd.id=usd.source_database_id) " ..
                                            "left join uri on (uri.id=usd.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.." group by tt.taxon_id" ..
            "|data=txt=GROUP_CONCAT(if( sd.id is not null,ifnull(concat(ifnull(concat(sd.authors_and_editors, '. '),''), " ..
            "if(uri.id=21,concat('[http://www.itis.gov ', sd.name, '] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. ')," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', sd.name, ']. '), " ..
            "ifnull(concat(sd.name, '. '),''))), " ..
            "ifnull(concat(sd.organisation, '. '),''), " ..
            -- "ifnull(concat(sd.contact_person, '. '),''), " ..
            -- "ifnull(concat(sd.taxonomic_coverage, '. '),''), " ..
            "ifnull(concat('Versija: ',sd.version, '. '),''), " ..
            "ifnull(concat(sd.release_date, '. '),'')), ''), '') SEPARATOR '####')}}"..
            "{{"..subst.."#for_external_table:{{{txt}}}}}"..
            "{{"..subst.."#clear_external_data:}}")
        if sdb2013 ~= nil and sdb2013 ~= '' then
            sdb2013m = mw.text.split(sdb2013,'####')
            sdb2013 = {}
            for i, s in ipairs( sdb2013m ) do
                sdb2013[i] = {}
                sdb2013[i].nr = i
                sdb2013[i].reference = s
            end
        else
            sdb2013 = {}
        end
        
        sdbt2013 = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join _source_database_to_taxon_tree_branch tx on (tt.taxon_id=tx.taxon_tree_id) " ..
                                            "left join taxon tx2 on (tx2.id = tt.taxon_id) " ..
                                            "left join source_database sd on (tx.source_database_id=sd.id) " ..
                                            "left join uri_to_source_database usd on (sd.id=usd.source_database_id) " ..
                                            "left join uri on (uri.id=usd.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.." and (tx.source_database_id<>tx2.source_database_id or tx2.source_database_id is null) " ..
            " group by tt.taxon_id" ..
            "|data=txt=GROUP_CONCAT(if( sd.id is not null,ifnull(concat(ifnull(concat(sd.authors_and_editors, '. '),''), " ..
            "if(uri.id=21,concat('[http://www.itis.gov ', sd.name, '] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. ')," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', sd.name, ']. '), " ..
            "ifnull(concat(sd.name, '. '),''))), " ..
            "ifnull(concat(sd.organisation, '. '),''), " ..
            -- "ifnull(concat(sd.contact_person, '. '),''), " ..
            -- "ifnull(concat(sd.taxonomic_coverage, '. '),''), " ..
            "ifnull(concat('Versija: ',sd.version, '. '),''), " ..
            "ifnull(concat(sd.release_date, '. '),'')), ''), '') SEPARATOR '####')}}"..
            "{{"..subst.."#for_external_table:{{{txt}}}}}"..
            "{{"..subst.."#clear_external_data:}}")
        if sdbt2013 ~= nil and sdbt2013 ~= '' then
            sdbt2013m = mw.text.split(sdbt2013,'####')
            sdbt2013 = {}
            for i, s in ipairs( sdbt2013m ) do
                sdbt2013[i] = {}
                sdbt2013[i].nr = i
                sdbt2013[i].reference = s
            end
        else
            sdbt2013 = {}
        end
        
        uri2013 = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join uri_to_taxon ut on (ut.taxon_id = tt.taxon_id) " ..
                                            "left join uri on (uri.id=ut.uri_id) " ..
                                            "|where=tt.taxon_id="..
            colid.." and uri.uri_scheme_id in (6, 7)  group by tt.taxon_id" ..
            "|data=txt=GROUP_CONCAT(if( uri.id is not null,ifnull(concat(" ..
            "if(uri.id=21,'[http://www.itis.gov ITIS] [http://www.cbif.gc.ca/itis (Canada)] [http://siit.conabio.gob.mx (Mexico)]. '," ..
            "ifnull(concat('[', REPLACE( uri.resource_identifier,  '#',  '' ), ' ', " ..
            "REPLACE( REPLACE( REPLACE( uri.resource_identifier,  '#',  '' ),  'http://',  '' ),  'https://',  '' ), ']. '), " ..
            "''))), ''), '') SEPARATOR '####')}}"..
            "{{"..subst.."#for_external_table:{{{txt}}}}}"..
            "{{"..subst.."#clear_external_data:}}")
        if uri2013 ~= nil and uri2013 ~= '' then
            uri2013m = mw.text.split(uri2013,'####')
            uri2013 = {}
            for i, s in ipairs( uri2013m ) do
                uri2013[i] = {}
                uri2013[i].nr = i
                uri2013[i].reference = s
            end
        else
            uri2013 = {}
        end
        
        inf2013 = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree tt " ..
                                            "left join reference_to_taxon rt on (rt.taxon_id = tt.taxon_id) " ..
                                            "left join reference r on (r.id=rt.reference_id) |where=tt.taxon_id="..
            colid.." and r.id is not null  group by tt.taxon_id|data=txt=GROUP_CONCAT(concat(ifnull(concat(r.authors, '. '),''), " ..
            "ifnull(concat(r.year, '. '),''), ifnull(concat(r.title, '. '),''), ifnull(concat(r.text, '. '),''))" ..
            " SEPARATOR '####')}}"..
            "{{"..subst.."#for_external_table:{{{txt}}}}}"..
            "{{"..subst.."#clear_external_data:}}")
        if inf2013 ~= nil and inf2013 ~= '' then
            inf2013m = mw.text.split(inf2013,'####')
            inf2013 = {}
            for i, s in ipairs( inf2013m ) do
                inf2013[i] = {}
                inf2013[i].nr = i
                inf2013[i].reference = s
            end
        else
            inf2013 = {}
        end
    end

    ret['colid'] = colid
    ret['source database'] = sdb2013
    ret['source database to tree'] = sdbt2013
    ret['uri to taxon'] = uri2013
    ret['reference'] = inf2013

    return ret
end

litm._getgbif = function ( args )
    local frame = mw.getCurrentFrame()
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local ret = {}
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text

    local gbifid = ''
    if ladb ~= '' then
        gbifid = jsongbif._get1{ la = ladb }
    end

    local infgbif = {}
    if gbifid ~= '' then 
        local refgbifj = frame:preprocess("{{"..subst.."#get_web_data:url=http://api.gbif.org/v1/species/"..gbifid..
            "/references?limit=100|format=json}}") or '{}'
        local refgbifm = json.decode(refgbifj)
        if refgbifm ~= nil then
            for i, eref in ipairs( refgbifm.results ) do
                infgbif[i] = {}
                infgbif[i].nr = i
                infgbif[i].reference = eref
                -- infgbif['a'..i] = eref
                --infgbif = infgbif .. '* ' .. eref.citation .. '\n'
            end
        end
    end
    
    ret['gbifid'] = gbifid
    ret['references'] = infgbif

    return ret
end

litm._getitis = function ( args )
    local frame = mw.getCurrentFrame()
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local ret = {}
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text

    local itisid = ''
    if ladb ~= '' then
        itisid = jsonitis._get1{ la = ladb }
    end

    local infitis = {}
    if itisid ~= '' then
        infitis = frame:preprocess("{{"..subst.."#get_db_data:|db=ITIS|from=/* "..pgname.." */ reference_links rl " ..
                                            "left join `experts` e on (e.expert_id = rl.`documentation_id` and e.expert_id_prefix = rl.`doc_id_prefix`) " ..
                                            "left join `publications` p on (p.publication_id = rl.`documentation_id` and p.pub_id_prefix = rl.`doc_id_prefix`) " ..
                                            "left join `other_sources` s on (s.source_id = rl.`documentation_id` and s.source_id_prefix = rl.`doc_id_prefix`) " ..
            "|where=rl.`tsn`="..
            itisid.." or rl.`tsn` in (SELECT DISTINCT  `tsn` sl "..
            "FROM  `synonym_links` sl WHERE  sl.`tsn_accepted` ="..itisid..
            ") group by rl.`tsn`|data=txt=distinct GROUP_CONCAT(if(e.expert is not null and " ..
            "e.expert_id_prefix='EXP', concat(e.expert, '. ', e.exp_comment), " ..
            "if(p.reference_author is not null and p.pub_id_prefix='PUB', " ..
            "concat(p.reference_author, if(p.title <> '',concat('. ', p.title),''), '. ', p.publication_name, "..
            "   if(p.publisher <>'',concat('. ', p.publisher), ''), "..
            "   if(p.pub_place <>'',concat('. ', p.pub_place),''), if(p.isbn <>'',concat('. ISBN ', p.isbn),''), "..
            "   if(p.issn <>'',concat('. ISSN ', p.issn),''), if(p.pages <>'',concat('. ', p.pages, ' psl.'),''), " ..
            "if(p.pub_comment <>'',concat(' ', p.pub_comment),'')), "..
            " if(s.source is not null and s.source_id_prefix='SRC', " ..
            "concat(s.source, '. ', s.source_comment),'')))  SEPARATOR '####')}}"..
            "{{"..subst.."#for_external_table:{{{txt}}}}}"..
            "{{"..subst.."#clear_external_data:}}")
        if infitis ~= nil then
            infitism = mw.text.split(infitis,'####')
            infitis = {}
            for i, s in ipairs( infitism ) do
                infitis[i] = {}
                infitis[i].nr = i
                infitis[i].reference = s
            end
        end
    end
    
    ret['itisid'] = itisid
    ret['Literatūra'] = infitis

    return ret
end

litm._geteol = function ( args )
    local frame = mw.getCurrentFrame()
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local ret = {}
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text

    local eolid = ''
    if eolid == '' and ladb ~= '' then
        eolid = jsoneol._get1{ la = ladb }
    end

    local infeol = {}
    if eolid ~= '' then 
        local refeolj = frame:preprocess("{{"..subst.."#get_web_data:url=http://eol.org/api/pages/1.0/"..eolid..
            ".json?images=0&videos=0&sounds=0&maps=0&text=0&iucn=false&subjects=overview&licenses=all&details=false&common_names=false&synonyms=false&references=true&vetted=0&cache_ttl=|format=json}}") or '{}'
        local refeolm = json.decode(refeolj)
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
                infeol[i] = {}
                infeol[i].nr = i
                infeol[i].reference = ereft
                --infeol['a'..i] = ereft
                -- table.insert(infeolm, ereft)
                -- infeol = infeol .. '* ' .. ereft .. '\n'
            end
        end
    end
    
    ret['eolid'] = eolid
    ret['references'] = infeol

    return ret
end

litm._get = function ( args )
    local la = args['la'] or ''
    local subst = args['subst'] or ''
    local ret = {}
    
    la = mw.text.trim( la )
    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    
    ret['COL'] = litm._getcol{ la = ladb, subst = subst }
    ret['GBIF'] = litm._getgbif{ la = ladb, subst = subst }
    ret['ITIS'] = litm._getitis{ la = ladb, subst = subst }
    ret['EOL'] = litm._geteol{ la = ladb, subst = subst }

    return ret
end

litm.show = function ( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local jsonlit = args[1] or pargs[1] or '{}'
    local jlit = json.decode(jsonlit)
    local rez = HtmlBuilder.create()
    
    if #jlit.COL["source database to tree"] ~= 0 or
        #jlit.COL["uri to taxon"] ~= 0 or
        #jlit.COL["reference"] ~= 0 or
        #jlit.COL["source database"] ~= 0 then
        
        rez
            .wikitext('=== Pagal Gyvybės katalogą ===')
            .newline()
        for i, eref in ipairs( jlit.COL["reference"] ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
        for i, eref in ipairs( jlit.COL["source database to tree"] ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
        for i, eref in ipairs( jlit.COL["source database"] ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
        for i, eref in ipairs( jlit.COL["uri to taxon"] ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
    end

    if #jlit.GBIF.references ~= 0 then
        rez
            .wikitext('=== Pagal GBIF ===')
            .newline()

        for i, eref in ipairs( jlit.GBIF.references ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
    end
 
    if #jlit.ITIS["Literatūra"] ~= 0 then
        rez
            .wikitext('=== Pagal ITIS ===')
            .newline()

        for i, eref in ipairs( jlit.ITIS["Literatūra"] ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
    end
 
    if #jlit.EOL.references ~= 0 then
        rez
            .wikitext('=== Pagal Gyvybės enciklopediją ===')
            .newline()

        for i, eref in ipairs( jlit.EOL.references ) do
            rez
                .wikitext('* ')
                .wikitext(eref.reference)
                .newline()
        end
    end
    
    return  tostring(rez)
end

return litm
