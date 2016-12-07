local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
--local Gref = require('Module:Gref')
--local Grefv = require('Module:Grefv')
local ValstVietininkas = require('Module:ValstybėsVietininkas')
local Switch = require('Module:Switch')
local Cite = require('Module:Cite')
local GgeSinonimas = require('Module:GgeSinonimas')
local Plural = require('Module:Plural')
local Parm = require('Module:Parm')

local tips = {  ['rūšis'] = true, 
                ['porūšis'] = true, 
                variatetas = true, 
                atmaina = true, 
                poatmaina = true, 
                forma = true, 
                poformis = true, 
                ['veislė'] = true 
             }
gpap = {}

gpap._grpcell = function( la, tip, pav, lst, frame )
    local tbl = HtmlBuilder.create()
    i = 0
    for lstel in mw.text.gsplit(lst,',') do
        local _lstel = mw.text.trim(lstel)
        if _lstel ~= '' then
            if i ~= 0 then tbl.wikitext(', ') end
            i = i+1
            
            local elems = mw.text.split( _lstel, ':' )
            if elems[2] == nil or elems[2] == '' then elems[2] = '?' end
            local viet = Switch._switch2( 'Switch/šalys', elems[1], 'vietininkas', elems[1] )
            local vel = Switch._switch2( 'Switch/šalys', elems[1], 'vėliava', '' )
            if viet == nill or viet == '' then viet = elems[1] end
            if vel ~= '' then
               vel = '[[Vaizdas:' .. vel .. '|25px|' .. elems[1] .. '|link=' .. elems[1] .. ']] '
            end
            
            -- frame:callParserFunction{ name = '#set', args = 'Šalies gyvosios gamtos sritis=Sritis:'..elems[1]..'/'..tip }
            -- frame:callParserFunction{ name = '#set', args = tip..' aptinkama šalyje='..elems[1] }
            -- frame:callParserFunction{ name = '#set', args = 'Šalys txt='..elems[1] }
            -- frame:callParserFunction{ name = '#subobject', 
            --         args = { 'Rūšys '..viet,
            --                 'Taksonas='..la,
            --                 'Taksono tipas='..tip,
            --                 'Taksono šalis='..elems[1],
            --                 'Taksonų skaičius='..elems[2] } }
            -- frame:callParserFunction{ name = '#set', args = 'Rūšių šalyje sritis=Sritis:'..pav..'/'..elems[1] }
            
            tbl
                .wikitext(vel)
                .wikitext(ValstVietininkas._viet( elems[1], elems[1], 'Sritis:'..elems[1]..'/'..tip ) )
                .wikitext(' (')
                .wikitext('[[Sritis:'..pav..'/'..elems[1]..'|'..elems[2]..']]')
                .wikitext(')')
        end
    end
    tbl.done()
    return tostring(tbl)
end

gpap._regcell = function( la, tip, lst, frame )
    local tbl = HtmlBuilder.create()
    i = 0
    for lstel in mw.text.gsplit(lst,',') do
        local _lstel = mw.text.trim(lstel)
        if _lstel ~= '' then
            if i ~= 0 then tbl.wikitext(', ') end
            i = i+1
            local vel = Switch._switch2( 'Switch/šalys', _lstel, 'vėliava', '' )
            if vel ~= '' then
               vel = '[[Vaizdas:' .. vel .. '|25px|' .. _lstel .. '|link=' .. _lstel .. ']] '
            end
            
            -- frame:callParserFunction{ name = '#set', args = 'Šalies gyvosios gamtos sritis=Sritis:'.._lstel..'/'..tip }
            -- frame:callParserFunction{ name = '#set', args = tip..' aptinkama regione='.._lstel }
            -- frame:callParserFunction{ name = '#set', args = 'Regionai txt='.._lstel }
            
            tbl
                .wikitext(vel)
                .wikitext(ValstVietininkas._viet( _lstel, _lstel, 'Sritis:'.._lstel..'/'..tip ) )
        end
    end
    tbl.done()
    return tostring(tbl)
end

function _compe( a, b )
	return mw.language.getContentLanguage():caseFold(a) < mw.language.getContentLanguage():caseFold(b)
end

function _compe1( a, b )
	return mw.language.getContentLanguage():caseFold(a[1]) < mw.language.getContentLanguage():caseFold(b[1])
end

gpap._salcell = function( la, tip, lst, frame, gbifs, pav )
	
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    local tbl = HtmlBuilder.create()
	local lstels = mw.text.split(lst,',') or {}
	for j = 1, #lstels do
		lstels[j] = mw.text.trim(lstels[j])
	end
	table.sort(lstels, _compe)
	if lstels == nil then lstels = {} end
	local gbifids = mw.text.split(gbifs,';')
	local gbifell = {}
	local k = 1
	for j = 1, #gbifids do
		if gbifids[j] ~= '' then
			local gbifinf = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ paplitimas tt |where=tt.id="..
				gbifids[j].." |data=name=tt.name,sal=tt.country,rus=tt.species,kiek=tt.ocurencies}}"..
				"{{#for_external_table:{{{sal}}};{{{name}}};{{{rus}}};{{{kiek}}}}}"..
				"{{#clear_external_data:}}") or ''
			--local gbifinfs = mw.text.split(gbifinf,';')
			gbifell[k] = mw.text.split(gbifinf,';')
			k = k+1
		end
	end
	table.sort(gbifell, _compe1)
    i = 0
	local lid, gid = 1, 1
	local coml = {}
	local sal = ''
	local salid = 0
	local k = 0
	while ((lid <= #lstels) or (gid <= #gbifell)) do
		local lstelsv = ''
		local lstelsk = ''
		local lstelsn = 0
		local lstelsm = {''}
		if lid <= #lstels then
			lstelsm = mw.text.split(lstels[lid],':') or {''}
			if #lstelsm > 0 then
				lstelsv = mw.text.trim(lstelsm[1])
			end
			if #lstelsm > 1 and not tips[tip] then
				lstelsn = tonumber(lstelsm[2])
                                if #lstelsm > 2 then
                                   lstelsk = lstelsm[3]
                                end
			elseif tips[tip] then
				lstelsn = 1
                                if #lstelsm > 1 then
                                   lstelsk = lstelsm[2]
                                end
			end
		end
		if lid <= #lstels and ((gid <= #gbifell and mw.language.getContentLanguage():caseFold(lstelsv) < mw.language.getContentLanguage():caseFold(mw.text.trim(gbifell[gid][1]))) or (gid > #gbifell)) then
			if lstelsv ~= '' then
				i = i+1
				-- penktas parametras:
				-- 0 - be aptikimų: [[1]]
				-- 1 - pirma eilutė: [[$1]] ($6 aptikimų:{$7})
				-- 2 - neišvedama (sekanti) eilutė.
				coml[i] = { lstelsv, la , lstelsn, 0, 0, 0, {}, 0, lstelsn, lstelsk } -- [[1]]
				sal = lstelsv
				salid = i
			end
			k = 0
			lid = lid+1
		else
			i = i+1
			coml[i] = { mw.text.trim(gbifell[gid][1]), gbifell[gid][2], tonumber(gbifell[gid][3]), tonumber(gbifell[gid][4]), 1, tonumber(gbifell[gid][4]), {}, tonumber(gbifell[gid][3]), 0, '' }
			if sal ~= mw.text.trim(gbifell[gid][1]) then
				sal = mw.text.trim(gbifell[gid][1])
				salid = i
				k = 0
				if la ~= gbifell[gid][2] then
					k = k+1
					coml[salid][7][k] = { gbifell[gid][2], tonumber(gbifell[gid][4]), tonumber(gbifell[gid][3]) }
				end
			else
				coml[salid][6] = coml[salid][6] + tonumber(gbifell[gid][4])
				coml[salid][8] = coml[salid][8] + tonumber(gbifell[gid][3])
				coml[i][5] = 2
				if la ~= gbifell[gid][2] then
					k = k+1
					coml[salid][7][k] = { gbifell[gid][2], tonumber(gbifell[gid][4]), tonumber(gbifell[gid][3]) }
				end
			end
			if lid <= #lstels then 
				if lstelsv == mw.text.trim(gbifell[gid][1]) and coml[salid][9] == 0 then
					if lstelsn ~= 0 then
						--coml[salid][8] = coml[salid][8] + lstelsn
						coml[salid][9] = lstelsn
					end
					coml[salid][10] = lstelsk
					lid = lid+1
				end
			end
			gid = gid+1
		end
	end
	
	k = 1
	for i = 1, #coml do
                local vel = Switch._switch2( 'Switch/šalys', coml[i][1], 'vėliava', '' )
                if vel ~= '' then
                   vel = '[[Vaizdas:' .. vel .. '|25px|' .. coml[i][1].. '|link=' .. coml[i][1].. ']]'
                end
		if coml[i][5] == 0 then
			--if k ~= 1 then tbl.wikitext(', ') end
			tbl
                            .newline()
		            .wikitext('|-')
                            .newline()
		            .wikitext('| ')
		            .wikitext(vel)
                            .newline()
		            .wikitext('| ')
                            .wikitext(ValstVietininkas._viet( coml[i][1], coml[i][1], 'Sritis:'..coml[i][1]..'/'..tip ) )
			if not tips[tip] then
			   tbl
                              .newline()
		              .wikitext('| ')
                              .newline()
		              .wikitext('| align="right" | ')
                           if coml[i][9] ~= 0 then
                              tbl.wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][9])..']]')
                           end
                           tbl
                              .newline()
		              .wikitext('| align="right" | ')
                              .wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][9])..']]')
			--if coml[i][9] ~= 0 then
			--	tbl
			--		.wikitext(' (')
			--		.wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][9])..']]')
			--		--.wikitext(tostring(coml[i][9]))
			--		.wikitext(' ')
			--		.wikitext(Komentaras._kom(Plural._plural( {coml[i][9], 'rūšis ELIP', 'rūšys ELIP', 'rūšių ELIP'} ), 'ELIP registruotų aptinkamų rūšių skaičius.'))
			--		.wikitext(')')
			--end
			end
			if gbifs ~= '' then
			   tbl
                              .newline()
		              .wikitext('| ')
                        end
			   tbl
                              .newline()
		              .wikitext('| align="center" | +')
                              .newline()
		              .wikitext('| ')
		              .wikitext(coml[i][10])
                              .newline()
			k = k+1
		elseif coml[i][5] == 1 then
			--if k ~= 1 then tbl.wikitext(', ') end
			tbl
                            .newline()
		            .wikitext('|-')
                            .newline()
		            .wikitext('| ')
		            .wikitext(vel)
                            .newline()
		            .wikitext('| ')
                            .wikitext(ValstVietininkas._viet( coml[i][1], coml[i][1], 'Sritis:'..coml[i][1]..'/'..tip ) )
			if not tips[tip] then
			   tbl
                              .newline()
		              .wikitext('| align="right" | ')
                              .wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][8])..']]')
                              .newline()
		              .wikitext('| align="right" | ')
                           if coml[i][9] ~= 0 then
                              tbl.wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][9])..']]')
                           end
                           tbl
                              .newline()
		              .wikitext('| align="right" | ')
                              .wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][8] + coml[i][9])..']]')
			end

		        --   .wikitext(' (')
			--if not tips[tip] then
			--	tbl
			--		.wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][8])..']]')
			--		--.wikitext(tostring(coml[i][8]))
			--		.wikitext(' ')
			--	if coml[i][9] ~= 0 then
			--		tbl
			--			.wikitext(Komentaras._kom(Plural._plural( {coml[i][8], 'rūšis GBIF', 'rūšys GBIF', 'rūšių GBIF'} ), 'GBIF registruotų aptinkamų rūšių skaičius.'))
			--			.wikitext(' bei papildomai ')
			--			.wikitext('[[Sritis:'..pav..'/'..coml[i][1]..'|'..tostring(coml[i][9])..']]')
			--			--.wikitext(tostring(coml[i][8]))
			--			.wikitext(' ')
			--			.wikitext(Komentaras._kom(Plural._plural( {coml[i][8], 'rūšis ELIP', 'rūšys ELIP', 'rūšių ELIP'} ), 'ELIP registruotų aptinkamų rūšių skaičius.'))
			--	else
			--		tbl
			--			.wikitext(Komentaras._kom(Plural._plural( {coml[i][8], 'rūšis GBIF', 'rūšys GBIF', 'rūšių GBIF'} ), 'GBIF registruotų aptinkamų rūšių skaičius.'))
			--	end
			--	tbl
			--		.wikitext(', ')
			--end
			if gbifs ~= '' then
			   tbl
                              .newline()
		              .wikitext('| align="right" | ')
		              .wikitext(tostring(coml[i][6]))
			end
			   tbl
                              .newline()
		              .wikitext('| align="center" | ')
			   if coml[i][9] > 0 then
			      tbl
		                 .wikitext('+')
			   end
			   tbl
                              .newline()
		              .wikitext('| ')
		              .wikitext(coml[i][10])
                              .newline()
			--tbl
			--	.wikitext(tostring(coml[i][6]))
			--	.wikitext(' ')
			--	.wikitext(Komentaras._kom(Plural._plural( {coml[i][6], 'aptikimas', 'aptikimai', 'aptikimų'} ), 'GBIF registruotų aptikimų vietų skaičius.'))
			local sins = coml[i][7]
			if #sins > 0 then
				tbl
					--.wikitext(', ')
					.wikitext('GBĮIP sinonimais registruotų aptikimų vietų skaičius:')
					.newline()
				for j = 1, #sins do
					--if j ~= 1 then tbl.wikitext(', ') end
					tbl
						.wikitext('* ')
						.wikitext(tostring(sins[j][2]))
						.wikitext(" – ''[[")
						.wikitext(sins[j][1])
						.wikitext("]]''")
						.newline()
				end
			end
			--tbl
			--	.wikitext(')')
			k = k+1
		end
	end
	
    --for lstel in mw.text.gsplit(lst,',') do
    --    local _lstel = mw.text.trim(lstel)
    --    if _lstel ~= '' then
    --        if i ~= 0 then tbl.wikitext(', ') end
    --        i = i+1
            
            -- frame:callParserFunction{ name = '#set', args = 'Šalies gyvosios gamtos sritis=Sritis:'.._lstel..'/'..tip }
            -- frame:callParserFunction{ name = '#set', args = tip..' aptinkama šalyje='.._lstel }
            -- frame:callParserFunction{ name = '#set', args = 'Šalys txt='.._lstel }
            
    --        tbl
    --            .wikitext(ValstVietininkas._viet( _lstel, _lstel, 'Sritis:'.._lstel..'/'..tip ) )
    --    end
    --end
    tbl.done()
    return tostring(tbl)
end

gpap._grp = function( la, tip, pav, frame, sal, gbifs, dal1 )
    local root = HtmlBuilder.create()
    local _la, _tip, _pav, _sal = la or '', tip or '', pav or '', sal or ''
    
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    elseif _tip == '' then
        return Komentaras._kom('?', 'Nenurodytas tipas')
    elseif _pav == '' then
        _pav = _la
    end
    
    local frame = mw.getCurrentFrame()
    local _ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
    --local dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ tax_sal_det_rus|where=la='"..
    --    _ladb.."' and type='".._tip.."' and salis<>''|order by=salis|data=salis=salis,sk=sk}}"..
    --    "{{#for_external_table:{{{salis}}}:{{{sk}}},}}{{#clear_external_data:}}") or ''
    if dal1 ~= '' and gbifs == '' then
        root
            --.wikitext( 'Šalys kuriose yra aptinkamos rūšys: ' )
            --.wikitext(gpap._grpcell(_la, _tip, _pav, dal1, frame))
            .wikitext( gpap._salcell( _la, _tip, dal1, frame, gbifs, _pav ) )
            --.wikitext( ' – skliaustuose nurodyta aptinkamų rūšių skaičius.' )
            --.done()
    elseif gbifs ~= '' or _sal ~= '' then
        --root.wikitext( 'Šalys kuriose yra aptinkamos rūšys: ' )
        root.wikitext( gpap._salcell( _la, _tip, _sal, frame, gbifs, _pav ) )
        --root.wikitext( '.' )
    end
     
    return tostring(root)
end

gpap.grp = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _tip = args.tip or pargs.tip or mw.text.trim(args[2] or pargs[2] or '')
    local _pav = args.pav or pargs.pav or mw.text.trim(args[3] or pargs[3] or '')
    
    return gpap._pap( _la, '', _pav, _tip, '', '', '', '', '', '', '' )
end

gpap._pap = function( la, mires, lt, tip, aukn, auki, gyln, gyli, reg, sal, gbif )
    local root = HtmlBuilder.create()
    local _la, _tip, _mires, _lt = la or '', tip or '', mires or '', lt or ''
    local _aukn, _auki, _gyln, _gyli = aukn or '', auki or '', gyln or '', gyli or ''
    local _reg, _sal = reg or '', sal or ''
    local _gbif = gbif or ''
    
    local gbifidm = mw.text.split(_gbif,',') or {}
    if #gbifidm ~= 1 then
        _gbif = ''
    end
    
    local frame = mw.getCurrentFrame()
    local ladb = mw.text.listToText(mw.text.split( _la, "'" ), "''", "''")
    local pg = mw.title.getCurrentTitle()
    local pgname = pg.text
 
    local sgbifid = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from paplitimas t " ..
                                     "  where t.name = '" .. ladb .. "') tt " ..
                                     "|where=tt.name='"..
            ladb.."'|order by=tt.gbif_id desc|data=gbif=tt.gbif_id}}"..
            "{{#for_external_table:{{{gbif}}};}}"..
            "{{#clear_external_data:}}") or ''

    sgb = mw.text.split(sgbifid,';') or {}
    if sgbifid ~= '' and sgb[1] ~= '0' then
                local sgbifid3 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from paplitimas t " ..
                                     "  where t.gbif_id = " .. sgb[1] .. ") tt " ..
                                     "|where=tt.gbif_id="..
                   sgb[1].."|order by=tt.name|data=gbif=tt.name}}"..
                   "{{#for_external_table:{{{gbif}}};}}"..
                   "{{#clear_external_data:}}") or ''
                sgb3 = mw.text.split(sgbifid3,';') or {}

       if #sgb ~= 2 or #sgb3 > 2 then
       --if sgb[2] ~= '0' then
          root.newline()
          root.wikitext( '[[Globalios biologinės įvairovės informacijos priemonė|Globalios biologinės įvairovės informacijos priemonėje (GBĮIP)]] ' .. 
              _tip .. ' [[' .. ladb .. ']] yra registruota naudojant kelis identifikatorius:')
          root.newline()
          for s in mw.text.gsplit(sgbifid,';') do
              if s ~= '' then
                local sgbifid2 = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ " ..
                                     " (select distinct t.name, t.gbif_id " ..
                                     "  from paplitimas t " ..
                                     "  where t.gbif_id = " .. s .. ") tt " ..
                                     "|where=tt.gbif_id="..
                   s.."|order by=tt.name|data=gbif=tt.name}}"..
                   "{{#for_external_table:{{{gbif}}};}}"..
                   "{{#clear_external_data:}}") or ''

                root.wikitext( '* [[gbifws:' .. s .. '|' .. s .. ']]. ' )
              if s == '0' then
                root.wikitext( 'Šis identifikatorius yra naudojamas GBĮIP nepatvirtintos informacijos identifikavimui.' )
                root.newline()
              else
                sgb2 = mw.text.split(sgbifid2,';') or {}
                if #sgb2 ~= 2 then
                      root.wikitext( 'Šiuo identifikatoriumi yra registruotos kelios rūšys, kurių pavadinimai panaudoti kaip sinonimai:' )
                      root.newline()
                      for ss in mw.text.gsplit(sgbifid2,';') do
                          if ss ~= '' then
                            root.wikitext( '** [[' )
                            --root.wikitext( Gref.getla( ss, '', '', '', '', '', '' ) )
                            root.wikitext(  ss )
                            root.wikitext( ']] – pagal GBĮIP [[gbifw:' .. ss .. '|' .. ss .. ']]. ' )
                            root.newline()
                         end
                      end
                else
                      root.newline()
                end
              end
                --root.newline()
             end
          end
          root.newline()
       --end
       end
    end

    local dal1 = frame:preprocess("{{#get_db_data:|db=taxon|from=/* "..pgname.." */ tax_sal_det_rus|where=la='"..
        ladb.."' and type='".._tip.."' and salis<>''|order by=salis|data=salis=salis,sk=sk}}"..
        "{{#for_external_table:{{{salis}}}:{{{sk}}},}}{{#clear_external_data:}}") or ''

    if _gbif == '' then
       local gbif1 = frame:preprocess("{{#get_db_data:|db=base|from=/* "..pgname.." */ x_GBIFtax|where=c_name='"..
           ladb.."' |order by=c_taxon_id|data=id=c_taxon_id}}"..
           "{{#for_external_table:{{{id}}}}}{{#clear_external_data:}}") or ''
       if gbif1 ~= '' and gbif1 ~= nil then
          _gbif = gbif1
       end
    end
    if _gbif == '' then
        if sgbifid ~= '' then
            sgbifids = mw.text.split(sgbifid,';') or {}
            if #sgbifids == 2 then
            if sgbifids[1] ~= '0' then
                _gbif = sgbifids[1]
            end
            end
            if #sgbifids == 3 then
            if sgbifids[1] ~= '0' and sgbifids[2] == '0' then
                _gbif = sgbifids[1]
            end
            end
        end
    end
    if _gbif == '' then
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
               _gbif = sgb[1]
            end
         elseif #sgb == 2 then
            _gbif = sgb[1]
         end
       end
    end
    local gbifs = ''
    if _gbif ~= '' then
        gbifs = frame:preprocess("{{#get_db_data:|db=Paplitimas|from=/* "..pgname.." */ paplitimas tt |where=tt.gbif_id="..
            _gbif.."|order by=tt.country|data=gbif=tt.id}}"..
            "{{#for_external_table:{{{gbif}}};}}"..
            "{{#clear_external_data:}}") or ''
    end
    if gbifs == nil then gbifs = '' end
 
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local frame = mw.getCurrentFrame()
    local nxline = false

    if _mires == 'taip' then
        root.wikitext( 'Yra išnykęs. ' )
        nxline = true
    end
    if _aukn ~= '' or _auki ~= '' then
        root.wikitext( 'Yra aptinkamas  ' )
        if _aukn ~= '' then
            root.wikitext( 'nuo  [[Aukštis nuo::', _aukn, ']] ' )
        end
        if _auki ~= '' then
            root.wikitext( 'iki  [[Aukštis::', _auki, ']] ' )
        end
        root.wikitext( 'aukštyje.  ' )
        nxline = true
    end
    if _gyln ~= '' or _gyli ~= '' then
        root.wikitext( 'Yra aptinkamas  ' )
        if _gyln ~= '' then
            root.wikitext( 'nuo  [[Gylis nuo::', _gyln, ']] ' )
        end
        if _gyli ~= '' then
            root.wikitext( 'iki  [[Gylis::', _gyli, ']] ' )
        end
        root.wikitext( 'gylyje.  ' )
        nxline = true
    end
    
    local king = Parm._get{ page = _la, parm = 'karalystė' }
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

    -- local king = mw.ustring.match( rtxt, "%c%s*%|%s*karalystė%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or ''
    local tip_rod = _tip
    if king == 'Fungi' or king == 'Plantae' then
        if tip_rod == 'tipas' then tip_rod = 'skyrius' end
        if tip_rod == 'būrys' then tip_rod = 'eilė' end
    end
    if _tip ~= '' then
        if nxline then
            root.newline().newline()
        end
        local gb = Cite._isn ( frame, {}, { GgeSinonimas._gbif{ ID = _gbif or '', taxon = _la, year='2013', date='m. gruodžio mėn. – 2014 m. sausio mėn' }, 
                'gbif'..(_gbif or '') } )
        if tips[_tip] then
            nxline = false
            if _reg ~= '' then
                root.wikitext( '* Aptinkama regionuose: ' )
                root.wikitext( gpap._regcell( _la, _tip, _reg, frame ) )
                root.wikitext( '.' )
                root.wikitext( gb )
                nxline = true
            end
            if _sal ~= '' or gbifs ~= '' then
				local pav = ''
				if _lt ~= '' then
					pav = _lt
				else
					pav = _la
				end
                if nxline then
                    root.newline()
                end
                -- root.wikitext( '* Aptinkama šalyse: ' )
                root.wikitext( '{| {{Graži lentelė}} class="sortable wikitable"' )
                root.newline()
                root.wikitext( '|+ ' )
                root
                    .tag('big')
                    .wikitext( "'''Sąrašas šalių, kuriose yra aptinkama " .. tip_rod .. ".'''" )
                    .done()
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '! align="left" colspan=15| Šis sąrašas sudarytas remiantis:' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( "* [[Globalios biologinės įvairovės informacijos priemonė|Globalios biologinės įvairovės informacijos priemonės (GBĮIP)]]" )
                   root.wikitext( gb )
                   root.wikitext( " informaciją." )
                end
                root.newline()
                root.wikitext( '* šiame [[Enciklopedija:Apie|Enciklopedijos Lietuvai ir pasauliui (ELIP)]] straipsnyje iš įvairių šaltinių registruota informaciją.' )
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '! colspan=2| Aptinkama' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( '! colspan=2| Registruoti aptinkamai' )
                   root.newline()
                   root.wikitext( '!class="unsortable" rowspan=2| Pastaba' )
                else
                   root.newline()
                   root.wikitext( '! Registruotas aptikimas' )
                   root.newline()
                   root.wikitext( '!class="unsortable" rowspan=2| Pastaba' )
                end
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '!class="unsortable" | Vėliava' )
                root.newline()
                root.wikitext( '! Šalis' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( '! GBĮIP' )
                   root.newline()
                   root.wikitext( '! ELIP' )
                else
                   root.newline()
                   root.wikitext( '! ELIP' )
                end
                root.newline()
                root.wikitext( '|-' )
                root.wikitext( gpap._salcell( _la, _tip, _sal, frame, gbifs, pav ) )
                root.newline()
                root.wikitext( '|}' )
                root.newline()
                nxline = true
            end
        elseif _sal~='' or gbifs~='' or dal1~='' then
            local pav = ''
            if _lt ~= '' then
                pav = _lt
            else
                pav = _la
            end
                root.wikitext( '{| {{Graži lentelė}} class="sortable wikitable"' )
                root.newline()
                root.wikitext( '|+ ' )
                root
                    .tag('big')
                    .wikitext( "'''Sąrašas šalių, kuriose yra aptinkama " .. tip_rod .. ".'''" )
                    .done()
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '! align="left" colspan=15| Šis sąrašas sudarytas remiantis:' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( "* [[Globalios biologinės įvairovės informacijos priemonė|Globalios biologinės įvairovės informacijos priemonės (GBĮIP)]]" )
                   root.wikitext( gb )
                   root.wikitext( " informaciją." )
                end
                root.newline()
                root.wikitext( '* šiame [[Enciklopedija:Apie|Enciklopedijos Lietuvai ir pasauliui (ELIP)]] straipsnyje iš įvairių šaltinių registruota informaciją.' )
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '! colspan=2| Aptinkama' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( '! colspan=3| Registruotų aptinkamų rūšių skaičius' )
                   root.newline()
                   root.wikitext( '! colspan=2| Registruoti aptinkamai' )
                   root.newline()
                   root.wikitext( '!class="unsortable" rowspan=2| Pastaba' )
                else
                   root.newline()
                   root.wikitext( '! colspan=3| Registruotų aptinkamų rūšių skaičius' )
                   root.newline()
                   root.wikitext( '!class="unsortable" rowspan=2| Pastaba' )
                end
                root.newline()
                root.wikitext( '|-' )
                root.newline()
                root.wikitext( '!class="unsortable" | Vėliava' )
                root.newline()
                root.wikitext( '! Šalis' )
                if gbifs ~= '' then
                   root.newline()
                   root.wikitext( '! GBĮIP' )
                   root.newline()
                   root.wikitext( '! ELIP' )
                   root.newline()
                   root.wikitext( '! Viso' )
                   root.newline()
                   root.wikitext( '! GBĮIP' )
                   root.newline()
                   root.wikitext( '! ELIP' )
                else
                   root.newline()
                   root.wikitext( '! GBĮIP' )
                   root.newline()
                   root.wikitext( '! ELIP' )
                   root.newline()
                   root.wikitext( '! Viso' )
                end
                root.newline()
                root.wikitext( '|-' )
            root.wikitext( gpap._grp( _la, _tip, pav, frame, _sal, gbifs, dal1 ) )
                root.newline()
                root.wikitext( '|}' )
                root.newline()
        end
        if _gbif ~= '' and (_sal~='' or gbifs~='' or dal1~='' ) then
            --root.wikitext( '<p>' )
            root.newline()
            root.wikitext( "[[Globalios biologinės įvairovės informacijos priemonė|Globalios biologinės įvairovės informacijos priemonės (GBĮIP)]]" )
            root.wikitext( gb )
            root.wikitext( " pateikiamas aptikimo vietų žemėlapis." )
            root.newline()
            root.newline()
            root.wikitext( frame:callParserFunction{ name = '#widget', args = { 'Iframe', url='http://cdn.gbif.org/v1/map/index.html?type=TAXON&key='.._gbif..
                '&resolution=1', width='700', height='400', border='0' } } )
            --root.wikitext( '<img class="decoded" src="http://ogc.gbif.org/wms?request=GetMap&bgcolor=0x666698&styles=,,,&layers=gbif:country_fill,gbif:tabDensityLayer,gbif:country_borders,gbif:country_names&srs=EPSG:4326&filter=()(%3CFilter%3E%3CPropertyIsEqualTo%3E%3CPropertyName%3Eurl%3C/PropertyName%3E%3CLiteral%3E%3C'..
            --    mw.uri.encode('![CDATA[')..'http%3A%2F%2Fdata.gbif.org%2Fmaplayer%2Ftaxon%2F'.._gbif..
            --    mw.uri.encode(']]')..'%3E%3C/Literal%3E%3C/PropertyIsEqualTo%3E%3C/Filter%3E)()()&width=721&height=362&Format=image/png&bbox=-180,-90,180,90'..
            --    '" alt="Paplitimo žemėlapis."></p>' )
        end
    end
    root.done()
     
    return tostring(root)
end

gpap.pap = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local mires, lt, aukn, auki, gyln, gyli, reg, sal, gbif = '', '', '', '', '', '', '', '', ''
    local pagename = _la
    local ttip = ''
 
    local parms = Parm._get{ page = _la, parm = {'išnykęs', 'statusas', 'lt', 'type', 'aukštis nuo', 'aukštis iki', 
        'gylis nuo', 'gylis iki', 'regionai', 'šalys', 'gbifid' } }
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
        mires = parms['išnykęs'] or mires
        local stat = parms['statusas'] or ''
        if stat == 'EX' then
            mires = 'taip'
        end
        lt = parms['lt'] or lt
        ttip = parms['type'] or ''
        aukn = parms['aukštis nuo'] or aukn
        auki = parms['aukštis iki'] or auki
        gyln = parms['gylis nuo'] or gyln
        gyli = parms['gylis iki'] or gyli
        reg = parms['regionai'] or reg
        sal = parms['šalys'] or sal
        gbif = parms['gbifid'] or gbif
    end
    
    return gpap._pap( _la, mires, lt, ttip, aukn, auki, gyln, gyli, reg, sal, gbif )
end

return gpap
