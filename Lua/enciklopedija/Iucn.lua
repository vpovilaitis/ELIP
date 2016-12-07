local HtmlBuilder = require('Module:HtmlBuilder')
local Switch = require('Module:Switch')

iucnp = {}
    
iucnp._get = function( statsyst, stat, kom, isnykes, deb )
    local root = HtmlBuilder.create()
    local isn = HtmlBuilder.create()
    local debpr, debpa = HtmlBuilder.create(), HtmlBuilder.create()
    if kom == nil then
        kom = ''
    end
    if deb == 'taip' then
        debpr
            .newline()
            .wikitext('{|')
            .newline()
        debpa
            .newline()
            .wikitext('|}')
            .newline()
    end
    if isnykes ~= nil and isnykes ~= '' and (stat == 'EX' or stat == 'ex') then
        isn
            .wikitext('&nbsp;(')
            .wikitext(isnykes)
            .wikitext(')')
    end

    if stat ~= nil and stat ~= '' then
        root
            .node(debpr)
            .newline()
            .wikitext('! colspan = 2 | [[Apsaugos būklė]]')
            .newline()
            .wikitext('|-')
            .newline()
            .wikitext('| colspan = 2 style = "text-align: center" | <div style = "text-align: center">')
            .newline()
            .wikitext(Switch._switch2( 'Switch/iucn', statsyst, stat, nil ))
            .node(isn)
            .tag('small')
                .wikitext(Switch._switch2( 'Switch/iucn', statsyst, 'kode', nil ))
                .wikitext('&nbsp;')
                .wikitext(kom)
                .done()
            .newline()
            .wikitext('</div>')
            .newline()
            .wikitext('|-')
            .newline()
            .node(debpa)
            .done()
            
        return tostring(root)
    else
        return ''
    end
end

iucnp.get = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local statsyst = args.statsyst or pargs.statsyst or mw.text.trim(args[1] or pargs[1] or '')
    local stat = args.stat or pargs.stat or mw.text.trim(args[2] or pargs[2] or '')
    local kom = args.kom or pargs.kom or mw.text.trim(args[3] or pargs[3] or '')
    local isnykes = mw.text.trim(args['išnykęs'] or pargs['išnykęs'] or '')
    local deb = mw.text.trim(args['deb'] or pargs['deb'] or '')
 
    return iucnp._get( statsyst, stat, kom, isnykes, deb )
end

return iucnp;
