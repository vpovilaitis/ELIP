local HtmlBuilder = require('Module:HtmlBuilder')
local Navbox = require('Module:Navbox')

copyggep = {}

copyggep._copygge = function( la, dat, dal )
    local root = HtmlBuilder.create()
    local lat = HtmlBuilder.create()
 
    local sk = 0
    if la == nil then
        la = ''
    end
    for lael in mw.text.gsplit(la,',') do
        lael = mw.text.trim(lael)
        if sk ~= 0 then
            lat.wikitext(', ')
        end
        lat.wikitext('„[[:gge:',lael, '|', lael, ']]“' )
        sk = sk + 1
    end
    root
        .tag('table')
            .attr('id', 'GGEautoriai')
            .attr('align', 'center')
            .attr('border', '0')
            .attr('cellpadding', '3')
            .attr('cellspacing', '3')
            .css('border', '1px solid #E0E0E0')
            .css('background-color', '#F8F8F8')
            .css('color', '#000')
            .css('margin', '0.5em auto')
            .tag('tr')
                .tag('td')
                    .css('font-size', '90%')
                    .wikitext('Panaudotas ', dat, 'CC-BY-SA turinys iš Gyvosios gamtos enciklopedijos straipsnio ')
                    .node(lat)
                    .wikitext('.<br />Gyvosios gamtos enciklopedijos dalyviai: ', dal )
                    .done()
                .done()
            .done()
    
    root.done()
     
    return  tostring(root)
end

copyggep.copygge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    local dat = args.dat or pargs.dat or mw.text.trim(args[2] or pargs[2] or '') or ''
    local dal = args.dat or pargs.dal or mw.text.trim(args[3] or pargs[3] or '') or ''
    if la == '' then
        return copyggep._copygge( '{{FULLPAGENAME}}', dat, dal )
    else
        return copyggep._copygge( la, dat, dal )
    end
end

copyggep._copyspecies = function( la, dat )
    local root = HtmlBuilder.create()
 
    root
        .tag('table')
            .attr('id', 'Speciesautoriai')
            .attr('align', 'center')
            .attr('border', '0')
            .attr('cellpadding', '3')
            .attr('cellspacing', '3')
            .css('border', '1px solid #E0E0E0')
            .css('background-color', '#F8F8F8')
            .css('color', '#000')
            .css('margin', '0.5em auto')
            .tag('tr')
                .tag('td')
                    .css('font-size', '90%')
                    .wikitext('Panaudotas ', dat, 'CC-BY-SA turinys iš Vikirūšis straipsnio „[[:wikispecies:',
                        la, '|', la, ']]“.' )
                    .done()
                .done()
            .done()
    
    root.done()
     
    return  tostring(root)
end

copyggep.copyspecies = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    local dat = args.dat or pargs.dat or mw.text.trim(args[2] or pargs[2] or '') or ''
    if la == '' then
        return copyggep._copyspecies( '{{FULLPAGENAME}}', dat )
    else
        return copyggep._copyspecies( la, dat )
    end
end

copyggep._copywiki = function( la, dat, dal )
    local root = HtmlBuilder.create()
    local txt = Navbox._navbox{ name='Vikipedija', title= 
            'Pirmos straipsnio versijos licencija', state='collapsed', list1=
            'Šio puslapio pirmajai versijai buvo panaudotas ' .. dat .. 'CC-BY-SA turinys iš Lietuviškos Vikipedijos straipsnio „[[:lt:' ..
                        la .. '|' .. la .. ']]“. [https://lt.wikipedia.org/w/index.php?title=' .. mw.uri.anchorEncode( la ) .. '&action=history Istorija].<br />Vikipedijos dalyviai: ' .. dal ..
            '. <br /><br />Pirmąją straipsnio versiją iš Vikipedijos įkėlė [[Naudotojas:VP-bot|naudotojas VP-bot]]. Jei straipsnis be šio naudotojo turi daugiau autorių arba redaktorių, ' ..
            'tai straipsnis Enciklopedijoje Lietuvai ir pasaulis buvo keistais bei papildytas ir net iš viso perrašytas. ',
            titlestyle='background-color:#F8F8F8;' }
 
    root
        .tag('table')
            .attr('id', 'Vikiautoriai')
            .attr('class', 'Vikiautoriai')
            .attr('align', 'center')
            .attr('border', '0')
            .attr('cellpadding', '3')
            .attr('cellspacing', '3')
            .attr('width', '100%')
            .css('border', '1px solid #E0E0E0')
            .css('background-color', '#F8F8F8')
            .css('color', '#000')
            .css('margin', '0.5em auto')
            .tag('tr')
                .tag('td')
                    .css('font-size', '90%')
                    .wikitext( txt )
                    .done()
                .done()
            .done()
    
    root.done()
     
    return  tostring(root)
end

copyggep.copywiki = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    local dat = args.dat or pargs.dat or mw.text.trim(args[2] or pargs[2] or '') or ''
    local dal = args.dat or pargs.dal or mw.text.trim(args[3] or pargs[3] or '') or ''
    if la == '' then
        return copyggep._copywiki( '{{FULLPAGENAME}}', dat, dal )
    else
        return copyggep._copywiki( la, dat, dal )
    end
end

copyggep._parenge = function( la )
    local root = HtmlBuilder.create()
 
    root
        .tag('table')
            .attr('id', 'Rengejas')
            .attr('align', 'center')
            .attr('border', '0')
            .attr('cellpadding', '3')
            .attr('cellspacing', '3')
            .css('border', '1px solid #E0E0E0')
            .css('background-color', '#F8F8F8')
            .css('color', '#000')
            .css('margin', '0.5em auto')
            .tag('tr')
                .tag('td')
                    .css('font-size', '90%')
                    .wikitext('Parengė: ', la, '.' )
                    .done()
                .done()
            .done()
    
    root.done()
     
    return  tostring(root)
end

copyggep.parenge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    
    return copyggep._parenge( la )
end

copyggep._sukure = function( la )
    local root = HtmlBuilder.create()
 
    root
        .tag('table')
            .attr('id', 'Kurejas')
            .attr('align', 'center')
            .attr('border', '0')
            .attr('cellpadding', '3')
            .attr('cellspacing', '3')
            .css('border', '1px solid #E0E0E0')
            .css('background-color', '#F8F8F8')
            .css('color', '#000')
            .css('margin', '0.5em auto')
            .tag('tr')
                .tag('td')
                    .css('font-size', '90%')
                    .wikitext('Sukūrė: ', la, '.' )
                    .done()
                .done()
            .done()
    
    root.done()
     
    return  tostring(root)
end

copyggep.sukure = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    
    return copyggep._sukure( la )
end

copyggep._rugge = function( lst )
    local root = HtmlBuilder.create()

    -- [[Vaizdas:Flag_of_Russia.svg|25px|border|link=Rusų kalba]] [[Rusų kalba|rus.]] {{#arraymap:{{{1|}}}|,|~|{{#if:{{#pos:~|[}}{{#pos:~|]}}|~|''[[:ru:{{{link|~}}}|~]]''}}|,&#32;}}
    root.wikitext('[[Vaizdas:Flag_of_Russia.svg|25px|border|link=Rusų kalba]] [[Rusų kalba|rus.]] ')
    local sk = 0
    for lstel in mw.text.gsplit(lst,',') do
        lstel = mw.text.trim(lstel)
        if sk ~= 0 then
            root.wikitext(', ')
        end
        if mw.ustring.find(lstel, '%[') == nil and mw.ustring.find(lstel, '%]') == nil then
            root.wikitext("''[[:ru:")
            root.wikitext(lstel)
            root.wikitext('|')
            root.wikitext(lstel)
            root.wikitext("]]''")
        else
            root.wikitext(lstel)
        end
        sk = sk + 1
    end
    
    root.done()
     
    return  tostring(root)
end

copyggep.rugge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local ru = args.ru or pargs.ru or mw.text.trim(args[1] or pargs[1] or '') or ''
    if ru == '' then
        return ''
    else
        return copyggep._rugge( ru )
    end
end

copyggep._degge = function( lst )
    local root = HtmlBuilder.create()

    root.wikitext('[[Vaizdas:Flag_of_Germany.svg|25px|border|link=Vokiečių kalba]] [[Vokiečių kalba|vok.]] ')
    local sk = 0
    for lstel in mw.text.gsplit(lst,',') do
        lstel = mw.text.trim(lstel)
        if sk ~= 0 then
            root.wikitext(', ')
        end
        if mw.ustring.find(lstel, '%[') == nil and mw.ustring.find(lstel, '%]') == nil then
            root.wikitext("''[[:de:")
            root.wikitext(lstel)
            root.wikitext('|')
            root.wikitext(lstel)
            root.wikitext("]]''")
        else
            root.wikitext(lstel)
        end
        sk = sk + 1
    end
    
    root.done()
     
    return  tostring(root)
end

copyggep.degge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local de = args.de or pargs.de or mw.text.trim(args[1] or pargs[1] or '') or ''
    if de == '' then
        return ''
    else
        return copyggep._degge( de )
    end
end

copyggep._engge = function( lst )
    local root = HtmlBuilder.create()

    root.wikitext('[[Vaizdas:Flag_of_the_United_Kingdom.svg|25px|border|link=Anglų kalba]] [[Anglų kalba|angl.]] ')
    local sk = 0
    for lstel in mw.text.gsplit(lst,',') do
        lstel = mw.text.trim(lstel)
        if sk ~= 0 then
            root.wikitext(', ')
        end
        if mw.ustring.find(lstel, '%[') == nil and mw.ustring.find(lstel, '%]') == nil then
            root.wikitext("''[[:en:")
            root.wikitext(lstel)
            root.wikitext('|')
            root.wikitext(lstel)
            root.wikitext("]]''")
        else
            root.wikitext(lstel)
        end
        sk = sk + 1
    end
    
    root.done()
     
    return  tostring(root)
end

copyggep.engge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local en = args.en or pargs.en or mw.text.trim(args[1] or pargs[1] or '') or ''
    if en == '' then
        return ''
    else
        return copyggep._engge( en )
    end
end

copyggep._frgge = function( lst )
    local root = HtmlBuilder.create()

    root.wikitext('[[Vaizdas:Flag_of_France.svg|25px|border|link=Prancūzų kalba]] [[Prancūzų kalba|pranc.]] ')
    local sk = 0
    for lstel in mw.text.gsplit(lst,',') do
        lstel = mw.text.trim(lstel)
        if sk ~= 0 then
            root.wikitext(', ')
        end
        if mw.ustring.find(lstel, '%[') == nil and mw.ustring.find(lstel, '%]') == nil then
            root.wikitext("''[[:fr:")
            root.wikitext(lstel)
            root.wikitext('|')
            root.wikitext(lstel)
            root.wikitext("]]''")
        else
            root.wikitext(lstel)
        end
        sk = sk + 1
    end
    
    root.done()
     
    return  tostring(root)
end

copyggep.frgge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local fr = args.fr or pargs.fr or mw.text.trim(args[1] or pargs[1] or '') or ''
    if fr == '' then
        return ''
    else
        return copyggep._frgge( fr )
    end
end

copyggep._kalbos = function( en, fr, ru, de )
    local root = HtmlBuilder.create()
    
    if en ~= '' then
        root.wikitext('* ')
        root.wikitext(copyggep._engge(en))
        if fr ~= '' or ru ~= '' or de ~= '' then root.newline() end
    end
    if fr ~= '' then
        root.wikitext('* ')
        root.wikitext(copyggep._frgge(fr))
        if ru ~= '' or de ~= '' then root.newline() end
    end
    if ru ~= '' then
        root.wikitext('* ')
        root.wikitext(copyggep._rugge(ru))
        if de ~= '' then root.newline() end
    end
    if de ~= '' then
        root.wikitext('* ')
        root.wikitext(copyggep._degge(de))
    end

    root.done()
     
    return  tostring(root)
end

copyggep.kalbos = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    
    if _la == nil or _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local en, fr, ru, de = '', '', '', ''
    local pagename = _la
 
    local rpage, err = mw.title.new(_la)
    local rtxt = ''
    if rpage and rpage.id ~= 0 then
        rtxt = rpage:getContent() or ""
        if rpage.isRedirect then
            local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
 
            if not redirect then
                redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
            end
            if redirect then
                pagename = redirect
                local page, err = mw.title.new(pagename)
                if page and page.id ~= 0 then
                    rtxt = page:getContent() or ""
                end
            end
        end
    end
 
    if rtxt ~= '' then
        en = mw.ustring.match( rtxt, "%c%s*%|%s*en%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or mw.ustring.match( rtxt, "%[%[en:([^%c%|%]]-)[%c%|%]]" ) or en
        fr = mw.ustring.match( rtxt, "%c%s*%|%s*fr%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or mw.ustring.match( rtxt, "%[%[fr:([^%c%|%]]-)[%c%|%]]" ) or fr
        ru = mw.ustring.match( rtxt, "%c%s*%|%s*ru%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or mw.ustring.match( rtxt, "%[%[ru:([^%c%|%]]-)[%c%|%]]" ) or ru
        de = mw.ustring.match( rtxt, "%c%s*%|%s*de%s*=%s*([^%c%|%}]-)%s*[%c%|%}]" ) or mw.ustring.match( rtxt, "%[%[de:([^%c%|%]]-)[%c%|%]]" ) or de
    end
    
    if en == '' and fr == '' and ru == '' and de == '' then 
        return '' 
    end
 
    return copyggep._kalbos( en, fr, ru, de )
end

return copyggep
