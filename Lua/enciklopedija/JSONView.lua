json = require('Modulis:JSON')

jsonp = {}

function make_table (t)
    local rows = ''
    for k, v in pairs(t) do
        rows = rows .. make_row(k, v)
    end
    return '<table class="mw-json-schema"><tbody>' .. rows .. '</tbody></table>'
end
 
function make_row (k, v)
    th = '<th>' .. k .. '</th>'
    if type(v) == 'table' then
        td = '<td>' .. make_table(v) .. '</td>'
    else
        if type(v) == 'string' then
            v = '"' .. v .. '"'
        else
            v = json.encode(v)
        end
        td = '<td class="value">' .. v .. '</td>'
    end
    return '<tr>' .. th .. td .. '</tr>'
end
 
jsonp.render = function ( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local atxt = args[1] or pargs[1] or ''
    local p = json.decode(atxt)
    return frame:callParserFunction{ name = '#tag', args = { 'pre', '\n\n  ' .. json.encode(p, {indent=true}) .. '\n\n' } }
    --return frame:extensionTag('poem','\n\n  ' .. json.encode(p, {indent=true}) .. '\n\n')
end
 
jsonp.renderUrl = function ( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aUrl = args[1] or pargs[1] or ''
    b, h, c, e = http.get(aUrl)
    local p = json.decode(b)
    return '<nowiki>\n' .. json.encode(p) .. '---'  .. '\n</nowiki>'
end
 
return jsonp
