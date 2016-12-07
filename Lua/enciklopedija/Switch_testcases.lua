-- Example Unit tests for [[Module:Bananas]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_Switch()
    local nwiki = false
    self:preprocess_equals('{{#invoke:Switch | switch |Switch/taxrank|gentis}}', 'table', {nowiki=nwiki})
    self:preprocess_equals('{{#invoke:Switch | switch2 |Switch/taxrank|gentis|link}}', '[[Gentis (biologija)|Gentis]]', {nowiki=nwiki})
    --self:preprocess_equals('{{#invoke:La-gge | lagge |Alauda}}', '[[Vaizdas:LogoWIKISPECIES.png|25px|link=gge:Alauda]] <i>[[Wikispecies:Alauda|Alauda]]</i>', {nowiki=nwiki})
    --self:preprocess_equals('{{#invoke:La-gge | lagge |[[Wikispecies:Alauda]]}}', '[[Vaizdas:LogoWIKISPECIES.png|25px|link=gge:]] [[Wikispecies:Alauda]]', {nowiki=nwiki})
end

return p
