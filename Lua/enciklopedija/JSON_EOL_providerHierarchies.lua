jsonEOLph = require('Modulis:JSON')
 
jsonEOLph = {}
 
jsonEOLph.render = function ( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local atxt = args[1] or pargs[1] or ''
    local ltxt = args[2] or pargs[2] or ''
    local p = json.decode(atxt)
    local ltp = json.decode(ttxt)
    return '<nowiki>' .. json.encode(p) .. '---'  .. '</nowiki>'
end
 
return jsonEOLph
