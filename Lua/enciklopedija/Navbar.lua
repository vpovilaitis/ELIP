﻿local p = {}

local HtmlBuilder = require('Module:HtmlBuilder')

function trim(s)
    return mw.ustring.match( s, "^%s*(.-)%s*$" )
end

function error(s)
    local span = HtmlBuilder.create('span')

    span
        .addClass('error')
        .css('float', 'left')
        .css('white-space', 'nowrap')
        .wikitext('Klaida: ' .. s)

    return tostring(span)
end

function getTitle( pageName )
    pageName = trim( pageName );
    local page_title, talk_page_title;
    
    if mw.ustring.sub(pageName, 1, 1) == ':' then
        page_title = mw.title.new( mw.ustring.sub(pageName, 2) );
    else
        page_title = mw.title.new( pageName, 'Šablonas' );
    end    
    
    if page_title then 
        talk_page_title = page_title.talkPageTitle;
    else
        talk_page_title = nil;
    end
    
    return page_title, talk_page_title;    
end

function _navbar( args )
    if not args[1] then
        return error('Nenurodytas pavadinimas')
    end
 
    local good, title, talk_title;
    good, title, talk_title = pcall( getTitle, args[1] );
    if not good then
        return error('Expensive parser function limit exceeded');
    end    

    if not title then
        return error('Puslapio nėra')
    end
 
    local mainpage = title.fullText;
    local talkpage = talk_title and talk_title.fullText or ''
    local editurl = title:fullUrl( 'action=edit' ); 
 
    local viewLink, talkLink, editLink = 'peržiūrėti', 'aptarimas', 'redaguoti'
    if args.mini then
        viewLink, talkLink, editLink = 'p', 'a', 'r'
    end
 
    local div = HtmlBuilder.create( 'div' )
    div
        .addClass( 'noprint' )
        .addClass( 'plainlinks' )
        .addClass( 'hlist' )
        .addClass( 'navbar')
        .cssText( args.style )
 
    if args.mini then div.addClass('mini') end
 
    if not (args.mini or args.plain) then
        div
            .tag( 'span' )
                .css( 'word-spacing', 0 )
                .cssText( args.fontstyle )
                .wikitext( args.text or 'Ši lentelė:' )
                .wikitext( ' ' )
    end
 
    if args.brackets then
        div
            .tag('span')
                .css('margin-right', '-0.125em')
                .cssText( args.fontstyle )
                .wikitext( '&#91;' )
                .newline();
    end
 
    local ul = div.tag('ul');
 
    ul
        .tag( 'li' )
            .addClass( 'nv-view' )
            .wikitext( '[[' .. mainpage .. '|' )
            .tag( 'span ' )
                .attr( 'title', 'Peržiūrėti šį šabloną' )
                .cssText( args.fontstyle or '' )
                .wikitext( viewLink )
                .done()
            .wikitext( ']]' )
            .done()
        ---  .tag( 'li' )
        ---      .addClass( 'nv-talk' )
        ---      .wikitext( '[[' .. talkpage .. '|' )
        ---      .tag( 'span ' )
        ---          .attr( 'title', 'Aptarti šį šabloną' )
        ---          .cssText( args.fontstyle or '' )
        ---          .wikitext( talkLink )
        ---          .done()
        ---      .wikitext( ']]' );
 
    if not args.noedit then 
        ul
            .tag( 'li' )
                .addClass( 'nv-edit' )
                .wikitext( '[' .. editurl .. ' ' )
                .tag( 'span ' )
                    .attr( 'title', 'Redaguoti šį šabloną' )
                    .cssText( args.fontstyle or '' )
                    .wikitext( editLink )
                    .done()
                .wikitext( ']' );
    end
 
    if args.brackets then
        div
            .tag('span')
                .css('margin-left', '-0.125em')
                .cssText( args.fontstyle or '' )
                .wikitext( '&#93;' )
                .newline();
    end
 
    return tostring(div)
end

function p.navbar(frame)
    local origArgs
    -- If called via #invoke, use the args passed into the invoking template.
    -- Otherwise, for testing purposes, assume args are being passed directly in.
    if frame == mw.getCurrentFrame() then
        origArgs = frame:getParent().args
    else
        origArgs = frame
    end
 
    -- ParserFunctions considers the empty string to be false, so to preserve the previous 
    -- behavior of {{navbar}}, change any empty arguments to nil, so Lua will consider
    -- them false too.
    args = {}
    for k, v in pairs(origArgs) do
        if v ~= '' then
            args[k] = v
        end
    end
 
    return _navbar(args)
end
 
return p
