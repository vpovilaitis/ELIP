local HtmlBuilder = require('Module:HtmlBuilder')
local Aut = require('Module:Aut')
local Komentaras = require('Module:Komentaras')
local Plural = require('Module:Plural')
local Cite = require('Module:Cite')
--local GgeSinonimas = require('Module:GgeSinonimas')
local json = require('Modulis:JSON')
local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')
local jsoncol = require('Modulis:JSON/COL')
local jsongbif = require('Modulis:JSON/GBIF')
local jsonitis = require('Modulis:JSON/ITIS')
local jsoneol = require('Modulis:JSON/EOL')

grefp = {}

grefp._ref = function( mires, lt, sin, la, larod, aut, met, ptip, sla, saut, smet, gbifpp, isrefpage )
    local root = HtmlBuilder.create()
    local frame = mw.getCurrentFrame()
    local gbif = ''
    if gbif == nil or gbif == '0' then gbif = '' end

    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()

    local colid, colidm, colidsk, colidrez = '', {}, 0, ''
    local gbifid, gbifidm, gbifidsk, gbifidrez = '', {}, 0, ''
    local itisid, itisidm, itisidsk, itisidrez = '', {}, 0, ''
    local eolid, eolidm, eolidsk, eolidrez = '', {}, 0, ''
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
    if la ~= '' then -- gbifid == '' and la ~= '' then
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
    if itisid == '' and la ~= '' then
        itisid = jsonitis._get1{ la = la }
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
        eolid = jsoneol._get1{ la = la, gjson = 'no' }
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
    gbif = gbifid

    local king = ''
    if parms ~= nil then
        king = parms['karalystė'] or ''
    end
    if ptip == '' and parms ~= nil then
        ptip = parms['type'] or ''
    end
    local pgname = pg.text
 
    --local formargs = {
    --        form = 'Auto_taxobox',
    --        ['link text'] = '<sup>[k]</sup>',
    --        ['link type'] = '',
    --        ['query string'] = ''
    --    }
    --formargs['query string'] = formargs['query string'] .. 'page name=' .. la
    --formargs['query string'] = formargs['query string'] .. '&Auto_taxobox[la]=' .. la
    --formargs['query string'] = formargs['query string'] .. '&Auto_taxobox[alt]=' .. la
    if isrefpage == nil then isrefpage = false end

    local autgbifs, autgbifaut, autgbifmet = '', '', ''
    local autgbifm = ';;;'
    if gbif ~= '' then
        autgbifm = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ GBIF_tree t|where=t.`key`="..
            gbif.."|data=auts=t.authorship,autaut=t.authors,autmet=t.year}}"..
            "{{#for_external_table:{{{auts}}};{{{autaut}}};{{{autmet}}};}}"..
            "{{#clear_external_data:}}") or ';;;'
    end
    autgbifms = mw.text.split( autgbifm, ';' )
    if autgbifms[1] ~= nil and autgbifms[1] ~= '' then
        autgbifs = mw.text.trim(autgbifms[1])
    end
    if autgbifms[2] ~= nil and autgbifms[2] ~= '' then
        autgbifaut = mw.text.trim(autgbifms[2])
    end
    if autgbifms[3] ~= nil and autgbifms[3] ~= '' then
        autgbifmet = mw.text.trim(autgbifms[3])
    end
    local autgbifsk = ''
    if autgbifs ~= '' then
        autgbifsk = Komentaras._kom(autgbifs, 'Lotyniško pavadinimo autorius iš GBIF.')
    end
    
    if sla ~= '' then
        local lasp = mw.text.trim(sla) -- mw.text.trim(mw.text.split(la, ' (', true)[1])
        if sla == lasp then
            root
                .tag('i')
                    .wikitext( "[[", sla, "]]" )
                    .done()
        else
            root
                .tag('i')
                    .wikitext( "[[", sla, '|', lasp, "]]" )
                    .done()
        end
        root.wikitext(" ")
        
        if saut ~= '' then
            local i = 0
            for a in mw.text.gsplit(saut, ',', true) do
                local _a = mw.text.trim(a)
                if _a ~= '' then
                    if i ~= 0 then
                        root.wikitext(', ')
                    end
                    local autsp = mw.text.trim(mw.text.split(_a, ' (', true)[1])
                    if _a == autsp then
                        root.wikitext(Aut._aut("[[" .. _a .. '|' .. _a .. "]]"))
                    else
                        root.wikitext(Aut._aut("[[" .. _a .. '|' .. autsp .. "]]"))
                    end
                    i = i + 1
                end
            end
            if i == 0 then
                root.wikitext(Komentaras._kom('?', 'Lotyniško sinonimo pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
            end
            root.wikitext(", ")
        else
            root.wikitext(Komentaras._kom('?', 'Lotyniško sinonimo pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
            root.wikitext(", ")
        end
    
        if smet == '' then
            root.wikitext( Komentaras._kom('?', 'Lotyniško sinonimo pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
        else
            local mets = mw.text.split(smet, ' publ. ')
            if #mets == 1 then
                root.wikitext( "[[", smet, "]]")
            else
                root.wikitext( "[[", mets[1], "]]" )
                root.wikitext( ' publ. ' )
                root.wikitext( "[[", mets[2], "]]" )
            end
        end

        root.wikitext(" – dabar laikomas ( ")
    end
    
    if mires == 'taip' then
        root.wikitext( Komentaras._kom('†', 'Išnykęs ar galimai išnykęs taksonas.', nil), ' ' )
    end

    if lt == '' then
        root.wikitext( Komentaras._kom('?', 'Lietuviškas pavadinimas nesukurtas, nežinomas arba dar neįvestas į ELIP.') )
    else
        local ltsp = mw.text.trim(mw.text.split(lt, ' (', true)[1])
        if lt == ltsp then
            root.wikitext( "[[", lt, "]]")
        else
            root.wikitext( "[[", lt, '|', ltsp, "]]")
        end
    end

    if sin ~= '' then
        for s in mw.text.gsplit(sin, ',', true) do
            local _s = mw.text.trim(s)
            if _s ~= '' then
                root.wikitext(', ')
                local tssp = mw.text.trim(mw.text.split(_s, ' (', true)[1])
                if _s == tssp then
                    root.wikitext("[[", _s, "]]")
                else
                    root.wikitext("[[", _s, '|', tssp, "]]")
                end
            end
        end
    end

    root.wikitext(" – ")
    
    local lasp = mw.text.trim(la) -- mw.text.trim(mw.text.split(la, ' (', true)[1])
    if larod ~= '' and larod ~= lasp then
        lasp = larod
    end
    if la == lasp then
        root
            .tag('i')
                .wikitext( "[[", la, "]]" )
                .done()
    else
        root
            .tag('i')
                .wikitext( "[[", la, '|', lasp, "]]" )
                .done()
    end
    root.wikitext(" ")

    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
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

    local aut2013 = ''
    local aut2013m = ';;;;'
    if #colidm == 1 and colid ~= '' then
        aut2013m = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ taxon_detail td LEFT JOIN aut_met tas ON ( td.author_string_id = tas.id )|where=taxon_id="..
            colid.."|data=auts=tas.string,aut=tas.aut,met=tas.met}}"..
            "{{#for_external_table:{{{auts}}};{{{aut}}};{{{met}}};}}"..
            "{{#clear_external_data:}}") or ''
    end
    aut2013s = mw.text.split( aut2013m, ';' )
    aut2013 = aut2013s[1]
    
    local aut2013k = ''
    if aut2013 ~= '' then
        aut2013k = Komentaras._kom(aut2013, 'Lotyniško pavadinimo autorius iš COL2013.')
    end
    
    if aut ~= '' or met ~= '' then
        if aut ~= '' then
            local i = 0
            for a in mw.text.gsplit(aut, ',', true) do
                local _a = mw.text.trim(a)
                if _a ~= '' then
                    if i ~= 0 then
                        root.wikitext(', ')
                    end
                    local autsp = mw.text.trim(mw.text.split(_a, ' (', true)[1])
                    if _a == autsp then
                        root.wikitext(Aut._aut("[[" .. _a .. '|' .. _a .. "]]"))
                    else
                        root.wikitext(Aut._aut("[[" .. _a .. '|' .. autsp .. "]]"))
                    end
                    i = i + 1
                end
            end
            if i == 0 then
                root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
            end
            root.wikitext(", ")
        else
            root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
            root.wikitext(", ")
        end
    
        if met == '' then
            root.wikitext( Komentaras._kom('?', 'Lotyniško pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
        else
            local mets = mw.text.split(met, ' publ. ')
            if #mets == 1 then
                root.wikitext( "[[", met, "]]")
            else
                root.wikitext( "[[", mets[1], "]]" )
                root.wikitext( ' publ. ' )
                root.wikitext( "[[", mets[2], "]]" )
            end
        end
        if aut2013 ~= '' then
            root.wikitext( ' ' )
            --root.wikitext(Komentaras._kom('['..aut2013..']', 'Lotyniško pavadinimo autorius iš COL2013.'))
            if ptyp == 'rūšis' then
                root.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..colid..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            else
                root.wikitext(Cite._isn(frame, {}, {'[[col2013s:'..la..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            end
        end
    elseif #colidm == 1 and colid ~= '' then
        if aut2013 ~= '' then
            if aut2013s[2] ~= '' then
                local i = 0
                for a in mw.text.gsplit(aut2013s[2], ',', true) do
                    local _a = mw.text.trim(a)
                    if _a ~= '' then
                        if i ~= 0 then
                            root.wikitext(', ')
                        end
                        local autsp = mw.text.trim(mw.text.split(_a, ' (', true)[1])
                        if _a == autsp then
                            root.wikitext(Aut._aut("[[" .. _a .. '|' .. _a .. "]]"))
                        else
                            root.wikitext(Aut._aut("[[" .. _a .. '|' .. autsp .. "]]"))
                        end
                        i = i + 1
                    end
                end
                if i == 0 then
                    root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
                end
                root.wikitext(", ")
            else
                root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
                root.wikitext(", ")
            end
        
            if aut2013s[3] == '' then
                root.wikitext( Komentaras._kom('?', 'Lotyniško pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
            else
                local mets = mw.text.split(aut2013s[3], ' publ. ')
                if #mets == 1 then
                    root.wikitext( "[[", aut2013s[3], "]]")
                else
                    root.wikitext( "[[", mets[1], "]]" )
                    root.wikitext( ' publ. ' )
                    root.wikitext( "[[", mets[2], "]]" )
                end
            end
            root.wikitext( ' ' )
            --root.wikitext(Komentaras._kom('['..aut2013..']', 'Lotyniško pavadinimo autorius iš COL2013.'))
            if ptyp == 'rūšis' then
                root.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..colid..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            else
                root.wikitext(Cite._isn(frame, {}, {'[[col2013s:'..la..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            end
        elseif autgbifs ~= '' then
            root.wikitext(autgbifsk)
        else
            root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
            root.wikitext(", ")
            root.wikitext( Komentaras._kom('?', 'Lotyniško pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
        end
    elseif autgbifs ~= '' then
        root.wikitext(autgbifsk)
    else
        root.wikitext(Komentaras._kom('?', 'Lotyniško pavadinimo autorius nežinomas arba dar neįvestas į ELIP.'))
        root.wikitext(", ")
        root.wikitext( Komentaras._kom('?', 'Lotyniško pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
    end
    
    if gbif ~= '' and gbif ~= '0' then
       local sgbifsk = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " GBIF_sk t " ..
                                     "|where=t.gbif_id="..
            gbif.."|data=parents=t.parents,species=t.species,genus=t.genus,"..
            "family=t.family,sfamily=t.superfamily,order=t.order,class=t.class,phylum=t.phylum,subspecies=t.subspecies}}"..
            "{{#for_external_table:{{{parents}}};{{{species}}};{{{genus}}};{{{family}}};{{{sfamily}}};{{{order}}};"..
            "{{{class}}};{{{phylum}}};{{{subspecies}}};}}"..
            "{{#clear_external_data:}}") or ''
        
        if sgbifsk ~= '' then
            sgbs = mw.text.split(sgbifsk,';') or {}
            local sk1 = sgbs[1]
            local sk2 = sgbs[2] -- rūšis
            local sk3 = sgbs[3] -- gentis
            local sk4 = sgbs[4] -- šeima
            local sk5 = sgbs[5] -- antšeimis
            local sk6 = sgbs[6] -- būrys
            local sk7 = sgbs[7] -- klasė
            local sk8 = sgbs[8] -- tipas
            local sk9 = sgbs[9] -- porūšis
            yra = false
            
            if sgbs[1] ~= '0' or sgbs[2] ~= '0' then
                root.wikitext(" [ ")
                
                if sgbs[1] ~= '0' then
                    --root.wikitext(sgbs[1])
                    root.wikitext( Komentaras._kom(sgbs[1] .. Plural._plural( { sk1, ' taksonas', 
                        ' taksonai', ' taksonų' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų GBIF.'))
                    yra = true
                end
        
                if sgbs[8] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[8])
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sgbs[8] .. Plural._plural( { sk8, ' skyrius', ' skyriai', ' skyrių' } ), 
                            'Nurodytas aprašytų GBIF skyrių skaičius.'))
                    else
                        root.wikitext( Komentaras._kom(sgbs[8] .. Plural._plural( { sk8, ' tipas', ' tipai', ' tipų' } ), 
                            'Nurodytas aprašytų GBIF tipų skaičius.'))
                    end
                end
                
                if sgbs[7] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[7])
                    root.wikitext( Komentaras._kom(sgbs[7] .. Plural._plural( { sk7, ' klasė', ' klasės', ' klasių' } ), 
                        'Nurodytas aprašytų GBIF klasių skaičius.'))
                end
                
                if sgbs[6] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[6])
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sgbs[6] .. Plural._plural( { sk6, ' eilė', ' eilės', ' eilių' } ), 
                            'Nurodytas aprašytų GBIF eilių skaičius.'))
                    else
                        root.wikitext( Komentaras._kom(sgbs[6] .. Plural._plural( { sk6, ' būrys', ' būriai', ' būrių' } ), 
                            'Nurodytas aprašytų GBIF būrių skaičius.'))
                    end
                end
                
                if sgbs[5] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[5])
                    root.wikitext( Komentaras._kom(sgbs[5] .. Plural._plural( { sk5, ' antšeimis', ' anšeimiai', ' antšeimių' } ), 
                        'Nurodytas aprašytų GBIF antšeimių skaičius.'))
                end
                
                if sgbs[4] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[4])
                    root.wikitext( Komentaras._kom(sgbs[4] .. Plural._plural( { sk4, ' šeima', ' šeimos', ' šeimų' } ), 
                        'Nurodytas aprašytų GBIF šeimų skaičius.'))
                end
                
                if sgbs[3] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[3])
                    root.wikitext( Komentaras._kom(sgbs[3] .. Plural._plural( { sk3, ' gentis', ' gentys', ' genčių' } ), 
                        'Nurodytas aprašytų GBIF genčių skaičius.'))
                end
                
                if sgbs[2] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[2])
                    root.wikitext( Komentaras._kom(sgbs[2] .. Plural._plural( { sk2, ' rūšis', ' rūšys', ' rūšių' } ), 
                        'Nurodytas aprašytų GBIF rūšių skaičius.'))
                end
                
                if sgbs[9] ~= '0' then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[9])
                    root.wikitext( Komentaras._kom(sgbs[9] .. Plural._plural( { sk9, ' porūšis', ' porūšiai', ' porūšių' } ), 
                        'Nurodytas aprašytų GBIF porūšių skaičius.'))
                end
                
                root.wikitext(" ]")
            end
        end

        root.wikitext( Cite._isn ( frame, {}, { '[[gbifws:'..gbif..'|'..la..']] arba [[gbifs:'..gbif..'|'..la..']]. '..
           autgbifsk..' [[gbifwd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). ({{en|Global Biodiversity Information Facility (GBIF)}}). GBIF identifikatorius: '..gbif, 
           'gbif-'..gbif } ) )
    end

    if itisid ~= '' and itisid ~= '0' then
       local itispsk = frame:preprocess("{{#get_db_data:|db=ITIS|from=/* "..pgname.." */ " ..
                                     " hiera7 t " ..
                                     "|where=t.TSN="..
            itisid.."|data=parents=t.sparent}}"..
            "{{#for_external_table:{{{parents}}}}}"..
            "{{#clear_external_data:}}") or ''
       local itissk = frame:preprocess("{{#get_db_data:|db=ITIS|from=/* "..pgname.." */ " ..
                                     " hiera5 t " ..
                                     "|where=t.TSN="..
            itisid.."|data=species=t.s220,genus=t.s180,"..
            "family=t.s140,sfamily=t.s130,order=t.s100,class=t.s60,phylum=t.s30,subspecies=t.s230}}"..
            "{{#for_external_table:{{{species}}};{{{genus}}};{{{family}}};{{{sfamily}}};{{{order}}};"..
            "{{{class}}};{{{phylum}}};{{{subspecies}}};}}"..
            "{{#clear_external_data:}}") or '0;0;0;0;0;0;0;0;0'
        
        if itispsk ~= '' and itissk ~= '' then
            sgbs = mw.text.split(itissk,';') or {0,0,0,0,0,0,0,0,0}
            local sk1 = itispsk
            local sk2 = tonumber(sgbs[1]) -- rūšis
            local sk3 = tonumber(sgbs[2]) -- gentis
            local sk4 = tonumber(sgbs[3]) -- šeima
            local sk5 = tonumber(sgbs[4]) -- antšeimis
            local sk6 = tonumber(sgbs[5]) -- būrys
            local sk7 = tonumber(sgbs[6]) -- klasė
            local sk8 = tonumber(sgbs[7]) -- tipas
            local sk9 = tonumber(sgbs[8]) -- porūšis
            yra = false
            
            if itispsk ~= '0' or sgbs[1] ~= '0' then
                root.wikitext(" [ ")
                
                if itispsk ~= '0' then
                    --root.wikitext(sgbs[1])
                    root.wikitext( Komentaras._kom(itispsk .. Plural._plural( { sk1, ' taksonas', 
                        ' taksonai', ' taksonų' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų ITIS.'))
                    yra = true
                end
        
                if sgbs[7] ~= '0' and sgbs[7] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[8])
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sgbs[7] .. Plural._plural( { sk8, ' skyrius', ' skyriai', ' skyrių' } ), 
                            'Nurodytas aprašytų ITIS skyrių skaičius.'))
                    else
                        root.wikitext( Komentaras._kom(sgbs[7] .. Plural._plural( { sk8, ' tipas', ' tipai', ' tipų' } ), 
                            'Nurodytas aprašytų ITIS tipų skaičius.'))
                    end
                end
                
                if sgbs[6] ~= '0' and sgbs[6] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[7])
                    root.wikitext( Komentaras._kom(sgbs[6] .. Plural._plural( { sk7, ' klasė', ' klasės', ' klasių' } ), 
                        'Nurodytas aprašytų ITIS klasių skaičius.'))
                end
                
                if sgbs[5] ~= '0' and sgbs[5] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[6])
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sgbs[5] .. Plural._plural( { sk6, ' eilė', ' eilės', ' eilių' } ), 
                            'Nurodytas aprašytų ITIS eilių skaičius.'))
                    else
                        root.wikitext( Komentaras._kom(sgbs[5] .. Plural._plural( { sk6, ' būrys', ' būriai', ' būrių' } ), 
                            'Nurodytas aprašytų ITIS būrių skaičius.'))
                    end
                end
                
                if sgbs[4] ~= '0' and sgbs[4] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[5])
                    root.wikitext( Komentaras._kom(sgbs[4] .. Plural._plural( { sk5, ' antšeimis', ' anšeimiai', ' antšeimių' } ), 
                        'Nurodytas aprašytų ITIS antšeimių skaičius.'))
                end
                
                if sgbs[3] ~= '0' and sgbs[3] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[4])
                    root.wikitext( Komentaras._kom(sgbs[3] .. Plural._plural( { sk4, ' šeima', ' šeimos', ' šeimų' } ), 
                        'Nurodytas aprašytų ITIS šeimų skaičius.'))
                end
                
                if sgbs[2] ~= '0' and sgbs[2] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[3])
                    root.wikitext( Komentaras._kom(sgbs[2] .. Plural._plural( { sk3, ' gentis', ' gentys', ' genčių' } ), 
                        'Nurodytas aprašytų ITIS genčių skaičius.'))
                end
                
                if sgbs[1] ~= '0' and sgbs[1] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[2])
                    root.wikitext( Komentaras._kom(sgbs[1] .. Plural._plural( { sk2, ' rūšis', ' rūšys', ' rūšių' } ), 
                        'Nurodytas aprašytų ITIS rūšių skaičius.'))
                end
                
                if sgbs[8] ~= '0' and sgbs[8] ~= nil then
                    if yra then
                        root.wikitext(" – ")
                    end
                    --root.wikitext(sgbs[9])
                    root.wikitext( Komentaras._kom(sgbs[8] .. Plural._plural( { sk9, ' porūšis', ' porūšiai', ' porūšių' } ), 
                        'Nurodytas aprašytų ITIS porūšių skaičius.'))
                end
                
                root.wikitext(" ]")
            end
        end

        root.wikitext( Cite._isn ( frame, {}, { '[[itis:'..itisid..'|'..la..']]. '..
           ' [[Integruota taksonominė informacinė sistema]] (ITIS). ({{en|Integrated Taxonomic Information System}}). ITIS identifikatorius: '..itisid, 
           'itis-'..itisid } ) )
    end
    if eolid ~= '' and eolid ~= '0' then
        root.wikitext( Cite._isn ( frame, {}, { '[[eoln:'..eolid..'|'..la..']]. '..
           ' [[Gyvybės enciklopedija]] (EOL). ({{en|Encyclopedia of Life}}). EOL identifikatorius: '..eolid, 
           'eol-'..eolid } ) )
    end

--    local yra = false
--    if ptip == 'karalystė' or ptip == 'pokaralystė' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='skyrius'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        local sk2 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='tipas'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk2 == nil or sk2 == '' then 
--                sk2 = '0' 
--        end
--        if sk1 ~= '0' or sk2 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            if sk1 ~= '' and sk1 ~= '0' then
--                root.wikitext(sk1)
--                root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' skyrius', ' skyriai', ' skyrių' } ), 
--                    'Nurodytas skaičius tik aprašytų ELIP.'))
--            else
--                if sk2 == nil or sk2 == '' then 
--                    sk2 = '0' 
--                end
--                root.wikitext(sk2)
--                root.wikitext( Komentaras._kom(Plural._plural( { sk2, ' tipas', ' tipai', ' tipų' } ), 
--                    'Nurodytas skaičius tik aprašytų ELIP.'))
--            end
--        end
--    end
--    if yra or ptip == 'skyrius' or ptip == 'tipas' or ptip == 'potipis' or 
--              ptip == 'viršklasė' or ptip == 'viršklasis' or ptip == 'antklasis' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='klasė'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk1 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            root.wikitext(sk1)
--            root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' klasė', ' klasės', ' klasių' } ), 
--                'Nurodytas skaičius tik aprašytų ELIP.'))
--        end
--    end
--    if yra or ptip == 'klasė' or ptip == 'poklasis' or ptip == 'infraklasė' or ptip == 'antbūris' then
--        local sk2 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='būrys'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='eilė'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk2 == nil or sk2 == '' then 
--                sk2 = '0' 
--        end
--        if sk1 ~= '0' or sk2 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            
--            if sk1 ~= '' and sk1 ~= '0' then
--                root.wikitext(sk1)
--                root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' eilė', ' eilės', ' eilių' } ), 
--                    'Nurodytas skaičius tik aprašytų ELIP.'))
--            else
--                root.wikitext(sk2)
--                root.wikitext( Komentaras._kom(Plural._plural( { sk2, ' būrys', ' būriai', ' būrių' } ), 
--                    'Nurodytas skaičius tik aprašytų ELIP.'))
--            end
--        end
--    end
--    if yra or ptip == 'būrys' or ptip == 'pobūris' or ptip == 'infrabūrys' or ptip == 'eilė' or ptip == 'poeilis' or ptip == 'antšeimis' or ptip == 'antšeimė' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='šeima'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk1 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            root.wikitext(sk1)
--            root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' šeima', ' šeimos', ' šeimų' } ), 
--                'Nurodytas skaičius tik aprašytų ELIP.'))
--        end
--    end
--    if yra or ptip == 'šeima' or ptip == 'pošeimis' or ptip == 'triba' or ptip == 'potribis' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='gentis'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk1 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            root.wikitext(sk1)
--            root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' gentis', ' gentys', ' genčių' } ), 
--                'Nurodytas skaičius tik aprašytų ELIP.'))
--        end
--    end
--    if yra or ptip == 'gentis' or ptip == 'pogentis' or ptip == 'sekcija' or ptip == 'posekcija' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='rūšis'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk1 ~= '0' then
--        if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            else
--                root.wikitext(" – ")
--            end
--            root.wikitext(sk1)
--            root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' rūšis', ' rūšys', ' rūšių' } ), 
--                'Nurodytas skaičius tik aprašytų ELIP.'))
--        end
--    end
--    if ptip == 'rūšis' then
--        local sk1 = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_yra_taksone|where=pla='" .. ladb ..
--            "' and ctype='porūšis'|limit=1|data=skgentis=csk}}{{#external_value:skgentis}}{{#clear_external_data:}}") or '0'
--        if sk1 == nil or sk1 == '' then 
--                sk1 = '0' 
--        end
--        if sk1 ~= '0' then
--            if not yra then
--                root.wikitext(" [ ")
--                yra = true
--            end
--            root.wikitext(sk1)
--            root.wikitext( Komentaras._kom(Plural._plural( { sk1, ' porūšis', ' porūšiai', ' porūšių' } ), 
--                'Nurodytas skaičius tik aprašytų ELIP.'))
--        end
--    end
--
--    if yra then
--        root.wikitext(" ]")
--    end
    
    --local colidm = mw.text.split( colid, ',' )
    --root.wikitext(" COL ID: "..colid)
    if #colidm == 1 and colid ~= '' then
        local inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree b "..
            "|where=b.taxon_id="..
            colid.."|data=typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
            "{{#for_external_table:{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}},}}"..
            "{{#clear_external_data:}}") or ',,,,'
        local inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '' }
        if #inf2013s == 5 and (inf2013s[3] ~= '0' or inf2013s[4] ~= '0') and 
            not (inf2013s[1] == 'subspecies' or inf2013s[1] == 'form' or inf2013s[1] == 'variety' )
        then
            local sk1 = inf2013s[3]
            local sk2 = inf2013s[4]
            yra = false
            
            root.wikitext(" [ ")
            
            if inf2013s[1] ~= 'genus' then
                --root.wikitext(sk1)
                if inf2013s[1] == 'kingdom' then
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' skyrius', ' skyriai', ' skyrių' } ), 
                            'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                    else
                        root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' tipas', ' tipai', ' tipų' } ), 
                            'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                    end
                elseif inf2013s[1] == 'phylum' then
                    root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' klasė', ' klasės', ' klasių' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                elseif inf2013s[1] == 'class' then
                    if king == 'Fungi' or king == 'Plantae' then
                        root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' eilė', ' eilės', ' eilių' } ), 
                            'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                    else
                        root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' būrys', ' būriai', ' būrių' } ), 
                            'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                    end
                elseif inf2013s[1] == 'order' then
                    root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' šeima arba antšeimis', 
                        ' šeimos arba antšeimiai', ' šeimų arba antšeimių' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                elseif inf2013s[1] == 'superfamily' then
                    root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' šeima', ' šeimos', ' šeimų' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                elseif inf2013s[1] == 'family' then
                    root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' gentis', ' gentys', ' genčių' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                else
                    root.wikitext( Komentaras._kom(sk1 .. Plural._plural( { sk1, ' taksonas', ' taksonai', ' taksonų' } ), 
                        'Nurodytas skaičius tiesioginių žemesnių taksonų aprašytų COL2013.'))
                end
                yra = true
            end
    
            if inf2013s[1] ~= 'species' then
                if yra then
                    root.wikitext(" – ")
                end
                --root.wikitext(sk2)
                root.wikitext( Komentaras._kom(sk2 .. Plural._plural( { sk2, ' rūšis', ' rūšys', ' rūšių' } ), 
                    'Nurodytas skaičius rūšių aprašytų COL2013.'))
            end
            root.wikitext(" ]")
            if inf2013s[1] == 'species' then
                root.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..colid..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            else
                root.wikitext(Cite._isn(frame, {}, {'[[col2013s:'..la..'|'..la..']]. '..
                    aut2013k ..
                    ' [[Gyvybės katalogas]]: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life (COL): 2013 Annual Checklist]. COL identifikatorius: '..colid,
                    'col2013-'..colid}))
            end
        end
    end

    --if not isrefpage then
    --   root.wikitext( frame:callParserFunction{ name = '#formlink', 
    --                            args = formargs } )
    --end

    if sla ~= '' then
        root.wikitext(" ) sinonimu.")
    end
    
    root.done()
     
    return  tostring(root) -- .. met .. _tip .. met
end

grefp.getla = function( la, aut, met, lt, sla, saut, smet )
    local _la, _aut, _met, _lt = la or '', aut or '', met or '', lt or ''
    local _sla, _saut, _smet = sla or '', saut or '', smet or ''
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local _mires, _sin, _larod = '', '', ''
    _la = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
    local pagename = _la
    local ttip = ''
    local isrefpage=false
    
    local parms = ParmData._get{ page = _la, parm = {'išnykęs', 'lt', 'lt sins', 'la', 'altla', 'autoriai', 'metai', 
        'statusas', 'type', 'gbifid' }, template = 'Auto_taxobox' }
    local parmsSin = ParmData._get{ page = _la, 
        parm = {'Lotyniškai', 'Priklauso', 'Pavadinimo autorius', 'Pavadinimo metai' }, template = 'Sinonimas' }
    -- local rpage, err = mw.title.new(_la)
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

    if parms ~= nil then
        _mires = parms['išnykęs'] or _mires
        _lt = parms['lt'] or _lt
        _sin = parms['lt sins'] or _sin
        local _la2 = parms['la'] or _la
        _larod = parms['altla'] or _larod
        _aut = parms['autoriai'] or _aut
        _met = parms['metai'] or _met
        local stat = parms['statusas'] or ''
        ttip = parms['type'] or ''
        gbif = parms['gbifid'] or ''
        if stat == 'EX' then
            _mires = 'taip'
        end
        if _la2 ~= _la then
            _la = _la2
        end
    end
    
    if parmsSin ~= nil then
        if _sla == '' then
            local gsla = parmsSin['Lotyniškai'] or ''
            local gpsla = parmsSin['Priklauso'] or ''
            local gsaut = parmsSin['Pavadinimo autorius'] or ''
            local gsmet = parmsSin['Pavadinimo metai'] or ''
            if gpsla ~= '' then
                return grefp.getla( gpsla, '', '', '', gsla, gsaut, gsmet )
            end
        end
        isrefpage = true
    end
    
    return grefp._ref( mw.text.trim(_mires or ''), mw.text.trim(_lt or ''), mw.text.trim(_sin or ''), _la, 
        mw.text.trim(_larod or ''), mw.text.trim(_aut or ''), mw.text.trim(_met or ''), mw.text.trim(ttip or ''),
        mw.text.trim(_sla or ''), mw.text.trim(_saut or ''), mw.text.trim(_smet or ''), gbif, isrefpage)
end

grefp.ref = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _aut = args.aut or pargs.aut or mw.text.trim(args[2] or pargs[2] or '')
    local _met = args.met or pargs.met or mw.text.trim(args[3] or pargs[3] or '')
    local _lt = args.lt or pargs.lt or mw.text.trim(args[4] or pargs[4] or '')
    
    return grefp.getla( _la, _aut, _met, _lt )
end

return grefp
