local HtmlBuilder = require('Module:HtmlBuilder')
local Redirect = require('Module:Redirect')
local Komentaras = require('Module:Komentaras')
local Cite = require('Module:Cite')

autp = {}

autp._aut = function( aname )
    local root = HtmlBuilder.create()
 
    root
        .tag('span')
            .css('font-variant', 'small-caps')
            .wikitext(aname)
            .done()
     
    return  tostring(root)
end

autp.aut = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args.aut or pargs.aut or mw.text.trim(args[1] or pargs[1] or '')
    if aname == '' then
        return ''
    else
        return autp._aut( aname )
    end
end

autp.autmet = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args.aut or pargs.aut or ''
    local amet = args.met or pargs.met or ''
    local ala = args.la or pargs.la or ''
    local aspalva = args.spalva or pargs.spalva or ''

    local root = HtmlBuilder.create()
    local raut = HtmlBuilder.create()
    local aladb = mw.text.listToText(mw.text.split( ala, "'" ), "''", "''")
    local ladb = aladb
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local gbif = ''
        
    if gbif == '' then
       local gbif1 = frame:preprocess("{{#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
           ladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
           "{{#for_external_table:{{{id}}}}}{{#clear_external_data:}}") or ''
       if gbif1 ~= '' and gbif1 ~= nil then
          gbif = gbif1
       end
    end
    if gbif == '' then
       local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from GBIF_sk t " ..
                                     "  where t.name = '" .. ladb .. "') tt " ..
                                     "|where=tt.name='"..
            ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            "{{#for_external_table:{{{gbif}}};}}"..
            "{{#clear_external_data:}}") or ''
 
       sgb = mw.text.split(sgbifid,';') or {}
       if sgbifid ~= '' then
         if #sgb == 3 then
            if sgb[2] == '0' then
               gbif = sgb[1]
            end
         elseif #sgb == 2 then
            gbif = sgb[1]
         end
       end
    end
    
    if gbif == '' then
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
               gbif = sgb[1]
            end
         elseif #sgb == 2 then
            gbif = sgb[1]
         end
       end
    end
    
    local autgbifs = ''
    local autgbifm = ';;;;'
    if gbif ~= '' then
        autgbifm = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ GBIF_tree t|where=t.`key`="..
            gbif.."|data=auts=t.authorship}}"..
            "{{#for_external_table:{{{auts}}};}}"..
            "{{#clear_external_data:}}") or ''
    end
    autgbifms = mw.text.split( autgbifm, ';' )
    if autgbifms[1] ~= '' then
        autgbifs = mw.text.trim(autgbifms[1])
    end
    local autgbifsk = ''
    if autgbifs ~= '' then
        autgbifsk = Komentaras._kom(autgbifs, 'Lotyniško pavadinimo autorius iš GBIF.')
    end

    local inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree b "..
        "left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id)|where=b.name='"..
        aladb.."' and c.c_name is null|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
        "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
        "{{#clear_external_data:}}") or ',,,,,'
    local inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
    if inf2013s[1] == '' then
        inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ base.x_col2013taxon c left join _taxon_tree b on (b.taxon_id=c.c_taxon_id)|where=c.c_name='"..
            aladb.."'|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
            "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
            "{{#clear_external_data:}}") or ',,,,,'
        inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
    end

    local aut2013 = ''
    local aut2013m = ';;;;'
    if inf2013s[1] ~= '' then
        aut2013m = frame:preprocess("{{#get_db_data:|db=col2013ac|from=taxon_detail td LEFT JOIN aut_met tas ON ( td.author_string_id = tas.id )|where=taxon_id="..
            inf2013s[1].."|data=auts=tas.string,aut=tas.aut,met=tas.met}}"..
            "{{#for_external_table:{{{auts}}};{{{aut}}};{{{met}}};}}"..
            "{{#clear_external_data:}}") or ''
    end
    aut2013s = mw.text.split( aut2013m, ';' )
    aut2013 = aut2013s[1] or ''
    
    local aut2013k = ''
    if aut2013 ~= '' then
        aut2013k = Komentaras._kom(aut2013, 'Lotyniško pavadinimo autorius iš COL2013.') or ''
    end
    
    if aname == '' then
        if inf2013s[1] ~= '' and aut2013 ~= '' then
            if autgbifsk ~= '' and aut2013s[2] == '' and aut2013s[3] == '' then
                raut.wikitext(autgbifsk)
            else
                if aut2013s[2] ~= '' then
                    local i = 0
                    for a in mw.text.gsplit(aut2013s[2], ',', true) do
                        local _a = mw.text.trim(a)
                        if _a ~= '' then
                            if i ~= 0 then
                                raut.wikitext(', ')
                            end
                            local autsp = mw.text.trim(mw.text.split(_a, ' (', true)[1])
                            if _a == autsp then
                                raut.wikitext(Aut._aut("[[" .. _a .. '|' .. _a .. "]]"))
                            else
                                raut.wikitext(Aut._aut("[[" .. _a .. '|' .. autsp .. "]]"))
                            end
                            i = i + 1
                        end
                    end
                    if i == 0 then
                        raut.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
                    end
                    raut.wikitext(", ")
                else
                    raut.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
                    raut.wikitext(", ")
                end
            
                if aut2013s[3] == '' then
                    raut.wikitext( Komentaras._kom('?', 'Lotyniško pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
                else
                    local mets = mw.text.split(aut2013s[3], ' publ. ')
                    if #mets == 1 then
                        raut.wikitext( "[[", aut2013s[3], "]]")
                    else
                        raut.wikitext( "[[", mets[1], "]]" )
                        raut.wikitext( ' publ. ' )
                        raut.wikitext( "[[", mets[2], "]]" )
                    end
                end
            end
            raut.wikitext( ' ' )
            --root.wikitext(Komentaras._kom('['..aut2013..']', 'Lotyniško pavadinimo autorius iš COL2013.'))
            if inf2013s[3] == 'species' then
                raut.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..inf2013s[1]..'|'..ala..']]. '..
                    aut2013k ..
                    ' Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].',
                    'col2013-'..inf2013s[1]}))
            else
                raut.wikitext(Cite._isn(frame, {}, {'[[col2013s:'..ala..'|'..ala..']]. '..
                    aut2013k ..
                    ' Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].',
                    'col2013-'..inf2013s[1]}))
            end
            if autgbifs ~= '' then
                raut.wikitext( Cite._isn ( frame, {}, { '[[gbifws:'..gbif..'|'..ala..']]. '..
                   autgbifsk..' [[gbifwd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). ({{en|Global Biodiversity Information Facility (GBIF)}}).', 
                   'gbif-'..gbif } ) )
            end
            
            root
                .wikitext('|- style="text-align:center;"\n')
                .wikitext('! style="background:' .. aspalva .. '" | [[Binarinė nomenklatūra|Mokslinis pavadinimas]]\n')
                .wikitext('|- style="text-align:center;" valign=top\n')
                .wikitext('|\n')
                .tag('b')
                    .tag('i')
                        .wikitext(ala)
                        .done()
                    .done()
                .wikitext('<br />')
                .tag('small')
                    .wikitext(tostring(raut))
                    .done()
                .wikitext('\n|-\n')
                .done()
    
            return tostring(root)
        elseif autgbifs ~= '' then
            raut.wikitext( autgbifsk )
            raut.wikitext( ' ' )
            raut.wikitext( Cite._isn ( frame, {}, { '[[gbifws:'..gbif..'|'..ala..']]. '..
               autgbifsk..' [[gbifwd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). ({{en|Global Biodiversity Information Facility (GBIF)}}).', 
               'gbif-'..gbif } ) )
            
            root
                .wikitext('|- style="text-align:center;"\n')
                .wikitext('! style="background:' .. aspalva .. '" | [[Binarinė nomenklatūra|Mokslinis pavadinimas]]\n')
                .wikitext('|- style="text-align:center;" valign=top\n')
                .wikitext('|\n')
                .tag('b')
                    .tag('i')
                        .wikitext(ala)
                        .done()
                    .done()
                .wikitext('<br />')
                .tag('small')
                    .wikitext(tostring(raut))
                    .done()
                .wikitext('\n|-\n')
                .done()
    
            return tostring(root)
        else
            return ''
        end
    else
        local i = 0
        for a in mw.text.gsplit(aname, ',', true) do
            local _a = mw.text.trim(a)
            if _a ~= '' then
                if i ~= 0 then
                    raut.wikitext(', ')
                end
                local autsp = mw.text.trim(mw.text.split(_a, ' (', true)[1])
                if _a == autsp then
                    raut.wikitext(autp._aut("[[" .. _a .. '|' .. _a .. "]]"))
                else
                    raut.wikitext(autp._aut("[[" .. _a .. '|' .. autsp .. "]]"))
                end
                i = i + 1
            end
        end
        if amet ~= '' then
            raut.wikitext(', ')
            
            local mets = mw.text.split(amet, ' publ. ')
            if #mets == 1 then
                raut.wikitext( "[[", amet, "]]")
            else
                raut.wikitext( "[[", mets[1], "]]" )
                raut.wikitext( ' publ. ' )
                raut.wikitext( "[[", mets[2], "]]" )
            end
        end
        
        if aut2013 ~= '' then
            raut.wikitext( ' ' )
            --root.wikitext(Komentaras._kom('['..aut2013..']', 'Lotyniško pavadinimo autorius iš COL2013.'))
            if inf2013s[3] == 'species' then
                raut.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..inf2013s[1]..'|'..ala..']]. '..
                    aut2013k ..
                    ' Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].',
                    'col2013-'..inf2013s[1]}))
            else
                raut.wikitext(Cite._isn(frame, {}, {'[[col2013s:'..ala..'|'..ala..']]. '..
                    aut2013k ..
                    ' Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].',
                    'col2013-'..inf2013s[1]}))
            end
        end
        if autgbifs ~= '' then
            raut.wikitext( Cite._isn ( frame, {}, { '[[gbifws:'..gbif..'|'..ala..']]. '..
               autgbifsk..' [[gbifwd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). ({{en|Global Biodiversity Information Facility (GBIF)}}).', 
               'gbif-'..gbif } ) )
        end

        root
            .wikitext('|- style="text-align:center;"\n')
            .wikitext('! style="background:' .. aspalva .. '" | [[Binarinė nomenklatūra|Mokslinis pavadinimas]]\n')
            .wikitext('|- style="text-align:center;" valign=top\n')
            .wikitext('|\n')
            .tag('b')
                .tag('i')
                    .wikitext(ala)
                    .done()
                .done()
            .wikitext('<br />')
            .tag('small')
                .wikitext(tostring(raut))
                .done()
            .wikitext('\n|-\n')
            .done()

        return tostring(root)
    end
end

autp.rel = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args.aut or pargs.aut or mw.text.trim(args[1] or pargs[1] or '')
    if aname == '' then
        return ''
    else
        return autp._aut( '[[' .. aname .. ']]' )
    end
end

autp.red = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args.aut or pargs.aut or mw.text.trim(args[1] or pargs[1] or '')
    if aname == '' then
        return ''
    else
        aname = Redirect.redir(aname, false, true)
        return autp._aut( aname )
    end
end

autp.redrel = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args.aut or pargs.aut or mw.text.trim(args[1] or pargs[1] or '')
    if aname == '' then
        return ''
    else
        aname = Redirect.redir(aname, true, true)
        return autp._aut( aname )
    end
end

return autp
