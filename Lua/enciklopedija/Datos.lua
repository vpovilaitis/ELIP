local HtmlBuilder = require('Module:HtmlBuilder')

datp = {}
 
local sk_menesio = {
    ['1'] = 'sausio',
    ['2'] = 'vasario',
    ['3'] = 'kovo',
    ['4'] = 'balandžio',
    ['5'] = 'gegužės',
    ['6'] = 'birželio',
    ['7'] = 'liepos',
    ['8'] = 'rugpjūčio',
    ['9'] = 'rugsėjo',
    ['10'] = 'spalio',
    ['11'] = 'lapkričio',
    ['12'] = 'gruodžio'
}

local sk_menesis = {
    ['1'] = 'sausis',
    ['2'] = 'vasaris',
    ['3'] = 'kovas',
    ['4'] = 'balandis',
    ['5'] = 'gegužė',
    ['6'] = 'birželis',
    ['7'] = 'liepa',
    ['8'] = 'rugpjūtis',
    ['9'] = 'rugsėjis',
    ['10'] = 'spalis',
    ['11'] = 'lapkritis',
    ['12'] = 'gruodis'
}

local men_d = {
    [1] = 31,
    [2] = 28,
    [3] = 31,
    [4] = 30,
    [5] = 31,
    [6] = 30,
    [7] = 31,
    [8] = 31,
    [9] = 30,
    [10] = 31,
    [11] = 30,
    [12] = 31
    }

local sk_menesio_u = {
    ['1'] = 'Sausio',
    ['2'] = 'Vasario',
    ['3'] = 'Kovo',
    ['4'] = 'Balandžio',
    ['5'] = 'Gegužės',
    ['6'] = 'Birželio',
    ['7'] = 'Liepos',
    ['8'] = 'Rugpjūčio',
    ['9'] = 'Rugsėjo',
    ['10'] = 'Spalio',
    ['11'] = 'Lapkričio',
    ['12'] = 'Gruodžio'
    }

--  january|jan=1|february|feb=2|march|mar=3|apr|april=4|may=5|june|jun=6|
--    july|jul=7|august|aug=8|september|sep=9|october|oct=10|november|nov=11|december|dec=12| 
local menuo_sk = {
    ['1'] = '1',
    ['sausis'] = '1',
    ['january'] = '1',
    ['jan'] = '1',
    ['2'] = '2',
    ['vasaris'] = '2',
    ['february'] = '2',
    ['feb'] = '2',
    ['3'] = '3',
    ['kovas'] = '3',
    ['march'] = '3',
    ['mar'] = '3',
    ['4'] = '4',
    ['balandis'] = '4',
    ['april'] = '4',
    ['apr'] = '4',
    ['5'] = '5',
    ['gegužė'] = '5',
    ['may'] = '5',
    ['6'] = '6',
    ['birželis'] = '6',
    ['june'] = '6',
    ['jun'] = '6',
    ['7'] = '7',
    ['liepa'] = '7',
    ['july'] = '7',
    ['jul'] = '7',
    ['8'] = '8',
    ['rugpjūtis'] = '8',
    ['august'] = '8',
    ['aug'] = '8',
    ['9'] = '9',
    ['rugsėjis'] = '9',
    ['september'] = '9',
    ['sep'] = '9',
    ['10'] = '10',
    ['spalis'] = '10',
    ['october'] = '10',
    ['oct'] = '10',
    ['11'] = '11',
    ['lapkritis'] = '11',
    ['november'] = '11',
    ['nov'] = '11',
    ['12'] = '12',
    ['gruodis'] = '12',
    ['december'] = '12',
    ['dec'] = '12'
    }

local amzius = {
        ['-29??'] = 'XXX amžius pr. m. e.',
        ['-28??'] = 'XXIX amžius pr. m. e.',
        ['-27??'] = 'XXVIII amžius pr. m. e.',
        ['-26??'] = 'XXVII amžius pr. m. e.',
        ['-25??'] = 'XXVI amžius pr. m. e.',
        ['-24??'] = 'XXV amžius pr. m. e.',
        ['-23??'] = 'XXIV amžius pr. m. e.',
        ['-22??'] = 'XXIII amžius pr. m. e.',
        ['-21??'] = 'XXII amžius pr. m. e.',
        ['-20??'] = 'XXI amžius pr. m. e.',
        ['-19??'] = 'XX amžius pr. m. e.',
        ['-18??'] = 'XIX amžius pr. m. e.',
        ['-17??'] = 'XVIII amžius pr. m. e.',
        ['-16??'] = 'XVII amžius pr. m. e.',
        ['-15??'] = 'XVI amžius pr. m. e.',
        ['-14??'] = 'XV amžius pr. m. e.',
        ['-13??'] = 'XIV amžius pr. m. e.',
        ['-12??'] = 'XIII amžius pr. m. e.',
        ['-11??'] = 'XII amžius pr. m. e.',
        ['-10??'] = 'XI amžius pr. m. e.',
        ['-9??'] = 'X amžius pr. m. e.',
        ['-8??'] = 'IX amžius pr. m. e.',
        ['-7??'] = 'VIII amžius pr. m. e.',
        ['-6??'] = 'VII amžius pr. m. e.',
        ['-5??'] = 'VI amžius pr. m. e.',
        ['-4??'] = 'V amžius pr. m. e.',
        ['-3??'] = 'IV amžius pr. m. e.',
        ['-2??'] = 'III amžius pr. m. e.',
        ['-1??'] = 'II amžius pr. m. e.',
        ['-??'] = 'I amžius pr. m. e.',
        ['??'] = 'I amžius',
        ['1??'] = 'II amžius',
        ['2??'] = 'III amžius',
        ['3??'] = 'IV amžius',
        ['4??'] = 'V amžius',
        ['5??'] = 'VI amžius',
        ['6??'] = 'VII amžius',
        ['7??'] = 'VIII amžius',
        ['8??'] = 'IX amžius',
        ['9??'] = 'X amžius',
        ['10??'] = 'XI amžius',
        ['11??'] = 'XII amžius',
        ['12??'] = 'XIII amžius',
        ['13??'] = 'XIV amžius',
        ['14??'] = 'XV amžius',
        ['15??'] = 'XVI amžius',
        ['16??'] = 'XVII amžius',
        ['17??'] = 'XVIII amžius',
        ['18??'] = 'XIX amžius',
        ['19??'] = 'XX amžius',
        ['20??'] = 'XXI amžius',
        ['21??'] = 'XXII amžius',
        ['22??'] = 'XXIII amžius',
        ['23??'] = 'XXIV amžius',
        ['24??'] = 'XXV amžius',
        ['25??'] = 'XXVI amžius',
        ['26??'] = 'XXVII amžius',
        ['27??'] = 'XXVIII amžius',
        ['28??'] = 'XXIX amžius',
        ['29??'] = 'XXX amžius',
    }

local am_ius = {
        ['-29??'] = 'XXX a. pr. m. e.',
        ['-28??'] = 'XXIX a. pr. m. e.',
        ['-27??'] = 'XXVIII a. pr. m. e.',
        ['-26??'] = 'XXVII a. pr. m. e.',
        ['-25??'] = 'XXVI a. pr. m. e.',
        ['-24??'] = 'XXV a. pr. m. e.',
        ['-23??'] = 'XXIV a. pr. m. e.',
        ['-22??'] = 'XXIII a. pr. m. e.',
        ['-21??'] = 'XXII a. pr. m. e.',
        ['-20??'] = 'XXI a. pr. m. e.',
        ['-19??'] = 'XX a. pr. m. e.',
        ['-18??'] = 'XIX a. pr. m. e.',
        ['-17??'] = 'XVIII a. pr. m. e.',
        ['-16??'] = 'XVII a. pr. m. e.',
        ['-15??'] = 'XVI a. pr. m. e.',
        ['-14??'] = 'XV a. pr. m. e.',
        ['-13??'] = 'XIV a. pr. m. e.',
        ['-12??'] = 'XIII a. pr. m. e.',
        ['-11??'] = 'XII a. pr. m. e.',
        ['-10??'] = 'XI a. pr. m. e.',
        ['-9??'] = 'X a. pr. m. e.',
        ['-8??'] = 'IX a. pr. m. e.',
        ['-7??'] = 'VIII a. pr. m. e.',
        ['-6??'] = 'VII a. pr. m. e.',
        ['-5??'] = 'VI a. pr. m. e.',
        ['-4??'] = 'V a. pr. m. e.',
        ['-3??'] = 'IV a. pr. m. e.',
        ['-2??'] = 'III a. pr. m. e.',
        ['-1??'] = 'II a. pr. m. e.',
        ['-??'] = 'I a. pr. m. e.',
        ['??'] = 'I a.',
        ['1??'] = 'II a.',
        ['2??'] = 'III a.',
        ['3??'] = 'IV a.',
        ['4??'] = 'V a.',
        ['5??'] = 'VI a.',
        ['6??'] = 'VII a.',
        ['7??'] = 'VIII a.',
        ['8??'] = 'IX a.',
        ['9??'] = 'X a.',
        ['10??'] = 'XI a.',
        ['11??'] = 'XII a.',
        ['12??'] = 'XIII a.',
        ['13??'] = 'XIV a.',
        ['14??'] = 'XV a.',
        ['15??'] = 'XVI a.',
        ['16??'] = 'XVII a.',
        ['17??'] = 'XVIII a.',
        ['18??'] = 'XIX a.',
        ['19??'] = 'XX a.',
        ['20??'] = 'XXI a.',
        ['21??'] = 'XXII a.',
        ['22??'] = 'XXIII a.',
        ['23??'] = 'XXIV a.',
        ['24??'] = 'XXV a.',
        ['25??'] = 'XXVI a.',
        ['26??'] = 'XXVII a.',
        ['27??'] = 'XXVIII a.',
        ['28??'] = 'XXIX a.',
        ['29??'] = 'XXX a.',
    }

local amziaus = {
        ['-29??'] = 'XXX amžiaus pr. m. e.',
        ['-28??'] = 'XXIX amžiaus pr. m. e.',
        ['-27??'] = 'XXVIII amžiaus pr. m. e.',
        ['-26??'] = 'XXVII amžiaus pr. m. e.',
        ['-25??'] = 'XXVI amžiaus pr. m. e.',
        ['-24??'] = 'XXV amžiaus pr. m. e.',
        ['-23??'] = 'XXIV amžiaus pr. m. e.',
        ['-22??'] = 'XXIII amžiaus pr. m. e.',
        ['-21??'] = 'XXII amžiaus pr. m. e.',
        ['-20??'] = 'XXI amžiaus pr. m. e.',
        ['-19??'] = 'XX amžiaus pr. m. e.',
        ['-18??'] = 'XIX amžiaus pr. m. e.',
        ['-17??'] = 'XVIII amžiaus pr. m. e.',
        ['-16??'] = 'XVII amžiaus pr. m. e.',
        ['-15??'] = 'XVI amžiaus pr. m. e.',
        ['-14??'] = 'XV amžiaus pr. m. e.',
        ['-13??'] = 'XIV amžiaus pr. m. e.',
        ['-12??'] = 'XIII amžiaus pr. m. e.',
        ['-11??'] = 'XII amžiaus pr. m. e.',
        ['-10??'] = 'XI amžiaus pr. m. e.',
        ['-9??'] = 'X amžiaus pr. m. e.',
        ['-8??'] = 'IX amžiaus pr. m. e.',
        ['-7??'] = 'VIII amžiaus pr. m. e.',
        ['-6??'] = 'VII amžiaus pr. m. e.',
        ['-5??'] = 'VI amžiaus pr. m. e.',
        ['-4??'] = 'V amžiaus pr. m. e.',
        ['-3??'] = 'IV amžiaus pr. m. e.',
        ['-2??'] = 'III amžiaus pr. m. e.',
        ['-1??'] = 'II amžiaus pr. m. e.',
        ['-??'] = 'I amžiaus pr. m. e.',
        ['??'] = 'I amžiaus',
        ['1??'] = 'II amžiaus',
        ['2??'] = 'III amžiaus',
        ['3??'] = 'IV amžiaus',
        ['4??'] = 'V amžiaus',
        ['5??'] = 'VI amžiaus',
        ['6??'] = 'VII amžiaus',
        ['7??'] = 'VIII amžiaus',
        ['8??'] = 'IX amžiaus',
        ['9??'] = 'X amžiaus',
        ['10??'] = 'XI amžiaus',
        ['11??'] = 'XII amžiaus',
        ['12??'] = 'XIII amžiaus',
        ['13??'] = 'XIV amžiaus',
        ['14??'] = 'XV amžiaus',
        ['15??'] = 'XVI amžiaus',
        ['16??'] = 'XVII amžiaus',
        ['17??'] = 'XVIII amžiaus',
        ['18??'] = 'XIX amžiaus',
        ['19??'] = 'XX amžiaus',
        ['20??'] = 'XXI amžiaus',
        ['21??'] = 'XXII amžiaus',
        ['22??'] = 'XXIII amžiaus',
        ['23??'] = 'XXIV amžiaus',
        ['24??'] = 'XXV amžiaus',
        ['25??'] = 'XXVI amžiaus',
        ['26??'] = 'XXVII amžiaus',
        ['27??'] = 'XXVIII amžiaus',
        ['28??'] = 'XXIX amžiaus',
        ['29??'] = 'XXX amžiaus'
    }
    
local desimtmetis = {
        ['-9?'] = '1-asis dešimtmetis',
        ['-8?'] = '2-asis dešimtmetis',
        ['-7?'] = '3-asis dešimtmetis',
        ['-6?'] = '4-asis dešimtmetis',
        ['-5?'] = '5-asis dešimtmetis',
        ['-4?'] = '6-asis dešimtmetis',
        ['-3?'] = '7-asis dešimtmetis',
        ['-2?'] = '8-asis dešimtmetis',
        ['-1?'] = '9-asis dešimtmetis',
        ['-0?'] = '10-asis dešimtmetis',
        ['0?'] = '1-asis dešimtmetis',
        ['1?'] = '2-asis dešimtmetis',
        ['2?'] = '3-asis dešimtmetis',
        ['3?'] = '4-asis dešimtmetis',
        ['4?'] = '5-asis dešimtmetis',
        ['5?'] = '6-asis dešimtmetis',
        ['6?'] = '7-asis dešimtmetis',
        ['7?'] = '8-asis dešimtmetis',
        ['8?'] = '9-asis dešimtmetis',
        ['9?'] = '10-asis dešimtmetis',
    }

local desimt = {
        ['-9?'] = '1 deš.',
        ['-8?'] = '2 deš.',
        ['-7?'] = '3 deš.',
        ['-6?'] = '4 deš.',
        ['-5?'] = '5 deš.',
        ['-4?'] = '6 deš.',
        ['-3?'] = '7 deš.',
        ['-2?'] = '8 deš.',
        ['-1?'] = '9 deš.',
        ['-0?'] = '10 deš.',
        ['0?'] = '1 deš.',
        ['1?'] = '2 deš.',
        ['2?'] = '3 deš.',
        ['3?'] = '4 deš.',
        ['4?'] = '5 deš.',
        ['5?'] = '6 deš.',
        ['6?'] = '7 deš.',
        ['7?'] = '8 deš.',
        ['8?'] = '9 deš.',
        ['9?'] = '10 deš.',
    }


datp._monthnumber = function( aname )
    local root = HtmlBuilder.create()
    local lang = mw.language.getContentLanguage()
    
    if aname ~= nil then
        aname = mw.text.trim( aname )
    end

    if aname ~= nil and aname ~= '' then
        local men = lang:lc(aname)
        local menn = menuo_sk[men]
    
        if menn ~= nil and menn ~= '' then
            root
                .wikitext(menn)
                .done()
             
            return  tostring(root)
        else
            menn = tostring(tonumber(men))
            menn = menuo_sk[menn]
        
            if menn ~= nil and menn ~= '' then
                root
                    .wikitext(menn)
                    .done()
                 
                return  tostring(root)
            else
                root
                    .wikitext("Blogas privalomas parametras (1=''mėnuo''")
                    .wikitext("[[Kategorija:Blogas šablono parametras]]")
                    .done()
                return tostring(root)
            end
        end
    else
        root
            .wikitext("Trūksta privalomo parametro (1=''mėnuo''")
            .wikitext("[[Kategorija:Trūksta šablono parametrų]]")
            .done()
        return tostring(root)
    end
end

datp.monthnumber = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args[1] or pargs[1] or ''
    return datp._monthnumber(aname)
end

datp._monthname = function( args )
    local aname = args.name or ''
    local atype = args.typ or 'kil'
    local root = HtmlBuilder.create()

    if aname ~= nill then
        aname = mw.text.trim( aname )
    end

    if aname ~= nil and aname ~= '' then
        local men = ''
        if atype == 'kil' then
            men = sk_menesio[datp._monthnumber(aname)]
        elseif atype == 'var' then
            men = sk_menesis[datp._monthnumber(aname)]
        end
    
        if men ~= nil and men ~= '' then
            root
                .wikitext(men)
                .done()
             
            return  tostring(root)
        else
            root
                .wikitext("Blogas privalomas parametras (1=''mėnuo''")
                .wikitext("[[Kategorija:Blogas šablono parametras]]")
                .done()
            return tostring(root)
        end
    else
        root
            .wikitext("Trūksta privalomo parametro (1=''mėnuo''")
            .wikitext("[[Kategorija:Trūksta šablono parametrų]]")
            .done()
        return tostring(root)
    end
end

datp.monthname = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args[1] or pargs[1] or ''
    
    return datp._monthname{ name=aname }
end

datp._monthname_u = function( args )
    local aname = args.name or ''
    local root = HtmlBuilder.create()

    if aname ~= nill then
        aname = mw.text.trim( aname )
    end

    if aname ~= nil and aname ~= '' then
        local men = sk_menesio_u[datp._monthnumber(aname)]
    
        if men ~= nil and men ~= '' then
            root
                .wikitext(men)
                .done()
             
            return  tostring(root)
        else
            root
                .wikitext("Blogas privalomas parametras (1=''mėnuo''")
                .wikitext("[[Kategorija:Blogas šablono parametras]]")
                .done()
            return tostring(root)
        end
    else
        root
            .wikitext("Trūksta privalomo parametro (1=''mėnuo''")
            .wikitext("[[Kategorija:Trūksta šablono parametrų]]")
            .done()
        return tostring(root)
    end
end

datp.monthname_u = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local aname = args[1] or pargs[1] or ''
    
    return datp._monthname_u{ name=aname }
end

datp._siandien = function( args )
    local form = args.form or ''
    local skirt = args.skirt or '/'
    
    if form ~= '' then
        return os.date(form)
    else
        return os.date('%Y')..skirt..os.date('%m')..skirt..os.date('%d')
    end
end

datp.siandien = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local form = args.form or pargs.form or ''
    local skirt = args.skirt or pargs.skirt or '/'
    
    return datp._siandien {form=form, skirt=skirt}
end

datp._age = function( args )
    --local root = HtmlBuilder.create()
    local ayear = args.ayear or ''
    local amonth = args.amonth or ''
    local aday = args.aday or ''
    local byear = args.byear or ''
    local bmonth = args.bmonth or ''
    local bday = args.bday or ''
    local anuo = args.nuo or ''
    local aiki = args.iki or ''
    local apie = args.apie or ''
    local skirt = args.skirt or '-'
    
    local currtime = mw.text.split( datp._siandien {skirt='/'}, '/' )
    
    if anuo == '' and aiki == ''and ayear == ''and amonth == ''and amonth == '' then
        return ''
    elseif anuo == '' and aiki == '' then
        ayear, amonth, aday = tonumber(ayear), tonumber('0'..amonth), tonumber('0'..aday)
        if byear == '' and bmonth == '' and bday == '' then
            byear, bmonth, bday = tonumber(currtime[1]), tonumber(currtime[2]), tonumber(currtime[3])
        else
            byear, bmonth, bday = tonumber(byear), tonumber('0'..bmonth), tonumber('0'..bday)
        end
    elseif aiki == '' then
        local sign, date = 1, anuo
        date = mw.ustring.gsub( date, '%?', '0' )
        if date ~= anuo then
            apie = '~'
        end
        if string.sub(date,1,1) == '~' then
            apie, date = '~', string.sub(date,2)
        end
        if string.sub(date,1,1) == '-' and skirt == '-' then
            sign, date = -1, string.sub(date,2)
        end
        local nuotime = mw.text.split( date, skirt )
        ayear, amonth, aday = tonumber('0'..(nuotime[1] or ''))*sign, tonumber('0'..(nuotime[2] or '')), tonumber('0'..(nuotime[3] or ''))
        local ikitime = currtime
        byear, bmonth, bday = tonumber(ikitime[1]), tonumber(ikitime[2]), tonumber(ikitime[3])
    else
        local sign, date = 1, anuo
        date = mw.ustring.gsub( date, '%?', '0' )
        if date ~= anuo then
            apie = '~'
        end
        if string.sub(date,1,1) == '~' then
            apie, date = '~', string.sub(date,2)
        end
        if string.sub(date,1,1) == '-' and skirt == '-' then
            sign, date = -1, string.sub(date,2)
        end
        local nuotime = mw.text.split( date, skirt )
        ayear, amonth, aday = tonumber(nuotime[1])*sign, tonumber('0'..(nuotime[2] or '')), tonumber('0'..(nuotime[3] or ''))
        local sign, date = 1, aiki
        date = mw.ustring.gsub( date, '%?', '0' )
        if date ~= aiki then
            apie = '~'
        end
        if string.sub(date,1,1) == '~' then
            apie, date = '~', string.sub(date,2)
        end
        if string.sub(date,1,1) == '-' and skirt == '-' then
            sign, date = -1, string.sub(date,2)
        end
        local ikitime = mw.text.split( date..skirt..skirt, skirt )
        byear, bmonth, bday = tonumber(ikitime[1])*sign, tonumber('0'..(ikitime[2] or '')), tonumber('0'..(ikitime[3] or ''))
    end
    
    if amonth*aday*bmonth*bday > 0 then
        local smonth = 0
        if bmonth < amonth or ( bmonth == amonth and bday < aday ) then
            smonth = 1
        end
        if byear - ayear - smonth == 0 then
            if bmonth == amonth then
                return apie .. tostring( bday - aday ) .. ' d.'
            else
                return apie .. tostring( men_d[amonth] + bday - aday ) .. ' d.'
            end
        else
            return apie .. tostring( byear - ayear - smonth ) .. ' m.'
        end
    else
        return '~' .. tostring( byear - ayear ) .. ' m.'
    end
end

datp.age = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local ayear = args[1] or pargs[1] or ''
    local amonth = args[2] or pargs[2] or ''
    local aday = args[3] or pargs[3] or ''
    local byear = args[4] or pargs[4] or ''
    local bmonth = args[5] or pargs[5] or ''
    local bday = args[6] or pargs[6] or ''
    local anuo = args.nuo or pargs.nuo or ''
    local aiki = args.iki or pargs.iki or ''
    local apie = args.apie or pargs.apie or ''
    local skirt = args.skirt or pargs.skirt or '-'
    
    return datp._age{ ayear=ayear, amonth=amonth, aday=aday, byear=byear, bmonth=bmonth, bday=bday, 
       nuo=anuo, iki=aiki, apie=apie, skirt=skirt }
end

datp._gime = function( args )
    local frame = mw.getCurrentFrame()
    local root = HtmlBuilder.create()
    local ayear = args.ayear or ''
    local amonth = args.amonth or ''
    local aday = args.aday or ''
    local suamz = args.suamz or ''
    local gime = args.gime or ''
    local apie = args.apie or ''
    local md = args.md or ''
    local set = args.set or ''
    local kat = args.kat or ''
    local aiki = args.iki or ''
    local skirt = args.skirt or '-'
    local sign = ''
    
    if gime == '' and ayear == '' and amonth == '' and aday == '' then
       return ''
    end
    if gime == '' then
        gime = apie .. ayear .. skirt .. amonth .. skirt .. aday
    end
    if string.sub(gime,1,1) == '~' or string.sub(gime,1,1) == '<' or string.sub(gime,1,1) == '>' then
        apie, gime = string.sub(gime,1,1), string.sub(gime,2)
    end
    if string.sub(gime,1,1) == '-' and skirt == '-' then
        sign, gime = '-', string.sub(gime,2)
    end
    local gimemas = mw.text.split( gime, skirt )
    ayear, amonth, aday = gimemas[1], gimemas[2] or '?', gimemas[3] or '?'
    
    gimeapie = mw.ustring.gsub( gime, '%?', '0' )
    if apie == '' and gimeapie ~= gime then
        apie = '~'
    end
    ayearapie = mw.ustring.gsub( ayear, '%?', '0' )
    amonthapie = mw.ustring.gsub( amonth, '%?', '0' )
    adayapie = mw.ustring.gsub( aday, '%?', '0' )
    amznuo = sign .. ayearapie .. skirt .. amonthapie .. skirt .. adayapie
    gimdata = sign .. ayear .. skirt .. amonth .. skirt .. aday
    if apie ~= '' then
        amznuo = '~' .. amznuo
        gimdata = '~' .. gimdata
    end
    if set ~= '' then
        frame:callParserFunction{ name = '#set', args = set..' data='..gimdata }
    end
    
    if md == 'U' or md == 'u' then
        if apie == '~' then
            root.wikitext('Apie ')
            md = 'x'
        elseif apie == '<' then
            root.wikitext('Prieš ')
            md = 'x'
        elseif apie == '>' then
            root.wikitext('Po ')
            md = 'x'
        end
    elseif md == 'AU' or md == 'au' then
        if apie == '~' then
            root.wikitext('Apie ')
            md = ''
        elseif apie == '<' then
            root.wikitext('Prieš ')
            md = ''
        elseif apie == '>' then
            root.wikitext('Po ')
            md = ''
        end
    else
        if apie == '~' then
            root.wikitext('apie ')
        elseif apie == '<' then
            root.wikitext('prieš ')
        elseif apie == '>' then
            root.wikitext('po ')
        end
    end
    if md == '' and ayear ~= '' then
        local mettxt = 'm.'
        if sign == '-' then
            mettxt = 'm. pr. m. e.'
        end
        if ayearapie == ayear then
            root
                .wikitext('[[')
                .wikitext(ayear)
                .wikitext(' ')
                .wikitext(mettxt)
                .wikitext(']]')
            if set ~= '' then
                frame:callParserFunction{ name = '#set', args = set..' metai='..ayear..' '..mettxt }
            end
            if kat ~= '' then
                root
                    .wikitext('[[Kategorija:'..kat..' ')
                    .wikitext(ayear)
                    .wikitext(' ')
                    .wikitext(mettxt)
                    .wikitext(']]')
            end
        else
            local amz = amzius[sign..ayear]
            local amzr = am_ius[sign..ayear]
            if amz ~= nil then
                root
                    .wikitext('[[')
                    .wikitext(amz)
                    .wikitext('|')
                    .wikitext(amzr)
                    .wikitext(']]')
                if set ~= '' then
                    frame:callParserFunction{ name = '#set', args = set..' metai='..amz }
                end
                if kat ~= '' then
                    root
                        .wikitext('[[Kategorija:'..kat..' ')
                        .wikitext(amz)
                        .wikitext(']]')
                end
            else
                amz = amziaus[sign..string.sub(ayear,1,string.len(ayear)-2)..'??']
                amzr = am_ius[sign..string.sub(ayear,1,string.len(ayear)-2)..'??']
                local des = desimtmetis[sign..string.sub(ayear,-2)]
                local desr = desimt[sign..string.sub(ayear,-2)]
                root
                    .wikitext('[[')
                    .wikitext(amz)
                    .wikitext(' ')
                    .wikitext(des)
                    .wikitext('|')
                    .wikitext(amzr)
                    .wikitext(' ')
                    .wikitext(desr)
                    .wikitext(']]')
                if set ~= '' then
                    frame:callParserFunction{ name = '#set', args = set..' metai='..amz..' '..des }
                end
                if kat ~= '' then
                    root
                        .wikitext('[[Kategorija:'..kat..' ')
                        .wikitext(amz)
                        .wikitext(' ')
                        .wikitext(des)
                        .wikitext(']]')
                end
            end
        end
    end
    
    if amonth ~= '' and amonthapie == amonth then
        if aday ~= '' and adayapie == aday then
            if md == '' and ayear ~= '' then
                root.wikitext('&#32;')
            end
            aday = tostring(tonumber(aday))
            if md == 'U' or md == 'u' then
                root
                    .wikitext('[[')
                    .wikitext( datp._monthname_u{ name=amonth } )
                    .wikitext(' ')
                    .wikitext( aday )
                    .wikitext(']] d.')
            else
                root
                    .wikitext('[[')
                    .wikitext( datp._monthname{ name=amonth } )
                    .wikitext(' ')
                    .wikitext( aday )
                    .wikitext(']] d.')
            end
            if set ~= '' then
                frame:callParserFunction{ name = '#set', args = set..' diena='..datp._monthname_u{ name=amonth }..' '..aday }
            end
            if kat ~= '' then
                root
                    .wikitext('[[Kategorija:'..kat..' ')
                    .wikitext( datp._monthname{ name=amonth } )
                    .wikitext(' ')
                    .wikitext( aday )
                    .wikitext(' d.]]')
            end
        else
            if md == '' and ayear ~= '' then
                root.wikitext('&#32;')
            end
            if md == 'U' or md == 'u' then
                root
                    .wikitext('[[')
                    .wikitext( datp._monthname{ name=amonth, typ='var' } )
                    .wikitext('|')
                    .wikitext( datp._monthname_u{ name=amonth } )
                    .wikitext(']] mėn.')
            else
                root
                    .wikitext('[[')
                    .wikitext( datp._monthname{ name=amonth, typ='var' } )
                    .wikitext('|')
                    .wikitext( datp._monthname{ name=amonth } )
                    .wikitext(']] mėn.')
            end
            if kat ~= '' then
                root
                    .wikitext('[[Kategorija:'..kat..' ')
                    .wikitext( datp._monthname{ name=amonth } )
                    .wikitext(' mėn.]]')
            end
        end
    end

    if suamz ~= '' then
       if aiki == '' or aiki == '--' then
         if amznuo ~= '--' and amznuo ~= '' then
        root
            .wikitext(' ')
            .tag('span')
                .attr('class', 'noprint')
                .css('white-space', 'nowrap')
                .wikitext('(')
                .wikitext(datp._age{ nuo=amznuo, iki='' })
                .wikitext(')')
                .done()
          end
       else
        root
            .wikitext(' ')
            .tag('span')
                .attr('class', 'noprint')
                .css('white-space', 'nowrap')
                .wikitext('(')
                .wikitext(datp._age{ iki=amznuo, nuo=aiki })
                .wikitext(')')
                .done()
       end
    end
                
    return tostring(root)
end

datp.gime = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local ayear = args[1] or pargs[1] or args.year or pargs.year or ''
    local amonth = args[2] or pargs[2] or args.month or pargs.month or ''
    local aday = args[3] or pargs[3] or args.day or pargs.day or ''
    local suamz = args[4] or pargs[4] or args.suamz or pargs.suamz or ''
    local agime = args['gimė'] or args['data'] or pargs['gimė'] or pargs['data'] or ''
    local apie = args.apie or pargs.apie or ''
    local md = args.md or pargs.md or ''
    local set = args.set or pargs.set or ''
    local kat = args.kat or pargs.kat or ''
    local skirt = args.skirt or pargs.skirt or '-'
    
    return datp._gime{ frame=frame, ayear=ayear, amonth=amonth, aday=aday, suamz=suamz, 
       gime=agime, apie=apie, md=md, set=set, kat=kat, skirt=skirt, iki='' }
end

datp.mire = function( frame )
    local args, pargs = frame.args, (frame:getParent() or {}).args or {}
    local ayear = args[1] or pargs[1] or args.dyear or pargs.dyear or ''
    local amonth = args[2] or pargs[2] or args.dmonth or pargs.dmonth or ''
    local aday = args[3] or pargs[3] or args.dday or pargs.dday or ''
    local byear = args[4] or pargs[4] or args.byear or pargs.byear or ''
    local bmonth = args[5] or pargs[5] or args.bmonth or pargs.bmonth or ''
    local bday = args[6] or pargs[6] or args.bday or pargs.bday or ''
    local suamz = args.suamz or pargs.suamz or 'T'
    local gime = args['gimė'] or pargs['gimė'] or ''
    local amire = args['mirė'] or pargs['mirė'] or ''
    local apie = args.apie or pargs.apie or ''
    local md = args.md or pargs.md or ''
    local set = args.set or pargs.set or ''
    local kat = args.kat or pargs.kat or ''
    local skirt = args.skirt or pargs.skirt or '-'
    
    if gime == '' then
        gime = byear .. skirt .. bmonth .. skirt .. bday
        if byear == '' then
           suamz = ''
        end
    end
    if apie ~= '' then
        suamz = ''
    end
    if amire == '' and ayear == '' then
       return ''
    end

    return datp._gime{ frame=frame, ayear=ayear, amonth=amonth, aday=aday, suamz=suamz, 
       gime=amire, apie=apie, md=md, set=set, kat=kat, skirt=skirt, iki=gime }
end

return datp
