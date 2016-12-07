local HtmlBuilder = require('Module:HtmlBuilder')
local Aut = require('Module:Aut')
local Komentaras = require('Module:Komentaras')
--local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')

gtitp = {}

gtitp._tit = function( mires, lt, sin, la, larod, aut, met )
    local root = HtmlBuilder.create()
    
    if mires == 'taip' then
        root.wikitext( Komentaras._kom('†', 'Išnykęs ar galimai išnykęs taksonas.', nil), ' ' )
    end

    if lt == '' then
        root
            .tag('b')
                .wikitext( Komentaras._kom('?', 'Lietuviškas pavadinimas nesukurtas, nežinomas arba dar neįvestas į ELIP.') )
                .done()
    else
        local ltsp = mw.text.trim(mw.text.split(lt, ' (', true)[1])
        if lt == ltsp then
            root
                .tag('b')
                    .wikitext( "[[", lt, "]]")
                    .done()
        else
            root
                .tag('b')
                    .wikitext( "[[", lt, '|', ltsp, "]]")
                    .done()
        end
    end
    root.wikitext( " ")
    
    if sin ~= '' then
        root.wikitext('(', Komentaras._kom("sin.", "Kiti lietuviški pavadinimo sinonimai.", 'Sinonimas'),' ')
        local i = 0
        for s in mw.text.gsplit(sin, ',', true) do
            local _s = mw.text.trim(s)
            if _s ~= '' then
                if i ~= 0 then
                    root.wikitext(', ')
                end
                local tssp = mw.text.trim(mw.text.split(_s, ' (', true)[1])
                if _s == tssp then
                    root.wikitext("[[", _s, "]]")
                else
                    root.wikitext("[[", _s, '|', tssp, "]]")
                end
                i = i + 1
            end
        end
        root.wikitext( ") ")
    end
    
    root.wikitext("– ")
    local lasp = mw.text.trim( la ) -- mw.text.trim(mw.text.split(la, ' (', true)[1])
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
                    root.wikitext(Aut._aut("[[Taksonų pavadinimų autorių sritis::Sritis:" .. _a .. '|' .. _a .. "]]"))
                else
                    root.wikitext(Aut._aut("[[Taksonų pavadinimų autorių sritis::Sritis:" .. _a .. '|' .. autsp .. "]]"))
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

    root.done()
     
    return  tostring(root)
end

gtitp.tit = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '') or ''
    
    return gtitp.titla(_la)
end

gtitp.titla = function( _la, subst )
    local _mires, _lt, _sin, _larod, _aut, _met = '', '', '', '', '', ''
    if subst==nil then subst='' end
    if _la == '' then
        return Komentaras._kom('?', 'Nenurodytas lotyniškas pavadinimas')
    end
    local pagename = _la
    
    local parms = ParmData._get{ page = _la, parm = {'išnykęs', 'lt', 'lt sins', 'la', 'altla', 'autoriai', 'metai', 
        'statusas' }, template = 'Auto_taxobox', subst }
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
        
        local m_sin = parms['lt sins']
        if m_sin ~= nil then _sin = m_sin end
        
        local _la2 = parms['la'] or _la
        _larod = parms['altla'] or _larod
        _aut = parms['autoriai'] or _aut
        _met = parms['metai'] or _met
        local stat = parms['statusas'] or ''
        if stat == 'EX' then
            _mires = 'taip'
        end
        if _la2 ~= _la then
            _la = _la2
        end
    end
    
    return gtitp._tit( mw.text.trim(_mires or ''), mw.text.trim(_lt or ''), mw.text.trim(_sin or ''), _la, 
        mw.text.trim(_larod or ''), mw.text.trim(_aut or ''), mw.text.trim(_met or '') )
end

return gtitp
