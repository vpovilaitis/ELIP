local HtmlBuilder = require('Module:HtmlBuilder')

p = {}

p._kom = function( txt, kom, lnk )
    local root = HtmlBuilder.create()

    if kom then
        if lnk then
            root
                .tag('span')
                    .attr('title', kom)
                    .css('border-bottom', '1px dotted')
                    .css('cursor', 'help')
                    .css('white-space', 'nowrap')
                    .wikitext( '[[',  lnk, '|', txt, ']]' )
                    .done()
        else
            root
                .tag('span')
                    .attr('title', kom)
                    .css('border-bottom', '1px dotted')
                    .css('cursor', 'help')
                    .css('white-space', 'nowrap')
                    .wikitext( txt )
                    .done()
        end
    else
        if lnk then
            root
                .tag('span')
                    .wikitext( '[[',  lnk, '|', txt, ']]' )
        else
            root
                .tag('span')
                    .wikitext( txt )
        end
    end
     
    return  tostring(root)
end

p.kom = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local _txt = args.txt or pargs.txt or mw.text.trim(args[1] or pargs[1] or '')
    local _kom = args.kom or pargs.kom or mw.text.trim(args[2] or pargs[2] or '')
    local _lnk = args.lnk or pargs.lnk or mw.text.trim(args[3] or pargs[3] or '')
    if _lnk == '' then
        _lnk = nil
    end
    if _kom == '' then
        _kom = nil
    end
    if _txt == '' then
        _txt = '?'
        _kom = 'Panaudotas komentaro šablonas be teksto.'
    end
    
    return p._kom( _txt, _kom, _lnk )
end

return p
