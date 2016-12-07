local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Gref = require('Module:Gref')
local ValVietininkas = require('Module:ValstybėsVietininkas')
local Plural = require('Module:Plural')
local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')

grefvp = {}

grefvp._refv = function( mires, lt, sin, la, larod, aut, met, ptip, vaizdas, valst, sla, saut, smet, gbif, isrefpage )
    local root = HtmlBuilder.create()
    local frame = mw.getCurrentFrame()
    --local lang = mw.getLanguage( 'lt' )
    local _valst = valst or ''
    local kas = lt
    if not lt or lt == '' then
        kas = la
    end
    if gbif == nil then gbif = '' end
    
    --local formargs = {
    --        form = 'Auto taxobox',
    --        ['link text'] = '<sup>[k]</sup>',
    --        ['link type'] = '',
    --        ['query string'] = ''
    --    }
    --formargs['query string'] = formargs['query string'] .. 'page name=' .. la
    --formargs['query string'] = formargs['query string'] .. '&Auto taxobox[la]=' .. la
    --formargs['query string'] = formargs['query string'] .. '&Auto taxobox[alt]=' .. la
    if isrefpage == nil then isrefpage = false end

    local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
 
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
 
    if _valst ~= '' and ptip ~= 'rūšis' and ptip ~= 'porūšis' then
        local sal = _valst
        local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
        local pg = mw.title.getCurrentTitle()
        local pgname = pg.text
        local sk = frame:preprocess("{{#get_db_data:db=taxon|from=/* "..pgname.." */ tax_sal_det_rus|where=la='" .. ladb ..
            "' and type='" .. ptip .. "' and salis='" .. _valst ..
            "'|limit=1|data=sksalrūšis=sk}}{{#external_value:sksalrūšis}}{{#clear_external_data:}}") or '0'
        
        if sk == '' then 
            sk = '0' 
        end
        
        local txt = HtmlBuilder.create()
        txt
            .wikitext(' ')
            .wikitext(ValVietininkas._viet( sal, '', '#default' ))
            .wikitext(' ')
            .wikitext(Plural._plural( {sk, 'aptinkama', 'aptinkamos', 'aptinkama'} ))
            .wikitext(' ')
            .wikitext(sk)
            .wikitext(' [[Sritis:')
            .wikitext(kas)
            .wikitext('/')
            .wikitext(sal)
            .wikitext('|')
            .wikitext(Plural._plural( {sk, 'rūšis', 'rūšys', 'rūšių'} ))
            .wikitext(']].')
            .done()
        _valst = tostring(txt)
    else
        _valst = ''
    end
    
    if la and la ~= '' then
        root
            .tag('div')
                .tag('table')
                    .tag('tr')
                        .tag('td')
                            .wikitext( " [[Vaizdas:", vaizdas, "|100px|]]" )
                            .done()
                        .tag('td')
                            .wikitext( Gref._ref( mires, lt, sin, la, larod, aut, met, ptip, sla, saut, smet, gbif, isrefpage ) )
                            .wikitext( _valst )
                            .done()
                        .done()
                    .done()
                .done()
    end

    root.done()
     
    return  tostring(root)
end

grefvp.ref = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _aut = args.aut or pargs.aut or mw.text.trim(args[2] or pargs[2] or '')
    local _met = args.met or pargs.met or mw.text.trim(args[3] or pargs[3] or '')
    local _lt = args.lt or pargs.lt or mw.text.trim(args[4] or pargs[4] or '')
    local _valst = mw.text.trim(args['valstybė'] or pargs['valstybė'] or '')
    
    return grefvp.refla( _la, _aut, _met, _lt, _valst )
end

grefvp.refla = function( la, aut, met, lt, valst, sla, saut, smet )
    local _la, _aut, _met, _lt, _valst = la or '', aut or '', met or '', lt or '', valst or ''
    local _sla, _saut, _smet = sla or '', saut or '', smet or ''
    if sla == nil then
        _sla = ''
    end
    if saut == nil then
        _saut = ''
    end
    if smet == nil then
        _smet = ''
    end
    local _mires, _sin, _larod = '', '', ''
    local pagename = _la
    local ttip = ''
    local vaizdas = ''
    local vaizdas1 = ''
    local gbif = ''
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local isrefpage=false
    
    local parms = ParmData._get{ page = _la, parm = {'išnykęs', 'lt', 'lt sins', 'la', 'altla', 'autoriai', 'metai', 
        'statusas', 'type', 'gbifid', 'vaizdas', 'vaizdas1' }, template = 'Auto_taxobox' }
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
        vaizdas = parms['vaizdas'] or ''
        vaizdas1 = parms['vaizdas1'] or ''
        gbif = parms['gbifid'] or ''
        if stat == 'EX' then
            _mires = 'taip'
        end
        if _la2 ~= _la and _la2 ~= '' and _la2 ~= nil then
            _la = _la2
        end
        if vaizdas == '' then
            vaizdas = vaizdas1
        end
    end
 
    if parmsSin ~= nil then
        if _sla == '' then
            local gsla = parmsSin['Lotyniškai'] or ''
            local gpsla = parmsSin['Priklauso'] or ''
            local gsaut = parmsSin['Pavadinimo autorius'] or ''
            local gsmet = parmsSin['Pavadinimo metai'] or ''
            if gpsla ~= '' then
                return grefvp.refla( gpsla, '', '', '', _valst, gsla, gsaut, gsmet )
            end
        end
        isrefpage = true
    end
    if vaizdas == '' then
        --local rpage, err = mw.title.makeTitle( 0, _la, '', 'species' )
        --local rtxt = ''
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
        --            end
        --        end
        --    end
        --end
        --
        --if rtxt ~= '' then
        --    vaizdas = mw.ustring.match( rtxt, "%[%[%s*[Ff]ile%:([^%c%|%]]-)%s*[%c%|%]]" ) or 
        --            mw.ustring.match( rtxt, "%[%[%s*[Ii]mage%:([^%c%|%]]-)%s*[%c%|%]]" ) or 
        --            mw.ustring.match( rtxt, "%{%{%s*[Ii]mage%s*%|%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
        --end
        if vaizdas == '' then
            vaizdas = 'Blank 50px.png'
        end
    end
    
    return grefvp._refv( mw.text.trim(_mires or ''), mw.text.trim(_lt or ''), mw.text.trim(_sin or ''), _la, 
        mw.text.trim(_larod or ''), mw.text.trim(_aut or ''), mw.text.trim(_met or ''), mw.text.trim(ttip or ''), vaizdas, _valst,
        mw.text.trim(_sla or ''), mw.text.trim(_saut or ''), mw.text.trim(_smet or ''), mw.text.trim(gbif or ''), isrefpage )
end

grefvp.kat = function( frame )
    local tit = mw.title.getCurrentTitle()
    local pgname = tit.text
    local laname = mw.ustring.gsub(pgname, "'", "''")
    local la, lt, parent, typ = '', '', '', ''
    local pla, plt = '', ''

    local parms = ParmData._get{ page = tit.rootText, parm = {'lt', 'la', 'parent', 'type' }, template = 'Auto_taxobox' }
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

    if parms ~= nil then
        la = mw.text.trim(parms['la'] or '')
        lt = mw.text.trim(parms['lt'] or '')
        parent = mw.text.trim(parms['parent'] or '')
        typ = mw.text.trim(parms['type'] or '')
    end
    
    if parent ~= '' then
        if not tit.isSubpage or tit.subpageText ~= 'Sinonimai' then
            parms = ParmData._get{ page = parent, parm = {'lt', 'la' }, template = 'Auto_taxobox' }
            -- local rpage, err = mw.title.new(parent)
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
                pla = mw.text.trim(parms['la'] or '')
                plt = mw.text.trim(parms['lt'] or '')
            end
        end
    end

    local root = HtmlBuilder.create()
    if la == '' then
        local objsar = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..laname.." */ features t |where=t.pavadinimas='"..tit.subpageText..
                "'|data=tip=t.pavadinimas}}"..
                "{{#for_external_table:{{{tip}}}}}{{#clear_external_data:}}") or ''
        local objsar2 = frame:preprocess("{{#get_db_data:|db=geoname|from=/* "..laname.." */ features t |where=t.name='"..tit.subpageText..
                "'|data=tip=t.name}}"..
                "{{#for_external_table:{{{tip}}}}}{{#clear_external_data:}}") or ''
        if tit.subpageText == 'taksonas' or tit.subpageText == 'porūšis' or tit.subpageText == 'rūšis' or tit.subpageText == 'gentis' or 
           tit.subpageText == 'šeima' or tit.subpageText == 'pogentis' or tit.subpageText == 'būrys' or tit.subpageText == 'forma' or
           tit.subpageText == 'varietetas' or tit.subpageText == 'pošeimis' or tit.subpageText == 'pobūris' or tit.subpageText == 'eilė' or
           tit.subpageText == 'geoname' or tit.subpageText == 'ggecitata' or tit.subpageText == 'šventyklos' or tit.subpageText == 'piliakalniai' or 
           tit.subpageText == 'Gyvenvietės' or tit.subpageText == 'vienuolynai' or objsar ~= '' or objsar2 ~= '' then
            root
                .wikitext(':Pagrindinis straipsnis – [[')
                .wikitext(tit.rootText)
                .wikitext(']].\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.rootText)
                .wikitext('|')
                .wikitext(tit.subpageText)
                .wikitext(']]\n')
                .done()
            return tostring(root)
        elseif tit.rootText == 'Gyvoji gamta' then
            root
                .wikitext(':Pagrindinis straipsnis – [[')
                .wikitext(tit.subpageText)
                .wikitext(']].\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.subpageText)
                .wikitext('|')
                .wikitext('Gyvoji gamta')
                .wikitext(']]\n')
                .wikitext('[[Kategorija:')
                .wikitext('Gyvoji gamta')
                .wikitext('/')
                .wikitext('pagal šalis')
                .wikitext('|')
                .wikitext(tit.subpageText)
                .wikitext(']]\n')
                .done()
            return tostring(root)
        elseif tit.subpageText == 'išnykusios gyvenvietės' then
            root
                .wikitext(':Pagrindinis straipsnis – [[')
                .wikitext(tit.rootText)
                .wikitext(']].\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.rootText)
                .wikitext('|')
                .wikitext('išnykusios gyvenvietės')
                .wikitext(']]\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.rootText)
                .wikitext('/')
                .wikitext('Gyvenvietės')
                .wikitext('| ]]\n')
                .done()
            return tostring(root)
        elseif tit.subpageText == 'panaikintos gyvenvietės' then
            root
                .wikitext(':Pagrindinis straipsnis – [[')
                .wikitext(tit.rootText)
                .wikitext(']].\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.rootText)
                .wikitext('|')
                .wikitext('panaikintos gyvenvietės')
                .wikitext(']]\n')
                .wikitext('[[Kategorija:')
                .wikitext(tit.rootText)
                .wikitext('/')
                .wikitext('Gyvenvietės')
                .wikitext('| ]]\n')
                .done()
            return tostring(root)
        else
            root
                .wikitext('Nerastas atitinkamas pagrindinis puslapis su kuriuo yra susijusi ši kategorija.\n')
                .wikitext(':Pagrindinis straipsnis – [[')
                .wikitext(tit.rootText)
                .wikitext(']].\n')
                .wikitext('[[Kategorija:Kandidatai trinti kategorijos]]')
                .done()
            return tostring(root)
        end
    end
    local pg = la
    if lt ~= '' and lt ~= la then
        pg = lt
    end
    local ppg = pla
    if plt ~= '' and plt ~= pla then
        ppg = plt
    end
    local subpg = ''
    if tit.isSubpage then
        subpg = '/'..tit.subpageText
    end
    if tit.rootText ~= pg then
        root
            -- Pervadinti
            .wikitext('Kategoriją [[:Kategorija:')
            .wikitext(tit.rootText)
            .wikitext(']] reikia pervadinti į [[:Kategorija:')
            .wikitext(pg)
            .wikitext(subpg)
            .wikitext(']].\n\n')
            .wikitext('Pagrindinis puslapis su kuriuo yra susijusi ši kategorija jau yra kitu pavadinimu ')
            .wikitext('arba turi būti kitu lietuvišku pavadinimu.\n\n')
            .wikitext('[[Kategorija:Kandidatai trinti kategorijos]]\n')
            .wikitext('[[Kategorija:Kandidatai pervadinti]]\n')
    end
    root
        -- bendrai
        .wikitext(grefvp.refla( la, '', '', '', '' ))
        .wikitext('\n')
        .wikitext(':Pagrindinis straipsnis – [[')
        .wikitext(pg)
        .wikitext(']].\n')
        
    if ppg ~= '' and ppg ~= pg and ppg ~= tit.rootText then
        root
            .wikitext(':Taip pat skaitykite – [[')
            .wikitext(ppg)
            .wikitext(']].\n')
    end
    
    if tit.isSubpage and tit.subpageText ~= 'Sinonimai' and tit.subpageText ~= 'pagal šalis' and tit.subpageText ~= 'ggecitata' and ppg ~= '' then
        root
            .wikitext(':Taip pat skaitykite – [[')
            .wikitext(tit.subpageText)
            .wikitext(']].\n')
            .wikitext('[[Kategorija:')
            .wikitext(ppg)
            .wikitext('/')
            .wikitext(tit.subpageText)
            .wikitext('|')
            .wikitext(pg)
            .wikitext(']]\n')
            .wikitext('[[Kategorija:')
            .wikitext(pg)
            .wikitext('/')
            .wikitext('pagal šalis')
            .wikitext('|')
            .wikitext(tit.subpageText)
            .wikitext(']]\n')
    elseif tit.isSubpage and tit.subpageText ~= 'Sinonimai' and tit.subpageText ~= 'pagal šalis' and tit.subpageText ~= 'ggecitata' and typ == 'karalystė' then
        root
            .wikitext(':Taip pat skaitykite – [[')
            .wikitext(tit.subpageText)
            .wikitext(']].\n')
            .wikitext('[[Kategorija:')
            .wikitext('Gyvoji gamta')
            .wikitext('/')
            .wikitext(tit.subpageText)
            .wikitext('|')
            .wikitext(pg)
            .wikitext(']]\n')
            .wikitext('[[Kategorija:')
            .wikitext(pg)
            .wikitext('/')
            .wikitext('pagal šalis')
            .wikitext('|')
            .wikitext(tit.subpageText)
            .wikitext(']]\n')
    elseif tit.isSubpage and tit.subpageText == 'ggecitata' then
        root
            .wikitext('[[Kategorija:')
            .wikitext(pg)
            .wikitext('|GGE Citata')
            .wikitext(']]\n')
    elseif tit.isSubpage and tit.subpageText == 'pagal šalis' then
        root
            .wikitext('[[Kategorija:')
            .wikitext(pg)
            .wikitext('| Pagal šalis')
            .wikitext(']]\n')
    elseif tit.isSubpage and tit.subpageText == 'Sinonimai' then
        root
            .wikitext('[[Kategorija:')
            .wikitext(pg)
            .wikitext('| Sinonimai')
            .wikitext(']]\n')
    elseif not tit.isSubpage then
        root
            .wikitext('[[Kategorija:')
            .wikitext(ppg)
            .wikitext('|')
            .wikitext(pg)
            .wikitext(']]\n')
    end
    root.done()

    return tostring(root)
end
 
return grefvp
