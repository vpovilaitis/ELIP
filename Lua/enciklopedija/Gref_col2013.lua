local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Gref = require('Module:Gref')
local Grefv = require('Module:Grefv')
local Cite = require('Module:Cite')

grefapc = {}

grefapc._cell = function( lst )
    local tbl = HtmlBuilder.create('table')
    for lstel in mw.text.gsplit(lst,',') do
        if lstel ~= '' then
            tbl
                .tag('tr')
                    .tag('td')
                        .wikitext(Grefv.refla(lstel, '', '', '', '', '', '', ''))
                        .done()
                    .done()
        end
    end
    tbl.done()
    return tostring(tbl)
end

grefapc._all = function( la, kam, kas, nuo, kiek, frame )
    local root = HtmlBuilder.create()
    local _la, _kam, _kas, _nuo, _kiek = la or '', kam or '', kas, nuo, kiek
    
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    else
        local frame = mw.getCurrentFrame()
        local ladb = mw.text.listToText(mw.text.split( la, "'" ), "''", "''")
        
        local inf2013 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=_taxon_tree|where=name='"..
            ladb.."'|data=tid=taxon_id,nam=name,typ=rank,pid=parent_id,skc=number_of_children,skr=total_species}}"..
            "{{#for_external_table:{{{tid}}},{{{nam}}},{{{typ}}},{{{pid}}},{{{skc}}},{{{skr}}}}}"..
            "{{#clear_external_data:}}") or ',,,,,'
        local iii = inf2013..' ??'
        local inf2013s = mw.text.split(inf2013,',') or { '', '', '', '', '', '' }

        local com = HtmlBuilder.create()
        if inf2013s[3] == 'species' then
            com.wikitext(Cite._isn(frame, {}, {'[[col2013id:'..inf2013s[1]..'|'.._la..']]. '..
                'Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].'}))
        else
            com.wikitext(Cite._isn(frame, {}, {'[[col2013s:'.._la..'|'.._la..']]. '..
                'Gyvybės katalogas: 2013 metų sąrašas. [http://www.catalogueoflife.org/ Catalogue of Life: 2013 Annual Checklist].'}))
        end
        com.done()
        
        local dal1 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=Skaiciai s left join (SELECT b.`name`, 1 sk FROM `_taxon_tree` b WHERE b.`parent_id` = "..
            inf2013s[1].." ORDER BY b.`name` ASC limit ".._nuo..",".._kiek..
            ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        _nuo = _nuo + _kiek
        local dal2 = frame:preprocess("{{#get_db_data:|db=col2013ac|from=taxon.Skaiciai s left join (SELECT b.`name`, 1 sk FROM `_taxon_tree` b WHERE b.`parent_id` = "..
            inf2013s[1].." ORDER BY b.`name` ASC limit ".._nuo..",".._kiek..
            ") a on (s.nr=a.sk)|where=s.nr=1|order by=a.name|data=tax=a.name}}{{#for_external_table:{{{tax}}},}}{{#clear_external_data:}}") or ''
        root
            .wikitext(Gref.getla(_la, '', '', '', '', '', ''))
            .wikitext( ' ', _kam, ' priklauso:', tostring(com), '\n' )
            .grazilentele()
                .tag('tr')
                    .attr('valign', 'top')
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefapc._cell(dal1))
                            .done()
                        .done()
                    .tag('td')
                        .attr('width', '50%')
                        .tag('div')
                            .wikitext(grefapc._cell(dal2))
                            .done()
                        .done()
                    .done()
                .done()
            .done()
    end

    root.done()
     
    return tostring(root)
end

grefapc.all = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _kam = args.kam or pargs.kam or mw.text.trim(args[2] or pargs[2] or '')
    local _kas = args.kas or pargs.kas or mw.text.trim(args[3] or pargs[3] or '')
    local nuo, _nuo = args.nuo or pargs.nuo, tonumber(args.nuo or pargs.nuo) or 0
    local kiek, _kiek = args.kiek or pargs.kiek, tonumber(args.kiek or pargs.kiek) or 50
    local _div, _mod = math.modf( _kiek/2 )
    if _mod ~= 0 then _div = _div + 1 end
    
    return grefapc._all( _la, _kam, _kas, _nuo, _div, frame )
end

return grefapc
