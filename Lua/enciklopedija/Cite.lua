local cite = {
    --wikitext = require("Module:Wikitext"),
    extensiontags = {
        nowiki = true,
        ref = true,
        gallery = true,
        pre = true,
        source = true,
        categorytree = true,
        charinsert = true,
        hiero = true,
        imagemap = true,
        inputbox = true,
        math = true,
        poem = true,
        ref = true,
        references = true,
        syntaxhighlight = true,
        timeline = true,
    }
}

-- This returns a string with HTML character entities for wikitext markup characters.
function wikiescape(text)
    text = text:gsub( '[&\'%[%]{|}]', {    
            ['&'] = '&#38;',    
            ["'"] = '&#39;',    
            ['['] = '&#91;',    
            [']'] = '&#93;',    
            ['{'] = '&#123;',	
            ['|'] = '&#124;',	
            ['}'] = '&#125;' } );
    return text;
end
 
cite.createTag = function(t, frame)
    local name = t.name or "!-- --"
    local content = t.contents or ""
    local attrs = {}
    if ( cite.extensiontags[name] ) then
        -- We have to preprocess these, so that they are properly turned into so-called "strip markers" in the generated wikitext.
        if ( not frame ) then error ("Funkcijai createTag() reikia nurodyti frame argumentą.") end
        local params = {}
        for n,v in pairs(t.params) do
            table.insert(params, "|" .. n .. "=" .. v)
        end
        return frame:preprocess("{{#tag:" .. name .. "|" .. content .. table.concat(params) .. "}}")
    else   
        for n,v in pairs(t.params) do
            if (v) then
                table.insert(attrs, n .. "=\"" .. wikiescape(v) .. "\"")
            else
                table.insert(attrs, n)
            end
        end
        if ("" == content) then
            return "<" .. name .. " " .. table.concat(attrs, " ") .. "/>"
        else
            return "<" .. name .. " " .. table.concat(attrs, " ") .. ">" .. content .. "</" .. name .. ">"
        end
    end
end
 
cite._isn = function( frame, config, args )
    local txt, name = args[1] or '', args[2] or ''
 
    if txt ~= '' and name ~= '' then
        return cite.createTag({name="ref",contents=txt,params={name=name}}, frame)
    elseif txt ~= '' then
        return cite.createTag({name="ref",contents=txt,params={}}, frame)
    elseif name ~= '' then
        return cite.createTag({name="ref",contents='',params={name=name}}, frame)
    else
        return cite.createTag({name="sup",contents='[[Enciklopedija:Šaltinių nurodymas|[reikalingas šaltinis]]][[Kategorija:Reikalinga citata]]',params={}}, frame)
    end
end

cite.isn = function( frame )
    local pframe = frame:getParent()
    local config = frame.args -- the arguments passed BY the template, in the wikitext of the template itself
    local args = pframe.args -- the arguments passed TO the template, in the wikitext that instantiates the template
    return cite._isn(frame, config, args)
end

return cite
