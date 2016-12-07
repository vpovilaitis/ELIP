-- Given a single page name determines what page it redirects to and returns the target page name, or the
-- passed page name when not a redirect. The passed page name can be given as plain text or as a page link.
-- Returns page name as plain text, or when the bracket parameter is given, as a page link. Returns an
-- error message when page does not exist or the redirect target cannot be determined for some reason.

-- Thus these are roughly the same:
-- [[{{#invoke:redirect|main|redirect-page-name}}]] and {{#invoke:redirect|main|redirect-page-name|bracket=yes}}

local p={}

p.redir = function(prname, pbracket, nopage)
    if not prname or not mw.ustring.match(prname, "%S") then return "" end
    bracket = pbracket and "[[%s]]" or "%s"
    rname = mw.ustring.match(prname,"%[%[(.+)%]%]") or prname
    
    local rpage, err = mw.title.new(rname)
    
    -- avoid expensive operation when nothing to do
    if not rpage then
        err = "Nerasta (mw.title.new klaida)"
    elseif rpage.id == 0 then
        if nopage then
            return mw.ustring.format(bracket, rname)
        else
            err = "Nerasta (id=0):"
        end
    elseif not rpage.isRedirect then
        return mw.ustring.format(bracket, rname) -- not a redirect so use passed page name (for some general-purpose template use)
    else
        local rtxt = rpage:getContent() or ""
        local redirect = mw.ustring.match( rtxt, "^#[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]%s*%[%[(.-)%]%]" )
        
        if redirect then
            return mw.ustring.format(bracket, redirect)
        else
            redirect = mw.ustring.match( rtxt, "^#[Pp][Ee][Rr][Aa][Dd][Rr][Ee][Ss][Aa][Vv][Ii][Mm][Aa][Ss]%s*%[%[(.-)%]%]" )
            if redirect then
                return mw.ustring.format(bracket, redirect)
            end
        end
        
        err = "nepavyko suprasti"
    end
    
    return '<span style="text-color:red;">[[Modulis:Redirect]] klaida: ' .. err .. ' - [[' .. rname .. ']]</span>'
end

function p.main(frame)
    local args, pargs = frame.args or {}, (frame:getParent() or {}).args or {}
    local rname, bracket, nopage = args[1] or pargs[1], args.bracket or pargs.bracket, args.nopage or pargs.nopage
    
    return p.redir(rname, bracket, nopage)
end

return p
