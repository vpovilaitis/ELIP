-- This module implements {{error}}.

local pklaida = {}

local HtmlBuilder = require('Module:HtmlBuilder')

local function _klaida(args)
    local message = args.message or args[1] or error('Pranešimas nenurodytas', 2)
    message = tostring(message)
    local tag = mw.ustring.lower(tostring(args.tag))

    -- Work out what html tag we should use.
    if not (tag == 'p' or tag == 'span' or tag == 'div') then
        tag = 'strong'
    end

    -- Generate the html.
    local root = HtmlBuilder.create(tag)
    root
        .addClass('error')
        .wikitext(message)

    return tostring(root)
end

function pklaida.klaida(frame)
    local args
    if frame == mw.getCurrentFrame() then
        -- We're being called via #invoke. The args are passed through to the module
        -- from the template page, so use the args that were passed into the template.
        args = frame.args
    else
        -- We're being called from another module or from the debug console, so assume
        -- the args are passed in directly.
        args = frame
    end
    -- if the message parameter is present but blank, change it to nil so that Lua will
    -- consider it false.
    if args.message == "" then
        args.message = nil
    end
    -- local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    -- local message = args.message or pargs.message or mw.text.trim(args[1] or pargs[1] or '')
    -- local tag = args.tag or pargs.tag or ''
    -- args.message = message
    -- args.tag = tag
    return _klaida(args)
end

return pklaida
