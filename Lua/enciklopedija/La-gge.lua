local HtmlBuilder = require('Module:HtmlBuilder')

laggep = {}

laggep._lagge = function( la, link )
    local root = HtmlBuilder.create()
 
    root.wikitext('[[Vaizdas:LogoWIKISPECIES.png|25px|link=gge:', link, ']] ')
    if link == '' then
        root.wikitext(la)
    else
        root
            .tag('i')
                .wikitext('[[species:', link, '|', la, ']]')
                .done()
    end
    
    root.done()
     
    return  tostring(root)
end

laggep.lagge = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local la = args.la or pargs.la or mw.text.trim(args[1] or pargs[1] or '')
    local link = args.link or pargs.link or la
    if mw.ustring.find(link, "[%'%[%]]") then link = '' end
    if mw.ustring.find(la, "[%'%[%]]") then link = '' end
    if la == '' then
        return laggep._lagge( '{{{1}}}', '' )
    else
        return laggep._lagge( la, link )
    end
end

return laggep
