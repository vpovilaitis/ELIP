local HtmlBuilder = require('Module:HtmlBuilder')
local Switch = require('Module:Switch')
local Datos = require('Module:Datos')
local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')
local GrefTit = require('Module:GrefTit')
local Cite = require('Module:Cite')
local Komentaras = require('Module:Komentaras')

geovalst = {}

geovalst.eil = function( iso, frame, pgname )
    local xeil = HtmlBuilder.create()
    local lst = mw.text.split(iso, ',')
    for i, lstel in ipairs(lst) do
        if lstel ~= '' then
            local elem = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..pgname.." */ Valstybes t |where=t.iso='"..lstel..
                "'|data=isoc=t.iso,iso3=t.iso3,ison=t.ison,fips=t.fips,pav=t.pavadinimas,sos=t.sostine,area=t.area,gyv=t.population,val=t.curencycode,tel=t.phone,pri=t.priklauso,kaim=t.kaimynai,geo=t.geoname}}"..
                "{{#for_external_table:{{{isoc}}};{{{iso3}}};{{{ison}}};{{{fips}}}; {{{pav}}};{{{sos}}};{{{area}}};{{{gyv}}};{{{val}}};{{{tel}}};{{{pri}}};{{{kaim}}};{{{geo}}};}}{{#clear_external_data:}}") or ''
            local elems = mw.text.split(elem, ';')
            xeil.tag('tr')
            xeil.tag('td').wikitext( '[[', elems[1], ']]' ).done()
            if elems[2] ~= '' then
                xeil
                    .tag('td').wikitext( '[[', elems[2], ']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            xeil
                .tag('td').wikitext( elems[3] ).done()
            if elems[4] ~= '' then
                xeil
                    .tag('td').wikitext( '[[', elems[4], ']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[5] ~= '' then
                local issal = Switch._switch( 'Switch/šalys', elems[5], false )
                local vel = ''
                if issal then
                    local velt = Switch._switch2( 'Switch/šalys', elems[5], 'vėliava', false )
                    if velt then
                        if velt ~= '' then
                            vel = '[[Vaizdas:'..velt..'|25px|link='..elems[5]..']]'
                        end
                    end
                end
                xeil
                    .tag('td').wikitext( vel ).done()
                    .tag('td').wikitext( '[[', elems[5], ']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[6] ~= '' then
                xeil
                    .tag('td').wikitext( '[[', elems[6], ']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[7] ~= '' then
                xeil
                    .tag('td')
                        .attr('align', 'right')
                        .wikitext( elems[7] ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[8] ~= '' then
                xeil
                    .tag('td')
                        .attr('align', 'right')
                        .wikitext( '[[Sritis:'..elems[5]..'|'..elems[8]..']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[9] ~= '' then
                xeil
                    .tag('td').wikitext( '[[', elems[9], ']]' ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            if elems[10] ~= '' then
                xeil
                    .tag('td').wikitext( elems[10] ).done()
            else
                xeil
                    .tag('td').wikitext( '<!--  -->' ).done()
            end
            local xpav = ''
            if elems[11] ~= '' then
                local pris = mw.text.split(elems[11], ',')
                for j, lstpri in ipairs(pris) do
                    if lstpri ~= '' then
                        local pavi = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..pgname.." */ Valstybes t |where=t.iso='"..lstpri..
                            "'|data=pav=t.pavadinimas}}"..
                            "{{#for_external_table:{{{pav}}}}}{{#clear_external_data:}}") or ''
                        if j>1 then
                            xpav = xpav .. ', '
                        end
                        xpav = xpav .. '[[' .. pavi .. ']]'
                    end
                end
            end
            xeil
                .tag('td')
                .wikitext( xpav )
                .done()
            xpav = ''
            if elems[12] ~= '' then
                local pris = mw.text.split(elems[12], ',')
                for j, lstpri in ipairs(pris) do
                    if lstpri ~= '' then
                        local pavi = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..pgname.." */ Valstybes t |where=t.iso='"..lstpri..
                            "'|data=pav=t.pavadinimas}}"..
                            "{{#for_external_table:{{{pav}}}}}{{#clear_external_data:}}") or ''
                        if j>1 then
                            xpav = xpav .. ', '
                        end
                        xpav = xpav .. '[[' .. pavi .. ']]'
                    end
                end
            end
            xeil
                .tag('td')
                .wikitext( xpav )
                .done()
            local txt = ''
            if elems[13] ~= '' then
                txt = '[[Citata:' .. elems[5] .. '|' .. elems[13] .. ']]'
            end
            xeil
                .tag('td')
                .wikitext( txt )
                .done()
            local objsara = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..pgname.." */ featvalclasses t |where=t.iso='"..elems[1]..
                "'|data=viso=sum(t.sk)}}"..
                "{{#for_external_table:{{{viso}}}}}{{#clear_external_data:}}") or ''
            xeil
                .tag('td')
                .attr('align', 'right')
                .wikitext( objsara )
                .done()
        end
    end
    return tostring(xeil)
end

geovalst.lent = function( frame )
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local sar = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..pgname.." */ Valstybes t |order by=t.iso|data=isol=t.iso}}{{#for_external_table:{{{isol}}},}}{{#clear_external_data:}}") or ''
    xtbl.grazilentele()
        .attr('class', 'sortable')
        .tag('tr')
            .tag('th').wikitext( 'ISO' ).done()
            .tag('th').wikitext( 'ISO3' ).done()
            .tag('th').wikitext( 'ISON' ).done()
            .tag('th').wikitext( '[[FIPS]]' ).done()
            .tag('th').wikitext( '' ).done()
            .tag('th').wikitext( 'Pavadinimas' ).done()
            .tag('th').wikitext( 'Sostinė' ).done()
            .tag('th').wikitext( 'Plotas' ).done()
            .tag('th').wikitext( 'Gyventojų' ).done()
            .tag('th').wikitext( 'Valiuta' ).done()
            .tag('th').wikitext( 'Telefonas' ).done()
            .tag('th').wikitext( 'Priklauso' ).done()
            .tag('th').wikitext( 'Kaimynai' ).done()
            .tag('th').wikitext( 'GeoNameID' ).done()
            .tag('th').wikitext( 'Geo objektų skaičius' ).done()
            .done()
            .wikitext(geovalst.eil(sar, frame, pgname))
    xtbl.done()
    return tostring(xtbl)    
end

geovalst.valstybe = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local xktbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    local pgname = pg.text
    local ret = false
    laname = mw.ustring.gsub(pgname, "'", "''")
    local sar = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ Valstybes t |where=t.pavadinimas='"..laname..
        "' or t.country='"..laname..
        "' or exists (select 1 from AlternatyvusPav tt where tt.geoname=t.geoname and tt.lang<>'link' and tt.name='"..laname.."')"..
        "|data=iso=t.iso,iso3=t.iso3,ison=t.ison,fips=t.fips,count=t.country,pri=t.priklauso,pav=t.pavadinimas,cap=t.capital,sost=t.sostine,area=t.area,pop=t.population,cont=t.continent,tld=t.tld,"..
        "cur=t.curencycode,curn=t.curencyname,tel=t.phone,posf=t.postalformat,posr=t.postalregex,lang=t.languages,geo=t.geoname,kaim=t.kaimynai,equ=t.equivalentfips}}"..
        "{{"..subst.."#for_external_table:{{{iso}}};{{{iso3}}};{{{ison}}};{{{fips}}};{{{count}}};{{{pri}}};{{{pav}}};{{{cap}}};{{{sost}}};{{{area}}};{{{pop}}};{{{cont}}};{{{tld}}};{{{cur}}};"..
        "{{{curn}}};{{{tel}}};{{{posf}}};{{{posr}}};{{{lang}}};{{{geo}}};{{{kaim}}};{{{equ}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = mw.text.split(sar, ';')
    if elems[1] ~= '' then
        ret = true
        local kurt = 'Galite sukurti šią valstybę aprašanti straipsnį, nukreipiamąjį arba nuorodinį straipsnį.'
        if ns == 800 then
            kurt = 'Galite sukurti šiai valstybei skirtą sritį arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        elseif ns == 802 then
            kurt = 'Galite sukurti šiai valstybei skirtą naujieną arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        elseif ns == 804 then
            kurt = 'Galite sukurti šiai valstybei skirtą citatą arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        end
        local kalbos = ''
        if elems[20] ~= '' then
            local ksarp = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ AlternatyvusPav t |where=t.geoname='"..elems[20]..
                "' and t.lang<>'link' and t.name='"..laname.."'|order by=t.lang|data=lan=t.lang}}"..
                "{{"..subst.."#for_external_table:{{{lan}}};}}{{"..subst.."#clear_external_data:}}") or ''
            if ksarp ~= '' and ksarp ~= ';' then
                local klstp = mw.text.split(ksarp, ';')
                local kods = 'kalbose, kurių kodai'
                if #klstp == 2 then
                    kods = 'kalboje, kurios kodas'
                end
                kalbos = ' Šis pavadinimas vartojamas ' .. kods .. ': '
                for i2, klstelp in ipairs(klstp) do
                    if klstelp ~= '' then
                        if i2 ~= 1 then
                            kalbos = kalbos .. ', '
                        end
                        kalbos = kalbos .. '[[' .. klstelp .. ']]'
                    end
                end
                kalbos = kalbos .. '.'
            end
        end
        local sosti = ''
        local apras = ''
        if elems[9] ~= '' then
            sosti = kalbos 
            apras = 'Šios valstybės sostinė yra [[' .. elems[9] .. ']], jos plotas ' .. elems[10] .. ' kvadratinių kilometrų ir joje gyvena ' ..elems[11] .. ' gyventojų (pagal GeoNames). '
        end
        
        if elems[20] ~= '' then
            local ksar = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ AlternatyvusPav t |where=t.geoname='"..elems[20]..
                "' and t.lang<>'link'|order by=t.lang|data=lan=t.lang,name=t.name,pref=t.isPreferred,short=t.isShort,snek=t.isColloquial,ist=t.isHistoric}}"..
                "{{"..subst.."#for_external_table:{{{lan}}};{{{name}}};{{{pref}}};{{{short}}};{{{snek}}};{{{ist}}}~}}{{"..subst.."#clear_external_data:}}") or ''
            local klst = mw.text.split(ksar, '~')
            local keils = HtmlBuilder.create()
            for i, klstel in ipairs(klst) do
                if klstel ~= '' then
                    local klst1 = mw.text.split(klstel, ';')
                    local kkod = klst1[1]
                    if klst1[1] ~= '' and klst1[1] ~= ' ' then
                        kkod = '[[' .. klst1[1] .. ']]'
                    end
                    keils
                        .tag('tr')
                            .tag('td').wikitext( kkod ).done()
                            .tag('td').wikitext( '[[',klst1[2],']]' ).done()
                            .tag('td').wikitext( klst1[3] ).done()
                            .tag('td').wikitext( klst1[4] ).done()
                            .tag('td').wikitext( klst1[5] ).done()
                            .tag('td').wikitext( klst1[6] ).done()
                        .done()
                end
            end
            xktbl
                .tag('table')
                    .grazilentele()
                    .tag('tr')
                        .tag('th').wikitext( 'Kalba' ).done()
                        .tag('th').wikitext( 'Pavadinimas' ).done()
                        .tag('th').wikitext( 'Pageidaujamas' ).done()
                        .tag('th').wikitext( 'Trumpas' ).done()
                        .tag('th').wikitext( 'Šnekamosios' ).done()
                        .tag('th').wikitext( 'Istorinis' ).done()
                        .done()
                    .wikitext(tostring(keils))
                    .done()
                        
        end
        local objs = HtmlBuilder.create()
        local objsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ featvalclasses t |where=t.iso='"..elems[1]..
            "'|data=viso=sum(t.sk)}}"..
            "{{"..subst.."#for_external_table:{{{viso}}}}}{{"..subst.."#clear_external_data:}}") or ''
        if objsara ~= '' and objsara ~= '0' then
            local obje = HtmlBuilder.create()
            local objsar = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ featvalclasses t |where=t.iso='"..elems[1]..
                "'|data=tip=t.classpavadinimas,sk=t.sk}}"..
                "{{"..subst.."#for_external_table:{{{tip}}};{{{sk}}}~}}{{"..subst.."#clear_external_data:}}") or ''
            local objes = mw.text.split(objsar, '~')
            for i, objesel in ipairs(objes) do
                local objesele = mw.text.split(objesel, ';')
                obje
                    .tag('tr')
                        .tag('td').wikitext( objesele[1] ).done()
                        .tag('td').attr('align', 'right').wikitext( objesele[2] ).done()
                        .done()
            end
            objs
                .tag('p')
                    .wikitext( 'Šiai valstybei GeoNames skelbiama informacija apie ', objsara, ' geografinių objektų. Jų pasiskirstymas pagal objektų klases yra sekantis.' )
                    .done()
                .newline()
                .tag('table')
                    .grazilentele()
                    .tag('tr')
                        .tag('th').wikitext( 'Klasė' ).done()
                        .tag('th').wikitext( 'Skaičius' ).done()
                        .done()
                    .wikitext(tostring(obje))
                    .done()
        end
        local childs = HtmlBuilder.create()
        local childsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ geotree t left join geonames g on g.geoname=t.parent |where=t.child='"..elems[20]..
            "'|data=cname=g.name,cpavad=g.pavadinimas,cascpavad=g.asciiname,cgeo=g.geoname}}"..
            "{{"..subst.."#for_external_table:{{{cname}}};{{{cpavad}}};{{{cascpavad}}};{{{cgeo}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if childsara ~= '' and childsara ~= ';;;~' then
            local childes = mw.text.split(childsara, '~')
            local childe = ''
            for i, childesel in ipairs(childes) do
                if childesel ~= '' then
                    local childesele = mw.text.split(childesel, ';')
                    local cpav = childesele[2]
                    if cpav == '' then
                        cpav = childesele[1]
                    end
                    if i > 1 then
                        childe = childe .. ', '
                    end
                    childe = childe .. '[[' .. cpav .. ']] (' .. childesele[4] .. ')'
                end
            end
            childs
                .tag('p')
                    .wikitext( 'Valstybė priklauso arba priklausė: ', childe, '.' )
                    .done()
        end
        childsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ geotree t left join geonames g on g.geoname=t.child |where=t.parent='"..elems[20]..
            "'|data=cname=g.name,cpavad=g.pavadinimas,cascpavad=g.asciiname,cgeo=g.geoname}}"..
            "{{"..subst.."#for_external_table:{{{cname}}};{{{cpavad}}};{{{cascpavad}}};{{{cgeo}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if childsara ~= '' and childsara ~= ';;;~' then
            local childes = mw.text.split(childsara, '~')
            local childe = ''
            for i, childesel in ipairs(childes) do
                if childesel ~= '' then
                    local childesele = mw.text.split(childesel, ';')
                    local cpav = childesele[2]
                    if cpav == '' then
                        cpav = childesele[1]
                    end
                    if i > 1 then
                        childe = childe .. ', '
                    end
                    childe = childe .. '[[' .. cpav .. ']] (' .. childesele[4] .. ')'
                end
            end
            childs
                .tag('p')
                    .wikitext( 'Valstybė turi sekančius tiesiogiai priklausančius administracinius vienetus: ', childe, '.' )
                    .done()
        end
        local gyv2015 = HtmlBuilder.create()
        local gyv2015sara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ valstGyv t |where=t.metai='2015' and t.variant='Medium' and t.loc='"..elems[3]..
            "'|data=gyv2015=t.PopTotal,aug2015=t.GrowthRate,den2015=t.PopDensity}}"..
            "{{"..subst.."#for_external_table:{{{gyv2015}}};{{{aug2015}}};{{{den2015}}}}}{{"..subst.."#clear_external_data:}}") or ''
        if gyv2015sara ~= '' and gyv2015sara ~= ';;' then
            local gyv2015esele = mw.text.split(gyv2015sara, ';')
            gyv2015
                .tag('tr')
                    .tag('th').wikitext( 'Gyventojų 2015 m. (JT)' ).done()
                    .tag('td').attr('align', 'right').wikitext( gyv2015esele[1] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Gyventojų augimas 2015 m. (JT)' ).done()
                    .tag('td').attr('align', 'right').wikitext( gyv2015esele[2] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Gyventojų tankumas 2015 m. (JT)' ).done()
                    .tag('td').attr('align', 'right').wikitext( gyv2015esele[3] ).done()
                    .done()
            apras = apras .. 'Pagal JT gyventojų statistikos pateikiamą informacija šalyje 2015 m. gyveno ' .. gyv2015esele[1] .. ' gyventojai. Gyventojų tankis ' .. gyv2015esele[3] .. 
                ' gyv./km². Gyventojų prieaugis tūkstančiui gyventojų sudarė ' .. gyv2015esele[2] .. '.'
        end
        local gyvm = HtmlBuilder.create()
        local gyvme = HtmlBuilder.create()
        local gyvmsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ valstGyv t |where=t.variant='Medium' and t.loc='"..elems[3]..
            "'|order by=t.metai|data=gyvmetai=t.metai,gyvm=t.PopTotal,augm=t.GrowthRate,denm=t.PopDensity}}"..
            "{{"..subst.."#for_external_table:{{{gyvmetai}}};{{{gyvm}}};{{{augm}}};{{{denm}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if gyv2msara ~= '' and gyvmsara ~= ';;;~' then
            local gyvmesele = mw.text.split(gyvmsara, '~')
            for i, gyvmesel in ipairs(gyvmesele) do
                local gyvmesele1 = mw.text.split(gyvmesel, ';')
                if gyvmesele1[1] ~= '' then
                    gyvme
                        .tag('tr')
                            .tag('td').wikitext( gyvmesele1[1] ).done()
                            .tag('td').attr('align', 'right').wikitext( gyvmesele1[2] ).done()
                            .tag('td').attr('align', 'right').wikitext( gyvmesele1[3] ).done()
                            .tag('td').attr('align', 'right').wikitext( gyvmesele1[4] ).done()
                            .done()
                end
            end
            gyvm
                .tag('table')
                    .grazilentele()
                    .tag('tr')
                        .tag('th').wikitext( 'Metai' ).done()
                        .tag('th').wikitext( 'Gyventojų skaičius' ).done()
                        .tag('th').wikitext( 'Gyventojų augimas' ).done()
                        .tag('th').wikitext( 'Gyventojų tankumas' ).done()
                        .done()
                    .wikitext( tostring(gyvme) )
                    .done()
        end
        local issal = Switch._switch( 'Switch/šalys', elems[7], false )
        local vel = ''
        local her = ''
        if issal then
            local velt = Switch._switch2( 'Switch/šalys', elems[7], 'vėliava', false )
            if velt then
                if velt ~= '' then
                    vel = '[[Vaizdas:'..velt..'|200px|link='..elems[7]..']]'
                end
            end
            local hert = Switch._switch2( 'Switch/šalys', elems[7], 'herbas', false )
            if hert then
                if hert ~= '' then
                    her = '[[Vaizdas:'..hert..'|100px|link='..elems[7]..']]'
                end
            end
        end
        local zemel = ''
        local prm = Parm._gettext{ page = 'Location map '..elems[7], namespace = 10, subst=subst }
        if prm ~= nil then
            zemel = frame:preprocess("{{Location map|"..elems[7].."|float=center|width=500|position=right|lat=0|long=0|caption=}}") or ''
        end
        xtbl
            .tag('table')
                .grazilentele()
                .attr('align', 'right')
                .tag('tr')
                    .tag('th')
                        .attr('colspan', '2')
                        .wikitext( elems[7] )
                        .done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'ISO' ).done()
                    .tag('td').wikitext( '[[', elems[1], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'ISO3' ).done()
                    .tag('td').wikitext( '[[', elems[2], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'ISON' ).done()
                    .tag('td').wikitext( elems[3] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( '[[FIPS]]' ).done()
                    .tag('td').wikitext( '[[', elems[4], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Vėliava' ).done()
                    .tag('td').attr('align', 'center').wikitext( vel ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Herbas' ).done()
                    .tag('td').attr('align', 'center').wikitext( her ).done()
                    .done()
                .tag('tr')
                    .tag('td').attr('align', 'center').attr('colspan', '2').wikitext( zemel ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Country' ).done()
                    .tag('td').wikitext( '[[', elems[5], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Priklauso' ).done()
                    .tag('td').wikitext( elems[6] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Pavadinimas' ).done()
                    .tag('td').wikitext( '[[', elems[7], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Capital' ).done()
                    .tag('td').wikitext( '[[', elems[8], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Sostinė' ).done()
                    .tag('td').wikitext( '[[', elems[9], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Plotas' ).done()
                    .tag('td').attr('align', 'right').wikitext( elems[10] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Gyventojų (GeoNames)' ).done()
                    .tag('td').attr('align', 'right').wikitext( elems[11] ).done()
                    .done()
                .wikitext( tostring(gyv2015) )
                .tag('tr')
                    .tag('th').wikitext( 'Žemynas' ).done()
                    .tag('td').wikitext( '[[', elems[12], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'TLD' ).done()
                    .tag('td').wikitext( '[[', elems[13], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Valiuta' ).done()
                    .tag('td').wikitext( '[[', elems[14], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Valiuta anglų' ).done()
                    .tag('td').wikitext( '[[', elems[15], ']]' ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Telefonas' ).done()
                    .tag('td').wikitext( elems[16] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Pašto kodo formatas' ).done()
                    .tag('td').wikitext( elems[17] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Pašto kodo regexp' ).done()
                    .tag('td').wikitext( elems[18] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Kalbos' ).done()
                    .tag('td').wikitext( elems[19] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'GeoName' ).done()
                    .tag('td').wikitext( elems[20] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Kaimynai' ).done()
                    .tag('td').wikitext( elems[21] ).done()
                    .done()
                .tag('tr')
                    .tag('th').wikitext( 'Ekvivalentus fips' ).done()
                    .tag('td').wikitext( elems[22] ).done()
                    .done()
            .done()
            .tag('p')
                .wikitext( "'''",pgname,"''' – pagal GeoNames yra valstybė „[[",elems[7],"]]“, jos sinonimas arba pavadinimas, kuria nors kita kalba.", sosti )
                .done()
            .newline()
            .tag('h2')
                .wikitext( 'Aprašymas' )
                .done()
            .newline()
            .tag('p')
                .wikitext( apras )
                .done()
            .newline()
            .tag('h2')
                .wikitext( 'Perspėjimas' )
                .done()
            .newline()
            .tag('p')
                .wikitext( kurt )
                .done()
            .newline()
            .tag('p')
                .wikitext( 'Šiame puslapyje pateikiama GeoNames skelbiama informacija. Už GeoNames skelbiamos informacijos teisingumą Enciklopedija Lietuvai ir pasauliui neatsako.' )
                .done()
            .newline()
            .tag('h2')
                .wikitext( 'Kalbos' )
                .done()
            .newline()
            .wikitext(tostring(xktbl))
            .newline()
            .tag('h2')
                .wikitext( 'Objektai' )
                .done()
            .newline()
            .wikitext(tostring(objs))
            .newline()
            .tag('h2')
                .wikitext( 'Administraciniai vienetai' )
                .done()
            .newline()
            .wikitext(tostring(childs))
            .newline()
            .tag('h2')
                .wikitext( 'Gyventojų skaičius' )
                .done()
            .newline()
            .tag('p')
                .wikitext( 'Gyventojų statistika, kuri pateikiama pagal Jungtinių Tautų surinktą ir pateikiamą statistinę informaciją.' )
                .done()
            .newline()
            .newline()
            .wikitext(tostring(gyvm))
            .newline()
            .tag('h2')
                .wikitext( 'Šaltiniai' )
                .done()
            .newline()
            .wikitext('* [http://www.geonames.org/ Geografinių duomenų bazė GeoNames]. 2015 m. lapkričio 13 d. duomenys.')
            .newline()
            .wikitext('* [http://esa.un.org/unpd/wpp/ Jungtinių tautų statistinė gyventojų duomenų bazė]. 2015 m. gruodžio 18 d. duomenys.')
            .newline()
            .newline()
            .wikitext('[[Kategorija:Valstybės/geoname]]')
            .newline()
            .newline()
            .tag('div')
                .attr('style', 'clear:both')
                .done()
            .newline()
            .wikitext('----')
            .newline()
            .done()
    end
    if ret then
        return tostring(xtbl)
    else
        return ''
    end
end

geovalst.geoname = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local xktbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local ret = false
    if ns == 804 or ns == 0 then
        local pgname = pg.rootText
        local laname = mw.ustring.gsub(pgname, "'", "''")
        laname = mw.ustring.gsub(laname, " %(reikšmės%)", "")
        local laname2 = mw.ustring.lower(mw.ustring.sub( laname, 1, 1 ))..mw.ustring.sub( laname, 2 )
        local pgnr = 0
        if pg.text ~= pg.subpageText then
            pgnr = tonumber('0' .. (pg.subpageText or ''))
        end
        if pgnr == nil then pgnr = 0 end
        local fromsk = pgnr*10
        local tosk = fromsk+10
        local prevpg = ''
        local prevnr = pgnr-1
        if pgnr > 0 then
            if prevnr==0 then prevnr='' else prevnr = '/'..prevnr end
            prevpg = '[['..pg.subjectNsText..':'..pgname..prevnr..'|'..pgnr..' psl.]]'
        end
        local kiek = tonumber('0'..(frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ namesDist t |where=t.name='"..laname..
                            "' or t.name='"..laname2..
                            "'|data=kiek=t.sk}}"..
                            "{{"..subst.."#for_external_table:{{{kiek}}}}}{{"..subst.."#clear_external_data:}}") or '0') )
        local kiekpg = tonumber('0'..(frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ namesDist t |where=t.name='"..laname..
                            "'or t.name='"..laname2..
                            "'|data=kiekpg=(t.sk+10-1) div 10}}"..
                            "{{"..subst.."#for_external_table:{{{kiekpg}}}}}{{"..subst.."#clear_external_data:}}") or '0') )
        local kiekpgt = '('..kiekpg..' psl.), viso skirtingų pavadinimų: '..kiek..'\n\nPereiti į: [['..pg.subjectNsText..':'..pgname..'|1]]'
        for ij = 1,(kiekpg-1) do
            kiekpgt = kiekpgt .. ', [['..pg.subjectNsText..':'..pgname..'/'..ij..'|'..(ij+1)..']]'
        end
        kiekpgt = kiekpgt .. ' psl.'
        local nextpg = ''
        if kiek > (pgnr+1)*10 then
            nextpg = '[['..pg.subjectNsText..':'..pgname..'/'..(pgnr+1)..'|'..(pgnr+2)..' psl.]]'
        end
        local sar = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ (SELECT t1.geoname, t1.name  FROM geoname.geonames t1 WHERE t1.name = '"..laname..
            "' or t1.name = '"..laname2.."' union SELECT t3.geoname, t3.pavadinimas name  FROM geoname.geonames t3 WHERE t3.pavadinimas = '"..laname..
            "' or t3.pavadinimas = '"..laname2.."' union SELECT t4.geoname, t4.asciiname name  FROM geoname.geonames t4 WHERE t4.asciiname = '"..laname..
            "' or t4.asciiname = '"..laname2.."' union SELECT t5.geoname, t5.asciipav name  FROM geoname.geonames t5 WHERE t5.asciipav = '"..laname..
            "' or t5.asciipav = '"..laname2.."' union SELECT t6.geoname, t6.name name  FROM geoname.names t6 WHERE t6.name = '"..laname..
            "' or t6.name = '"..laname2.."' union select t2.geoname, t2.name from geoname.AlternatyvusPav t2 WHERE (t2.name = '"..laname..
            "' or t2.name = '"..laname2.."') and t2.lang not IN ('post','iata','icao','faac','link') and not exists (select 1 from Valstybes tt where tt.geoname=t2.geoname)) t |where=(t.name='"..laname..
            "') or (t.name='"..laname2..
            "')|order by=1 limit " .. fromsk .. ",10|data=geo=t.geoname}}"..
            "{{"..subst.."#for_external_table:{{{geo}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        local gzemel2 = ''
        local sakilm = ''
        local fcode = ''
        local fcode2 = ''
        local country2 = ''
        local ccode = ''
        local adm1c = ''
        local fcodec = ''
        local latitude = ''
        local longitude = ''
        local population = ''
        local mdate = ''
        local adm1n = ''
        local adm1nkilm = ''
        local elevation = ''
        local plot = ''
        if sar ~= '' and sar ~= ';' then
            ret = true
            local elems = mw.text.split(sar, '~')
            
            for i, klstel in ipairs(elems) do
                if klstel ~= '' then
                    fcode = ''
                    fcodec = ''
                    fcode2 = ''
                    local kalbos = ''
                    local ksarp = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ AlternatyvusPav t |where=t.geoname='"..klstel..
                        "' and t.lang not IN ('post','iata','icao','faac','link') and (t.name='"..laname.."' or t.name='"..laname2.."')|order by=t.lang|limit=20|data=lan=t.lang}}"..
                        "{{"..subst.."#for_external_table:{{{lan}}};}}{{"..subst.."#clear_external_data:}}") or ''
                    if ksarp ~= '' and ksarp ~= ';' then
                        local klstp = mw.text.split(ksarp, ';')
                        for i2, klstelp in ipairs(klstp) do
                            if klstelp ~= '' then
                                if i2 ~= 1 then
                                    kalbos = kalbos .. ', '
                                end
                                kalbos = kalbos .. '[[' .. klstelp .. ']]'
                            end
                        end
                    end
                    local kalbos2 = ''
                    local ksarp2 = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ AlternatyvusPav t |where=t.geoname='"..klstel..
                        "' and t.lang not IN ('post','iata','icao','faac','link') and (t.name<>'"..laname.."' and t.name<>'"..laname2.."')|order by=t.lang|limit=20|data=lan=t.lang,name=t.name}}"..
                        "{{"..subst.."#for_external_table:{{{lan}}},{{{name}}};}}{{"..subst.."#clear_external_data:}}") or ''
                    if ksarp2 ~= '' and ksarp2 ~= ';' then
                        local klstp2 = mw.text.split(ksarp2, ';')
                        for i3, klstelp2 in ipairs(klstp2) do
                            if klstelp2 ~= '' then
                                local klstp3 = mw.text.split(klstelp2, ',')
                                if i3 ~= 1 then
                                    kalbos2 = kalbos2 .. ', '
                                end
                                local islang = ''
                                if klstp3[1] ~= '' then
                                    islang = ' ([[' .. klstp3[1] .. ']])'
                                end
                                kalbos2 = kalbos2 .. '[[' .. klstp3[2] .. ']]' .. islang
                            end
                        end
                    end
                    local name = ''
                    local pavad = ''
                    local pavad2 = ''
                    local ascpavad = ''
                    local altpavad = ''
                    latitude = ''
                    longitude = ''
                    local fclass = ''
                    local fclassc = ''
                    local miestas = ''
                    local miestas2 = ''
                    local country = ''
                    population = ''
                    elevation = ''
                    plot = ''
                    ccode = ''
                    fcodec = ''
                    adm1c = ''
                    local adm1 = ''
                    local apav = ''
                    local ksarp3 = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ geoname.geonames t "..
                        "left join geoname.featuresclass fc on fc.class=t.featureclass "..
                        "left join geoname.features fd on fd.code=t.featurecode "..
                        "left join geoname.adm1 ad1 on ad1.code=case when t.admv1='00' or t.admv1='' then '00' else concat(t.countrycode,'.',t.admv1) end "..
                        "left join geoname.geonames ad1g on ad1.geoname=ad1g.geoname "..
                        "left join geoname.Valstybes va on va.iso=t.countrycode |where=t.geoname='"..klstel..
                        "'|order by=t.name|data=name=t.name,pavad=t.pavadinimas,ascpavad=t.asciiname,altpavad=t.altnames,latitude=t.latitude,longitude=t.longitude,"..
                        "fclass=case when fc.classpavadinimas='' then fc.classname else fc.classpavadinimas end,fcode=case when fd.pavadinimas='' then fd.name else fd.pavadinimas end,"..
                        "country=va.pavadinimas,fcodec=t.featurecode,population=t.population,elevation=t.elevation,"..
                        "adm1=case when ad1g.geoname is null then '' when ad1g.pavadinimas='' then ad1g.name else ad1g.pavadinimas end,"..
                        "apav=t.asciipav,fclassc=t.featureclass,mdate=substr(t.moddate,1,4),plot=t.dem,ccode=t.countrycode,adm1c=t.admv1}}"..
                        "{{"..subst.."#for_external_table:{{{name}}};{{{pavad}}};{{{ascpavad}}};{{{altpavad}}};{{{latitude}}};{{{longitude}}};{{{fclass}}};{{{fcode}}};{{{country}}};{{{fcodec}}};"..
                        "{{{population}}};{{{elevation}}};{{{adm1}}};{{{apav}}};{{{fclassc}}};{{{mdate}}};{{{plot}}};{{{ccode}}};{{{adm1c}}};}}{{"..subst.."#clear_external_data:}}") or ''
                    local klstp3
                    if ksarp3 ~= '' and ksarp3 ~= ';' then
                        klstp3 = mw.text.split(ksarp3, ';')
                        if klstp3[1] ~= '' then name = '[[' .. klstp3[1] .. ']]' end
                        if klstp3[14] ~= '' then 
                            pavad = '[[' .. klstp3[14] .. ']]' 
                            pavad2 = klstp3[14] 
                        end
                        if klstp3[2] ~= '' then 
                            pavad = '[[' .. klstp3[2] .. ']]' 
                            pavad2 = klstp3[2] 
                        end
                        if klstp3[3] ~= '' then ascpavad = '[[' .. klstp3[3] .. ']]' end
                        if klstp3[4] ~= '' then
                            local klstp4 = mw.text.split(klstp3[4], ',')
                            for ialt, klstelalt in ipairs(klstp4) do
                                if klstelalt ~= '' then
                                    if ialt ~=1 then altpavad = altpavad .. ', ' end
                                    altpavad = altpavad .. '[[' .. klstelalt .. ']]'
                                end
                            end
                        end
                        if klstp3[5] ~= '' then latitude = klstp3[5] end
                        if klstp3[6] ~= '' then longitude = klstp3[6] end
                        if klstp3[7] ~= '' then fclass = klstp3[7] end
                        if klstp3[8] ~= '' then fcode = klstp3[8] .. ' (' .. klstp3[10] .. ')' end
                        if klstp3[8] ~= '' then fcode2 = klstp3[8] end
                        if klstp3[10] ~= '' then fcodec = klstp3[10] end
                        if klstp3[15] ~= '' then fclassc = klstp3[15] end
                        if klstp3[9] ~= '' then 
                            country = '[[' .. klstp3[9] .. ']]' 
                            country2 = klstp3[9]
                        end
                        if klstp3[11] ~= '' then population = klstp3[11] end
                        if klstp3[12] ~= '' then elevation = klstp3[12] end
                        if klstp3[16] ~= '' then mdate = klstp3[16] end
                        --if klstp3[17] ~= '' then plot = klstp3[17] end
                        if klstp3[18] ~= '' then ccode = klstp3[18] end
                        if klstp3[19] ~= '' then adm1c = klstp3[19] end
                        if klstp3[13] ~= '' then adm1 = '[[' .. klstp3[13] .. ']]' end
                        if klstp3[13] ~= '' then adm1n = klstp3[13] end
                    end
                    local childs = HtmlBuilder.create()
                    local childsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ geotree t left join geonames g on g.geoname=t.parent |where=t.child='"..klstel..
                        "'|limit=20|data=cname=g.name,cpavad=g.pavadinimas,cascpavad=g.asciiname,cgeo=g.geoname}}"..
                        "{{"..subst.."#for_external_table:{{{cname}}};{{{cpavad}}};{{{cascpavad}}};{{{cgeo}}}~}}{{"..subst.."#clear_external_data:}}") or ''
                    if childsara ~= '' and childsara ~= ';;~' then
                        local childes = mw.text.split(childsara, '~')
                        local childe = ''
                        for i, childesel in ipairs(childes) do
                            if childesel ~= '' then
                                local childesele = mw.text.split(childesel, ';')
                                local cpav = childesele[2]
                                if cpav == '' then
                                    cpav = childesele[1]
                                end
                                if i > 1 then
                                    childe = childe .. ', '
                                end
                                childe = childe .. '[[' .. cpav .. ']] (' .. childesele[4] .. ')'
                            end
                        end
                        childs
                            .tag('p')
                                .wikitext( 'Administracinis vienetas priklauso administraciniam vienetui: ', childe, '. ' )
                                .done()
                    end
                    childsara = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..laname.." */ geotree t left join geonames g on g.geoname=t.child |where=t.parent='"..klstel..
                        "'|limit=20|data=cname=g.name,cpavad=g.pavadinimas,cascpavad=g.asciiname,cgeo=g.geoname}}"..
                        "{{"..subst.."#for_external_table:{{{cname}}};{{{cpavad}}};{{{cascpavad}}};{{{cgeo}}}~}}{{"..subst.."#clear_external_data:}}") or ''
                    if childsara ~= '' and childsara ~= ';;~' then
                        local childes = mw.text.split(childsara, '~')
                        local childe = ''
                        for i, childesel in ipairs(childes) do
                            if childesel ~= '' then
                                local childesele = mw.text.split(childesel, ';')
                                local cpav = childesele[2]
                                if cpav == '' then
                                    cpav = childesele[1]
                                end
                                if i > 1 then
                                    childe = childe .. ', '
                                end
                                childe = childe .. '[[' .. cpav .. ']] (' .. childesele[4] .. ')'
                            end
                        end
                        childs
                            .tag('p')
                                .wikitext( 'Administracinis vienetas turi sekančius tiesiogiai priklausančius administracinius vienetus: ', childe, '.' )
                                .done()
                    end
                    local issal = Switch._switch( 'Switch/šalys', klstp3[9], false )
                    local vel = ''
                    local velpx = '125'
                    if #elems > 2 or kiek>1 then velpx = '25' end
                    if issal then
                        sakilm = Switch._switch2( 'Switch/šalys', klstp3[9], 'kilmininkas', false )
                        if sakilm then
                            sakilm = '[[' .. klstp3[9] .. '|' .. sakilm .. ']]'
                        else
                            sakilm = '[[' .. klstp3[9] .. ']]'
                        end
                        local velt = Switch._switch2( 'Switch/šalys', klstp3[9], 'vėliava', false )
                        if velt then
                            if velt ~= '' then
                                vel = '[[Vaizdas:'..velt..'|'..velpx..'px|link='..klstp3[9]..']]'
                            end
                        end
                    end
                    if #elems > 2 or kiek>1 then
                        xktbl
                            .wikitext( '|-\n' )
                            .wikitext( '| ' .. kalbos .. '\n' )
                            .wikitext( '| ' .. klstel .. '\n' )
                            .wikitext( '| ' .. name .. '\n' )
                            .wikitext( '| ' .. pavad .. '\n' )
                            .wikitext( '| ' .. ascpavad .. '\n' )
                            .wikitext( '| ' .. altpavad .. '\n' )
                            .wikitext( '| ' .. latitude .. '\n' )
                            .wikitext( '| ' .. longitude .. '\n' )
                            .wikitext( '| ' .. fclass .. '\n' )
                            .wikitext( '| ' .. fcode .. '\n' )
                            .wikitext( '| ' .. vel .. '\n' )
                            .wikitext( '| ' .. country .. '\n' )
                            .wikitext( '| ' .. population .. '\n' )
                            .wikitext( '| ' .. elevation .. '\n' )
                            --.wikitext( '| ' .. plot .. '\n' )
                            .wikitext( '| ' .. adm1 .. '\n' )
                            .wikitext( '| ' .. kalbos2 .. '\n' )
                            .wikitext( '| ' .. tostring(childs) .. '\n' )
                    else
                        local zemel = ''
                        local gzemel = ''
                        if fclassc == 'P' then
                            miestas = '{| width="350px" style="margin-bottom: 0.5em; margin-left: 1em; background: #f9f9f9; float: right; border: 0px #e0efef solid;"\n|-\n|\n'..
                                frame:preprocess( '{{Miestas2\n|lat=' .. latitude .. '\n|long=' .. longitude .. '\n|valstybė=' .. country2 .. '\n|admVienetas='..adm1n..'\n|pavadinimas=' .. pgname .. 
                                    '\n|gyventojumetai='..mdate..'\n|gyventoju ='..population..'\n|plotas='..plot..'\n|altitudė='..elevation..'\n|geoname='..klstel..'\n}}\n|-\n|\n' )
                            miestas2 = '|}\n'
                        end
                        --local prm = Parm._gettext{ page = 'Location map '..klstp3[9], namespace = 10 }
                        --if prm ~= nil then
                            if latitude=='' or longitude=='' then
                                local prm = Parm._gettext{ page = 'Location map '..adm1n, namespace = 10, subst=subst }
                                if prm ~= nil then
                                    zemel = frame:preprocess("{{Location map|"..adm1n.."|float=center|width=350|position=right|lat=0|long=0|caption=}}") or ''
                                else
                                    prm = Parm._gettext{ page = 'Location map '..klstp3[9], namespace = 10, subst=subst }
                                    if prm ~= nil then
                                        zemel = frame:preprocess("{{Location map|"..klstp3[9].."|float=center|width=350|position=right|lat=0|long=0|caption=}}") or ''
                                    end
                                end
                            else
                                local prm = Parm._gettext{ page = 'Location map '..adm1n, namespace = 10, subst=subst }
                                if prm ~= nil then
                                    zemel = frame:preprocess("{{Location map|"..adm1n.."|float=center|width=350|position=right|lat="..latitude.."|long="..longitude.."|caption="..pavad2.."}}") or ''
                                else
                                    prm = Parm._gettext{ page = 'Location map '..klstp3[9], namespace = 10, subst=subst }
                                    if prm ~= nil then
                                        zemel = frame:preprocess("{{Location map|"..klstp3[9].."|float=center|width=350|position=right|lat="..latitude.."|long="..longitude.."|caption="..pavad2.."}}") or ''
                                    end
                                end
                                gzemel = frame:preprocess("{{#display_map: "..latitude..", "..longitude.." \n |zoom=14|height=350px |width=350px}}") or ''
                                if fclassc ~= 'P' then
                                    gzemel = gzemel .. frame:preprocess("\n{{coord|"..latitude.."|"..longitude.."|display=inline,title}}{{#set:Koordinatės="..latitude..", "..longitude.."}}") or ''
                                end
                                if pgid ~= 0 and ns==0 and mw.ustring.find( laname, "'" )==nil then
                                    gzemel2 = frame:preprocess("\n=== Google žemėlapis ===\n{{#ask:[[" .. pgname .. "]]|?#|?Koordinatės|format=googlemaps|headers=show|link=all|geoservice=geonames|zoom=14"..
                                        "|width=800|height=800|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}" .. 
                                        "\n\n=== OpenLayers žemėlapis ===\n{{#ask:[[" .. pgname .. "]]|?#|?Koordinatės|format=openlayers|headers=show|link=all|geoservice=geonames|zoom=14"..
                                        "|width=800|height=800|layers=osm-mapnik,osm-cyclemap,osmarender|forceshow=1|showtitle=1|title=Specialus:Ask|offset=|limit=}}\n\n" ..
                                        "=== WikiMapia žemėlapis ===\n{{#widget:WikiMapia|lat= "..latitude.."|long= "..longitude..
                                        "|zoom=14|height=800px|width=800px}}\n\n" ..
                                        "=== Pasaulio žemėlapiuose ===\n{{Vlasenko/show2|long="..longitude.."|lat="..latitude.."}}\n\n"
                                        ) or '' --  <headertabs />
                                else
                                    gzemel2 = frame:preprocess("\n=== Google žemėlapis ===\n{{#display_map: "..latitude..", "..longitude.." \n"..
                                        "\n|zoom=14|height=800px |width=800px}}\n\n" ..
                                        "=== OpenLayers žemėlapis ===\n{{#display_map: "..latitude..", "..longitude..
                                        " \n |service=openlayers|zoom=14|height=800px |width=800px}}\n\n" ..
                                        "=== WikiMapia žemėlapis ===\n{{#widget:WikiMapia|lat "..latitude.."|long= "..longitude..
                                        "|zoom=14|height=800px|width=800px}}\n\n" ..
                                        "=== Pasaulio žemėlapiuose ===\n{{Vlasenko/show2|long="..longitude.."|lat="..latitude.."}}\n\n"
                                        ) or '' --  <headertabs />
                                end
                            end
                        --end
                        xtbl
                            .wikitext(miestas)
                            .newline()
                            .wikitext('{| cellpadding=2 width=350px style="margin-bottom: 0.5em; margin-left: 1em; background: #f9f9f9; float: right; border: 1px #e0efef solid; font-size: 95%;"\n')
                            .wikitext('|-\n')
                            .wikitext('! colspan=2 | GeoNames Info\n')
                            .wikitext('|-\n')
                            .wikitext('! colspan=2 style="background:#e0efef;" | ',pavad,'\n')
                        if miestas== '' then
                            xtbl
                                .wikitext('|-\n')
                                .wikitext('! colspan=2 | ',vel,'\n')
                        end
                        xtbl
                                .wikitext('|-\n')
                                .wikitext('! colspan=2 | ',zemel,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Šalis\n')
                                .wikitext('| ',country,'\n')
                        xtbl
                                .wikitext('|-\n')
                                .wikitext('! Administracinis vienetas\n')
                                .wikitext('| ',adm1,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Geoname pavadinimas\n')
                                .wikitext('| ',name,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Ascii pavadinimas\n')
                                .wikitext('| ',ascpavad,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Sinonimai\n')
                                .wikitext('| ',altpavad,'\n')
                        if miestas== '' then
                            xtbl
                                .wikitext('|-\n')
                                .wikitext('! Koordinatės\n')
                                .wikitext('| ',latitude, '; ', longitude,'\n')
                        end
                        xtbl
                                .wikitext('|-\n')
                                .wikitext('! Tipo klasė\n')
                                .wikitext('| ',fclass,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Tipas\n')
                                .wikitext('| ',fcode,'\n')
                        if miestas== '' then
                            xtbl
                                .wikitext('|-\n')
                                .wikitext('! Gyventojai\n')
                                .wikitext('| ',population,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Aukštingumas\n')
                                .wikitext('| ',elevation,'\n')
                                .wikitext('|-\n')
                                --.wikitext('! Plotas\n')
                                --.wikitext('| ',plot,'\n')
                                --.wikitext('|-\n')
                        end
                        xtbl
                                .wikitext('|-\n')
                                .wikitext('! Kalbose\n')
                                .wikitext('| ',kalbos,'\n')
                                .wikitext('|-\n')
                                .wikitext('! Kalbomis\n')
                                .wikitext('| ',kalbos2,'\n')
                        if miestas== '' then
                            xtbl
                                .wikitext('|-\n')
                                .wikitext('! GeoName ID\n')
                                .wikitext('| ',klstel,'\n')
                                .wikitext('|-\n')
                                .wikitext('! colspan=2 | ',gzemel,'\n')
                        end
                        xtbl
                                .wikitext('|-\n')
                                .wikitext('! Administraciniai vienetai\n')
                                .wikitext('| ',tostring(childs),'\n')
                                .wikitext('|}\n')
                            .newline()
                            .wikitext( miestas2 )
                    end
                end
            end
            local fcode3 = ''
            if #elems > 1 then
                local popp = ''
                fcode3 = mw.ustring.upper( mw.ustring.sub( fcode2, 1, 1 ) ) .. mw.ustring.sub( fcode2, 2 )
                if adm1n~='' then 
                    adm1nkilm = Parm._get{ page = adm1n, parm = 'kilm', namespace = 0, subst=subst } or ''
                    
                    if adm1nkilm~='' then
                        popp = '\n== Geografija ==\n\n'..fcode3..' yra '..sakilm..' pagrindinio teritorinio vieneto [['..adm1n..'|'..adm1nkilm..']] teritorijoje.'
                    else
                        popp = '\n== Geografija ==\n\n'..fcode3..' yra '..sakilm..' pagrindinio teritorinio vieneto [['..adm1n..']] teritorijoje.' 
                    end
                else
                    popp = '\n== Geografija ==\n\n'..fcode3..' yra '..sakilm..' teritorijoje.'
                end
                if ccode ~= '' and fcodec~='PPLC' then
                    local sosta = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ geonames g |where=g.countrycode='"..ccode..
                        "' and g.featurecode='PPLC'|limit=1|data=cname=g.asciipav,cpav=g.pavadinimas,ascpav=g.asciiname,clat=g.latitude,clong=g.longitude}}"..
                        "{{"..subst.."#for_external_table:{{{cname}}};{{{cpav}}};{{{ascpav}}};{{{clat}}};{{{clong}}};}}{{"..subst.."#clear_external_data:}}") or ''
                    --popp = popp .. ' Atstumas.'..ccode..';'..sosta
                    if sosta ~= '' then
                        local sostal = mw.text.split(sosta, ';')
                        local sostt = ''
                        if sostal[2]~='' then
                            local sostkilm = Parm._get{ page = sostal[2], parm = 'kilm', namespace = 0, subst=subst } or ''
                            if sostkilm~='' then
                                sostt = '[['..sostal[2]..'|'..sostkilm..']]'
                            else
                                sostt = '([['..sostal[2]..']])'
                            end
                        else
                            sostt = '([['..sostal[1]..'|'..sostal[3]..']])'
                        end
                        if sostal[4]~='' and sostal[5]~='' then
                            local klat = tonumber( latitude )-tonumber( sostal[4] )
                            local klong = tonumber( longitude )-tonumber( sostal[5] )
                            local kt = 'į ' --('..tostring( klat )..';'..tostring( klong )..') '
                            if klat>=0 and klong>0 and klong>klat*2 then
                                kt = kt..'rytus'
                            elseif klat>0 and klong>=0 and klat>klong*2 then
                                kt = kt..'šiaurę'
                            elseif klat>0 and klong>0 then
                                kt = kt..'šiaurės rytus'
                            elseif klat>=0 and klong<0 and (-klong)>klat*2 then
                                kt = kt..'vakarus'
                            elseif klat>0 and klong<0 and klat>(-klong)*2 then
                                kt = kt..'šiaurę'
                            elseif klat>0 and klong<0 then
                                kt = kt..'šiaurės vakarus'
                            elseif klat<0 and klong>0 and klong>(-klat)*2 then
                                kt = kt..'rytus'
                            elseif klat<0 and klong>=0 and (-klat)>klong*2 then
                                kt = kt..'pietus'
                            elseif klat<0 and klong>0 then
                                kt = kt..'pietryčius'
                            elseif klat<0 and klong<0 and (-klong)>(-klat)*2 then
                                kt = kt..'vakarus'
                            elseif klat<0 and klong<0 and (-klat)>(-klong)*2 then
                                kt = kt..'pietus'
                            elseif klat<0 and klong<0 then
                                kt = kt..'pietvakarius'
                            else
                                kt = kt..'(kryptimi '..tostring( klat )..';'..tostring( klong )..') '
                            end
                            local atstu = frame:preprocess("{{#geodistance:"..latitude..", "..longitude.."|"..sostal[4]..", "..sostal[5].."|unit=km|decimals=2}}")
                            popp = popp .. ' '..fcode3..' yra '..atstu..' atstumu '..kt..' nuo šalies sostinės '..sostt..'.'
                        end
                    end
                end
                if adm1c ~= '' and ccode ~= '' and fcodec~='PPLC' and fcodec~='PPLA' then
                    local adm1t = ''
                    if adm1nkilm~='' then
                        adm1t = '[['..adm1n..'|'..adm1nkilm..']]'
                    else
                        adm1t = '([['..adm1n..']])' 
                    end
                    local sosta = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ geonames g |where=g.countrycode='"..ccode..
                        "' and g.admv1='"..adm1c.."' and g.featurecode='PPLA'|limit=1|data=cname=g.asciipav,cpav=g.pavadinimas,ascpav=g.asciiname,clat=g.latitude,clong=g.longitude}}"..
                        "{{"..subst.."#for_external_table:{{{cname}}};{{{cpav}}};{{{ascpav}}};{{{clat}}};{{{clong}}};}}{{"..subst.."#clear_external_data:}}") or ''
                    --popp = popp .. ' Atstumas.'..ccode..';'..sosta
                    if sosta ~= '' then
                        local sostal = mw.text.split(sosta, ';')
                        local sostt = ''
                        if sostal[2]~='' then
                            local sostkilm = Parm._get{ page = sostal[2], parm = 'kilm', namespace = 0, subst=subst } or ''
                            if sostkilm~='' then
                                sostt = '[['..sostal[2]..'|'..sostkilm..']]'
                            else
                                sostt = '([['..sostal[2]..']])'
                            end
                        else
                            sostt = '([['..sostal[1]..'|'..sostal[3]..']])'
                        end
                        if sostal[4]~='' and sostal[5]~='' then
                            local klat = tonumber( latitude )-tonumber( sostal[4] )
                            local klong = tonumber( longitude )-tonumber( sostal[5] )
                            local kt = 'į ' --('..tostring( klat )..';'..tostring( klong )..') '
                            if klat>=0 and klong>0 and klong>klat*2 then
                                kt = kt..'rytus'
                            elseif klat>0 and klong>=0 and klat>klong*2 then
                                kt = kt..'šiaurę'
                            elseif klat>0 and klong>0 then
                                kt = kt..'šiaurės rytus'
                            elseif klat>=0 and klong<0 and (-klong)>klat*2 then
                                kt = kt..'vakarus'
                            elseif klat>0 and klong<0 and klat>(-klong)*2 then
                                kt = kt..'šiaurę'
                            elseif klat>0 and klong<0 then
                                kt = kt..'šiaurės vakarus'
                            elseif klat<0 and klong>0 and klong>(-klat)*2 then
                                kt = kt..'rytus'
                            elseif klat<0 and klong>=0 and (-klat)>klong*2 then
                                kt = kt..'pietus'
                            elseif klat<0 and klong>0 then
                                kt = kt..'pietryčius'
                            elseif klat<0 and klong<0 and (-klong)>(-klat)*2 then
                                kt = kt..'vakarus'
                            elseif klat<0 and klong<0 and (-klat)>(-klong)*2 then
                                kt = kt..'pietus'
                            elseif klat<0 and klong<0 then
                                kt = kt..'pietvakarius'
                            else
                                kt = kt..'(kryptimi '..tostring( klat )..';'..tostring( klong )..') '
                            end
                            local atstu = frame:preprocess("{{#geodistance:"..latitude..", "..longitude.."|"..sostal[4]..", "..sostal[5].."|unit=km|decimals=2}}")
                            popp = popp .. ' '..fcode3..' yra '..atstu..' atstumu '..kt..' nuo '..adm1t..' administracinio centro '..sostt..'.'
                        end
                    end
                end
                if elevation~='' then 
                    popp = popp..' '..fcode3..' yra '..elevation..' m. aukštyje virš jūros lygio.' 
                end
                if plot~='' then 
                    popp = popp..' '..fcode3..' užima '..plot..' km² plotą.' 
                end
                local obj = sakilm..' '..fcode2..''
                if adm1n~='' then
                    if adm1nkilm~='' then
                        obj = sakilm..' '..fcode2..' [['..adm1n..'|'..adm1nkilm..']] teritorijoje'
                    else
                        obj = sakilm..' '..fcode2..' [['..adm1n..']] teritorijoje'
                    end
                else
                    obj = sakilm..' '..fcode2
                end
                local obj2 = 'šį geografinį objektą aprašanti straipsnį, nukreipiamąjį arba nuorodinį straipsnį.'
                local obj3 = 'šiam geografiniam objektui'
                local obj4 = 'nukreipiamąjį ar nuorodinį straipsnį į ją.'
                if #elems > 2 then
                    obj = 'geografiniai objektai, jų sinonimai arba pavadinimai'
                    obj2 = 'šiuos geografinius objektus aprašanti nuorodinį straipsnį.'
                    obj3 = 'šiems geografiniams objektams'
                    obj4 = 'nuorodinį straipsnį į jas.'
                end
                local kurt = 'Galite sukurti ' .. obj2
                if ns == 800 then
                    kurt = 'Galite sukurti '..obj3..' skirtą sritį arba '..obj4
                elseif ns == 802 then
                    kurt = 'Galite sukurti '..obj3..' skirtą naujieną arba '..obj4
                elseif ns == 804 then
                    kurt = 'Galite sukurti '..obj3..' skirtą citatą arba '..obj4
                end
                if pgid ~= 0 then
                    kurt = ''
                end
                if population~='' and population~='0' then
                     popp = popp .. ' Gyventojų skaičius [['..mdate..']] m. - '..population..'.'
                end
                if #elems > 2 or kiek>1 then
                    xtbl
                        .newline()
                        .newline()
                        .wikitext( "'''",pgname,"''' – ",obj,", kuria nors kalba." )
                        .newline()
                        .newline()
                        .wikitext( frame:preprocess('{{header\n|title='..pgname..'\n|author=\n|override_author=\n|translator=\n|section=Galimų reikšmių sąrašas pagal geonames\n|previous='..prevpg..'\n|next='..nextpg..
                            '\n|year=\n|wikipedia=\n|notes=Viso puslapių: '..kiekpgt..'\n}}') )
                        .newline()
                        .wikitext( frame:preprocess('{| {{Graži lentelė}}\n') )
                        .wikitext( '|-\n' )
                        .wikitext( '! Kalbose\n' )
                        .wikitext( '! GeoName ID\n' )
                        .wikitext( '! Geonames pavadinimas\n' )
                        .wikitext( '! Pavadinimas\n' )
                        .wikitext( '! Ascii pavadinimas\n' )
                        .wikitext( '! Sinonimai\n' )
                        .wikitext( '! Latitude\n' )
                        .wikitext( '! Longitude\n' )
                        .wikitext( '! Tipo klasė\n' )
                        .wikitext( '! Tipas\n' )
                        .wikitext( '! \n' )
                        .wikitext( '! Šalis\n' )
                        .wikitext( '! Gyventojai\n' )
                        .wikitext( '! Aukštingumas\n' )
                        --.wikitext( '! Plotas\n' )
                        .wikitext( '! ADMV1\n' )
                        .wikitext( '! Kalbomi\n' )
                        .wikitext( '! Administraciniai vienetai\n' )
                        .wikitext( '|-\n' )
                        .wikitext(tostring(xktbl))
                        .wikitext( '|}\n' )
                        .newline()
                        .newline()
                        --.wikitext( '== Perspėjimas ==' )
                        --.newline()
                        --.wikitext( kurt )
                        --.newline()
                        --.newline()
                        --.wikitext( 'Šiame puslapyje pateikiama GeoNames skelbiama informacija. Už GeoNames skelbiamos informacijos teisingumą Enciklopedija Lietuvai ir pasauliui neatsako.' )
                        --.newline()
                        --.newline()
                        .wikitext( '== Šaltiniai ==' )
                        .newline()
                        .wikitext('* [http://www.geonames.org/ Geografinių duomenų bazė GeoNames]. 2015 m. lapkričio 13 d. duomenys.')
                        .newline()
                        .newline()
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext(frame:preprocess('{{Geonames nuorodinis}}'))
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                else
                    xtbl
                        .newline()
                        .newline()
                        .wikitext(frame:preprocess('{{TOCright\n|clear=none\n}}'))
                        .newline()
                        .newline()
                        .wikitext( "'''",pgname,"''' – ",obj,".",popp )
                        .newline()
                        .wikitext( '== Lokalizacija ==' )
                        .newline()
                        .newline()
                        .wikitext( '{| width=1250' )
                        .newline()
                        .wikitext( '|- width=1250' )
                        .newline()
                        .wikitext( '| width=1250 |' )
                        .newline()
                        .newline()
                        .wikitext( gzemel2 )
                        .newline()
                        .wikitext( '|}' )
                        .newline()
                        .newline()
                        --.wikitext( '== Perspėjimas ==' )
                        --.newline()
                        --.newline()
                        --.wikitext( kurt )
                        --.newline()
                        --.newline()
                        --.wikitext( 'Šiame puslapyje pateikiama GeoNames skelbiama informacija. Už GeoNames skelbiamos informacijos teisingumą Enciklopedija Lietuvai ir pasauliui neatsako.' )
                        --.newline()
                        --.newline()
                        .wikitext( '== Šaltiniai ==' )
                        .newline()
                        .newline()
                        .wikitext('* [http://www.geonames.org/ Geografinių duomenų bazė GeoNames]. 2015 m. lapkričio 13 d. duomenys.')
                        .newline()
                        .newline()
                        .wikitext('[[Kategorija:',country2,'/geoname]]')
                        .newline()
                        .wikitext('[[Kategorija:',country2,'/',fcode2,']]')
                    if adm1n ~= '' then
                      xtbl
                        .newline()
                        .wikitext('[[Kategorija:',adm1n,'/geoname]]')
                        .newline()
                        .wikitext('[[Kategorija:',adm1n,'/',fcode2,']]')
                    end
                    xtbl
                        .newline()
                        .newline()
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                end
            end
        end
    end
    if ret then
        return tostring(xtbl)
    else
        return ''
    end
end

geovalst.mdaktaras = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local xktbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local ret = false
    local ns = pg.namespace
    if ns == 804 or ns == 0 then
        local ns = pg.namespace
        local pgname = pg.text
        local laname = mw.ustring.gsub(pgname, "'", "''")
        local lask = mw.ustring.find(laname, " %(")
        if lask ~= nil then
            laname = mw.ustring.sub(laname, 1, lask)
        end
        local sar = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ moksludaktarai t |where=t.asmuo='"..laname..
            "'|order by=t.metai asc|data=mdaktid=t.ID}}"..
            "{{"..subst.."#for_external_table:{{{mdaktid}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if sar ~= '' and sar ~= '~' then
            ret = true
            local elems = mw.text.split(sar, '~')
            
            for i, klstel in ipairs(elems) do
                if klstel ~= '' then
                    local pasmuo, pavard = '', ' '
                    local antras = ''
                    local veikla = ''
                    local pid = ''
                    local pvadovai = HtmlBuilder.create()
                    local ptarybos = HtmlBuilder.create()
                    local poponentai = HtmlBuilder.create()
                    local plaips = ''
                    local ptit = ''
                    local pmetai = ''
                    local pkryptis = ''
                    local pistaiga = ''
                    local pdisertacija = ''
                    local pdiser = ''
                    local pvadovas = ''
                    local pgynimotaryba = ''
                    local poponentas = ''
                    local panotacija = ''
                    local kist = 0
                    local kvad = 0
                    local ktar = 0
                    local kopo = 0
                    local kkrypkil = ''
                    local ksarp3 = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ moksludaktarai t |where=t.ID="..klstel..
                        "|order by=t.ID|data=asmuo=t.asmuo,laips=t.laipsnis,tit=t.titulas,metai=t.metai,kryptis=t.kryptis,istaiga=t.istaiga,disertacija=t.disertacija,vadovas=t.vadovas,gynimotaryba=t.gynimotaryba,oponentas=t.oponentas,id=t.ID,anotacija=t.anotacija}}"..
                        "{{"..subst.."#for_external_table:{{{asmuo}}};{{{laips}}};{{{tit}}};{{{metai}}};{{{kryptis}}};{{{istaiga}}};{{{disertacija}}};{{{vadovas}}};{{{gynimotaryba}}};{{{oponentas}}};{{{id}}};{{{anotacija}}}}}{{"..subst.."#clear_external_data:}}") or ''
                    if ksarp3 ~= '' and ksarp3 ~= ';;;;;;' then
                        local klstp3 = mw.text.split(ksarp3, ';')
                        if klstp3[1] ~= '' then 
                            kkrypkil = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ mokslukryptis t |where=t.kryptis='"..klstp3[5]..
                                "'|data=kil=t.kilmininkas}}{{"..subst.."#for_external_table:{{{kil}}}}}{{"..subst.."#clear_external_data:}}") or ''
                            --if true then return klstp3[1]..kkrypkil end
                            pasmuo = '[[' .. klstp3[1] .. ']]'
                            local pavelems = mw.text.split(klstp3[1], ' ')
                            if #pavelems == 4 then
                                pavard = pavelems[4]
                            elseif #pavelems == 3 then
                                pavard = pavelems[3]
                            elseif #pavelems == 2 then
                                pavard = pavelems[2]
                            end
                            antras = "'''[[" .. klstp3[1] .. "]]''' – [[Lietuva|Lietuvos]] respublikos [[" .. klstp3[5] .. "|" .. kkrypkil .. "]] mokslų " .. klstp3[2] .. "."
                            veikla = "[[Lietuva|Lietuvos]] respublikos [[" .. klstp3[5] .. "|" .. kkrypkil .. "]] mokslų " .. klstp3[2]
                            plaips = '[[' .. klstp3[3] .. ']]'
                            panotacija = klstp3[12]
                            ptit = '[[' .. klstp3[2] .. ']]'
                            pmetai = Datos._gime{ gime=klstp3[4] }
                            pkryptis = '[[' .. klstp3[5] .. ']]'
                            if klstp3[6] ~= '' then
                                local klstp4 = mw.text.split(klstp3[6], ',')
                                kist = #klstp4
                                for j, klstel4 in ipairs(klstp4) do
                                    if j > 1 then pistaiga = pistaiga .. ', ' end
                                    pistaiga = pistaiga .. '[[' .. klstel4 .. ']]'
                                end
                            end
                            if klstp3[8] ~= '' then
                                local klstp8 = mw.text.split(klstp3[8], ',')
                                kvad = #klstp8
                                for j, klstel8 in ipairs(klstp8) do
                                    if j > 1 then pvadovas = pvadovas .. ', ' end
                                    pvadovas = pvadovas .. '[[' .. klstel8 .. ']]'
                                end
                            end
                            if klstp3[9] ~= '' then
                                local klstp9 = mw.text.split(klstp3[9], ',')
                                ktar = #klstp9
                                for j, klstel9 in ipairs(klstp9) do
                                    if j > 1 then pgynimotaryba = pgynimotaryba .. ', ' end
                                    pgynimotaryba = pgynimotaryba .. '[[' .. klstel9 .. ']]'
                                end
                            end
                            if klstp3[10] ~= '' then
                                local klstp10 = mw.text.split(klstp3[10], ',')
                                kopo = #klstp10
                                for j, klstel10 in ipairs(klstp10) do
                                    if j > 1 then poponentas = poponentas .. ', ' end
                                    poponentas = poponentas .. '[[' .. klstel10 .. ']]'
                                end
                            end
                            if klstp3[1] ~= '' then
                                local kvadov = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ moksludaktaro_vadovas tt "..
                                    "left join ggetree.moksludaktarai t on t.ID=tt.ID|where=tt.vadovas='"..klstp3[1]..
                                    "'|order by=t.metai|data=asmuo=t.asmuo,laips=t.laipsnis,tit=t.titulas,metai=t.metai,kryptis=t.kryptis,istaiga=t.istaiga,disertacija=t.disertacija,vadovas=t.vadovas,gynimotaryba=t.gynimotaryba,oponentas=t.oponentas,id=t.ID}}"..
                                    "{{"..subst.."#for_external_table:{{{asmuo}}};{{{laips}}};{{{tit}}};{{{metai}}};{{{kryptis}}};{{{istaiga}}};{{{disertacija}}};{{{vadovas}}};{{{gynimotaryba}}};{{{oponentas}}};{{{id}}}~}}{{"..subst.."#clear_external_data:}}") or ''
                                local kvadovl = mw.text.split(kvadov, '~')
                                local kvadovlkopo = #kvadovl
                                if kvadovlkopo > 1 then
                                    for j, kvadove in ipairs(kvadovl) do
                                        if kvadove ~= '' then
                                            local kvadovle = mw.text.split(kvadove, ';')
                                            kkrypkilvadovle = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ mokslukryptis t |where=t.kryptis='"..kvadovle[5]..
                                                "'|data=kil=t.kilmininkas}}{{"..subst.."#for_external_table:{{{kil}}}}}{{"..subst.."#clear_external_data:}}") or ''
                                            local laipkilmvadovle = 'daktaro'
                                            if kvadovle[3] == 'habilituotas daktaras' then
                                                laipkilmvadovle = 'habilituoto daktaro'
                                            end
                                            if j == 1 then 
                                                pvadovai
                                                    .newline()
                                                    .newline()
                                                    .wikitext( '== Vadovavo disertantams ==' )
                                                    .newline()
                                            end
                                            pvadovai
                                                .wikitext( frame:preprocess('* {{Data|'.. kvadovle[4].. '}}'), ' – [[', kvadovle[1], ']] apgynė [[Lietuva|Lietuvos]] respublikos [[', kvadovle[5], 
                                                        "|" .. kkrypkilvadovle .. "]] mokslų " .. laipkilmvadovle .. ' disertaciją "', kvadovle[7], '".' )
                                                .newline()
                                        end
                                    end
                                end
                            end
                            if klstp3[1] ~= '' then
                                local kvadov = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ moksludaktaro_oponentas tt "..
                                    "left join ggetree.moksludaktarai t on t.ID=tt.ID|where=tt.oponentas='"..klstp3[1]..
                                    "'|order by=t.metai|data=asmuo=t.asmuo,laips=t.laipsnis,tit=t.titulas,metai=t.metai,kryptis=t.kryptis,istaiga=t.istaiga,disertacija=t.disertacija,vadovas=t.vadovas,gynimotaryba=t.gynimotaryba,oponentas=t.oponentas,id=t.ID}}"..
                                    "{{"..subst.."#for_external_table:{{{asmuo}}};{{{laips}}};{{{tit}}};{{{metai}}};{{{kryptis}}};{{{istaiga}}};{{{disertacija}}};{{{vadovas}}};{{{gynimotaryba}}};{{{oponentas}}};{{{id}}}~}}{{"..subst.."#clear_external_data:}}") or ''
                                local kvadovl = mw.text.split(kvadov, '~')
                                local kvadovlkopo = #kvadovl
                                if kvadovlkopo > 1 then
                                    for j, kvadove in ipairs(kvadovl) do
                                        if kvadove ~= '' then
                                            local kvadovle = mw.text.split(kvadove, ';')
                                            kkrypkilvadovle = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ mokslukryptis t |where=t.kryptis='"..kvadovle[5]..
                                                "'|data=kil=t.kilmininkas}}{{"..subst.."#for_external_table:{{{kil}}}}}{{"..subst.."#clear_external_data:}}") or ''
                                            local laipkilmvadovle = 'daktaro'
                                            if kvadovle[3] == 'habilituotas daktaras' then
                                                laipkilmvadovle = 'habilituoto daktaro'
                                            end
                                            if j == 1 then 
                                                poponentai
                                                    .newline()
                                                    .newline()
                                                    .wikitext( '== Oponavo disertantams ==' )
                                                    .newline()
                                            end
                                            poponentai
                                                .wikitext( frame:preprocess('* {{Data|'.. kvadovle[4].. '}}'), ' – [[', kvadovle[1], ']] apgynė [[Lietuva|Lietuvos]] respublikos [[', kvadovle[5], 
                                                        "|" .. kkrypkilvadovle .. "]] mokslų " .. laipkilmvadovle .. ' disertaciją "', kvadovle[7], '".' )
                                                .newline()
                                        end
                                    end
                                end
                            end
                            if klstp3[1] ~= '' then
                                local kvadov = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ moksludaktaro_gynimotaryba tt "..
                                    "left join ggetree.moksludaktarai t on t.ID=tt.ID|where=tt.gynimotaryba='"..klstp3[1]..
                                    "'|order by=t.metai|data=asmuo=t.asmuo,laips=t.laipsnis,tit=t.titulas,metai=t.metai,kryptis=t.kryptis,istaiga=t.istaiga,disertacija=t.disertacija,vadovas=t.vadovas,gynimotaryba=t.gynimotaryba,oponentas=t.oponentas,id=t.ID}}"..
                                    "{{"..subst.."#for_external_table:{{{asmuo}}};{{{laips}}};{{{tit}}};{{{metai}}};{{{kryptis}}};{{{istaiga}}};{{{disertacija}}};{{{vadovas}}};{{{gynimotaryba}}};{{{oponentas}}};{{{id}}}~}}{{"..subst.."#clear_external_data:}}") or ''
                                local kvadovl = mw.text.split(kvadov, '~')
                                local kvadovlkopo = #kvadovl
                                if kvadovlkopo > 1 then
                                    for j, kvadove in ipairs(kvadovl) do
                                        if kvadove ~= '' then
                                            local kvadovle = mw.text.split(kvadove, ';')
                                            kkrypkilvadovle = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..laname.." */ mokslukryptis t |where=t.kryptis='"..kvadovle[5]..
                                                "'|data=kil=t.kilmininkas}}{{"..subst.."#for_external_table:{{{kil}}}}}{{"..subst.."#clear_external_data:}}") or ''
                                            local laipkilmvadovle = 'daktaro'
                                            if kvadovle[3] == 'habilituotas daktaras' then
                                                laipkilmvadovle = 'habilituoto daktaro'
                                            end
                                            if j == 1 then 
                                                ptarybos
                                                    .newline()
                                                    .newline()
                                                    .wikitext( '== Dalyvavo gynimo taryboje ==' )
                                                    .newline()
                                            end
                                            ptarybos
                                                .wikitext( frame:preprocess('* {{Data|'.. kvadovle[4].. '}}'), ' – [[', kvadovle[1], ']] apgynė [[Lietuva|Lietuvos]] respublikos [[', kvadovle[5], 
                                                        "|" .. kkrypkilvadovle .. "]] mokslų " .. laipkilmvadovle .. ' disertaciją "', kvadovle[7], '".' )
                                                .newline()
                                        end
                                    end
                                end
                            end
                            local laipkilm = 'daktaro'
                            if klstp3[3] == 'habilituotas daktaras' then
                                laipkilm = 'habilituoto daktaro'
                            end
                            pdisertacija = klstp3[7]
                            if pdisertacija ~= '' then
                                pdiser = pmetai .. ' apgynė [[Lietuva|Lietuvos]] respublikos [[' .. klstp3[5] .. "|" .. kkrypkil .. "]] mokslų " .. laipkilm .. ' disertaciją „' .. pdisertacija .. '“. '
                            else
                                pdiser = pmetai .. ' apgynė [[Lietuva|Lietuvos]] respublikos [[' .. klstp3[5] .. "|" .. kkrypkil .. "]] mokslų " .. laipkilm .. ' disertaciją. '
                            end
                            if pistaiga ~= '' then
                                if kist == 1 then
                                    pdiser = pdiser .. 'Disertaciją apgynė mokslų įstaigoje: ' .. pistaiga .. '.'
                                else
                                    pdiser = pdiser .. 'Disertaciją apgynė mokslų įstaigose: ' .. pistaiga .. '.'
                                end
                            end
                            if pvadovas ~= '' then
                                if kvad == 1 then
                                    pdiser = pdiser .. ' Mokslinis vadovas: ' .. pvadovas .. '.'
                                else
                                    pdiser = pdiser .. ' Moksliniai vadovai: ' .. pvadovas .. '.'
                                end
                            end
                            if pgynimotaryba ~= '' then
                                if ktar == 1 then
                                    pdiser = pdiser .. ' Disertacijos gynimo tarybą sudarė: ' .. pgynimotaryba .. '.'
                                else
                                    pdiser = pdiser .. ' Disertacijos gynimo tarybą sudarė: ' .. pgynimotaryba .. '.'
                                end
                            end
                            if poponentas ~= '' then
                                if kopo == 1 then
                                    pdiser = pdiser .. ' Disertacijos gynimo oponentais buvo: ' .. poponentas .. '.'
                                else
                                    pdiser = pdiser .. ' Disertacijos gynimo oponentais buvo: ' .. poponentas .. '.'
                                end
                            end
                        end
                    end
                    local biogr = frame:preprocess( '{{Žmogaus biografija\n|fonas=off\n|veikla=' .. veikla .. '\n}}\n{{TOCright\n|clear=none\n}}' )
                    xktbl
                        .wikitext(biogr)
                        .newline()
                        .newline()
                        .wikitext( antras )
                        .newline()
                        .newline()
                        .wikitext( '== Biografija ==' )
                        .newline()
                        .newline()
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext( '== Disertacija ==' )
                        .newline()
                        .wikitext('{| cellpadding=2 width=450px style="margin-bottom: 0.5em; margin-left: 1em; background: #f9f9f9; float: right; border: 1px #e0efef solid; font-size: 95%;"\n')
                        .wikitext('|-\n')
                        .wikitext('! colspan=2 | ',pasmuo,'\n')
                        .wikitext('|-\n')
                        .wikitext('! width=150px | Titulas\n')
                        .wikitext('| ',ptit,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Disertacijos laipsnis\n')
                        .wikitext('| ',plaips,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Disertacijos metai\n')
                        .wikitext('| ',pmetai,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Mokslų kryptis\n')
                        .wikitext('| ',pkryptis,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Įstaiga\n')
                        .wikitext('| ',pistaiga,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Disertacija\n')
                        .wikitext('| ',pdisertacija,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Vadovas\n')
                        .wikitext('| ',pvadovas,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Gynimo taryba\n')
                        .wikitext('| ',pgynimotaryba,'\n')
                        .wikitext('|-\n')
                        .wikitext('! Disertacijos oponentai\n')
                        .wikitext('| ',poponentas,'\n')
                        .wikitext('|}\n')
                        .newline()
                        .wikitext( pdiser )
                        .newline()
                        .newline()
                        .wikitext( panotacija )
                        .wikitext( tostring(pvadovai) )
                        .wikitext( tostring(poponentai) )
                        .wikitext( tostring(ptarybos) )
                        .newline()
                        .newline()
                        .wikitext( '== Šaltiniai ==' )
                        .newline()
                        .wikitext('* [http://mokslas.lmt.lt/22/apie2.php Lietuvos mokslininkai].')
                        .newline()
                        .wikitext('* [http://www.lmt.lt/lt/paslaugos/disertacijos/d-db.html Lietuvos disertacijų gynimo duomenų bazė].')
                        .newline()
                        .newline()
                        .wikitext('[[Kategorija:Lietuvos ' .. kkrypkil .. ' mokslų daktarai|' .. pavard .. ']]')
                        .newline()
                        .newline()
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                            
                end
            end
        end
    end
    if ret then
        return tostring(xktbl)
    else
        return ''
    end
end

geovalst.gbif = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local xktbl = HtmlBuilder.create()
    local xktblis = false
    local ret = false
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    if ns == 804 or ns == 0 then
        local nstext = pg.nsText
        local pgname = pg.text
        local laname = pg.text
        local prm = Parm._get{ page = pgname, parm = 'la', subst=subst } or ''
        local sar = ''
        local refs = HtmlBuilder.create('ul')
        if prm ~= '' then
            laname = prm
        end
        laname2 = mw.ustring.gsub(laname, "'", "''")
        laname2 = mw.ustring.gsub(laname2, " %(reikšmės%)", "")
        laname = mw.ustring.gsub(laname, " %(reikšmės%)", "")
        local kurt = 'Galite sukurti šį taksoną aprašanti straipsnį, nukreipiamąjį arba nuorodinį straipsnį.'
        if ns == 800 then
            kurt = 'Galite sukurti šiam taksonui skirtą sritį arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        elseif ns == 802 then
            kurt = 'Galite sukurti šiam taksonui skirtą naujieną arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        elseif ns == 804 then
            kurt = 'Galite sukurti šiam taksonui skirtą citatą arba nukreipiamąjį ar nuorodinį straipsnį į ją.'
        end
        local uriname = mw.uri.encode( laname, "QUERY" )
        local wikiname = mw.uri.encode( laname, "WIKI" )
        sar = frame:preprocess("{{"..subst.."#get_db_data:|db=col2013ac|from=/* "..laname2.." */ _taxon_tree_join t |where=t.name='"..laname2..
            "' or t.altname='"..laname2..
            "'|order by=t.key asc|data=king=t.kingdom,phyl=t.phylum,clas=t.class,ord=t.order,fam=t.family,gen=t.genus,spec=t.species,aut=t.authors,met=t.year,key=t.key,rank=t.rank,auts=t.authorship,gbif=t.gbif_id,col=t.col_id}}"..
            "{{"..subst.."#for_external_table:{{{king}}};{{{phyl}}};{{{clas}}};{{{ord}}};{{{fam}}};{{{gen}}};{{{spec}}};{{{aut}}};{{{met}}};{{{key}}};{{{rank}}};{{{auts}}};{{{gbif}}};{{{col}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if sar ~= '' and sar ~= '~' then
            local sart = mw.text.split(sar, '~')
            if #sart > 1 then
                for i, sarc in ipairs(sart) do
                    if sarc ~= '' then
                        local sare = mw.text.split(sarc, ';')
                        local king,kinglt,kingkat = '','',''
                        local phyl,phyllt,phylkat = '','',''
                        local clas,claslt,claskat = '','',''
                        local ord,ordlt,ordkat = '','',''
                        local fam,famlt,famkat = '','',''
                        local gen,genlt,genkat = '','',''
                        local spec,speclt = '',''
                        local aut,auts = '',''
                        local met,autmet = '',''
                        local key,vaiz = '',''
                        local gbif,col = '',''
                        local rank,ranklt = '',''
                        vaiz = Parm._get{ page = laname, parm = 'vaizdas', subst=subst } or ''
                        if vaiz ~= '' then
                            vaiz = '[[Vaizdas:' .. vaiz .. '|350px]]'
                        end
                        if sare[11] ~= '' then
                            rank = sare[11]
                        end
                        if sare[12] ~= '' then
                            auts = Komentaras._kom(sare[12], 'Lotyniško pavadinimo autorius iš GBIF.')
                        end
                        if sare[1] ~= '' then
                            kinglt = Parm._get{ page = sare[1], parm = 'lt', subst=subst } or ''
                            if kinglt ~= '' then
                                kingkat = '[[Kategorija:' .. kinglt .. '/ggecitata]]'
                                kinglt = '[[' .. kinglt .. ']]'
                            else
                                kingkat = '[[Kategorija:' .. sare[1] .. '/ggecitata]]'
                            end
                            king = kinglt .. " (''[[" .. sare[1] .. "]]'')"
                            if rank ~= 'karalystė' then
                                kinglt = ' karalystės ' .. king
                            else
                                kinglt = ' karalystė'
                            end
                        end
                        if sare[2] ~= '' then
                            phyllt = Parm._get{ page = sare[2], parm = 'lt', subst=subst } or ''
                            if phyllt ~= '' then
                                phylkat = '[[Kategorija:' .. phyllt .. '/ggecitata]]'
                                phyllt = '[[' .. phyllt .. ']]'
                            else
                                phylkat = '[[Kategorija:' .. sare[2] .. '/ggecitata]]'
                            end
                            phyl = phyllt .. " (''[[" .. sare[2] .. "]]'')"
                            if sare[1] == 'Plantae' or sare[1] == 'Fungi'  then
                                if rank ~= 'tipas' then
                                    phyllt = ' skyriaus ' .. phyl
                                else
                                    phyllt = ' skyrius'
                                end
                            else
                                if rank ~= 'tipas' then
                                    phyllt = ' tipo ' .. phyl
                                else
                                    phyllt = ' tipas'
                                end
                            end
                        end
                        if sare[3] ~= '' then
                            claslt = Parm._get{ page = sare[3], parm = 'lt', subst=subst } or ''
                            if claslt ~= '' then
                                claskat = '[[Kategorija:' .. claslt .. '/ggecitata]]'
                                claslt = '[[' .. claslt .. ']]'
                            else
                                claskat = '[[Kategorija:' .. sare[3] .. '/ggecitata]]'
                            end
                            clas = claslt .. " (''[[" .. sare[3] .. "]]'')"
                            if rank ~= 'klasė' then
                                claslt = ' klasės ' .. clas
                            else
                                claslt = ' klasė'
                            end
                        end
                        if sare[4] ~= '' then
                            ordlt = Parm._get{ page = sare[4], parm = 'lt', subst=subst } or ''
                            if ordlt ~= '' then
                                ordkat = '[[Kategorija:' .. ordlt .. '/ggecitata]]'
                                ordlt = '[[' .. ordlt .. ']]'
                            else
                                ordkat = '[[Kategorija:' .. sare[4] .. '/ggecitata]]'
                            end
                            ord = ordlt .. " (''[[" .. sare[4] .. "]]'')"
                            if sare[1] == 'Plantae' or sare[1] == 'Fungi'  then
                                if rank ~= 'būrys' then
                                    ordlt = ' eilės ' .. ord
                                else
                                    ordlt = ' eilė'
                                end
                            else
                                if rank ~= 'būrys' then
                                    ordlt = ' būrio ' .. ord
                                else
                                    ordlt = ' būrys'
                                end
                            end
                        end
                        if sare[5] ~= '' then
                            famlt = Parm._get{ page = sare[5], parm = 'lt', subst=subst } or ''
                            if famlt ~= '' then
                                famkat = '[[Kategorija:' .. famlt .. '/ggecitata]]'
                                famlt = '[[' .. famlt .. ']]'
                            else
                                famkat = '[[Kategorija:' .. sare[5] .. '/ggecitata]]'
                            end
                            fam = famlt .. " (''[[" .. sare[5] .. "]]'')"
                            if rank ~= 'šeima' then
                                famlt = ' šeimos ' .. fam
                            else
                                famlt = ' šeima'
                            end
                        end
                        if sare[6] ~= '' then
                            genlt = Parm._get{ page = sare[6], parm = 'lt', subst=subst } or ''
                            if genlt ~= '' then
                                genkat = '[[Kategorija:' .. genlt .. '/ggecitata]]'
                                genlt = '[[' .. genlt .. ']]'
                            else
                                genkat = '[[Kategorija:' .. sare[6] .. '/ggecitata]]'
                            end
                            gen = genlt .. " (''[[" .. sare[6] .. "]]'')"
                            if rank ~= 'gentis' then
                                genlt = ' genties ' .. gen
                            else
                                genlt = ' gentis'
                            end
                        end
                        if sare[7] ~= '' then
                            spec = '[[' .. sare[7] .. ']]'
                            speclt = Parm._get{ page = sare[7], parm = 'lt', subst=subst } or ''
                            if speclt ~= '' then
                                speclt = '[[' .. speclt .. ']]'
                            end
                            spec = speclt .. " (''[[" .. sare[7] .. "]]'')"
                            if rank ~= 'rūšis' then
                                speclt = ' rūšies ' .. spec
                                if rank == 'porūšis' then
                                    ranklt = ' porūšis'
                                end
                            else
                                speclt = ' rūšis'
                            end
                        end
                        local tokat = ''
                        if genkat ~= '' then
                            tokat = genkat
                        elseif famkat ~= '' then
                            tokat = famkat
                        elseif ordkat ~= '' then
                            tokat = ordkat
                        elseif claskat ~= '' then
                            tokat = claskat
                        elseif phylkat ~= '' then
                            tokat = phylkat
                        elseif kingkat ~= '' then
                            tokat = kingkat
                        end
                        local apras = 'Ši ' .. (rank or '')
                        if prm ~= '' then
                            apras = apras .. " aprašyta straipsnyje (''[[" .. laname .. "]]'')." .. tokat
                        else
                            apras = apras .. " gali būti aprašyta straipsnyje (''[[" .. laname .. "]]'')." .. tokat
                        end
                        if auts == '' then
                            if sare[8] ~= '' then
                                aut = sare[8]
                            end
                            if sare[9] ~= '' then
                                met = '[[' .. sare[9] .. ']]'
                            end
                            auts = aut .. ', ' .. met
                        end
                        if sare[13] ~= '' and sare[13] ~= '0' then
                            gbif = '[[gbifws:' .. sare[13] .. '|' .. sare[13] .. ']]'
                        end
                        if sare[14] ~= '' and sare[14] ~= '0' then
                            col = '[[col2013id:' .. sare[14] .. '|' .. sare[14] .. ']]'
                        end
                        --local gge = frame:preprocess("{{Naujas/gge}}") or ''
                        if nstext ~= 'Kategorija' and not xktblis then
                            xktblis = true
                            xktbl
                                .tag('h1')
                                    .wikitext( 'GBIF' )
                                    .done()
                                .newline()
                                .tag('center')
                                    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://www.gbif.org/species/search?q='..uriname..'|width=1100|height=900}}'))
                                    .done()
                                .newline()
                                --.tag('h1')
                                --    .wikitext( 'ZipCodeZoo' )
                                --    .done()
                                --.newline()
                                --.tag('center')
                                --    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://zipcodezoo.com/index.php/'..wikiname..'|width=1100|height=900}}'))
                                --    .done()
                                --.newline()
                                .tag('h1')
                                    .wikitext( 'EOL' )
                                    .done()
                                .newline()
                                .tag('center')
                                    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://www.eol.org/search?q='..uriname..'|width=1100|height=900}}'))
                                    .done()
                                .newline()
                                .tag('h1')
                                    .wikitext( 'COL' )
                                    .done()
                                .newline()
                                .tag('center')
                                    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://www.catalogueoflife.org/col/search/all/key/'..uriname..'|width=1100|height=900}}'))
                                    .done()
                                .newline()
                                .tag('h1')
                                    .wikitext( 'Entrez' )
                                    .done()
                                .newline()
                                .tag('center')
                                    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://www.ncbi.nlm.nih.gov/gquery/gquery.fcgi?term='..uriname..'|width=1100|height=900}}'))
                                    .done()
                                .newline()
                                .tag('h1')
                                    .wikitext( 'BHL' )
                                    .done()
                                .newline()
                                .tag('center')
                                    .wikitext(frame:preprocess('{{#widget:Iframe|url=http://www.biodiversitylibrary.org/search?SearchTerm='..uriname..'|width=1100|height=900}}'))
                                    .done()
                                .newline()
                                .wikitext(frame:preprocess('<headertabs />'))
                                .newline()
                        end
                        if sare[13] ~= '' and sare[13] ~= '0' then
                            refs
                                .tag('li')
                                    .wikitext( '[[gbifws:', sare[13], '|', laname, ']]. ',  auts, 
                                        frame:preprocess(' [[gbifwd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). ({{en|Global Biodiversity Information Facility (GBIF)}}).') )
                                    .done()
                        end
                        if sare[14] ~= '' and sare[14] ~= '0' then
                            refs
                                .tag('li')
                                    .wikitext( '[[col2013id:', sare[13], '|', laname, ']]. ',  auts, 
                                        frame:preprocess(' [[col2013s:' .. laname .. '|Gyvybės katalogas: 2013 metų sąrašas]] (COL 2013). ({{en|Catalogue of Life: 2013 Annual Checklist}}).') )
                                    .done()
                        end
                        xtbl
                            .tag('table')
                                .grazilentele()
                                .attr('align', 'right')
                                .attr('width', '400px')
                                .tag('tr')
                                    .tag('th')
                                        .attr('colspan', '2')
                                        .wikitext( '[[', pgname, ']]' )
                                        .done()
                                    .done()
                                .tag('tr')
                                    .tag('th')
                                        .attr('colspan', '2')
                                        .wikitext( vaiz )
                                        .done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Karalystė' ).done()
                                    .tag('td').wikitext( king ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Tipas/Skyrius' ).done()
                                    .tag('td').wikitext( phyl ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Klasė' ).done()
                                    .tag('td').wikitext( clas ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Būrys/Eilė' ).done()
                                    .tag('td').wikitext( ord ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Šeima' ).done()
                                    .tag('td').wikitext( fam ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Gentis' ).done()
                                    .tag('td').wikitext( gen ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Rūšis' ).done()
                                    .tag('td').wikitext( spec ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( 'Autorius' ).done()
                                    .tag('td').wikitext( auts ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( '[[gbifw:', laname, '|GBIF]]' ).done()
                                    .tag('td').wikitext( gbif ).done()
                                    .done()
                                .tag('tr')
                                    .tag('th').attr('width', '150px').wikitext( '[[col2013s:', laname, '|COL 2013]]' ).done()
                                    .tag('td').wikitext( col ).done()
                                    .done()
                                .done()
                            .newline()
                            .wikitext( GrefTit.titla(laname, subst), ' – ', kinglt, phyllt, claslt, ordlt, famlt, genlt, speclt, ranklt, '.' )
                            .newline()
                            .newline()
                            .tag('h2')
                                .wikitext( 'Aprašymas' )
                                .done()
                            .newline()
                            .tag('p')
                                .wikitext( apras )
                                .done()
                            .newline()
                            .tag('h2')
                                .wikitext( 'Perspėjimas' )
                                .done()
                            .newline()
                            .tag('p')
                                .wikitext( kurt )
                                .done()
                            .newline()
                            .tag('p')
                                .wikitext( 'Šiame puslapyje pateikiama GBIF ir arba COL skelbiama informacija. Už GBIF ir arba COL skelbiamos informacijos teisingumą Enciklopedija Lietuvai ir pasauliui neatsako.' )
                                .done()
                            .newline()
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                    end
                end
                refs.done()
                xtbl
                    .tag('div')
                        .attr('style', 'clear:both')
                        .done()
                    .newline()
                    .tag('h2')
                        .wikitext( 'Šaltiniai' )
                        .done()
                    .newline()
                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                    .wikitext( tostring(refs) )
                    .newline()
                    .newline()
                    .wikitext( tostring(xktbl) )
                    .newline()
                    .tag('div')
                        .attr('style', 'clear:both')
                        .done()
                    .newline()
                    .wikitext('----')
                    .newline()
                    .done()
                return tostring(xtbl)
            else
                return ''
            end
        else
            return ''
        end
    else
        return ''
    end
end

geovalst.ggeparents = function ( laname, subst )
    local ret = {}
    local parms = nil
    if subst==nil then subst='' end
    
    repeat
        parms = ParmData._get{ page = laname, parm = {'la', 'type', 'karalystė', 'parent', 'lt' }, template = 'Auto_taxobox', subst=subst }
        if parms ~= nil and parms['type'] ~= '' then
            ret[parms['type']] = parms
        end
    until parms['type'] ~= 'karalystė' or parms['type'] ~= '' or parms ~= nil
    return ret
end

geovalst.ggelist2 = function( frame,subst )
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    local nstext = pg.nsText
    if nstext == 'Sritis' then
        local pgname = pg.text
        local sart = mw.text.split(pgname, '/')
        if #sart == 1 then
            local laname = sart[1]
            --local prm = Parm._get{ page = laname, parm = 'la' } or ''
            local parms = ParmData._get{ page = laname, parm = {'la', 'type', 'karalystė', 'parent' }, template = 'Auto_taxobox', subst=subst }
            if parms ~= nil then
                laname = parms['la']
                local xtbl = HtmlBuilder.create()
             
                if parms['type'] == 'karalystė' then
                    local gge = frame:preprocess("{{GGElist2|rūšis|karalystei}}") or ''
                    xtbl
                        .newline()
                        .wikitext( gge )
                        .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                    return tostring(xtbl)
                elseif parms['type'] == 'skyrius' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                    if kinglt == '' then
                        kinglt = parms['karalystė']
                    end
                    local gge = frame:preprocess("{{GGElist2|rūšis|skyriui|" .. kinglt .. "}}") or ''
                    xtbl
                        .newline()
                        .wikitext( gge )
                        .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                    return tostring(xtbl)
                elseif parms['type'] == 'tipas' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                    if kinglt == '' then
                        kinglt = parms['karalystė']
                    end
                    local gge = frame:preprocess("{{GGElist2|rūšis|tipui|" .. kinglt .. "}}") or ''
                    xtbl
                        .newline()
                        .wikitext( gge )
                        .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                        .tag('div')
                            .attr('style', 'clear:both')
                            .done()
                        .newline()
                        .wikitext('----')
                        .newline()
                        .done()
                    return tostring(xtbl)
                elseif (parms['type'] == 'klasė' or parms['type'] == 'potipis' or parms['type'] == 'infratipas' or parms['type'] == 'antklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    if parms['parent'] ~= nil and parms['parent'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local aparms = geovalst.ggeparents(parms['parent'], subst)

                        local typelt = ''
                        if aparms['tipas'] ~= nil then
                            typelt = aparms['tipas']['lt']
                            if typelt == '' then
                                typelt = aparms['tipas']['la']
                            end
                        elseif aparms['skyrius'] ~= nil then
                            typelt = aparms['skyrius']['lt']
                            if typelt == '' then
                                typelt = aparms['skyrius']['la']
                            end
                        end
                        --local typeparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if typeparms['type'] == 'tipas' or typeparms['type'] == 'skyrius' then
                        --    typelt = typeparms['lt']
                        --    if typelt == '' then
                        --        typelt = typeparms['la']
                        --    end
                        --else
                        --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --    if typeparms['type'] == 'tipas' or typeparms['type'] == 'skyrius' then
                        --        typelt = typeparms['lt']
                        --        if typelt == '' then
                        --            typelt = typeparms['la']
                        --        end
                        --    else
                        --        typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --        if typeparms['type'] == 'tipas' or typeparms['type'] == 'skyrius' then
                        --            typelt = typeparms['lt']
                        --            if typelt == '' then
                        --                typelt = typeparms['la']
                        --            end
                        --        else
                        --            typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --            if typeparms['type'] == 'tipas' or typeparms['type'] == 'skyrius' then
                        --                typelt = typeparms['lt']
                        --                if typelt == '' then
                        --                    typelt = typeparms['la']
                        --                end
                        --            else
                        --                typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --            end
                        --        end
                        --    end
                        --end
                        local kas = 'klasei'
                        if parms['type'] == 'potipis' then kas = 'potypiui' end
                        if parms['type'] == 'infratipas' then kas = 'infratipui' end
                        if parms['type'] == 'antklasis' then kas = 'antklasiui' end
                        local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    else
                        return ''
                    end
                elseif (parms['type'] == 'būrys' or parms['type'] == 'antbūris' or parms['type'] == 'infraklasė' or parms['type'] == 'poklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    if parms['parent'] ~= nil and parms['parent'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local aparms = geovalst.ggeparents(parms['parent'], subst)

                        local typelt = ''
                        if aparms['tipas'] ~= nil then
                            typelt = aparms['tipas']['lt']
                            if typelt == '' then
                                typelt = aparms['tipas']['la']
                            end
                        elseif aparms['skyrius'] ~= nil then
                            typelt = aparms['skyrius']['lt']
                            if typelt == '' then
                                typelt = aparms['skyrius']['la']
                            end
                        end
                        local claslt = ''
                        if aparms['klasė'] ~= nil then
                            claslt = aparms['klasė']['lt']
                            if claslt == '' then
                                claslt = aparms['klasė']['la']
                            end
                        end
                        --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if clasparms['type'] ~= 'klasė' then
                        --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local claslt = clasparms['lt'] or ''
                        --local claspa = clasparms['parent'] or ''
                        --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                        --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local typelt = typeparms['lt'] or ''
                        --if typelt == '' then
                        --    typelt = typeparms['la']
                        --end
                        --if claslt == '' then
                        --    claslt = clasparms['la']
                        --end
                        local kas = 'būriui'
                        if parms['type'] == 'antbūris' then kas = 'antbūriui' end
                        if parms['type'] == 'infraklasė' then kas = 'infraklasei' end
                        if parms['type'] == 'poklasis' then kas = 'poklasiui' end
                        local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    else
                        return ''
                    end
                elseif parms['type'] == 'eilė' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    if parms['parent'] ~= nil and parms['parent'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local aparms = geovalst.ggeparents(parms['parent'], subst)

                        local typelt = ''
                        if aparms['tipas'] ~= nil then
                            typelt = aparms['tipas']['lt']
                            if typelt == '' then
                                typelt = aparms['tipas']['la']
                            end
                        elseif aparms['skyrius'] ~= nil then
                            typelt = aparms['skyrius']['lt']
                            if typelt == '' then
                                typelt = aparms['skyrius']['la']
                            end
                        end
                        local claslt = ''
                        if aparms['klasė'] ~= nil then
                            claslt = aparms['klasė']['lt']
                            if claslt == '' then
                                claslt = aparms['klasė']['la']
                            end
                        end
                        --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if clasparms['type'] ~= 'klasė' then
                        --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local claslt = clasparms['lt'] or ''
                        --local claspa = clasparms['parent'] or ''
                        --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                        --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local typelt = typeparms['lt'] or ''
                        --if typelt == '' then
                        --    typelt = typeparms['la']
                        --end
                        --if claslt == '' then
                        --    claslt = clasparms['la']
                        --end
                        local kas = 'eilei'
                        local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    else
                        return ''
                    end
                elseif (parms['type'] == 'šeima' or parms['type'] == 'antšeimis' or parms['type'] == 'infrabūrys' or parms['type'] == 'pobūris') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    if parms['parent'] ~= nil and parms['parent'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local aparms = geovalst.ggeparents(parms['parent'], subst)

                        local typelt = ''
                        if aparms['tipas'] ~= nil then
                            typelt = aparms['tipas']['lt']
                            if typelt == '' then
                                typelt = aparms['tipas']['la']
                            end
                        elseif aparms['skyrius'] ~= nil then
                            typelt = aparms['skyrius']['lt']
                            if typelt == '' then
                                typelt = aparms['skyrius']['la']
                            end
                        end
                        local claslt = ''
                        if aparms['klasė'] ~= nil then
                            claslt = aparms['klasė']['lt']
                            if claslt == '' then
                                claslt = aparms['klasė']['la']
                            end
                        end
                        local ordlt = ''
                        if aparms['būrys'] ~= nil then
                            ordlt = aparms['būrys']['lt']
                            if ordlt == '' then
                                ordlt = aparms['būrys']['la']
                            end
                        elseif aparms['eilė'] ~= nil then
                            ordlt = aparms['eilė']['lt']
                            if ordlt == '' then
                                ordlt = aparms['eilė']['la']
                            end
                        end
                        --local ordparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                        --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local ordlt = ordparms['lt'] or ''
                        --local ordpa = ordparms['parent'] or ''
                        --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if clasparms['type'] ~= 'klasė' and clasparms['type'] ~= 'tipas' and clasparms['type'] ~= 'skyrius' then
                        --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local claslt = ''
                        --local claspa = ''
                        --if clasparms['type'] == 'klasė' then
                        --    claslt = clasparms['lt'] or ''
                        --    claspa = clasparms['parent'] or ''
                        --end
                        --local typeparms = {}
                        --if clasparms['type'] ~= 'tipas' and clasparms['type'] ~= 'skyrius' then
                        --    typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --    if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                        --        typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --    end
                        --else
                        --    typeparms = clasparms
                        --end
                        --local typelt = typeparms['lt'] or ''
                        --if typelt == '' then
                        --    typelt = typeparms['la']
                        --end
                        --if claslt == '' then
                        --    claslt = clasparms['la']
                        --end
                        --if ordlt == '' then
                        --    ordlt = ordparms['la']
                        --end
                        local kas = 'šeimai'
                        if parms['type'] == 'antšeimis' then kas = 'antšeimiui' end
                        if parms['type'] == 'infrabūrys' then kas = 'infrabūriui' end
                        if parms['type'] == 'pobūris' then kas = 'pobūriui' end
                        local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    else
                        return ''
                    end
                elseif (parms['type'] == 'gentis' or parms['type'] == 'pošeimis' or parms['type'] == 'pogentis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                    if parms['parent'] ~= nil and parms['parent'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local aparms = geovalst.ggeparents(parms['parent'], subst)

                        local typelt = ''
                        if aparms['tipas'] ~= nil then
                            typelt = aparms['tipas']['lt']
                            if typelt == '' then
                                typelt = aparms['tipas']['la']
                            end
                        elseif aparms['skyrius'] ~= nil then
                            typelt = aparms['skyrius']['lt']
                            if typelt == '' then
                                typelt = aparms['skyrius']['la']
                            end
                        end
                        local claslt = ''
                        if aparms['klasė'] ~= nil then
                            claslt = aparms['klasė']['lt']
                            if claslt == '' then
                                claslt = aparms['klasė']['la']
                            end
                        end
                        local ordlt = ''
                        if aparms['būrys'] ~= nil then
                            ordlt = aparms['būrys']['lt']
                            if ordlt == '' then
                                ordlt = aparms['būrys']['la']
                            end
                        elseif aparms['eilė'] ~= nil then
                            ordlt = aparms['eilė']['lt']
                            if ordlt == '' then
                                ordlt = aparms['eilė']['la']
                            end
                        end
                        local famlt = ''
                        if aparms['šeima'] ~= nil then
                            famlt = aparms['šeima']['lt']
                            if famlt == '' then
                                famlt = aparms['šeima']['la']
                            end
                        end
                        --if famparms['type'] ~= 'šeima' then
                        --    famparms = ParmData._get{ page = famparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local famlt = famparms['lt'] or ''
                        --local fampa = famparms['parent'] or ''
                        --local ordparms = ParmData._get{ page = fampa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                        --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local ordlt = ordparms['lt'] or ''
                        --local ordpa = ordparms['parent'] or ''
                        --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if clasparms['type'] ~= 'klasė' then
                        --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local claslt = clasparms['lt'] or ''
                        --local claspa = clasparms['parent'] or ''
                        --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                        --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                        --end
                        --local typelt = typeparms['lt'] or ''
                        --if typelt == '' then
                        --    typelt = typeparms['la']
                        --end
                        --if claslt == '' then
                        --    claslt = clasparms['la']
                        --end
                        --if ordlt == '' then
                        --    ordlt = ordparms['la']
                        --end
                        --if famlt == '' then
                        --    famlt = famparms['la']
                        --end
                        local kas = 'genčiai'
                        if parms['type'] == 'pošeimis' then kas = 'pošeimiui' end
                        if parms['type'] == 'pogentis' then kas = 'pogenčiui' end
                        local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. famlt .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    else
                        return ''
                    end
                else
                    return ''
                end
            else
                return ''
            end
        elseif #sart == 2 then
            local listtypes = {
                    ['tipas'] = true,
                    ['skyrius'] = true,
                    ['klasė'] = true,
                    ['būrys'] = true,
                    ['eilė'] = true,
                    ['šeima'] = true,
                    ['gentis'] = true,
                    ['antklasis'] = true,
                    ['pobūris'] = true,
                    ['pošeimis'] = true,
                    ['pogentis'] = true,
                    ['infrabūrys'] = true,
                    ['antšeimis'] = true,
                    ['potipis'] = true,
                    ['antbūris'] = true,
                    ['poklasis'] = true,
                    ['infratipas'] = true,
                    ['infraklasė'] = true,
                }
            local islisttype = listtypes[ sart[2] ]
            local pagenr = tonumber( sart[2] ) or 0
            if islisttype then
                local laname = sart[1]
                --local prm = Parm._get{ page = laname, parm = 'la' } or ''
                local parms = ParmData._get{ page = laname, parm = {'la', 'type', 'karalystė', 'parent' }, template = 'Auto_taxobox', subst=subst }
                if parms ~= nil then
                    laname = parms['la']
                    local xtbl = HtmlBuilder.create()
                 
                    if parms['type'] == 'karalystė' then
                        local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|karalystei}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif parms['type'] == 'skyrius' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|skyriui|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif parms['type'] == 'tipas' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|tipui|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif (parms['type'] == 'klasė' or parms['type'] == 'potipis' or parms['type'] == 'infratipas' or parms['type'] == 'antklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            --local typeparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            local kas = 'klasei'
                            if parms['type'] == 'potipis' then kas = 'potypiui' end
                            if parms['type'] == 'infratipas' then kas = 'infratipui' end
                            if parms['type'] == 'antklasis' then kas = 'antklasiui' end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'būrys' or parms['type'] == 'antbūris' or parms['type'] == 'infraklasė' or parms['type'] == 'poklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            local kas = 'būriui'
                            if parms['type'] == 'antbūris' then kas = 'antbūriui' end
                            if parms['type'] == 'infraklasė' then kas = 'infraklasei' end
                            if parms['type'] == 'poklasis' then kas = 'poklasiui' end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif parms['type'] == 'eilė' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            local kas = 'eilei'
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "||" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'šeima' or parms['type'] == 'antšeimis' or parms['type'] == 'infrabūrys' or parms['type'] == 'pobūris') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            local ordlt = ''
                            if aparms['būrys'] ~= nil then
                                ordlt = aparms['būrys']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['būrys']['la']
                                end
                            elseif aparms['eilė'] ~= nil then
                                ordlt = aparms['eilė']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['eilė']['la']
                                end
                            end
                            --local ordparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                            --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local ordlt = ordparms['lt'] or ''
                            --local ordpa = ordparms['parent'] or ''
                            --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            --if ordlt == '' then
                            --    ordlt = ordparms['la']
                            --end
                            local kas = 'šeimai'
                            if parms['type'] == 'antšeimis' then kas = 'antšeimiui' end
                            if parms['type'] == 'infrabūrys' then kas = 'infrabūriui' end
                            if parms['type'] == 'pobūris' then kas = 'pobūriui' end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'gentis' or parms['type'] == 'pošeimis' or parms['type'] == 'pogentis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            local ordlt = ''
                            if aparms['būrys'] ~= nil then
                                ordlt = aparms['būrys']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['būrys']['la']
                                end
                            elseif aparms['eilė'] ~= nil then
                                ordlt = aparms['eilė']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['eilė']['la']
                                end
                            end
                            local famlt = ''
                            if aparms['šeima'] ~= nil then
                                famlt = aparms['šeima']['lt']
                                if famlt == '' then
                                    famlt = aparms['šeima']['la']
                                end
                            end
                            --local famparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if famparms['type'] ~= 'šeima' then
                            --    famparms = ParmData._get{ page = famparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local famlt = famparms['lt'] or ''
                            --local fampa = famparms['parent'] or ''
                            --local ordparms = ParmData._get{ page = fampa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                            --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local ordlt = ordparms['lt'] or ''
                            --local ordpa = ordparms['parent'] or ''
                            --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            --if ordlt == '' then
                            --    ordlt = ordparms['la']
                            --end
                            --if famlt == '' then
                            --    famlt = famparms['la']
                            --end
                            local kas = 'genčiai'
                            if parms['type'] == 'pošeimis' then kas = 'pošeimiui' end
                            if parms['type'] == 'pogentis' then kas = 'pogenčiui' end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. famlt .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    else
                        return ''
                    end
                else
                    return ''
                end
            elseif pagenr ~= nil and pagenr > 0 then
                local laname = sart[1]
                --local prm = Parm._get{ page = laname, parm = 'la' } or ''
                local parms = ParmData._get{ page = laname, parm = {'la', 'type', 'karalystė', 'parent' }, template = 'Auto_taxobox', subst=subst }
                if parms ~= nil then
                    laname = parms['la']
                    local xtbl = HtmlBuilder.create()
                 
                    if parms['type'] == 'karalystė' then
                        local gge = frame:preprocess("{{GGElist2|rūšis|karalystei}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif parms['type'] == 'skyrius' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local gge = frame:preprocess("{{GGElist2|rūšis|skyriui|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif parms['type'] == 'tipas' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                        if kinglt == '' then
                            kinglt = parms['karalystė']
                        end
                        local gge = frame:preprocess("{{GGElist2|rūšis|tipui|" .. kinglt .. "}}") or ''
                        xtbl
                            .newline()
                            .wikitext( gge )
                            .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                            .tag('div')
                                .attr('style', 'clear:both')
                                .done()
                            .newline()
                            .wikitext('----')
                            .newline()
                            .done()
                        return tostring(xtbl)
                    elseif (parms['type'] == 'klasė' or parms['type'] == 'potipis' or parms['type'] == 'infratipas' or parms['type'] == 'antklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            --local typeparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            local kas = 'klasei'
                            if parms['type'] == 'potipis' then kas = 'potypiui' end
                            if parms['type'] == 'infratipas' then kas = 'infratipui' end
                            if parms['type'] == 'antklasis' then kas = 'antklasiui' end
                            local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'būrys' or parms['type'] == 'antbūris' or parms['type'] == 'infraklasė' or parms['type'] == 'poklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            local kas = 'būriui'
                            if parms['type'] == 'antbūris' then kas = 'antbūriui' end
                            if parms['type'] == 'infraklasė' then kas = 'infraklasei' end
                            if parms['type'] == 'poklasis' then kas = 'poklasiui' end
                            local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif parms['type'] == 'eilė' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            local kas = 'eilei'
                            local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'šeima' or parms['type'] == 'antšeimis' or parms['type'] == 'infrabūrys' or parms['type'] == 'pobūris') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            local ordlt = ''
                            if aparms['būrys'] ~= nil then
                                ordlt = aparms['būrys']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['būrys']['la']
                                end
                            elseif aparms['eilė'] ~= nil then
                                ordlt = aparms['eilė']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['eilė']['la']
                                end
                            end
                            --local ordparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                            --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local ordlt = ordparms['lt'] or ''
                            --local ordpa = ordparms['parent'] or ''
                            --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' and clasparms['type'] ~= 'tipas' and clasparms['type'] ~= 'skyrius' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = ''
                            --local claspa = ''
                            --if clasparms['type'] == 'klasė' then
                            --    claslt = clasparms['lt'] or ''
                            --    claspa = clasparms['parent'] or ''
                            --end
                            --local typeparms = {}
                            --if clasparms['type'] ~= 'tipas' and clasparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --    if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --        typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --    end
                            --else
                            --    typeparms = clasparms
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            --if ordlt == '' then
                            --    ordlt = ordparms['la']
                            --end
                            local kas = 'šeimai'
                            if parms['type'] == 'antšeimis' then kas = 'antšeimiui' end
                            if parms['type'] == 'infrabūrys' then kas = 'infrabūriui' end
                            if parms['type'] == 'pobūris' then kas = 'pobūriui' end
                            local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    elseif (parms['type'] == 'gentis' or parms['type'] == 'pošeimis' or parms['type'] == 'pogentis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                        if parms['parent'] ~= nil and parms['parent'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local aparms = geovalst.ggeparents(parms['parent'], subst)
    
                            local typelt = ''
                            if aparms['tipas'] ~= nil then
                                typelt = aparms['tipas']['lt']
                                if typelt == '' then
                                    typelt = aparms['tipas']['la']
                                end
                            elseif aparms['skyrius'] ~= nil then
                                typelt = aparms['skyrius']['lt']
                                if typelt == '' then
                                    typelt = aparms['skyrius']['la']
                                end
                            end
                            local claslt = ''
                            if aparms['klasė'] ~= nil then
                                claslt = aparms['klasė']['lt']
                                if claslt == '' then
                                    claslt = aparms['klasė']['la']
                                end
                            end
                            local ordlt = ''
                            if aparms['būrys'] ~= nil then
                                ordlt = aparms['būrys']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['būrys']['la']
                                end
                            elseif aparms['eilė'] ~= nil then
                                ordlt = aparms['eilė']['lt']
                                if ordlt == '' then
                                    ordlt = aparms['eilė']['la']
                                end
                            end
                            local famlt = ''
                            if aparms['šeima'] ~= nil then
                                famlt = aparms['šeima']['lt']
                                if famlt == '' then
                                    famlt = aparms['šeima']['la']
                                end
                            end
                            --local famparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if famparms['type'] ~= 'šeima' then
                            --    famparms = ParmData._get{ page = famparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local famlt = famparms['lt'] or ''
                            --local fampa = famparms['parent'] or ''
                            --local ordparms = ParmData._get{ page = fampa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                            --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local ordlt = ordparms['lt'] or ''
                            --local ordpa = ordparms['parent'] or ''
                            --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if clasparms['type'] ~= 'klasė' then
                            --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local claslt = clasparms['lt'] or ''
                            --local claspa = clasparms['parent'] or ''
                            --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                            --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                            --end
                            --local typelt = typeparms['lt'] or ''
                            --if typelt == '' then
                            --    typelt = typeparms['la']
                            --end
                            --if claslt == '' then
                            --    claslt = clasparms['la']
                            --end
                            --if ordlt == '' then
                            --    ordlt = ordparms['la']
                            --end
                            --if famlt == '' then
                            --    famlt = famparms['la']
                            --end
                            local kas = 'genčiai'
                            if parms['type'] == 'pošeimis' then kas = 'pošeimiui' end
                            if parms['type'] == 'pogentis' then kas = 'pogenčiui' end
                            local gge = frame:preprocess("{{GGElist2|rūšis|" .. kas .. "|" .. famlt .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        else
                            return ''
                        end
                    else
                        return ''
                    end
                else
                    return ''
                end
            else
                return ''
            end
        elseif #sart == 3 then
            local listtypes = {
                    ['tipas'] = true,
                    ['skyrius'] = true,
                    ['klasė'] = true,
                    ['būrys'] = true,
                    ['eilė'] = true,
                    ['šeima'] = true,
                    ['gentis'] = true,
                    ['antklasis'] = true,
                    ['pobūris'] = true,
                    ['pošeimis'] = true,
                    ['pogentis'] = true,
                    ['infrabūrys'] = true,
                    ['antšeimis'] = true,
                    ['potipis'] = true,
                    ['antbūris'] = true,
                    ['poklasis'] = true,
                    ['infratipas'] = true,
                    ['infraklasė'] = true,
                }
            local islisttype = listtypes[ sart[2] ]
            local pagenr = tonumber( sart[3] )
            if islisttype then
                if pagenr ~= nil and pagenr > 0 then
                    local laname = sart[1]
                    --local prm = Parm._get{ page = laname, parm = 'la' } or ''
                    local parms = ParmData._get{ page = laname, parm = {'la', 'type', 'karalystė', 'parent' }, template = 'Auto_taxobox', subst=subst }
                    if parms ~= nil then
                        laname = parms['la']
                        local xtbl = HtmlBuilder.create()
                     
                        if parms['type'] == 'karalystė' then
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|karalystei}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        elseif parms['type'] == 'skyrius' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|skyriui|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        elseif parms['type'] == 'tipas' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                            if kinglt == '' then
                                kinglt = parms['karalystė']
                            end
                            local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|tipui|" .. kinglt .. "}}") or ''
                            xtbl
                                .newline()
                                .wikitext( gge )
                                .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                .tag('div')
                                    .attr('style', 'clear:both')
                                    .done()
                                .newline()
                                .wikitext('----')
                                .newline()
                                .done()
                            return tostring(xtbl)
                        elseif (parms['type'] == 'klasė' or parms['type'] == 'potipis' or parms['type'] == 'infratipas' or parms['type'] == 'antklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            if parms['parent'] ~= nil and parms['parent'] ~= '' then
                                local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                                if kinglt == '' then
                                    kinglt = parms['karalystė']
                                end
                                local aparms = geovalst.ggeparents(parms['parent'], subst)
        
                                local typelt = ''
                                if aparms['tipas'] ~= nil then
                                    typelt = aparms['tipas']['lt']
                                    if typelt == '' then
                                        typelt = aparms['tipas']['la']
                                    end
                                elseif aparms['skyrius'] ~= nil then
                                    typelt = aparms['skyrius']['lt']
                                    if typelt == '' then
                                        typelt = aparms['skyrius']['la']
                                    end
                                end
                                --local typeparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                                --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local typelt = typeparms['lt'] or ''
                                --if typelt == '' then
                                --    typelt = typeparms['la']
                                --end
                                local kas = 'klasei'
                                if parms['type'] == 'potipis' then kas = 'potypiui' end
                                if parms['type'] == 'infratipas' then kas = 'infratipui' end
                                if parms['type'] == 'antklasis' then kas = 'antklasiui' end
                                local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                                xtbl
                                    .newline()
                                    .wikitext( gge )
                                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                    .tag('div')
                                        .attr('style', 'clear:both')
                                        .done()
                                    .newline()
                                    .wikitext('----')
                                    .newline()
                                    .done()
                                return tostring(xtbl)
                            else
                                return ''
                            end
                        elseif (parms['type'] == 'būrys' or parms['type'] == 'antbūris' or parms['type'] == 'infraklasė' or parms['type'] == 'poklasis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            if parms['parent'] ~= nil and parms['parent'] ~= '' then
                                local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                                if kinglt == '' then
                                    kinglt = parms['karalystė']
                                end
                                local aparms = geovalst.ggeparents(parms['parent'], subst)
        
                                local typelt = ''
                                if aparms['tipas'] ~= nil then
                                    typelt = aparms['tipas']['lt']
                                    if typelt == '' then
                                        typelt = aparms['tipas']['la']
                                    end
                                elseif aparms['skyrius'] ~= nil then
                                    typelt = aparms['skyrius']['lt']
                                    if typelt == '' then
                                        typelt = aparms['skyrius']['la']
                                    end
                                end
                                local claslt = ''
                                if aparms['klasė'] ~= nil then
                                    claslt = aparms['klasė']['lt']
                                    if claslt == '' then
                                        claslt = aparms['klasė']['la']
                                    end
                                end
                                --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if clasparms['type'] ~= 'klasė' then
                                --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local claslt = clasparms['lt'] or ''
                                --local claspa = clasparms['parent'] or ''
                                --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                                --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local typelt = typeparms['lt'] or ''
                                --if typelt == '' then
                                --    typelt = typeparms['la']
                                --end
                                --if claslt == '' then
                                --    claslt = clasparms['la']
                                --end
                                local kas = 'būriui'
                                if parms['type'] == 'antbūris' then kas = 'antbūriui' end
                                if parms['type'] == 'infraklasė' then kas = 'infraklasei' end
                                if parms['type'] == 'poklasis' then kas = 'poklasiui' end
                                local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                                xtbl
                                    .newline()
                                    .wikitext( gge )
                                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                    .tag('div')
                                        .attr('style', 'clear:both')
                                        .done()
                                    .newline()
                                    .wikitext('----')
                                    .newline()
                                    .done()
                                return tostring(xtbl)
                            else
                                return ''
                            end
                        elseif parms['type'] == 'eilė' and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            if parms['parent'] ~= nil and parms['parent'] ~= '' then
                                local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                                if kinglt == '' then
                                    kinglt = parms['karalystė']
                                end
                                local aparms = geovalst.ggeparents(parms['parent'], subst)
        
                                local typelt = ''
                                if aparms['tipas'] ~= nil then
                                    typelt = aparms['tipas']['lt']
                                    if typelt == '' then
                                        typelt = aparms['tipas']['la']
                                    end
                                elseif aparms['skyrius'] ~= nil then
                                    typelt = aparms['skyrius']['lt']
                                    if typelt == '' then
                                        typelt = aparms['skyrius']['la']
                                    end
                                end
                                local claslt = ''
                                if aparms['klasė'] ~= nil then
                                    claslt = aparms['klasė']['lt']
                                    if claslt == '' then
                                        claslt = aparms['klasė']['la']
                                    end
                                end
                                --local clasparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if clasparms['type'] ~= 'klasė' then
                                --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local claslt = clasparms['lt'] or ''
                                --local claspa = clasparms['parent'] or ''
                                --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                                --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local typelt = typeparms['lt'] or ''
                                --if typelt == '' then
                                --    typelt = typeparms['la']
                                --end
                                --if claslt == '' then
                                --    claslt = clasparms['la']
                                --end
                                local kas = 'eilei'
                                local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                                xtbl
                                    .newline()
                                    .wikitext( gge )
                                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                    .tag('div')
                                        .attr('style', 'clear:both')
                                        .done()
                                    .newline()
                                    .wikitext('----')
                                    .newline()
                                    .done()
                                return tostring(xtbl)
                            else
                                return ''
                            end
                        elseif (parms['type'] == 'šeima' or parms['type'] == 'antšeimis' or parms['type'] == 'infrabūrys' or parms['type'] == 'pobūris') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            if parms['parent'] ~= nil and parms['parent'] ~= '' then
                                local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                                if kinglt == '' then
                                    kinglt = parms['karalystė']
                                end
                                local aparms = geovalst.ggeparents(parms['parent'], subst)
        
                                local typelt = ''
                                if aparms['tipas'] ~= nil then
                                    typelt = aparms['tipas']['lt']
                                    if typelt == '' then
                                        typelt = aparms['tipas']['la']
                                    end
                                elseif aparms['skyrius'] ~= nil then
                                    typelt = aparms['skyrius']['lt']
                                    if typelt == '' then
                                        typelt = aparms['skyrius']['la']
                                    end
                                end
                                local claslt = ''
                                if aparms['klasė'] ~= nil then
                                    claslt = aparms['klasė']['lt']
                                    if claslt == '' then
                                        claslt = aparms['klasė']['la']
                                    end
                                end
                                local ordlt = ''
                                if aparms['būrys'] ~= nil then
                                    ordlt = aparms['būrys']['lt']
                                    if ordlt == '' then
                                        ordlt = aparms['būrys']['la']
                                    end
                                elseif aparms['eilė'] ~= nil then
                                    ordlt = aparms['eilė']['lt']
                                    if ordlt == '' then
                                        ordlt = aparms['eilė']['la']
                                    end
                                end
                                --local ordparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                                --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local ordlt = ordparms['lt'] or ''
                                --local ordpa = ordparms['parent'] or ''
                                --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if clasparms['type'] ~= 'klasė' then
                                --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local claslt = clasparms['lt'] or ''
                                --local claspa = clasparms['parent'] or ''
                                --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                                --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local typelt = typeparms['lt'] or ''
                                --if typelt == '' then
                                --    typelt = typeparms['la']
                                --end
                                --if claslt == '' then
                                --    claslt = clasparms['la']
                                --end
                                --if ordlt == '' then
                                --    ordlt = ordparms['la']
                                --end
                                local kas = 'šeimai'
                                if parms['type'] == 'antšeimis' then kas = 'antšeimiui' end
                                if parms['type'] == 'infrabūrys' then kas = 'infrabūriui' end
                                if parms['type'] == 'pobūris' then kas = 'pobūriui' end
                                local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                                xtbl
                                    .newline()
                                    .wikitext( gge )
                                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                    .tag('div')
                                        .attr('style', 'clear:both')
                                        .done()
                                    .newline()
                                    .wikitext('----')
                                    .newline()
                                    .done()
                                return tostring(xtbl)
                            else
                                return ''
                            end
                        elseif (parms['type'] == 'gentis' or parms['type'] == 'pošeimis' or parms['type'] == 'pogentis') and parms['karalystė'] ~= nil and parms['karalystė'] ~= '' then
                            if parms['parent'] ~= nil and parms['parent'] ~= '' then
                                local kinglt = Parm._get{ page = parms['karalystė'], parm = 'lt', subst=subst } or ''
                                if kinglt == '' then
                                    kinglt = parms['karalystė']
                                end
                                local aparms = geovalst.ggeparents(parms['parent'], subst)
        
                                local typelt = ''
                                if aparms['tipas'] ~= nil then
                                    typelt = aparms['tipas']['lt']
                                    if typelt == '' then
                                        typelt = aparms['tipas']['la']
                                    end
                                elseif aparms['skyrius'] ~= nil then
                                    typelt = aparms['skyrius']['lt']
                                    if typelt == '' then
                                        typelt = aparms['skyrius']['la']
                                    end
                                end
                                local claslt = ''
                                if aparms['klasė'] ~= nil then
                                    claslt = aparms['klasė']['lt']
                                    if claslt == '' then
                                        claslt = aparms['klasė']['la']
                                    end
                                end
                                local ordlt = ''
                                if aparms['būrys'] ~= nil then
                                    ordlt = aparms['būrys']['lt']
                                    if ordlt == '' then
                                        ordlt = aparms['būrys']['la']
                                    end
                                elseif aparms['eilė'] ~= nil then
                                    ordlt = aparms['eilė']['lt']
                                    if ordlt == '' then
                                        ordlt = aparms['eilė']['la']
                                    end
                                end
                                local famlt = ''
                                if aparms['šeima'] ~= nil then
                                    famlt = aparms['šeima']['lt']
                                    if famlt == '' then
                                        famlt = aparms['šeima']['la']
                                    end
                                end
                                --local famparms = ParmData._get{ page = parms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if famparms['type'] ~= 'šeima' then
                                --    famparms = ParmData._get{ page = famparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local famlt = famparms['lt'] or ''
                                --local fampa = famparms['parent'] or ''
                                --local ordparms = ParmData._get{ page = fampa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if ordparms['type'] ~= 'būrys' and ordparms['type'] ~= 'eilė' then
                                --    ordparms = ParmData._get{ page = ordparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local ordlt = ordparms['lt'] or ''
                                --local ordpa = ordparms['parent'] or ''
                                --local clasparms = ParmData._get{ page = ordpa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if clasparms['type'] ~= 'klasė' then
                                --    clasparms = ParmData._get{ page = clasparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local claslt = clasparms['lt'] or ''
                                --local claspa = clasparms['parent'] or ''
                                --local typeparms = ParmData._get{ page = claspa, parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --if typeparms['type'] ~= 'tipas' and typeparms['type'] ~= 'skyrius' then
                                --    typeparms = ParmData._get{ page = typeparms['parent'], parm = {'la', 'type', 'parent', 'lt' }, template = 'Auto_taxobox' }
                                --end
                                --local typelt = typeparms['lt'] or ''
                                --if typelt == '' then
                                --    typelt = typeparms['la']
                                --end
                                --if claslt == '' then
                                --    claslt = clasparms['la']
                                --end
                                --if ordlt == '' then
                                --    ordlt = ordparms['la']
                                --end
                                --if famlt == '' then
                                --    famlt = famparms['la']
                                --end
                                local kas = 'genčiai'
                                if parms['type'] == 'pošeimis' then kas = 'pošeimiui' end
                                if parms['type'] == 'pogentis' then kas = 'pogenčiui' end
                                local gge = frame:preprocess("{{GGElist3|" .. sart[2] .. "|" .. kas .. "|" .. famlt .. "|" .. ordlt .. "|" .. claslt .. "|" .. typelt .. "|" .. kinglt .. "}}") or ''
                                xtbl
                                    .newline()
                                    .wikitext( gge )
                                    .wikitext( tostring(Cite.createTag({name="references",contents='',params={}}, frame) or '') )
                                    .tag('div')
                                        .attr('style', 'clear:both')
                                        .done()
                                    .newline()
                                    .wikitext('----')
                                    .newline()
                                    .done()
                                return tostring(xtbl)
                            else
                                return ''
                            end
                        else
                            return ''
                        end
                    else
                        return ''
                    end
                else
                    return ''
                end
            else
                return ''
            end
        else
            return ''
        end
    else
        return ''
    end
end
 
geovalst.knypusl = function( frame,subst )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local action = args.action or pargs.action or ''
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    local nstext = pg.nsText
    if nstext == 'Puslapis' and action ~= 'edit' then
        local pgname = pg.text
        local sart = mw.text.split(pgname, '/')
        if #sart == 2 then
            local pagenr = tonumber( sart[2] )
            if pagenr ~= nil and pagenr > 0 then
                local xtbl = HtmlBuilder.create()
                xtbl
                    .wikitext( "[[Vaizdas:", sart[1], "|800px|center|thumb|page=", sart[2], "|", sart[1], " puslapis Nr. ", sart[2], "]]" )
                    .tag('div')
                        .attr('style', 'clear:both')
                        .done()
                    .newline()
                    .wikitext('----')
                    .newline()
                    .done()
                return tostring(xtbl)
            else
                return ''
            end
        else
            return ''
        end
    else
        return ''
    end
end
 
geovalst.straipsn = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    --local xktbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local ret = false
    local pgname = pg.rootText
    local laname = mw.ustring.gsub(pgname, "'", "''")
    local iszod = mw.ustring.find(laname, " %(žodis%)")
    if ns == 804 or ns == 0 then
        laname = mw.ustring.gsub(laname, " %(žodis%)", "")
        laname = mw.ustring.gsub(laname, " %(reikšmės%)", "")
        local pgnr = 0
        if pg.text ~= pg.subpageText then
            pgnr = tonumber('0' .. (pg.subpageText or '')) or 0
        end
        local fromsk = pgnr*20
        local tosk = fromsk+20
        local prevpg = ''
        local prevnr = pgnr-1
        if pgnr > 0 then
            if prevnr==0 then prevnr='' else prevnr = '/'..prevnr end
            prevpg = '[['..pg.subjectNsText..':'..pgname..prevnr..'|'..pgnr..' psl.]]'
        end
        local kiek = tonumber('0'..(frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ e2pagesk t |where=t.o_title='"..laname..
                            "'|data=kiek=t.kiek}}"..
                            "{{"..subst.."#for_external_table:{{{kiek}}}}}{{"..subst.."#clear_external_data:}}") or '0') )
        if kiek == 0 then
            return ''
        end
        local kiekpg = tonumber('0'..(frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ e2pagesk t |where=t.o_title='"..laname..
                            "'|data=kiekpg=(t.kiek+20-1) div 20}}"..
                            "{{"..subst.."#for_external_table:{{{kiekpg}}}}}{{"..subst.."#clear_external_data:}}") or '0') )
        local kiekabc = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ e2pagesk t |where=t.o_title='"..laname..
                            "'|data=kiekabc=t.abc}}"..
                            "{{"..subst.."#for_external_table:{{{kiekabc}}}}}{{"..subst.."#clear_external_data:}}") or ''
        local kiekpgt = '('..kiekpg..' psl.), viso skirtingų pavadinimų: '..kiek..'\n\nPereiti į: [['..pg.subjectNsText..':'..pgname..'|1]]'
        for ij = 1,(kiekpg-1) do
            if (ij > pgnr-50 and ij < pgnr+50) or (ij+1)%100 == 0 or ij+1==kiekpg then
                kiekpgt = kiekpgt .. ', [['..pg.subjectNsText..':'..pgname..'/'..ij..'|'..(ij+1)..']]'
            end
        end
        kiekpgt = kiekpgt .. ' psl.\n\nPereiti pagal abėcėlę: '
        local elemsabc = mw.text.split(kiekabc, ',')
        for j, klstelabc in ipairs(elemsabc) do
            if klstelabc ~= '' then
                local elemsabcr = mw.text.split(klstelabc, ':')
                if j>1 then
                    kiekpgt = kiekpgt .. ', '
                end
                if elemsabcr[2]=='0' then
                    kiekpgt = kiekpgt .. '[['..pg.subjectNsText..':'..pgname..'|'..elemsabcr[1]..']]'
                else
                    kiekpgt = kiekpgt .. '[['..pg.subjectNsText..':'..pgname..'/'..elemsabcr[2]..'|'..elemsabcr[1]..']]'
                end
            end
        end
        local nextpg = ''
        if kiek > (pgnr+1)*20 then
            nextpg = '[['..pg.subjectNsText..':'..pgname..'/'..(pgnr+1)..'|'..(pgnr+2)..' psl.]]'
        end
        local sar = frame:preprocess("{{"..subst.."#get_db_data:|db=geoname|from=/* "..pgname.." */ e2page t |where=t.word='"..laname..
            "'|order by=t.page_title limit " .. fromsk .. ",20|data=name=concat(case when t.page_namespace=0 then '' when t.page_namespace=800 then 'Sritis:' when t.page_namespace=802 then 'Naujiena:' when t.page_namespace=803 then 'Naujienos:' when t.page_namespace=804 then 'Citata:' when t.page_namespace=805 then 'Citatos:' else '' end,t.page_title)}}"..
            "{{"..subst.."#for_external_table:{{{name}}}~}}{{"..subst.."#clear_external_data:}}") or ''
        if sar ~= '' then
            ret = true
            local elems = mw.text.split(sar, '~')
            xtbl
                .wikitext("'''"..laname.."''' – gali reikšti:")
                .newline()
                .newline()
                .wikitext( frame:preprocess('{{header\n|title='..laname..'\n|author=\n|override_author=\n|translator=\n|section=Galimų reikšmių sąrašas\n|previous='..prevpg..'\n|next='..nextpg..
                    '\n|year=\n|wikipedia=\n|notes=Viso puslapių: '..kiekpgt..'\n}}') )
                .newline()
            for i, klstel in ipairs(elems) do
                if klstel ~= '' then
                    xtbl
                        .wikitext("* [["..mw.ustring.gsub(klstel, "_", " ").."]]")
                        .newline()
                end
            end
            xtbl
                .newline()
                .wikitext('----')
                .newline()
                .wikitext(frame:preprocess('{{Nuorodinis}}'))
                .done()
        end
    end
    if ret then
        return tostring(xtbl)
    else
        return ''
    end
end

geovalst.piladmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų piliakalnių sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/piliakalniai|'..kilm..' piliakalniai]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų piliakalnių sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/piliakalniai|'..kilm..' piliakalniai]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/piliakalniai|'..kilm..' piliakalniai]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.kapadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų kapinių sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/kapinės|'..kilm..' kapinės]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų kapinių sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/kapinės|'..kilm..' kapinės]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/kapinės|'..kilm..' kapinės]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.gyvadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų gyvenviečių sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/Gyvenvietės|'..kilm..' gyvenvietės]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų gyvenviečių sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/Gyvenvietės|'..kilm..' gyvenvietės]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/Gyvenvietės|'..kilm..' gyvenvietės]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.igyvadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų išnykusių gyvenviečių sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/išnykusios gyvenvietės|'..kilm..' išnykusios gyvenvietės]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų išnykusių gyvenviečių sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/išnykusios gyvenvietės|'..kilm..' išnykusios gyvenvietės]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/išnykusios gyvenvietės|'..kilm..' išnykusios gyvenvietės]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.dgyvadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų panaikintų gyvenviečių sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/panaikintos gyvenvietės|'..kilm..' panaikintos gyvenvietės]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų panaikintų gyvenviečių sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/panaikintos gyvenvietės|'..kilm..' panaikintos gyvenvietės]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/panaikintos gyvenvietės|'..kilm..' panaikintos gyvenvietės]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.sventadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnių administracinių vienetų šventyklų sąrašus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'/šventyklos|'..kilm..' šventyklos]]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinių vienetų šventyklų sąrašus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'/šventyklos|'..kilm..' šventyklos]]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'/šventyklos|'..kilm..' šventyklos]]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.aadmv = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local admv = args['admv'] or pargs['admv'] or ''
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local pgid = pg.id
    local ns = pg.namespace
    local pgname = pg.text
    local name = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..admv..
                            "'|order by=t._page|data=valst=t._page}}"..
                            "{{"..subst.."#for_external_table:{{{valst}}}}}{{"..subst.."#clear_external_data:}}") or ''
    local elems = ''
    if name==admv then
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.admVienetas='"..admv..
                                "'|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    else
        elems = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t.`valstybė`='"..admv..
                                "' and t.admVienetas is null|order by=t._page|data=elems=t._page}}"..
                                "{{"..subst.."#for_external_table:{{{elems}}};}}{{"..subst.."#clear_external_data:}}") or ''
    end
    if elems ~= '' and elems ~= ';' then
        local elemsl = mw.text.split(elems, ';')
        xtbl
            .newline()
            .wikitext('= Detaliau =')
            .newline()
            .wikitext('Perėjimas į smulkesnius administracinius vieneus.')
            .newline()
        for i, elem in ipairs(elemsl) do
            if elem ~= '' then
                local kilm = Parm._get{ page = elem, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..elem.."|-}}")..' [[Sritis:'..elem..'|'..elem..']]')
                    .newline()
            end
        end
        xtbl
            .newline()
    end
    if name==admv then
        xtbl
            .newline()
            .wikitext('= Plačiau =')
            .newline()
            .wikitext('Perėjimas į stambesnių administracinius vieneus.')
            .newline()
        local vien = admv
        while vien~='' do
            local avien = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.admVienetas|data=avien=t.admVienetas}}"..
                        "{{"..subst.."#for_external_table:{{{avien}}}}}{{"..subst.."#clear_external_data:}}") or ''
            if avien~='' then
                local kilm = Parm._get{ page = avien, parm = 'kilm', namespace = 0, subst=subst }
                xtbl
                    .wikitext('* '..frame:preprocess("{{Vėliava|"..avien.."|-}}")..' [[Sritis:'..avien..'|'..avien..']]')
                    .newline()
            else
                local avalst = frame:preprocess("{{"..subst.."#get_db_data:|db=wikidata|from=/* "..pgname.." */ Administracinis_vienetas t |where=t._page='"..vien..
                        "'|order by=t.`valstybė`|data=avalst=t.`valstybė`}}"..
                        "{{"..subst.."#for_external_table:{{{avalst}}}}}{{"..subst.."#clear_external_data:}}") or ''
                if avalst~='' then
                    local kilm = Parm._get{ page = avalst, parm = 'kilm', namespace = 0, subst=subst }
                    xtbl
                        .wikitext('* '..frame:preprocess("{{Vėliava|"..avalst.."|-}}")..' [[Sritis:'..avalst..'|'..avalst..']]')
                        .newline()
                end
            end
            vien = avien
        end
    end
    return tostring(xtbl)
end

geovalst.ltwiki = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    if ns == 804 or ns == 0 then
        local pgname = pg.text
        local laname = mw.ustring.gsub(pgname, "'", "''")
        local yra = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..pgname.." */ Paplitimas.ltwiki t |where=t.name='"..laname..
                    "'|order by=t.name|data=name=t.name}}"..
                    "{{"..subst.."#for_external_table:{{{name}}}}}{{"..subst.."#clear_external_data:}}") or ''
        --local nn = mw.title.makeTitle("",laname,"","lt")
        if yra ~= '' then
            xtbl
                .wikitext(frame:preprocess("{{"..subst.."lt::"..laname.."}}"))
                .newline()
                .newline()
                .wikitext("[[lt:"..laname.."]]")
                .newline()
                .newline()
                .tag('div')
                    .attr('style', 'clear:both')
                    .done()
                .newline()
                .wikitext('----')
                .newline()
        end
    end
    return tostring(xtbl)
end

geovalst.kapai = function( frame,subst )
    local xtbl = HtmlBuilder.create()
    local pg = mw.title.getCurrentTitle()
    local ns = pg.namespace
    if ns == 804 or ns == 0 then
        local pgname = pg.text
        local laname = mw.ustring.gsub(pgname, "'", "''")
        local yra = frame:preprocess("{{"..subst.."#get_db_data:|db=ggetree|from=/* "..pgname.." */ ggetree.Kapines t |where=t.name='"..laname..
                    "'|order by=t.name|data=name=t.name,sen=t.sen,plo=t.plotas,kod=t.kodas,tip=t.tipas,past=t.pastaba,sav=t.sav}}"..
                    "{{"..subst.."#for_external_table:{{{name}}};{{{sen}}};{{{plo}}};{{{kod}}};{{{tip}}};{{{past}}};{{{sav}}};}}{{"..subst.."#clear_external_data:}}") or ''
        --local nn = mw.title.makeTitle("",laname,"","lt")
        if yra ~= '' then
            local elems = mw.text.split(yra, ';')
            local kilm = elems[2]
            local kilml = elems[2]
            if elems[2] ~= '' then
                kilm = Parm._get{ page = elems[2], parm = 'kilm', namespace = 0, subst=subst }
            else
                kilml = elems[7]
                kilm = Parm._get{ page = elems[7], parm = 'kilm', namespace = 0, subst=subst }
            end
            local adtext = ''
            if elems[3] ~= '' then
                adtext = " Kapinės užima "..elems[3].." ha plotą."
            end
            xtbl
                .wikitext(frame:preprocess("{{Kapai\n|pav="..laname.."\n|kit=\n|lat=\n|long=\n|gyv=\n|sen="..kilml.."\n|auk=\n|plo="..elems[3].."\n|nau="..elems[5].."\n|zva=\n|tir=\n|unk="..elems[4].."\n|foto=\n|fotoinfo=\n}}"))
                .newline()
                .newline()
                .wikitext("'''"..laname.."''' – [["..elems[7].."]]s, esančios [["..kilml.."|"..kilm.."]] teritorijoje, "..elems[5].." kapinės."..adtext)
                .newline()
                .newline()
                .wikitext("== Istorija ==")
                .newline()
                .newline()
                .wikitext("== Palaidotieji ==")
                .newline()
                .newline()
                .wikitext("[[Kategorija:"..kilml.."/kapinės]]")
                .newline()
                .newline()
                .tag('div')
                    .attr('style', 'clear:both')
                    .done()
                .newline()
                .wikitext('----')
                .newline()
        end
    end
    return tostring(xtbl)
end

geovalst.all = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local subst = args['subst'] or pargs['subst'] or ''
    local text = args['text'] or pargs['text'] or ''
    local alttext = args['alttext'] or pargs['alttext'] or ''
    local xtbl = HtmlBuilder.create()

    local txt = geovalst.kapai( frame,subst ) .. geovalst.ltwiki( frame,subst ) .. geovalst.mdaktaras(frame,subst) .. geovalst.knypusl(frame,subst) .. geovalst.valstybe(frame,subst) .. geovalst.geoname(frame,subst)  .. geovalst.straipsn(frame,subst) .. geovalst.gbif(frame,subst) .. geovalst.ggelist2(frame,subst)
            
    if txt == ''  then 
        txt = frame:preprocess(text)
    else
        local alt = frame:preprocess(alttext) or ''
        if alt ~= '' then
            --xtbl
            --    .newline()
            --    .tag('nowiki')
            --        .wikitext( txt )
            --        .done()
            --    .done()
            txt = txt .. frame:preprocess(alttext) -- .. tostring(xtbl)
        end
    end
        
    return txt    
end

return geovalst
