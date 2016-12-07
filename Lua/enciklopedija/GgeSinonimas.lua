local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Aut = require('Module:Aut')
local Cite = require('Module:Cite')
local json = require('Modulis:JSON')
local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')
local jsoncol = require('Modulis:JSON/COL')
local jsongbif = require('Modulis:JSON/GBIF')
local jsonitis = require('Modulis:JSON/ITIS')
local jsoneol = require('Modulis:JSON/EOL')

local sin = {}
local conf = {}

--sin.getla = function( rpage, parm )
    --local ret = Parm._get{ page = rpage.text, parm = parm } or ''
    -- local pagename = rpage.text
    -- local rtxt = ''
    -- local ret = ''
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
    -- 
    -- if rtxt ~= '' then
    --     ret = mw.ustring.match( rtxt, "%c%s*%|%s*"..parm.."%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
    -- end
 
    --return ret
--end

function sin._esin(args)
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    local mla = ParmData._get{ page = page.text, parm = 'la', template = 'Auto_taxobox' } or ''
    --local mla = sin.getla( page, 'la' )
    if mla == nil or mla == '' then
        mla = args['Priklauso'] or ''
    end
    if mla == nil then
        mla = ''
    end
    if mla == '' then
        mla = ParmData._get{ page = page.rootText, parm = 'la', template = 'Auto_taxobox' } or ''
        -- local pages = mw.title.new( page.rootText )
        -- mla = sin.getla( pages, 'la' )
    end
    
    local root = HtmlBuilder.create()
    local formargs = { 
            form = 'Sinonimas',
            ['link text'] = '<sup>[k]</sup>',
            ['link type'] = '',
            ['query string'] = ''
        }
    root.wikitext('* ')
    
    if args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        root.wikitext(Komentaras._kom('?', 'Lotyniško sinonimo pavadinimas nenurodytas.'))
    else
        formargs['query string'] = formargs['query string'] .. 'page name=' .. args['Lotyniškai']
        formargs['query string'] = formargs['query string'] .. '&Sinonimas[Lotyniškai]=' .. args['Lotyniškai']
        formargs['query string'] = formargs['query string'] .. '&Sinonimas[Priklauso]=' .. mla
        local showla, altla = args['Lotyniškai'], ''
        if args['alt'] ~= nil and args['alt'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[alt]=' .. args['alt']
            altla = args['alt']
        end
        if altla == '' then
            altla = mw.text.trim(mw.text.split(args['Lotyniškai'], ' (', true)[1])
        end
        if args['Lotyniškai'] == altla then
            root
                .tag('i')
                    .wikitext( "[[", args['Lotyniškai'], "]]" )
                    .done()
        else
            showla = altla
            root
                .tag('i')
                    .wikitext( "[[", args['Lotyniškai'], '|', altla, "]]" )
                    .done()
        end
        root.wikitext(" ")
        
        if args['Pavadinimo autorius'] ~= nil and args['Pavadinimo autorius'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Pavadinimo autorius]=' .. args['Pavadinimo autorius']
            local i = 0
            for a in mw.text.gsplit(args['Pavadinimo autorius'], ',', true) do
                local _a = mw.text.trim(a)
                if _a ~= '' then
                    if i ~= 0 then
                        root.wikitext(', ')
                    end
                    local autsp = _a --mw.text.trim(mw.text.split(_a, ' (', true)[1])
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
 
        if args['Pavadinimo metai'] == nil or args['Pavadinimo metai'] == '' then
            root.wikitext( Komentaras._kom('?', 'Lotyniško sinonimo pavadinimo sukūrimo metai nežinomi arba dar neįvesti į ELIP.'))
        else
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Pavadinimo metai]=' .. args['Pavadinimo metai']
            local mets = mw.text.split(args['Pavadinimo metai'], ' publ. ')
            if #mets == 1 then
                root.wikitext( "[[", args['Pavadinimo metai'], "]]")
            else
                root.wikitext( "[[", mets[1], "]]" )
                root.wikitext( ' publ. ' )
                root.wikitext( "[[", mets[2], "]]" )
            end
        end
        if args['ITIS'] ~= nil and args['ITIS'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[ITIS]=' .. args['ITIS']
            root.wikitext( Cite._isn ( frame, {}, { sin._itis{ ID = args['ITIS'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'itis'..args['ITIS'] } ) )
        end
        if args['CBIF'] ~= nil and args['CBIF'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[CBIF]=' .. args['CBIF']
            root.wikitext( Cite._isn ( frame, {}, { sin._cbif{ ID = args['CBIF'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'cbif'..args['CBIF'] } ) )
        end
        if args['WoRMS'] ~= nil and args['WoRMS'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[WoRMS]=' .. args['WoRMS']
            root.wikitext( Cite._isn ( frame, {}, { sin._worms{ ID = args['WoRMS'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'worms'..args['WoRMS'] } ) )
        end
        if args['Malacolog'] ~= nil and args['Malacolog'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Malacolog]=' .. args['Malacolog']
            root.wikitext( Cite._isn ( frame, {}, { sin._malacolog{ ID = args['Malacolog'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'malacolog'..args['Malacolog'] } ) )
        end
        if args['Gastropods'] ~= nil and args['Gastropods'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Gastropods]=' .. args['Gastropods']
            local gelems = mw.text.split( args['Gastropods'], ',' )
            root.wikitext( Cite._isn ( frame, {}, { sin._gastropods{ GRP = gelems[1], ID = gelems[2], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'gastropods'..gelems[1]..gelems[2] } ) )
        end
        if args['Paleodb'] ~= nil and args['Paleodb'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Paleodb]=' .. args['Paleodb']
            root.wikitext( Cite._isn ( frame, {}, { sin._paleodb{ ID = args['Paleodb'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'paleodb'..args['Paleodb'] } ) )
        end
        if args['Birdlife'] ~= nil and args['Birdlife'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Birdlife]=' .. args['Birdlife']
            root.wikitext( Cite._isn ( frame, {}, { sin._birdlife{ ID = args['Birdlife'], taxon = "''"..showla.."''",
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'birdlife'..args['Birdlife'] } ) )
        end
        if args['GBIF'] ~= nil and args['GBIF'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[GBIF]=' .. args['GBIF']
            root.wikitext( Cite._isn ( frame, {}, { sin._gbif{ ID = args['GBIF'], taxon = showla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'gbif'..args['GBIF'] } ) )
        end
        if args['EOL'] ~= nil and args['EOL'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[EOL]=' .. args['EOL']
            root.wikitext( Cite._isn ( frame, {}, { sin._eol{ ID = args['EOL'], taxon = mla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'eol'..args['EOL'] } ) )
        end
        if args['COL2013'] ~= nil and args['COL2013'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[COL2013]=' .. args['COL2013']
            root.wikitext( Cite._isn ( frame, {}, { sin._col2013{ ID = args['COL2013'], taxon = mla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'col'..args['COL2013'] } ) )
        end
        if args['PlantsL'] == '1' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[PlantsL]=' .. args['PlantsL']
            root.wikitext( Cite._isn ( frame, {}, { sin._plantl{ taxon = mla }, 
                'plantsl' } ) )
        elseif args['PlantsL'] == '2' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[PlantsL]=' .. args['PlantsL']
            root.wikitext( Cite._isn ( frame, {}, { sin._plantl{ taxon = mla }, 'plantsl' } ) )
        end
        if args['PlantsLRefId'] ~= nil and args['PlantsLRefId'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[PlantsLRefId]=' .. args['PlantsLRefId']
            root.wikitext( Cite._isn ( frame, {}, { sin._plantsl{ ID = args['PlantsLRefId'], taxon = showla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'plantsl'..args['PlantsLRefId'] } ) )
        end
        if args['JSTOR'] == '1' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[JSTOR]=' .. args['JSTOR']
            root.wikitext( Cite._isn ( frame, {}, { sin._jstor{ taxon = showla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                nil } ) )
        end
        if args['Tropicos'] == '1' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Tropicos]=' .. args['Tropicos']
            root.wikitext( Cite._isn ( frame, {}, { sin._tropicos{ taxon = mla }, 
                'tropicos' } ) )
        elseif args['Tropicos'] == '2' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[Tropicos]=' .. args['Tropicos']
            root.wikitext( Cite._isn ( frame, {}, { nil, 'tropicos' } ) )
        end
        if args['TropicosId'] ~= nil and args['TropicosId'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[TropicosId]=' .. args['TropicosId']
            root.wikitext( Cite._isn ( frame, {}, { sin._tropicosid{ ID = args['TropicosId'], taxon = showla,
                    ['Lotyniškai'] = args['Lotyniškai'], Priklauso = mla, alt = args['alt'] }, 
                'tropicos'..args['TropicosId'] } ) )
        end
        if args['wiki'] ~= nil and args['wiki'] ~= '' then
            formargs['query string'] = formargs['query string'] .. '&Sinonimas[wiki]=' .. args['wiki']
            for lstel in mw.text.gsplit(args['wiki'],',') do
                local _lstel = mw.text.trim(lstel)
                if _lstel ~= '' then
                    root.wikitext( Cite._isn ( frame, {}, { '[[:'.._lstel..']]', nil } ) )
                end
            end
        end
        if args['išnašos'] ~= nil and args['išnašos'] ~= '' then
            root.wikitext( args['išnašos'] )
        end
        
        if args['created'] == nil or args['created'] == '' then
            local parms = ParmData._get{ page = args['Lotyniškai'], parm = {'Priklauso', 'Lotyniškai' }, template = 'Sinonimas' }
            -- local page = mw.title.new( args['Lotyniškai'] )
            if parms ~= nil then
                -- if page.isRedirect then
                --     local rtxt = page:getContent() or ""
                --     local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
                -- 
                --     if not redirect then
                --         redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
                --     end
                --     if redirect then
                --         page = mw.title.new(redirect)
                --     end
                -- end
        
                local mlas = parms['Priklauso'] or ''
                local mlasla = parms['Lotyniškai'] or ''
                if args['Lotyniškai'] ~= mlasla or mla ~= mlas then
                    root.wikitext( frame:callParserFunction{ name = '#formlink:form=Sinonimas', 
                                args = formargs } )
                end
            else
                root.wikitext( frame:callParserFunction{ name = '#formlink:form=Sinonimas', 
                                args = formargs } )
                -- root.wikitext( Cite._isn ( frame, {}, { 'Negalimas puslapio vardas', nil } ) )
                -- root.newline()
                -- root.wikitext( '[[Kategorija:Surinkti]]' )
                -- root.newline()
            end
        -- else
        --    root.wikitext('+')
        end
    end
    
    root
        -- .newline()
        .done()
    return tostring(root)
end

function sin.esin(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._esin(args)
end

function sin.vsin(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(conf) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._vsin(args)
end

function sin._vsin(args)
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    local mpriklauso = ParmData._get{ page = page.text, parm = 'Priklauso', template = 'Sinonimas' } or '' -- sin.getla( page, 'Priklauso' )
    local root = HtmlBuilder.create()
    local vplotis = args['plotis']
    if vplotis == nil or vplotis == '' then
        vplotis = '260px'
    end
    
    if mpriklauso == '' then
        if args['Priklauso'] and args['Priklauso'] ~= '' then
            mpriklauso = args['Priklauso']
        else
            return ''
        end
    end
    
    local parms = ParmData._get{ page = mpriklauso, parm = {'vaizdas', 'antraštė', 'vaizdas1', 'antraštė1' }, template = 'Auto_taxobox' }
    -- local rpage = mw.title.new( mpriklauso )
    if parms ~= nil then
        -- if rpage.isRedirect then
        --     local rtxt = rpage:getContent() or ""
        --     local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
        -- 
        --     if not redirect then
        --         redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
        --     end
        --     if redirect then
        --         rpage = mw.title.new(redirect)
        --     end
        -- end

        local mv1 = mw.text.trim(parms['vaizdas'] or '')
        local mv1t = parms['antraštė'] or ''
        local mv2 = mw.text.trim(parms['vaizdas1'] or '')
        local mv2t = parms['antraštė1'] or ''
        
        if mv1 ~= '' then
            root.newline()
            root.wikitext( '|-' )
            root.newline()
            root.wikitext( '| style="text-align:center;" | [[Vaizdas:')
            root.wikitext( mv1 )
            root.wikitext( '|' )
            root.wikitext( vplotis )
    		root.wikitext( ']]' )
			if mv1t ~= '' then
				root
					.wikitext( '<br />' )
					.tag('small')
						.wikitext( mv1t )
						.done()
			end
            root.newline()
            root.wikitext( '|-' )
            root.newline()
        end
        if mv2 ~= '' then
            root.newline()
            root.wikitext( '|-' )
            root.newline()
            root.wikitext( '| style="text-align:center;" | [[Vaizdas:')
            root.wikitext( mv2 )
            root.wikitext( '|' )
            root.wikitext( vplotis )
			root.wikitext( ']]' )
			if mv2t ~= '' then
				root
					.wikitext( '<br />' )
					.tag('small')
						.wikitext( mv2t )
						.done()
			end
            root.newline()
            root.wikitext( '|-' )
            root.newline()
        end
    else
        return ''
    end
    
    return tostring(root)
end

function _compCanonicalName( a, b )
    return mw.language.getContentLanguage():caseFold(a.canonicalName or a.scientificName) < mw.language.getContentLanguage():caseFold(b.canonicalName or b.scientificName)
end

function _compEolCanonicalName( a, b )
    return mw.language.getContentLanguage():caseFold(a.synonym) < mw.language.getContentLanguage():caseFold(b.synonym)
end

function sin._ssin(args)
    local frame = mw.getCurrentFrame()
    local page = mw.title.getCurrentTitle()
    local mla = Parm._get{ page = page.text, parm = 'la' } or ''
    --local mla = sin.getla( page, 'la' )
    if mla == '' then
        mla = args['la'] or ''
    end
    if mla == '' then
        return ''
    end
    local mladb = mw.text.listToText(mw.text.split( mla, "'" ), "''", "''")
    local mlt = Parm._get{ page = mla, parm = 'lt' }
    --local pages = mw.title.new(mla)
    local itisid, eolid, gbifid, colid = '', '', '', ''
    if mlt ~= nil then
        mlt = ''
        --itisid = parms['itisid'] or ''
        --eolid = parms['eolid'] or ''
        --gbifid = parms['gbifid'] or ''
        --colid = parms['colid'] or ''
    end

    --local itisidm = mw.text.split(itisid,',') or {}
    --if #itisidm ~= 1 then
    --    itisid = ''
    --end
    --local eolidm = mw.text.split(eolid,',') or {}
    --if #eolidm ~= 1 then
    --    eolid = ''
    --end
    --local gbifidm = mw.text.split(gbifid,',') or {}
    --if #gbifidm ~= 1 then
    --    gbifid = ''
    --end
    --local colidm = mw.text.split(colid,',') or {}
    --if #colidm ~= 1 then
    --    colid = ''
    --end

    if mlt == '' then
        mlt = mla
    end
    local nuo = 0
    if args['nuo'] and args['nuo'] ~= '' then
        nuo = tonumber(args['nuo'])
    end
    local kiek = 50
    if args['kiek'] and args['kiek'] ~= '' then
        kiek = tonumber(args['kiek'])
    end

    local nex = page.text .. '/sinonimai/1'
    if args['next'] and args['next'] ~= '' then
        nex = args['next']
    end
    local ladb = mw.text.listToText(mw.text.split( mla, "'" ), "''", "''")
    
    local root = HtmlBuilder.create()
    local rsin = HtmlBuilder.create()
    
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    --local mladb = mw.text.listToText(mw.text.split( mla, "'" ), "''", "''")
    if colid == '' then
        colid = jsoncol._get1{ la = mladb } or ''
    end
    local colidm = mw.text.split( colid, ',' )
    -- local inf2013 = ''
    -- local inf2013s = { '', '', '', '', '', '' }
    -- if mla ~= '' then
    --     inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ _taxon_tree b "..
    --         "left join base.x_col2013taxon c on (b.taxon_id=c.c_taxon_id)|where=b.name='"..
    --         mladb.."' and c.c_name is null|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
    --         "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
    --         "{{#clear_external_data:}}") or ',,,,,'
    --     inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
    --     if inf2013s[1] == '' then
    --         inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ base.x_col2013taxon c left join _taxon_tree b on (b.taxon_id=c.c_taxon_id)|where=c.c_name='"..
    --             mladb.."'|data=tid=b.taxon_id,nam=b.name,typ=b.rank,pid=b.parent_id,skc=b.number_of_children,skr=b.total_species}}"..
    --             "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
    --             "{{#clear_external_data:}}") or ',,,,,'
    --         inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }
    --     end
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
    aut2013 = aut2013s[1] or ''
    
    local aut2013k = ''
    if aut2013 ~= '' then
        aut2013k = Komentaras._kom(aut2013, 'Lotyniško pavadinimo autorius iš COL2013.') or ''
    end
    
    local sin2013 = ''
    local sin2013m = ''
    if #colidm == 1 and colid ~= '' then
        sin2013m = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ synonym s "..
            "LEFT JOIN synonym_name sn ON ( s.id = sn.id ) |where=taxon_id="..
            colid.."|order by=sn.name|data=sin=s.id}}"..
            "{{#for_external_table:{{{sin}}};}}"..
            "{{#clear_external_data:}}") or ''
        
        -- rsin.wikitext('Nuo='.. nuo ..';Kiek='..kiek..';Nex='..nex..';inf2013s[1]='..inf2013s[1])
        -- local kiek1 = kiek + 1
        -- sin2013m = frame:preprocess("{{#get_db_data:|db=col2013ac|from=taxon.Skaiciai s left join " ..
        --     "(SELECT sy.id, ifnull(bsn.c_name,sn.name) name, 1 sk from col2013ac.synonym sy " ..
        --     " LEFT JOIN synonym_name sn ON ( sy.id = sn.id ) " ..
        --     " LEFT JOIN base.x_col2013synonym bsn ON ( sy.id = bsn.c_synonym_id ) " ..
        --     "where sy.taxon_id="..
        --     inf2013s[1].." ORDER BY 2 ASC limit "..nuo..","..kiek1 ..
        --     ") a on (s.nr=a.sk)|where=s.nr=1|data=sin=a.id}}"..
        --     "{{#for_external_table:{{{sin}}};}}"..
        --     "{{#clear_external_data:}}") or ''
    end
    
    -- gbifid = sin.getla( pages, 'gbifid' )
    if gbifid == '' then
        gbifid = jsongbif._get1{ la = mladb } or ''
    end
    -- if gbifid == '' then
    --    local gbif1 = frame:preprocess("{{#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
    --        ladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
    --        "{{#for_external_table:{{{id}}}}}{{#clear_external_data:}}") or ''
    --    if gbif1 ~= '' and gbif1 ~= nil then
    --       gbifid = gbif1
    --    end
    -- end
    -- if gbifid == '' then
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
    --            gbifid = sgb[1]
    --         end
    --      elseif #sgb == 2 then
    --         gbifid = sgb[1]
    --      end
    --    end
    -- end
    -- if gbifid == '' then
    --     local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
    --                                         " (select distinct t.name, t.gbif_id " ..
    --                                         "  from paplitimas t " ..
    --                                         "  where t.name = '" .. ladb .. "') tt " ..
    --                                         "|where=tt.name='"..
    --         ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
    --         "{{#for_external_table:{{{gbif}}};}}"..
    --         "{{#clear_external_data:}}") or ''
    --     if sgbifid ~= '' then
    --         sgbifids = mw.text.split(sgbifid,';') or {}
    --         if #sgbifids == 2 then
    --         if sgbifids[1] ~= '0' then
    --             gbifid = sgbifids[1]
    --         end
    --         end
    --         if #sgbifids == 3 then
    --         if sgbifids[1] ~= '0' and sgbifids[2] == '0' then
    --             gbifid = sgbifids[1]
    --         end
    --         end
    --     end
    -- end
    local singbifm = {}
    
    if gbifid ~= '' then 
        local singbifj = frame:preprocess("{{#get_web_data:url=http://api.gbif.org/v1/species/"..gbifid..
            "/synonyms?limit=300|format=json text}}") or '{}'
        if singbifj ~= nil then
            singbifm = json.decode(singbifj)
            table.sort(singbifm.results, _compCanonicalName)
            for j, singbife in ipairs( singbifm.results ) do
                singbife.authorship = mw.text.listToText(mw.text.split( singbife.authorship, " & " ), ", ", ", ")
                singbife.authorship = mw.text.listToText(mw.text.split( singbife.authorship, " and " ), ", ", ", ")
                singbife.authorship = mw.text.listToText(mw.text.split( singbife.authorship, " ex " ), ", ", ", ")
                singbife.authorship = mw.text.listToText(mw.text.split( singbife.authorship, " in " ), ", ", ", ")
            end
        end
    end

    -- eolid = sin.getla( pages, 'eolid' )
    if eolid == '' then
        eolid = jsoneol._get1{ la = mladb } or ''
    end
    -- if eolid == '' then
    --     local ladburl = mw.text.listToText(mw.text.split( ladb, " " ), "+", "+")
    --     local pheolidj = frame:preprocess("{{#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
    --         ladburl .. "&page=1&exact=true&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    --     local pheolid = json.decode(pheolidj)
    --     if pheolid == nil or pheolid.totalResults == 0 then
    --         pheolidj = frame:preprocess("{{#get_web_data:url=http://eol.org/api/search/1.0.json?q=" ..
    --             ladburl .. "&page=1&exact=false&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl=|format=json text}}") or '{}'
    --         pheolid = json.decode(pheolidj)
    --     end
    --     if pheolid ~= nil and pheolid.results ~= nil then
    --         if pheolid.totalResults == 1 then
    --             eolid = pheolid.results[1].id
    --         end
    --     end
    -- end
    local sineolm = {}
    
    if eolid ~= '' then 
        local sineolj = frame:preprocess("{{#get_web_data:url=http://eol.org/api/pages/1.0/"..eolid..
            ".json?images=0&videos=0&sounds=0&maps=0&text=0&iucn=false&subjects=overview&licenses=all&details=false&common_names=false&synonyms=true&references=false&vetted=0&cache_ttl=|format=json text}}") or '{}'
        if sineolj ~= nil then
            sineolm = json.decode(sineolj)
            -- table.sort(sineolm.synonyms, _compEolCanonicalName)
            -- local mas, k = {}, 0
            -- for j, sineole in ipairs( sineolm.synonyms ) do
            --     if j == 1 then
            --         k = k + 1
            --         mas[k] = sineole
            --         mas[k].synonym = mw.text.decode(mas[k].synonym)
            --     elseif mas[k].synonym ~= sineole.synonym then
            --         k = k + 1
            --         mas[k] = sineole
            --         mas[k].synonym = mw.text.decode(mas[k].synonym)
            --     end
            -- end
            -- sineolm.synonyms = mas
            if sineolm ~= nil then
            for j, sineole in ipairs( sineolm.synonyms ) do
                t1, t2 = mw.ustring.match( sineole.synonym, '^(.-)(%<.-)$' )
                if t1 ~= nil and t2 ~= nil then
                    sineole.canonicalName = t1
                    sineole.authorship = t2
                    t2 = mw.ustring.match( sineole.authorship, '^%<.-%>(.-)%<.-%>$' )
                    sineole.authorship = t2
                else
                    t1, t2 = mw.ustring.match( sineole.synonym, '^(.-) (sensu .-)$' )
                    if t1 ~= nil then
                        sineole.canonicalName = t1
                        sineole.authorship = t2
                    else
                        t1, t2 = mw.ustring.match( sineole.synonym, '^(.-) (%L.-)$' )
                        if t1 ~= nil then
                            sineole.canonicalName = t1
                            sineole.authorship = t2
                            t1, t2 = mw.ustring.match( sineole.authorship, '^(%(%u%l-%) %l-) (%L.-)$' )
                            if t1 ~= nil then
                                sineole.canonicalName = sineole.canonicalName .. ' ' .. t1
                                sineole.authorship = t2
                            end
                        else
                            sineole.canonicalName = sineole.synonym
                            sineole.authorship = ''
                        end
                    end
                end
                -- repeat
                --     t1, t2, t3 = mw.ustring.match( sineole.authorship, '^(.+) %((.-)%) (.+)$' )
                --     sineole.authorship = t1 .. ', ' .. t2 .. ', ' .. t3
                -- until t1~=nil
                -- repeat
                --     t1, t2 = mw.ustring.match( sineole.authorship, '^(.+) %((.-)%)$' )
                --     sineole.authorship = t1 .. ', ' .. t2
                -- until t1~=nil
                -- repeat
                --     t1, t2 = mw.ustring.match( sineole.authorship, '^%((.-)%) (.+)$' )
                --     sineole.authorship = t1 .. ', ' .. t2
                -- until t1~=nil
                -- t1 = mw.ustring.match( sineole.authorship, '^%((.-)%)$' )
                -- sineole.authorship = t1
                if sineole == nil or sineole.authorship == nil then
                    sineole.authorship = ''
                end
                sineole.authorship = mw.text.listToText(mw.text.split( sineole.authorship, " & " ), ", ", ", ")
                sineole.authorship = mw.text.listToText(mw.text.split( sineole.authorship, " and " ), ", ", ", ")
                sineole.authorship = mw.text.listToText(mw.text.split( sineole.authorship, " ex " ), ", ", ", ")
                sineole.authorship = mw.text.listToText(mw.text.split( sineole.authorship, " in " ), ", ", ", ")
            end
            end
        end
    end

    local rtxt = page:getContent() or ""
    local i = 0
    local titl = true
    for sinid in mw.text.gsplit(sin2013m,';') do
        i = i + 1
            
        if i > nuo + kiek then
            rsin.wikitext('<center>[['..nex..'|Daugiau sinonimų]]</center>')
            --rsin.wikitext(frame:preprocess('[[Kategorija:Nesukurtas puslapis daugiau sinonimų]]'))
            local pagesin, err = mw.title.new(nex)
            --if pagesin and pagesin.id ~= 0 then
                rtxtsin = pagesin:getContent()
                if rtxtsin == nil then
                    rsin.wikitext('[[Kategorija:Nesukurtas puslapis daugiau sinonimų]]')
                end
            --end
            rsin.newline()
            break
        end
        if i > nuo then
            if sinid ~= '' then
                local sin2013i = frame:preprocess("{{#get_db_data:|db=col2013ac|from=/* "..pgname.." */ synonym s " ..
                    "LEFT JOIN synonym_name sn ON ( s.id = sn.id ) " ..
                    "LEFT JOIN base.x_col2013synonym bsn ON ( s.id = bsn.c_synonym_id ) " ..
                    "LEFT JOIN aut_met sas ON ( sas.id = s.author_string_id ) |where=s.id="..
                    sinid.."|data=sin=ifnull(bsn.c_name,sn.name),auts=sas.string,aut=sas.aut,met=sas.met,alt=sn.name}}"..
                    "{{#for_external_table:{{{sin}}};{{{auts}}};{{{aut}}};{{{met}}};{{{alt}}};}}"..
                    "{{#clear_external_data:}}") or ''
                local sin2013n = mw.text.split( sin2013i, ';' )
                if sin2013n[1] ~= '' then
                    if titl then
                        rsin.wikitext("'''Pagal [[Gyvybės katalogas|COL2013]]''':")
                        rsin.newline()
                        titl = false
                    end
                    local singbifo = nil
                    if singbifm.results ~= nil then
                        for j, singbife in ipairs( singbifm.results ) do
                            if singbife.canonicalName == sin2013n[1] then
                                singbifo = singbife
                                --table.remove( singbifm.results, j )
                                break
                            end
                        end
                    end
                    local sineolo = nil
                    if sineolm~=nil and sineolm.synonyms ~= nil then
                        for j, sineole in ipairs( sineolm.synonyms ) do
                            if sineole.canonicalName == sin2013n[1] then
                                sineolo = sineole
                                --table.remove( sineolm.synonyms, j )
                                break
                            end
                        end
                    end
                    --local ret = mw.ustring.match( rtxt, "%c%s*%|%s*Lotyniškai%s*=%s*(" .. sin2013n[1] .. ")%s*[%c%|%}]" ) or ''
                    --if ret == '' then
                    local parmsSyn = ParmData._get{ page = sin2013n[1], 
                        parm = {'ITIS', 'CBIF', 'GBIF', 'Pavadinimo autorius', 'Pavadinimo metai', 'WoRMS', 'Malacolog', 'Gastropods', 
                        'Paleodb', 'Birdlife', 'COL2013', 'EOL', 'PlantsL', 'PlantsLRefId', 'JSTOR', 'Tropicos', 'wiki' }, template = 'Sinonimas' }
                    
                        --local rpages = mw.title.new( sin2013n[1] )
                        local sargs = {}
                        sargs['Lotyniškai'] = sin2013n[1]
                        sargs['Pavadinimo autorius'] = sin2013n[3]
                        sargs['Pavadinimo metai'] = sin2013n[4]
                        sargs['COL2013'] = colid
                        --if sin2013n[1] ~= sin2013n[5] then
                            sargs['alt'] = sin2013n[5]
                        --end
                        sargs['Priklauso'] = mla

                        local el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['ITIS'] or ''
                        end
                        if el ~= '' then
                            sargs['ITIS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['CBIF'] or ''
                        end
                        if el ~= '' then
                            sargs['CBIF'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['GBIF'] or ''
                        end
                        if el ~= '' then
                            sargs['GBIF'] = el
                        elseif singbifo ~= nil then
                            sargs['GBIF'] = singbifo.taxonID
                        end
                        if sin2013n[3] == '' then
                            el = ''
                            if parmsSyn ~= nil then
                                el = parmsSyn['Pavadinimo autorius'] or ''
                            end
                            if el ~= '' then
                               sargs['Pavadinimo autorius'] = el
                            end
                        end
                        if sin2013n[4] == '' then
                            el = ''
                            if parmsSyn ~= nil then
                                el = parmsSyn['Pavadinimo metai'] or ''
                            end
                            if el ~= '' then
                               sargs['Pavadinimo metai'] = el
                            end
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['WoRMS'] or ''
                        end
                        if el ~= '' then
                            sargs['WoRMS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Malacolog'] or ''
                        end
                        if el ~= '' then
                            sargs['Malacolog'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Gastropods'] or ''
                        end
                        if el ~= '' then
                            sargs['Gastropods'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Paleodb'] or ''
                        end
                        if el ~= '' then
                            sargs['Paleodb'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Birdlife'] or ''
                        end
                        if el ~= '' then
                            sargs['Birdlife'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['EOL'] or ''
                        end
                        if el ~= '' then
                            sargs['EOL'] = el
                        elseif sineolo ~= nil then
                            sargs['EOL'] = eolid
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsL'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsL'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsLRefId'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsLRefId'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['JSTOR'] or ''
                        end
                        if el ~= '' then
                            sargs['JSTOR'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Tropicos'] or ''
                        end
                        if el ~= '' then
                            sargs['Tropicos'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['wiki'] or ''
                        end
                        if el ~= '' then
                            sargs['wiki'] = el
                        end
                        
                        rsin.wikitext(sin._esin(sargs))
                        rsin.wikitext( Cite._isn ( frame, {}, { sin2013n[1] .. ' '..
                            Komentaras._kom(sin2013n[2], 'Lotyniško pavadinimo autorius iš COL2013.')..
                            ' [[Gyvybės katalogas]]. (' .. 
                            frame:preprocess('{{en|[[col:|Catalogue of Life]], COL – Species 2010 – Species 2013}}')..
                            '). COL 2013 sinonimo ID: '..sinid, nil } ) )
                        if singbifo ~= nil and singbifo.taxonID ~= nil then
                            rsin.wikitext( Cite._isn ( frame, {}, { (singbifo.canonicalName or singbifo.scientificName) .. ' '..
                                Komentaras._kom(singbifo.authorship, 'Lotyniško pavadinimo autorius iš GBIF.')..
                                ' [[Globalios biologinės įvairovės informacijos priemonė]]. (' .. 
                                frame:preprocess('{{en|The Global Biodiversity Information Facility, GBIF}}')..
                                '). GBIF sinonimo ID: [[gbifws:'..singbifo.taxonID..'|'..singbifo.taxonID..
                                ']] [[gbifws:'..singbifo.taxonID..'|WWW]]', nil } ) )
                            if singbifo.publishedIn ~= nil then
                                rsin.wikitext( Cite._isn ( frame, {}, { singbifo.publishedIn, nil } ) )
                            end
                        end
                            
                        rsin.newline()
                    --end
                end
            end
        end
    end
    j = 0
    titl = true
    if singbifm.results ~= nil and i <= (nuo + kiek) and #(singbifm.results) > 0 then
        for j, singbife in ipairs( singbifm.results ) do
            if (i + j) > nuo + kiek then
                rsin.wikitext('<center>[['..nex..'|Daugiau sinonimų]]</center>')
                local pagesin, err = mw.title.new(nex)
                --if pagesin and pagesin.id ~= 0 then
                    rtxtsin = pagesin:getContent()
                    if rtxtsin == nil then
                        rsin.wikitext('[[Kategorija:Nesukurtas puslapis daugiau sinonimų]]')
                    end
                --end
                rsin.newline()
                break
            end
            if (i + j) > nuo and singbife.taxonID ~= nil then
                    --local ret = mw.ustring.match( rtxt, "%c%s*%|%s*Lotyniškai%s*=%s*(" .. singbife.canonicalName .. ")%s*[%c%|%}]" ) or ''
                    --if ret == '' then
                    if titl then
                        rsin.wikitext("'''Pagal [[Globalios biologinės įvairovės informacijos priemonė|GBIF]]''':")
                        rsin.newline()
                        titl = false
                    end
                    local parmsSyn = ParmData._get{ page = (singbife.canonicalName or singbife.scientificName), 
                        parm = {'ITIS', 'CBIF', 'GBIF', 'Pavadinimo autorius', 'Pavadinimo metai', 'WoRMS', 'Malacolog', 'Gastropods', 
                        'Paleodb', 'Birdlife', 'COL2013', 'EOL', 'PlantsL', 'PlantsLRefId', 'JSTOR', 'Tropicos', 'wiki' }, template = 'Sinonimas' }
                    
                        -- local rpages = mw.title.new( singbife.canonicalName )
                        local sargs = {}
                        sargs['Lotyniškai'] = singbife.canonicalName or singbife.scientificName
                        sargs['alt'] = singbife.canonicalName or singbife.scientificName
                        sargs['Pavadinimo autorius'] = singbife.authorship
                        sargs['Priklauso'] = mla
                        sargs['GBIF'] = singbife.taxonID

                        local el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['COL2013'] or ''
                        end
                        if el ~= '' then
                            sargs['COL2013'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['ITIS'] or ''
                        end
                        if el ~= '' then
                            sargs['ITIS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['CBIF'] or ''
                        end
                        if el ~= '' then
                            sargs['CBIF'] = el
                        end
                        --if sin2013n[3] == '' then
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Pavadinimo autorius'] or ''
                        end
                           if el ~= '' then
                               sargs['Pavadinimo autorius'] = el
                           end
                        --end
                        --if sin2013n[4] == '' then
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Pavadinimo metai'] or ''
                        end
                           if el ~= '' then
                               sargs['Pavadinimo metai'] = el
                           end
                        --end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['WoRMS'] or ''
                        end
                        if el ~= '' then
                            sargs['WoRMS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Malacolog'] or ''
                        end
                        if el ~= '' then
                            sargs['Malacolog'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Gastropods'] or ''
                        end
                        if el ~= '' then
                            sargs['Gastropods'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Paleodb'] or ''
                        end
                        if el ~= '' then
                            sargs['Paleodb'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Birdlife'] or ''
                        end
                        if el ~= '' then
                            sargs['Birdlife'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['EOL'] or ''
                        end
                        if el ~= '' then
                            sargs['EOL'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsL'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsL'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsLRefId'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsLRefId'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['JSTOR'] or ''
                        end
                        if el ~= '' then
                            sargs['JSTOR'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Tropicos'] or ''
                        end
                        if el ~= '' then
                            sargs['Tropicos'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['wiki'] or ''
                        end
                        if el ~= '' then
                            sargs['wiki'] = el
                        end
                        
                        rsin.wikitext(sin._esin(sargs))
                        rsin.wikitext( Cite._isn ( frame, {}, { (singbife.canonicalName or singbife.scientificName) .. ' '..
                            Komentaras._kom(singbife.authorship, 'Lotyniško pavadinimo autorius iš GBIF.')..
                            ' [[Globalios biologinės įvairovės informacijos priemonė]]. (' .. 
                            frame:preprocess('{{en|The Global Biodiversity Information Facility, GBIF}}')..
                            '). GBIF sinonimo ID: [[gbifws:'..singbife.taxonID..'|'..singbife.taxonID..
                                ']] [[gbifws:'..singbife.taxonID..'|WWW]]', nil } ) )
                        if singbife.publishedIn ~= nil then
                            rsin.wikitext( Cite._isn ( frame, {}, { singbife.publishedIn, nil } ) )
                        end
                            
                        rsin.newline()
                    --end
            end
        end
    end
    if singbifm.results ~= nil then
        i = i + #(singbifm.results)
    end
    j = 0
    titl = true
    if sineolm ~= nil and sineolm.synonyms ~= nil and i <= (nuo + kiek) and #(sineolm.synonyms) > 0 then
        for j, sineole in ipairs( sineolm.synonyms ) do
            if (i + j) > nuo + kiek then
                rsin.wikitext('<center>[['..nex..'|Daugiau sinonimų]]</center>')
                local pagesin, err = mw.title.new(nex)
                --if pagesin and pagesin.id ~= 0 then
                    rtxtsin = pagesin:getContent()
                    if rtxtsin == nil then
                        rsin.wikitext('[[Kategorija:Nesukurtas puslapis daugiau sinonimų]]')
                    end
                --end
                rsin.newline()
                break
            end
            if (i + j) > nuo then
                    --local ret = mw.ustring.match( rtxt, "%c%s*%|%s*Lotyniškai%s*=%s*(" .. sineole.canonicalName .. ")%s*[%c%|%}]" ) or ''
                    --if ret == '' then
                    if titl then
                        rsin.wikitext("'''Pagal [[Gyvybės enciklopedija|EOL]]''':")
                        rsin.newline()
                        titl = false
                    end
                    local parmsSyn = ParmData._get{ page = sineole.canonicalName, 
                        parm = {'ITIS', 'CBIF', 'GBIF', 'Pavadinimo autorius', 'Pavadinimo metai', 'WoRMS', 'Malacolog', 'Gastropods', 
                        'Paleodb', 'Birdlife', 'COL2013', 'EOL', 'PlantsL', 'PlantsLRefId', 'JSTOR', 'Tropicos', 'wiki' }, template = 'Sinonimas' }
                    
                        --local rpages = mw.title.new( sineole.canonicalName )
                        local sargs = {}
                        sargs['Lotyniškai'] = sineole.canonicalName
                        sargs['alt'] = sineole.canonicalName
                        sargs['Pavadinimo autorius'] = sineole.authorship
                        sargs['Priklauso'] = mla
                        sargs['EOL'] = eolid

                        local el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['COL2013'] or ''
                        end
                        if el ~= '' then
                            sargs['COL2013'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['ITIS'] or ''
                        end
                        if el ~= '' then
                            sargs['ITIS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['CBIF'] or ''
                        end
                        if el ~= '' then
                            sargs['CBIF'] = el
                        end
                        --if sin2013n[3] == '' then
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Pavadinimo autorius'] or ''
                        end
                           if el ~= '' then
                               sargs['Pavadinimo autorius'] = el
                           end
                        --end
                        --if sin2013n[4] == '' then
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Pavadinimo metai'] or ''
                        end
                           if el ~= '' then
                               sargs['Pavadinimo metai'] = el
                           end
                        --end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['WoRMS'] or ''
                        end
                        if el ~= '' then
                            sargs['WoRMS'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Malacolog'] or ''
                        end
                        if el ~= '' then
                            sargs['Malacolog'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Gastropods'] or ''
                        end
                        if el ~= '' then
                            sargs['Gastropods'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Paleodb'] or ''
                        end
                        if el ~= '' then
                            sargs['Paleodb'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Birdlife'] or ''
                        end
                        if el ~= '' then
                            sargs['Birdlife'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['GBIF'] or ''
                        end
                        if el ~= '' then
                            sargs['GBIF'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsL'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsL'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['PlantsLRefId'] or ''
                        end
                        if el ~= '' then
                            sargs['PlantsLRefId'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['JSTOR'] or ''
                        end
                        if el ~= '' then
                            sargs['JSTOR'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['Tropicos'] or ''
                        end
                        if el ~= '' then
                            sargs['Tropicos'] = el
                        end
                        el = ''
                        if parmsSyn ~= nil then
                            el = parmsSyn['wiki'] or ''
                        end
                        if el ~= '' then
                            sargs['wiki'] = el
                        end
                        
                        rsin.wikitext(sin._esin(sargs))
                        rsin.wikitext( Cite._isn ( frame, {}, { sineole.canonicalName .. ' '..
                            Komentaras._kom(sineole.authorship, 'Lotyniško pavadinimo autorius iš EOL.')..
                            ' [[Gyvybės enciklopedija]]. (' .. 
                            frame:preprocess('{{en|Encyclopedia of Life, EOL}}')..
                            '). EOL sinonimas: [[eoln:'..eolid..'|'..sineole.synonym..
                                ']]', nil } ) )
                            
                        rsin.newline()
                    --end
            end
        end
    end
    
    if (args['sinonimai'] and args['sinonimai'] ~= '') or 
       (args['sinonimai2'] and args['sinonimai2'] ~= '') or 
       (args['sinonimai3'] and args['sinonimai3'] ~= '') or sin2013m ~= '' or 
       (singbifm.results ~= nil and #(singbifm.results) > 0) or
       (sineolm ~= nil and sineolm.synonyms ~= nil and #(sineolm.synonyms) > 0) then
        local spav = args['sinonimų pavadinimas'] or 'Sinonimai'
        if spav == '' then
            spav = 'Sinonimai'
        end
        if nuo == 0 then
            root
                .wikitext('|- style="text-align:center;"')
                .newline()
                .wikitext('! style="background:') 
                .wikitext(args['spalva'])
                .wikitext('" | ')
                .wikitext(spav)
                .wikitext(args['sinonimai3'])
                .newline()
                .wikitext('|- style="font-size: 90%;"')
                .newline()
                .wikitext('| style="font-size: 90%;" |')
                .newline()
        else
            root.wikitext(frame:preprocess('[[Kategorija:'..mlt..'| ]]'))
        end
        if sin2013m ~= '' or singbifm.results ~= nil or (sineolm ~= nil and sineolm.synonyms ~= nil) then
            root
                .wikitext(tostring(rsin))
                .newline()
        end
            if args['sinonimai2'] and args['sinonimai2'] ~= '' then
                root
                    .newline()
                    .wikitext('----')
                    .newline()
                    .wikitext(args['sinonimai2'])
                    .newline()
            end
            if args['sinonimai'] and args['sinonimai'] ~= '' then
                root
                    .newline()
                    .wikitext('----')
                    .newline()
                    .wikitext(args['sinonimai'])
                    .newline()
            end
        if nuo == 0 then
            root
                .wikitext('|-')
        end
    end
    
    root
        -- .newline()
        .done()
    return tostring(root)
end

function sin.ssin(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(conf) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._ssin(args)
end
 
sin._itis = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (TSN ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas ITIS id.', 'Nenurodytas ITIS id.', 'itis:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[itis:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[itis:|Integruota Taksonominė Informacinė Sistema]]. (ITIS)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.itis(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._itis(args)
end
 
sin._cbif = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (TSN ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas CBIF id.', 'Nenurodytas CBIF id.', 'cbif-tsn:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[cbif-tsn:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[cbif-tsn:|Kanados Integruota Taksonominė Informacinė Sistema]]. (CBIF)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.cbif(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._cbif(args)
end
 
sin._worms = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas WoRMS id.', 'Nenurodytas WoRMS id.', 'wormsm:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[wormsd:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[wormsm:|Pasaulio jūros rūšių registras]]. (WoRMS)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.worms(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._worms(args)
end
 
sin._malacolog = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas Malakologijos id.', 'Nenurodytas Malakologijos id.', 'malacolog:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[malacolog:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[malacolog:|Vakarų Atlanto jūros moliuskų duomenų bazė]] (Malakologijos 4.1.1. versija).')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.malacolog(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._malacolog(args)
end
 
sin._gastropods = function( args )
    local _grp = args.GRP or conf.GRP or mw.text.trim(args[1] or conf[1] or '')
    local _id = args.ID or conf.ID or mw.text.trim(args[2] or conf[2] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[3] or conf[3] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' or _grp == '' then
        return Komentaras._kom('? Nenurodytas gastropods id.', 'Nenurodytas gastropods id.', 'gastropods:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[gastropods:')
        .wikitext(_grp)
        .wikitext('/Shell_')
        .wikitext(_id)
        .wikitext('.shtml|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_grp)
        .wikitext(',')
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext("]].  Eddie Hardy. [[gastropods:|Hardy's jūros pilvakojų interneto gidas]]. (Gastropods)")
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.gastropods(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._gastropods(args)
end
 
sin._paleodb = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas Paleodb id.', 'Nenurodytas Paleodb id.', 'paleodb:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[paleodb:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[paleodb:|Paleontologijos duomenų bazė]]. (PaleoDB)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.paleodb(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._paleodb(args)
end
 
sin._birdlife = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas Birdlife id.', 'Nenurodytas Birdlife id.', 'birdlifem:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parmsSyn = ParmData._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'alt' }, template = 'Sinonimas' }
        local parms = ParmData._get{ page = _txt, parm = {'la', 'lt' }, template = 'Auto_taxobox' }
        if parmsSyn ~= nil then
            mlas = parmsSyn['Lotyniškai'] or ''
            mlap = parmsSyn['Priklauso'] or ''
        end
        if parms ~= nil then
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
        
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[birdlife:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[birdlifem:|Paukščių gyvenimo tarptautinė svetainė]]. (BirdLife)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.birdlife(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._birdlife(args)
end
 
sin._gbif = function( args )
    local frame = mw.getCurrentFrame()
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Informacija paimta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    if _id == nil or _id == '' then
        if _txt == nil or _txt == '' then
            local page = mw.title.getCurrentTitle()
            local parms = Parm._get{ page = page.text, parm = {'gbifid', 'GBIF' } }
            if parms ~= nil then
                local mgb = parms['gbifid'] or ''
                local mgb2 = parms['GBIF'] or ''
                if mgb ~= '' then
                    _id = mgb
                elseif mgb2 ~= '' then
                    _id = mgb2
                else
                    return Komentaras._kom('? Nenurodytas GBIF id.', 'Nenurodytas GBIF id.', 'gbifd:')
                end
            else
                return Komentaras._kom('? Nenurodytas GBIF id.', 'Nenurodytas GBIF id.', 'gbifd:')
            end
        elseif not mw.ustring.find(_txt, "'") then
            local parms = Parm._get{ page = _txt, parm = {'gbifid', 'GBIF', 'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
            if parms ~= nil then
                local mgb = parms['gbifid'] or ''
                local mgb2 = parms['GBIF'] or ''
                if mgb ~= '' then
                    _id = mgb
                elseif mgb2 ~= '' then
                    _id = mgb2
                else
                    _id = ''
                end
                local mlas = parms['Lotyniškai'] or ''
                local mlap = parms['Priklauso'] or ''
                local mlaalt = parms['alt'] or ''
                local mla = parms['la'] or ''
                local mlt = parms['lt'] or ''
                if mlt ~= '' and mla ~= '' then
                    _txt = "'''"..mlt.."''' (''"..mla.."'')"
                elseif mla ~= '' then
                     _txt = "''"..mla.."''"
                elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
                     _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
                     mla = mlaalt
                elseif mlas ~= '' and mlap ~= '' then
                     _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
                     mla = mlas
                elseif mlas ~= '' and mlaalt ~= '' then
                     _txt = "''"..mlaalt.."''"
                     mla = mlaalt
                elseif mlas ~= '' then
                     _txt = "''"..mlas.."''"
                     mla = mlas
                else
                    mla = _txt
                    _txt  = "''".._txt.."''"
                end
                if _id == nil or _id == '' then
                    local root = HtmlBuilder.create()
                    root
                        .wikitext('[[gbif:')
                        .wikitext(mla)
                        .wikitext('|')
                        .wikitext(_txt)
                        .wikitext(']]. [[gbifd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). (' .. 
                                frame:preprocess('{{en|Global Biodiversity Information Facility (GBIF)}}') .. ').')
                        .wikitext(DTs)
                        .wikitext(_year)
                        .wikitext(DTv)
                        .wikitext(_date)
                        .wikitext(DTe)
                    
                    return tostring(root)
                end
            else
                return Komentaras._kom('? Nenurodytas GBIF id.', 'Nenurodytas GBIF id.', 'gbifd:')
            end
        else
            return Komentaras._kom('? Nenurodytas GBIF id.', 'Nenurodytas GBIF id.', 'gbifd:')
        end
    end
    if _txt == nil or _txt == '' then
        local page = mw.title.getCurrentTitle()
        local parms = Parm._get{ page = page.text, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
        if mlas == '' and mla == '' and mlt == '' then
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        else
            if mlt ~= '' and mla ~= '' then
                _txt = "'''"..mlt.."''' (''"..mla.."'')"
            elseif mla ~= '' then
                 _txt = "''"..mla.."''"
            elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
                 _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
            elseif mlas ~= '' and mlap ~= '' then
                 _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
            elseif mlas ~= '' and mlaalt ~= '' then
                 _txt = "''"..mlaalt.."''"
            elseif mlas ~= '' then
                 _txt = "''"..mlas.."''"
            else
                _txt, TSNs, TSNe  = '', 'TSN ', ''
            end
        end
    elseif not mw.ustring.find(_txt, "'") then
        local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
        if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
            local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
            if parms ~= nil then
                mlas = parms['Lotyniškai'] or ''
                mlap = parms['Priklauso'] or ''
                mlaalt = parms['alt'] or ''
                mla = parms['la'] or ''
                mlt = parms['lt'] or ''
            end
        else
            mlas = args['Lotyniškai']
            mlap = args.Priklauso
            mlaalt = args.alt or ''
        end
        
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
             mla = mlaalt
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
             mla = mlas
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
             mla = mlaalt
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
             mla = mlas
        else
            mla = _txt
            _txt  = "''".._txt.."''"
        end
    end
    
    local root = HtmlBuilder.create()
    root
        .wikitext('[[gbifc:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(' aptikimo vietos]]. [[gbifo:')
        .wikitext(_id)
        .wikitext('|Aptikimo vietų registravimo šaltiniai]]. [[gbifws:')
        .wikitext(_id)
        .wikitext('|Žemėlapis ir informacija]]. [[gbifws:')
        .wikitext(_id)
        .wikitext('|WWW]]. [[gbifd:|Globali biologinės įvairovės informacijos priemonė]] (GBĮIP). (' .. 
                            frame:preprocess('{{en|Global Biodiversity Information Facility (GBIF)}}') .. ').')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.gbif(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._gbif(args)
end
 
sin._plantl = function( args )
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[1] or conf[1] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe, _id = '', '', _txt
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlt ~= '' and mla ~= '' then
        _txt = "'''"..mlt.."''' (''"..mla.."'')"
        _id = mla
    elseif mla ~= '' then
         _txt = "''"..mla.."''"
         _id = mla
    elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlaalt
    elseif mlas ~= '' and mlap ~= '' then
         _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlas
    elseif mlas ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."''"
         _id = mlaalt
    elseif mlas ~= '' then
         _txt = "''"..mlas.."''"
         _id = mlas
    end
    _id = mw.uri.encode(_id)

    local root = HtmlBuilder.create()
    root
        .wikitext('[http://www.theplantlist.org/tpl/search?q=')
        .wikitext(_id)
        .wikitext(' ')
        .wikitext(_txt)
        .wikitext(']. [[plantlm:|Augalų sąrašas]]. Darbinis sąrašas visų augalų rūšių. (PlantsL. 2010. Versija 1.)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.plantl(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._plantl(args)
end
 
sin._plantsl = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (TSN ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    if _id == '' then
        return Komentaras._kom('? Nenurodytas PlantsL id.', 'Nenurodytas PlantsL id.', 'plantlm:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlt ~= '' and mla ~= '' then
        _txt = "'''"..mlt.."''' (''"..mla.."'')"
    elseif mla ~= '' then
         _txt = "''"..mla.."''"
    elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
    elseif mlas ~= '' and mlap ~= '' then
         _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
    elseif mlas ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."''"
    elseif mlas ~= '' then
         _txt = "''"..mlas.."''"
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[plantl-rec:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[plantlm:|Augalų sąrašas]]. Darbinis sąrašas visų augalų rūšių. (PlantsL. 2010. Versija 1.)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.plantsl(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._plantsl(args)
end
 
sin._jstor = function( args )
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[1] or conf[1] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe, _id = '', '', _txt
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlt ~= '' and mla ~= '' then
        _txt = "'''"..mlt.."''' (''"..mla.."'')"
        _id = mla
    elseif mla ~= '' then
         _txt = "''"..mla.."''"
         _id = mla
    elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlaalt
    elseif mlas ~= '' and mlap ~= '' then
         _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlas
    elseif mlas ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."''"
         _id = mlaalt
    elseif mlas ~= '' then
         _txt = "''"..mlas.."''"
         _id = mlas
    end
    _id = mw.uri.encode(_id)

    local root = HtmlBuilder.create()
    root
        .wikitext('[[plants:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(']]. [[plants:|Globalus augalų sąrašas]]. (JSTOR)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.jstor(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._jstor(args)
end
 
sin._tropicos = function( args )
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[1] or conf[1] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe, _id = '', '', _txt
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlt ~= '' and mla ~= '' then
        _txt = "'''"..mlt.."''' (''"..mla.."'')"
        _id = mla
    elseif mla ~= '' then
         _txt = "''"..mla.."''"
         _id = mla
    elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlaalt
    elseif mlas ~= '' and mlap ~= '' then
         _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
         _id = mlas
    elseif mlas ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."''"
         _id = mlaalt
    elseif mlas ~= '' then
         _txt = "''"..mlas.."''"
         _id = mlas
    end
    _id = mw.uri.encode(_id)

    local root = HtmlBuilder.create()
    root
        .wikitext('[http://www.tropicos.org/NameSearch.aspx?name=')
        .wikitext(_id)
        .wikitext(' ')
        .wikitext(_txt)
        .wikitext(']. [[tropicos:|Tropinių augalų sąrašas]]. (Tropicos)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.tropicos(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._tropicos(args)
end
 
sin._tropicosid = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (TSN ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas Tropicos id.', 'Nenurodytas Tropicos id.', 'tropicosn:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlt ~= '' and mla ~= '' then
        _txt = "'''"..mlt.."''' (''"..mla.."'')"
    elseif mla ~= '' then
         _txt = "''"..mla.."''"
    elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
    elseif mlas ~= '' and mlap ~= '' then
         _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
    elseif mlas ~= '' and mlaalt ~= '' then
         _txt = "''"..mlaalt.."''"
    elseif mlas ~= '' then
         _txt = "''"..mlas.."''"
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[tropicosn:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[tropicosn:|Tropinių augalų sąrašas]]. (Tropicos)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.tropicosid(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._tropicosid(args)
end
 
sin._eol = function( args )
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    if _id == '' then
        return Komentaras._kom('? Nenurodytas EOL id.', 'Nenurodytas EOL id.', 'eoln:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[eoln:')
        .wikitext(_id)
        .wikitext('/names/synonyms|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[eoln:|Gyvybės enciklopedija]]. (EOL)')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.eol(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._eol(args)
end
 
sin._col2013 = function( args )
    local frame = mw.getCurrentFrame()
    local _id = args.ID or conf.ID or mw.text.trim(args[1] or conf[1] or '')
    local _txt = args.taxon or conf.taxon or mw.text.trim(args[2] or conf[2] or '')
    local _date = args.date or conf.date or ''
    local _year = args.year or conf.year or ''
    local DTs, DTv, DTe = ' Tikrinta ', ' ', '.'
    local TSNs, TSNe = ' (ID ', ')'
    if _date == nil or _date == '' then
        _date, DTs, DTv, DTe, _year  = '', '', '', '', ''
    end
    
    if _id == '' then
        return Komentaras._kom('? Nenurodytas COL (Species 2013) id.', 'Nenurodytas COL (Species 2013) id.', 'col:')
    end
    
    local page = mw.title.getCurrentTitle()
    if _txt == nil or _txt == '' then
        _txt = page.text
    end
    local mlas, mlap, mlaalt, mla, mlt = '', '', '', '', ''
    if args.Priklauso == nil or args.Priklauso == '' or args['Lotyniškai'] == nil or args['Lotyniškai'] == '' then
        local parms = Parm._get{ page = _txt, parm = {'Lotyniškai', 'Priklauso', 'la', 'alt', 'lt' } }
        if parms ~= nil then
            mlas = parms['Lotyniškai'] or ''
            mlap = parms['Priklauso'] or ''
            mlaalt = parms['alt'] or ''
            mla = parms['la'] or ''
            mlt = parms['lt'] or ''
        end
    else
        mlas = args['Lotyniškai']
        mlap = args.Priklauso
        mlaalt = args.alt or ''
    end
    
    if mlas == '' and mla == '' and mlt == '' then
        _txt, TSNs, TSNe  = '', 'TSN ', ''
    else
        if mlt ~= '' and mla ~= '' then
            _txt = "'''"..mlt.."''' (''"..mla.."'')"
        elseif mla ~= '' then
             _txt = "''"..mla.."''"
        elseif mlas ~= '' and mlap ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlap ~= '' then
             _txt = "''"..mlas.."'' (''"..mlap.."'' – sinonimas)"
        elseif mlas ~= '' and mlaalt ~= '' then
             _txt = "''"..mlaalt.."''"
        elseif mlas ~= '' then
             _txt = "''"..mlas.."''"
        else
            _txt, TSNs, TSNe  = '', 'TSN ', ''
        end
    end

    local root = HtmlBuilder.create()
    root
        .wikitext('[[col2013id:')
        .wikitext(_id)
        .wikitext('|')
        .wikitext(_txt)
        .wikitext(TSNs)
        .wikitext(_id)
        .wikitext(TSNe)
        .wikitext(']]. [[Gyvybės katalogas]]. (' .. 
                            frame:preprocess('{{en|[[col:|Catalogue of Life]], COL – Species 2010 – Species 2013}}') .. '). ')
        .wikitext(DTs)
        .wikitext(_year)
        .wikitext(DTv)
        .wikitext(_date)
        .wikitext(DTe)
    
    return tostring(root)
end

function sin.col2013(frame)
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbox}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    local args = {}
    conf = frame.args
    local parent_args = frame:getParent().args;
 
    for k, v in pairs(parent_args) do
        if v ~= '' then
            args[k] = mw.text.trim(v)
        end
    end
    return sin._col2013(args)
end
 
return sin
