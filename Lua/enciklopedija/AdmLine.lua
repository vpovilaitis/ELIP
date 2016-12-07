local HtmlBuilder = require('Module:HtmlBuilder')
local Komentaras = require('Module:Komentaras')
local Switch = require('Module:Switch')
local json = require('Modulis:JSON')
--local Parm = require('Module:Parm')
local ParmData = require('Module:ParmData')

local admline = {}

function admline.tline(frame)
    local fargs, pargs = frame.args, (frame:getParent() or {}).args or {}
 
    args = {}
    args.laipsnis = fargs.laipsnis or pargs.laipsnis or ''
    args.typ = fargs.typ or pargs.typ or ''
    args.la = fargs.la or pargs.la or ''
    args.alias = fargs.alias or pargs.alias or ''
    if args.alias == '' then args.alias = args.la end
    args.link = fargs.link or pargs.link or args.la or ''
    if args.link == '' then args.link = args.la end
    args.lt = fargs.lt or pargs.lt or ''
    args.rodyti = fargs.rodyti or pargs.rodyti or args.lt or ''
    --args.level = fargs.level or pargs.level or '0'
    args['išnykęs'] = fargs['išnykęs'] or pargs['išnykęs'] or ''
 
    return taxline._tline(args, '')
end

admline._tline = function (args, kat)
    local frame = mw.getCurrentFrame()
    local lin = HtmlBuilder.create()
    local lang = mw.language.new( 'lt' )
    local isny, _la, _lt = '', HtmlBuilder.create(), HtmlBuilder.create()
    local s_alias = mw.text.trim( args.alias or '' ) or '' -- mw.text.trim( (mw.text.split(args.la or '', ' (', true) or {''})[1] or '' )
    local s_la = mw.text.trim( args.la or '' ) or '' -- mw.text.trim( (mw.text.split(args.la or '', ' (', true) or {''})[1] or '' )
    local s_lt = mw.text.trim( (mw.text.split(args.lt or '', ' (', true) or {''})[1] or '')
    
    if args.link == nil or args.link == '' then
        args.link = args.la
    end
    
    local king = ParmData._get{ page = args.link, parm = 'karalystė', template = 'Auto_taxobox' }

    local spec_la = s_la
    if s_alias ~= nil and s_alias ~= '' and s_alias ~= spec_la then
        spec_la = s_alias
    end
    
    if args['išnykęs'] == 'taip' or args['išnykęs'] == 'yes' then 
        isny = Komentaras._kom('†', 'Išnykęs ar galimai išnykęs taksonas.', nil) .. ' '
    end
    if args.lt == nil or args.lt == '' then
        if  args.link ~= s_la then
            _la
                .tag('i')
                    .wikitext('[[', args.link, '|', s_la, ']]')
                    .done()
        else
            _la
                .tag('i')
                    .wikitext('[[', args.link, ']]')
                    .done()
        end
    else
        if args.rodyti ~= nil and args.rodyti ~= '' and args.rodyti ~= args.lt then
            _lt
                .wikitext('[[', args.lt, '|', args.rodyti, ']]')
                .done()
        elseif s_lt ~= args.lt then
            _lt
                .wikitext('[[', args.lt, '|', s_lt, ']]')
                .done()
        else
            _lt
                .wikitext('[[', args.lt, ']]')
                .done()
        end
    end

    if king == 'Fungi' or king == 'Plantae' or king == 'Chromista' then
        if args.laipsnis == 'tipas' then args.laipsnis = 'skyrius' end
        if args.laipsnis == 'būrys' then args.laipsnis = 'eilė' end
    end
    local levt = tonumber(Switch._switch2( 'Switch/taxrank', args.typ, 'l', 1000 ) or 1000) or 1000
    local lev = tonumber(Switch._switch2( 'Switch/taxrank', args.laipsnis, 'l', 1000 ) or 1000) or 1000
    if lev < levt then
        local levn = Switch._switch2( 'Switch/taxrank', args.laipsnis, 'n', 'taksonui' )
        frame:callParserFunction{ name = '#set', args = 'Priklauso '..levn..'='..args.la }
        if args.typ ~= '' then
            frame:callParserFunction{ name = '#set', args = args.typ..' priklauso '..levn..'='..args.la }
        end
    end
    lin
        --.attr('valign', 'top')
        .wikitext('|- valign="top"\n')
        .wikitext('| ')
            .wikitext(Switch._switch2( 'Switch/taxrank', args.laipsnis, 'link', 
                Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas arba klaidingas taksono tipas') ) )
            .wikitext(':')
            --.done()
        .wikitext(' || ')
            .wikitext(isny)
            .wikitext(_la)
            .wikitext(_lt)
            .wikitext(kat)
            .wikitext('<br />')
            .tag('i')
                .wikitext('([[Vaizdas:Wikispecies-logo.svg|12px|link=wikispecies:', s_alias, ']] ')
                .wikitext('[[:wikispecies:', s_alias, '|', s_alias, ']])')
                .done()
        --.done()
        .wikitext('\n|- valign="top"')
        .done()
    return  tostring(lin)
end

admline.by_la = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local _alias = args.alias or pargs.alias or ''
    local _typ = args.typ or pargs.typ or mw.text.trim(args[2] or pargs[2] or '')
    local _issin = args.issin or pargs.issin or mw.text.trim(args[3] or pargs[3] or '')
    local lin, tips = HtmlBuilder.create(), HtmlBuilder.create()
    local myargs = {}
    _la = mw.text.trim( _la )
    if _la == nil or _la == '' then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas lotyniškas pavadinimas') )
            .wikitext('\n|- valign="top"')
            .done()
        return tostring(lin)
    end
    if _alias == nil or _alias == '' then
        _alias = _la
    end
    local err
    myargs.la = _la
    myargs.alias = _alias
    myargs.typ = _typ
    myargs.issin = _issin
    myargs, err = taxline.getby_la( myargs )
    if err then
        return err
    end
    return taxline.parents( myargs, { myargs.la } )
end

admline.parents = function( args, list )
    local katlin = HtmlBuilder.create()
    if args.issin ~= '' then
        if #list == 1 then
            if args.lt ~= nil and args.lt ~= '' then
                katlin.wikitext('[[Kategorija:'..args.lt..'/Sinonimai]]')
            else
                if args.la ~= nil and args.la ~= '' then
                    katlin.wikitext('[[Kategorija:'..args.la..'/Sinonimai]]')
                end
            end
        end
    else
        if #list == 2 then
            if args.lt ~= nil and args.lt ~= '' then
                katlin.wikitext('[[Kategorija:'..args.lt..']]')
            else
                if args.la ~= nil and args.la ~= '' then
                    katlin.wikitext('[[Kategorija:'..args.la..']]')
                end
            end
        end
    end
    katlin
        .done()
    if args.laipsnis == 'karalystė' then
        local dlin, klin = HtmlBuilder.create(), HtmlBuilder.create()
        domargs = {}
        domargs.laipsnis = 'domenas'
        domargs.typ = args.typ or ''
        domargs.la = args.domenas or ''
        domargs.alias = args.domenas or ''
        domargs.link = args.domenaslt or args.domenas or ''
        domargs.lt = args.domenaslt or args.domenas or ''
        domargs.rodyti = ''
        domargs['išnykęs'] = ''
        dlin
            .wikitext(taxline._tline(domargs, ''))
            .done()
        local karargs = {}
        karargs.laipsnis = args.laipsnis
        karargs.typ = args.typ or ''
        karargs.la = args.la or ''
        karargs.alias = args.alias or ''
        karargs.link = args.link or ''
        karargs.lt = args.lt or ''
        karargs.rodyti = ''
        karargs['išnykęs'] = args.mires
        klin
            .wikitext(taxline._tline(karargs, tostring(katlin)))
            .done()
        return tostring(dlin)..tostring(klin)
    else
        if args.parent == nil or args.parent == '' then
           local lin = HtmlBuilder.create()
           lin
               .wikitext('|- valign="top"\n')
               .wikitext('| ')
               .wikitext(' || ')
               .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas tėvo pavadinimas: '..args.la) )
               .wikitext(tostring(katlin))
               .wikitext('\n|- valign="top"')
               .done()
           return tostring(lin)
        else
            local pargs, mlist = {}, {}
            for i, v in pairs(list) do
                mlist[i] = v
                if args.parent == v then
                    local lin = HtmlBuilder.create()
                    lin
                        .wikitext('|- valign="top"\n')
                        .wikitext('| ')
                        .wikitext(' || ')
                        .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nurodytas ciklinis tėvas pavadinimas: '..v) )
                        .wikitext(tostring(katlin))
                        .wikitext('\n|- valign="top"')
                        .done()
                    return tostring(lin)
                end
            end
            local err
            mlist[#list+1] = args.parent
            pargs.la = args.parent
            pargs.alias = args.parent
            pargs.typ = args.typ or ''
            pargs.issin = args.issin
            pargs, err = taxline.getby_la( pargs )
            if err then
                return err
            end
            local plin = taxline.parents( pargs, mlist )
            local elin = HtmlBuilder.create()
            local eargs = {}
            eargs.laipsnis = args.laipsnis
            eargs.typ = args.typ or ''
            eargs.la = args.la or ''
            eargs.alias = args.alias or ''
            eargs.link = args.link or ''
            eargs.lt = args.lt or ''
            eargs.rodyti = ''
            eargs['išnykęs'] = args.mires
            elin
                .wikitext(taxline._tline(eargs, tostring(katlin)))
                .done()
            return plin..tostring(elin)
        end
    end
end

admline.getby_la = function( args )
    local myargs = {}
    myargs.la = args.la
    myargs.alias = args.alias
    myargs.typ = args.typ or ''
    myargs.issin = args.issin or ''
    local pagename = args.la
    if myargs.la == nil or myargs.la == '' then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Nenurodytas lotyniškas pavadinimas') )
            .wikitext('\n|- valign="top"')
            .done()
        return args, tostring(lin)
    end
    local parms = ParmData._get{ page = myargs.la, parm = {'išnykęs', 'statusas', 'la', 'alias', 'lt', 'type', 'parent', 'karalystė', 
        'karalystė lt', 'domenas', 'domenas lt' }, template = 'Auto_taxobox' }

    if parms==nil then
        lin
            .wikitext('|- valign="top"\n')
            .wikitext('| ')
            .wikitext(' || ')
            .wikitext( Komentaras._kom('?[[Kategorija:Surinkti]]', 'Negalimas puslapis: '..myargs.la) )
            .wikitext('\n|- valign="top"')
            .done()
        return args, tostring(lin)
    end

    myargs.mires = parms['išnykęs'] or mires
    local stat = parms['statusas'] or ''
    if stat == 'EX' then
        myargs.mires = 'taip'
    end
    local la_is = parms['la'] or ''
    if la_is ~= '' then
        if myargs.la ~= la_is then
            myargs.la = la_is
        end
    end
    local alias_is = parms['alias'] or ''
    if alias_is ~= nil and alias_is ~= '' then
        if myargs.alias ~= alias_is then
            myargs.alias = alias_is
        end
    end
    if myargs.alias == '' then
        myargs.alias = myargs.la
    end
    myargs.lt = parms['lt'] or ''
    myargs.laipsnis = parms['type'] or ''
    if myargs.typ == '' then
        myargs.typ = myargs.laipsnis
    end
    myargs.link = pagename
    myargs.parent = parms['parent'] or ''
    myargs.karalyste = parms['karalystė'] or ''
    myargs.karalystelt = parms['karalystė lt'] or ''
    myargs.domenas = parms['domenas'] or ''
    myargs.domenaslt = parms['domenas lt'] or ''

    return myargs, false
end

return admline
