<?php
/**
 * Internationalization file for the External Data extension
 *
 * @addtogroup Extensions
 */

$messages = array();

/** English
 * @author Yaron Koren
 */
$messages['en'] = array(
	// user messages
	'getdata' => 'Get data',
	'externaldata-desc' => 'Allows for retrieving structured data from external URLs, databases and other sources',
	'externaldata-web-invalid-format' => 'Invalid format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Unable to connect to $1',
	'externaldata-xml-error' => 'XML error: $1 at line $2',
	'externaldata-db-incomplete-information' => 'Error: Incomplete information for this database ID.',
	'externaldata-db-could-not-get-url' => 'Could not get URL after $1 {{PLURAL:$1|try|tries}}.',
	'externaldata-db-unknown-type' => 'Error: Unknown database type.',
	'externaldata-db-could-not-connect' => 'Error: Could not connect to database.',
	'externaldata-db-unknown-collection' => 'Error: Unknown MongoDB collection.',
	'externaldata-db-no-return-values' => 'Error: No return values specified.',
	'externaldata-db-invalid-query' => 'Invalid query.',
);

/** Message documentation (Message documentation)
 * @author Dead3y3
 * @author Fryed-peach
 * @author Shirayuki
 */
$messages['qqq'] = array(
	'getdata' => '{{doc-special|GetData}}',
	'externaldata-desc' => '{{desc|name=External Data|url=http://www.mediawiki.org/wiki/Extension:External_Data}}',
	'externaldata-web-invalid-format' => 'The error message if #get_web_data is called with an invalid format value',
	'externaldata-ldap-unable-to-connect' => "The error message if #get_ldap_data can't connect to the LDAP server",
	'externaldata-xml-error' => "The error message if #get_web_data can't parse an XML file",
	'externaldata-db-incomplete-information' => 'Used as error message.

Database server, database type, database directory, database username and/or database password are not specified.',
	'externaldata-db-could-not-get-url' => 'Parameters:
* $1 - number of HTTP tries',
	'externaldata-db-unknown-type' => 'Used as error message when creating a database object with using the specified information.',
	'externaldata-db-could-not-connect' => 'Used as error message when connecting to the database system.',
	'externaldata-db-unknown-collection' => 'The error message if #get_db_data can\'t find the specified "collection" when connecting to MongoDB.',
	'externaldata-db-no-return-values' => 'Used as error message, if the number of the specified columns is zero.

If successful, the system returns values in the specified columns.',
	'externaldata-db-invalid-query' => 'Used as error message, if the query has been failed.',
);

/** Afrikaans (Afrikaans)
 * @author Naudefj
 */
$messages['af'] = array(
	'getdata' => 'Kry data',
	'externaldata-xml-error' => 'XML-fout: $1 op reël $2',
	'externaldata-db-unknown-type' => 'Fout: onbekende databasistipe.',
	'externaldata-db-could-not-connect' => "Fout: kon nie 'n verbinding met databasis bewerkstellig nie.",
	'externaldata-db-invalid-query' => 'Ongeldige navraag.',
);

/** Gheg Albanian (Gegë)
 * @author Mdupont
 */
$messages['aln'] = array(
	'getdata' => 'Merr të dhëna',
	'externaldata-desc' => 'Lejon retrieving të dhënat e strukturuar nga URL jashtme, bazat e të dhënave dhe burimet tjera',
	'externaldata-ldap-unable-to-connect' => "Në pamundësi për t'u lidhur tek $1",
	'externaldata-xml-error' => 'XML error: $1 tek $2 linjë',
	'externaldata-db-incomplete-information' => 'Gabim: informata jo të plota për këtë server të identitetit.',
	'externaldata-db-could-not-get-url' => 'Nuk mund te merrni URL pasi $1 {{PLURAL:$1|provoni|përpiqet}}.',
	'externaldata-db-unknown-type' => 'Gabim: Lloj i panjohur bazës së të dhënave.',
	'externaldata-db-could-not-connect' => 'Gabim: Nuk mund të lidheni me bazën e të dhënave.',
	'externaldata-db-no-return-values' => 'Gabim: Nuk ka kthim vlerat e caktuara.',
	'externaldata-db-invalid-query' => 'pyetje e pavlefshme.',
);

/** Arabic (العربية)
 * @author DRIHEM
 * @author Imksa
 * @author Meno25
 * @author OsamaK
 */
$messages['ar'] = array(
	'getdata' => 'الحصول على البيانات',
	'externaldata-desc' => 'يسمح باسترجاع البيانات الهيكلية من مسارات خارجية، قواعد البيانات ومصادر أخرى',
	'externaldata-web-invalid-format' => 'إمتداد خاطئ: "$1"',
	'externaldata-ldap-unable-to-connect' => 'تعذّر الاتصال ب$1',
	'externaldata-xml-error' => 'خطأ XML: $1 عند السطر $2',
	'externaldata-db-incomplete-information' => 'خطأ: معلومات غير كاملة عن هوية هذا الخادوم.',
	'externaldata-db-could-not-get-url' => 'تعذّر الحصول على المسار بعد {{PLURAL:$1||محاولة واحدة|محاوتين|$1 محاولات|$1 محاولة }}.',
	'externaldata-db-unknown-type' => 'خطأ: نوع قاعدة بيانات غير معروف.',
	'externaldata-db-could-not-connect' => 'خطأ: تعذّر الاتصال بقاعدة البيانات.',
	'externaldata-db-no-return-values' => 'خطأ: لم تحدد أي قيم عائدة.',
	'externaldata-db-invalid-query' => 'استعلام غير صالح.',
);

/** Egyptian Spoken Arabic (مصرى)
 * @author Dudi
 * @author Meno25
 */
$messages['arz'] = array(
	'getdata' => 'الحصول على البيانات',
	'externaldata-desc' => 'بيسمح انك تجيب الداتا المتركبه من URLات برّانيه, و قواعد بيانات (databases) و مصادر تانيه',
);

/** Asturian (asturianu)
 * @author Xuacu
 */
$messages['ast'] = array(
	'getdata' => 'Recuperar datos',
	'externaldata-desc' => 'Permite recuperar datos estructuraos de direiciones URL, bases de datos y otres fontes esternes',
	'externaldata-web-invalid-format' => 'Formatu inválidu: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Nun se pudo coneutar con $1',
	'externaldata-xml-error' => 'Error XML: $1 na llinia $2',
	'externaldata-db-incomplete-information' => 'Error: Información incompleta pa esta ID de sirvidor.',
	'externaldata-db-could-not-get-url' => 'Nun se pudo recuperar la URL dempués de $1 {{PLURAL:$1|intentu|intentos}}.',
	'externaldata-db-unknown-type' => 'Error: Triba de base de datos desconocida.',
	'externaldata-db-could-not-connect' => 'Error: Nun se pudo coneutar cola base de datos.',
	'externaldata-db-unknown-collection' => 'Fallu: Coleición MongoDB desconocida.',
	'externaldata-db-no-return-values' => "Error: Nun s'especificaron valores de retornu.",
	'externaldata-db-invalid-query' => 'Consulta inválida.',
);

/** Belarusian (Taraškievica orthography) (беларуская (тарашкевіца)‎)
 * @author EugeneZelenko
 * @author Jim-by
 * @author Wizardist
 */
$messages['be-tarask'] = array(
	'getdata' => 'Атрымаць зьвесткі',
	'externaldata-desc' => 'Дазваляе атрымліваць структураваныя зьвесткі з вонкавых URL-адрасоў, базаў зьвестак і іншых крыніц',
	'externaldata-web-invalid-format' => 'Няслушны фармат: «$1»',
	'externaldata-ldap-unable-to-connect' => 'Немагчыма далучыцца да $1',
	'externaldata-xml-error' => 'Памылка XML: $1 у радку $2',
	'externaldata-db-incomplete-information' => 'Памылка: Няпоўная інфармацыя для гэтага ідэнтыфікатара сэрвэра.',
	'externaldata-db-could-not-get-url' => 'Немагчыма атрымаць URL-адрас пасьля $1 {{PLURAL:$1|спробы|спробаў|спробаў}}.',
	'externaldata-db-unknown-type' => 'Памылка: Невядомы тып базы зьвестак.',
	'externaldata-db-could-not-connect' => 'Памылка: Немагчыма далучыцца да базы зьвестак.',
	'externaldata-db-unknown-collection' => 'Памылка: невядомая калецыя MongoDB.',
	'externaldata-db-no-return-values' => 'Памылка: Не пазначаныя выніковыя значэньні.',
	'externaldata-db-invalid-query' => 'Няслушны запыт.',
);

/** Breton (brezhoneg)
 * @author Fohanno
 * @author Fulup
 * @author Y-M D
 */
$messages['br'] = array(
	'getdata' => 'Tapout roadennoù',
	'externaldata-desc' => 'Talvezout a ra da adtapout roadennoù frammet adalek URLoù diavaez, diazoù titouroù ha mammennoù all.',
	'externaldata-web-invalid-format' => 'Furmad direizh : "$1"',
	'externaldata-ldap-unable-to-connect' => "Ne c'haller ket kevreañ ouzh $1",
	'externaldata-xml-error' => 'Fazi XML : $1 el linenn $2',
	'externaldata-db-incomplete-information' => 'Fazi : Titouroù diglok evit an ID servijer-mañ.',
	'externaldata-db-could-not-get-url' => 'Dibosupl eo tapout an URL goude $1 {{PLURAL:$1|taol-esae|taol-esae}}.',
	'externaldata-db-unknown-type' => 'Fazi : Seurt diaz roadennoù dianav',
	'externaldata-db-could-not-connect' => "Fazi : Ne c'haller ket kevreañ ouzh an diaz roadennoù.",
	'externaldata-db-no-return-values' => "Fazi : N'eus bet resisaet talvoud distro ebet.",
	'externaldata-db-invalid-query' => 'Reked direizh.',
);

/** Bosnian (bosanski)
 * @author CERminator
 */
$messages['bs'] = array(
	'getdata' => 'Uzmi podatke',
	'externaldata-desc' => 'Omogućuje za preuzimanje strukturnih podataka iz vanjskih URLova, baza podataka i drugih izvora',
	'externaldata-ldap-unable-to-connect' => 'Ne može se spojiti na $1',
	'externaldata-xml-error' => 'XML greška: $1 na liniji $2',
	'externaldata-db-incomplete-information' => 'Greška: Nepotpune informacije za ovaj ID servera.',
	'externaldata-db-could-not-get-url' => 'Nije pronađen URL nakon $1 {{PLURAL:$1|pokušaja|pokušaja}}.',
	'externaldata-db-unknown-type' => 'Greška: Nepoznat tip baze podataka.',
	'externaldata-db-could-not-connect' => 'Greška: Ne može se spojiti na bazu podataka.',
	'externaldata-db-no-return-values' => 'Greška: Nije navedena povratna vrijednost.',
	'externaldata-db-invalid-query' => 'Nevaljan upit.',
);

/** Catalan (català)
 * @author Paucabot
 * @author Solde
 */
$messages['ca'] = array(
	'getdata' => 'Obtenir dades',
	'externaldata-xml-error' => 'Error XML: $1 a la línia $2',
	'externaldata-db-unknown-type' => 'Error: Tipus de base de dades desconegut.',
	'externaldata-db-could-not-connect' => "Error: No s'ha pogut connectar a la base de dades.",
	'externaldata-db-invalid-query' => 'Consulta no vàlida.',
);

/** Czech (česky)
 * @author Jkjk
 * @author Reaperman
 */
$messages['cs'] = array(
	'getdata' => 'Získat data',
	'externaldata-desc' => 'Umožňuje získávání strukturovaných dat z externích webových stránek, databází a jiných zdrojů',
	'externaldata-web-invalid-format' => 'Neplatný formát: „$1“',
	'externaldata-ldap-unable-to-connect' => 'Nepodařilo se spojit s $1',
	'externaldata-xml-error' => 'Chyba XML: $1 na řádku $2',
	'externaldata-db-incomplete-information' => 'Chyba: Nekompletní informace pro toto ID serveru', # Fuzzy
	'externaldata-db-unknown-type' => 'Chyba: Neznámý typ databáze.',
	'externaldata-db-could-not-connect' => 'Chyba: Nepodařilo se připojit k databázi.',
	'externaldata-db-no-return-values' => 'Chyba: Nebyly zadány návratové hodnoty.', # Fuzzy
	'externaldata-db-invalid-query' => 'Neplatný požadavek.',
);

/** Danish (dansk)
 * @author Tjernobyl
 */
$messages['da'] = array(
	'externaldata-db-invalid-query' => 'Ugyldig forespørgsel.',
);

/** German (Deutsch)
 * @author Imre
 * @author Kghbln
 * @author MF-Warburg
 * @author Merlissimo
 * @author Metalhead64
 * @author Purodha
 * @author Umherirrender
 */
$messages['de'] = array(
	'getdata' => 'Daten holen',
	'externaldata-desc' => 'Ermöglicht das Einfügen strukturierter Daten von externen URLs, Datenbanken und anderen Quellen',
	'externaldata-web-invalid-format' => 'Ungültiges Format: „$1“',
	'externaldata-ldap-unable-to-connect' => 'Es konnte keine Verbindung zu $1 hergestellt werden',
	'externaldata-xml-error' => 'XML-Fehler: $1 in Zeile $2',
	'externaldata-db-incomplete-information' => 'Fehler: Es liegen nur unvollständige Informationen für diese Serverkennung vor.',
	'externaldata-db-could-not-get-url' => 'Die URL konnte mit {{PLURAL:$1|einem Versuch|$1 Versuchen}} nicht abgerufen werden.',
	'externaldata-db-unknown-type' => 'Fehler: Es handelt sich um einen unbekannten Datenbanktyp.',
	'externaldata-db-could-not-connect' => 'Fehler: Es konnte keine Verbindung zur Datenbank hergestellt werden.',
	'externaldata-db-unknown-collection' => 'Fehler: Unbekannte MongoDB-Sammlung',
	'externaldata-db-no-return-values' => 'Fehler: Es wurden keine Rückgabewerte festgelegt.',
	'externaldata-db-invalid-query' => 'Ungültige Abfrage.',
);

/** Lower Sorbian (dolnoserbski)
 * @author Michawiki
 */
$messages['dsb'] = array(
	'getdata' => 'Daty wobstaraś',
	'externaldata-desc' => 'Zmóžnja wótwołowanje strukturěrowanych datow z eksternych URL, datowych bankow a drugich žrědłow',
	'externaldata-web-invalid-format' => 'Njepłaśiwy format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Njemóžno z $1 zwězaś',
	'externaldata-xml-error' => 'Zmólka XML: $1 na smužce $2',
	'externaldata-db-incomplete-information' => "'''Zmólka: Njedopołne informacije za toś ten serwerowy ID.'''",
	'externaldata-db-could-not-get-url' => 'Njemóžno URL pó $1 {{PLURAL:$1|wopyśe|wopytoma|wopytach|wopytach}} dostaś.',
	'externaldata-db-unknown-type' => "'''Zmólka: Njeznata datowa banka.'''",
	'externaldata-db-could-not-connect' => "'''Zmólka: Njemóžno z datoweju banku zwězaś.'''",
	'externaldata-db-no-return-values' => "'''Zmólka: Žedne gódnoty slědkdaśa pódane.'''",
	'externaldata-db-invalid-query' => 'Njepłaśiwe napšašowanje.',
);

/** Greek (Ελληνικά)
 * @author Dead3y3
 * @author Omnipaedista
 * @author Protnet
 * @author ZaDiak
 */
$messages['el'] = array(
	'getdata' => 'Πάρε δεδομένα',
	'externaldata-desc' => 'Επιτρέπει την ανάκτηση δεδομένων σε μορφές CSV, JSON και XML και για εξωτερικά URLs και για σελίδες του τοπικού wiki', # Fuzzy
	'externaldata-web-invalid-format' => 'Μη έγκυρη μορφή: «$1»',
	'externaldata-ldap-unable-to-connect' => 'Δεν είναι δυνατή η σύνδεση με $1',
	'externaldata-xml-error' => 'Σφάλμα XML : $1 στη γραμμή $2',
	'externaldata-db-invalid-query' => 'Άκυρο αίτημα.',
);

/** Esperanto (Esperanto)
 * @author Yekrats
 */
$messages['eo'] = array(
	'externaldata-db-invalid-query' => 'Malvalida serĉomendo.',
);

/** Spanish (español)
 * @author Armando-Martin
 * @author Crazymadlover
 * @author Imre
 * @author Manuelt15
 * @author Sanbec
 * @author Translationista
 */
$messages['es'] = array(
	'getdata' => 'Obtener datos',
	'externaldata-desc' => 'Permite la recuperación de datos estructurados a partir de direcciones URL externas, bases de datos y otras fuentes',
	'externaldata-web-invalid-format' => 'Formato inválido: "$1"',
	'externaldata-ldap-unable-to-connect' => 'No se pudo conectar con $1',
	'externaldata-xml-error' => 'Error XML: $1 en línea $2',
	'externaldata-db-incomplete-information' => 'Error: Información incompleta para este ID de servidor.',
	'externaldata-db-could-not-get-url' => 'No se pudo obtener la URL después de $1 {{PLURAL:$1|intento|intentos}}.',
	'externaldata-db-unknown-type' => 'Error: Tipo de base de datos desconocido.',
	'externaldata-db-could-not-connect' => 'Error: No se pudo lograr conexión con la base de datos.',
	'externaldata-db-no-return-values' => 'Error: No se ha especificado valores de retorno.',
	'externaldata-db-invalid-query' => 'Consulta inválida.',
);

/** Estonian (eesti)
 * @author Pikne
 */
$messages['et'] = array(
	'externaldata-db-unknown-type' => 'Tõrge: Tundmatu andmebaasi tüüp.',
	'externaldata-db-could-not-connect' => 'Tõrge: Andmebaasiga ei saa ühendust.',
	'externaldata-db-invalid-query' => 'Vigane päring.',
);

/** Basque (euskara)
 * @author Kobazulo
 */
$messages['eu'] = array(
	'getdata' => 'Datuak eskuratu',
);

/** Persian (فارسی)
 * @author Mjbmr
 */
$messages['fa'] = array(
	'getdata' => 'دریافت اطلاعات',
);

/** Finnish (suomi)
 * @author Centerlink
 * @author Crt
 * @author Nedergard
 * @author Silvonen
 * @author Str4nd
 */
$messages['fi'] = array(
	'getdata' => 'Hae data',
	'externaldata-desc' => 'Mahdollistaa muotoillun datan noutamisen ulkoisista verkko-osoitteista, tietokannoista ja muista lähteistä.',
	'externaldata-web-invalid-format' => 'Virheellinen muoto: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Ei voitu yhdistää palvelimelle $1',
	'externaldata-xml-error' => 'XML-virhe: $1 rivillä $2',
	'externaldata-db-incomplete-information' => 'Virhe: Vaillinaiset tiedot tälle palvelintunnukselle.',
	'externaldata-db-could-not-get-url' => 'Ei voitu hakea verkko-osoitetta $1 {{PLURAL:$1|yrityksen|yrityksen}} jälkeen.',
	'externaldata-db-unknown-type' => 'Virhe: Tuntematon tietokantatyyppi.',
	'externaldata-db-could-not-connect' => 'Virhe: Ei yhteyttä tietokantaan.',
	'externaldata-db-unknown-collection' => 'Virhe: Tuntematon MongoDB-kokoelma.',
	'externaldata-db-no-return-values' => 'Virhe: Paluuarvoja ei ole annettu.',
	'externaldata-db-invalid-query' => 'Virheellinen kysely.',
);

/** French (français)
 * @author Crochet.david
 * @author Gomoko
 * @author IAlex
 * @author McDutchie
 * @author PieRRoMaN
 */
$messages['fr'] = array(
	'getdata' => 'Obtenir des données',
	'externaldata-desc' => "Permet de récupérer des données structurées à partir d'URL externes, de bases de données et d'autres sources",
	'externaldata-web-invalid-format' => 'Format invalide: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Impossible de se connecter à $1',
	'externaldata-xml-error' => 'Erreur XML : $1 à la ligne $2',
	'externaldata-db-incomplete-information' => 'Erreur : Informations incomplètes pour cet identifiant de serveur.',
	'externaldata-db-could-not-get-url' => "Impossible d'obtenir l'URL après $1 essai{{PLURAL:$1|s|s}}.",
	'externaldata-db-unknown-type' => 'ERREUR: Type de base de données inconnu.',
	'externaldata-db-could-not-connect' => 'Erreur : Impossible de se connecter à la base de données.',
	'externaldata-db-unknown-collection' => 'Erreur: Collection MongoDB inconnue.',
	'externaldata-db-no-return-values' => "Erreur : Aucune valeur de retour n'a été spécifiée.",
	'externaldata-db-invalid-query' => 'Requête invalide.',
);

/** Franco-Provençal (arpetan)
 * @author ChrisPtDe
 */
$messages['frp'] = array(
	'getdata' => 'Avêr des balyês',
	'externaldata-web-invalid-format' => 'Format envalido : « $1 »',
	'externaldata-ldap-unable-to-connect' => 'Empossiblo de sè branchiér a $1',
	'externaldata-xml-error' => 'Èrror XML : $1 a la legne $2',
	'externaldata-db-could-not-get-url' => 'Empossiblo d’avêr l’URL aprés $1 tentativ{{PLURAL:$1|a|es}}.',
	'externaldata-db-unknown-type' => 'Èrror : tipo de bâsa de balyês encognu.',
	'externaldata-db-could-not-connect' => 'Èrror : empossiblo de sè branchiér a la bâsa de balyês.',
	'externaldata-db-no-return-values' => 'Èrror : niona valor de retôrn at étâ spècefiâ.',
	'externaldata-db-invalid-query' => 'Requéta envalida.',
);

/** Galician (galego)
 * @author Toliño
 */
$messages['gl'] = array(
	'getdata' => 'Obter os datos',
	'externaldata-desc' => 'Permite a recuperación de datos estruturados a partir de enderezos URL externos, bases de datos e outras fontes',
	'externaldata-web-invalid-format' => 'Formato incorrecto: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Non se pode conectar con $1',
	'externaldata-xml-error' => 'Erro XML: $1 na liña $2',
	'externaldata-db-incomplete-information' => 'Erro: Información incompleta para este ID de servidor.',
	'externaldata-db-could-not-get-url' => 'Non se puido obter o enderezo URL despois de $1 {{PLURAL:$1|intento|intentos}}.',
	'externaldata-db-unknown-type' => 'Erro: Tipo de base de datos descoñecido.',
	'externaldata-db-could-not-connect' => 'Erro: Non se puido conectar coa base de datos.',
	'externaldata-db-unknown-collection' => 'Erro: Colección MongoDB descoñecida.',
	'externaldata-db-no-return-values' => 'Erro: Non se especificou ningún valor de retorno.',
	'externaldata-db-invalid-query' => 'A consulta non é válida.',
);

/** Swiss German (Alemannisch)
 * @author Als-Chlämens
 * @author Als-Holder
 */
$messages['gsw'] = array(
	'getdata' => 'Date hole',
	'externaldata-desc' => 'Erlaubt strukturierti Daten abzruefe vu extärne URL un andre Quälle',
	'externaldata-web-invalid-format' => 'Ungültigs Format: „$1“',
	'externaldata-ldap-unable-to-connect' => 'Cha kei Verbindig härstellen zue $1',
	'externaldata-xml-error' => 'XML-Fähler: $1 in dr Zyyle $2',
	'externaldata-db-incomplete-information' => 'Fähler: Nit vollständigi Information fir die Server-ID.',
	'externaldata-db-could-not-get-url' => 'Cha d URL nit finde no $1 {{PLURAL:$1|Versuech|Versuech}}.',
	'externaldata-db-unknown-type' => 'Fähler: Nit bekannte Datebanktyp.',
	'externaldata-db-could-not-connect' => 'Fähler: Cha kei Verbindig härstelle zue dr Datebank.',
	'externaldata-db-no-return-values' => 'Fähler: Kei Ruckgabewärt spezifiziert.',
	'externaldata-db-invalid-query' => 'Nit giltigi Umfrog.',
);

/** Gujarati (ગુજરાતી)
 * @author Ashok modhvadia
 */
$messages['gu'] = array(
	'getdata' => 'માહિતી પ્રાપ્ત કરો',
	'externaldata-desc' => 'બાહ્ય કડીઓ અને સ્થાનિક વિકિ પાનાઓ પરથી CSV, JSON અને XML શૈલીમાં માહિતીની પુન:પ્રાપ્તિની છુટ', # Fuzzy
);

/** Hebrew (עברית)
 * @author Amire80
 * @author Rotemliss
 * @author YaronSh
 */
$messages['he'] = array(
	'getdata' => 'קבלת נתונים',
	'externaldata-desc' => 'אפשרות לקבלת נתונים במבנים מכתובות חיצוניות, מסדי נתונים ומקורות אחרים',
	'externaldata-web-invalid-format' => 'תסדיר בלתי־תקין: "$1"',
	'externaldata-ldap-unable-to-connect' => 'לא ניתן להתחבר ל־$1',
	'externaldata-xml-error' => 'שגיאת XML: $1 בשורה $2',
	'externaldata-db-incomplete-information' => 'שגיאה: יש רק מידע חלקי על מספר השרת הזה.',
	'externaldata-db-could-not-get-url' => 'לא ניתן לקבל את כתובת ה־URL לאחר {{PLURAL:$1|נסיון אחד|$1 נסיונות}}.',
	'externaldata-db-unknown-type' => 'שגיאה: סוג מסד הנתונים אינו מוכר.',
	'externaldata-db-could-not-connect' => 'שגיאה: לא ניתן להתחבר אל מסד הנתונים.',
	'externaldata-db-no-return-values' => 'שגיאה: לא הוגדרו ערכים להחזרה.',
	'externaldata-db-invalid-query' => 'שאילתה בלתי תקינה.',
);

/** Upper Sorbian (hornjoserbsce)
 * @author Michawiki
 */
$messages['hsb'] = array(
	'getdata' => 'Daty wobstarać',
	'externaldata-desc' => 'Zmóžnja wotwołowanje strukturowanych datow z eksternych URL, datowych bankow a druhich žórłow',
	'externaldata-web-invalid-format' => 'Njepłaćiwy format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Njemóžno z $1 zwjazać',
	'externaldata-xml-error' => 'Zmylk XML: $1 na lince $2',
	'externaldata-db-incomplete-information' => "'''Zmylk: Njedospołne informacije za ID tutoho serwera.'''",
	'externaldata-db-could-not-get-url' => 'Njebě móžno URL po $1 {{PLURAL:$1|pospyće|pospytomaj|pospytach|pospytach}} dóstać.',
	'externaldata-db-unknown-type' => "'''Zmylk: Njeznaty typ datoweje banki.'''",
	'externaldata-db-could-not-connect' => "'''Zmylk: Njemóžno z datowej banku zwjazać.'''",
	'externaldata-db-unknown-collection' => 'Zmylk: Njeznata MongoDB-zběrka.',
	'externaldata-db-no-return-values' => "'''Zmylk: Žane hódnoty wróćenja podate.'''",
	'externaldata-db-invalid-query' => 'Njepłaćiwe naprašowanje.',
);

/** Hungarian (magyar)
 * @author Dj
 * @author Glanthor Reviol
 */
$messages['hu'] = array(
	'getdata' => 'Adatok lekérése',
	'externaldata-desc' => 'Strukturált adatok lekérése külső URL-ekről, adatbázisokból vagy más forrásokból',
	'externaldata-web-invalid-format' => 'Érvénytelen formátum: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Sikertelen csatlakozás a következőhöz: $1',
	'externaldata-xml-error' => '$1 XML hiba, $2. sor',
	'externaldata-db-incomplete-information' => 'Hiba: hiányos információ a szerver azonosítóhoz.',
	'externaldata-db-could-not-get-url' => 'Nem sikerült lekérni az URL-t {{PLURAL:$1|egy|$1}} próbálkozás alatt.',
	'externaldata-db-unknown-type' => 'Hiba: ismeretlen adatbázis típus.',
	'externaldata-db-could-not-connect' => 'Hiba: nem sikerült csatlakozni az adatbázishoz.',
	'externaldata-db-no-return-values' => 'Hiba: nem lettek megadva visszatérési értékek.',
	'externaldata-db-invalid-query' => 'Érvénytelen lekérdezés.',
);

/** Interlingua (interlingua)
 * @author McDutchie
 */
$messages['ia'] = array(
	'getdata' => 'Obtener datos',
	'externaldata-desc' => 'Permitte recuperar datos structurate ab adresses URL, bases de datos e altere fontes externe',
	'externaldata-web-invalid-format' => 'Formato invalide: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Impossibile connecter se a $1',
	'externaldata-xml-error' => 'Error de XML: $1 al linea $2',
	'externaldata-db-incomplete-information' => 'Error: Information incomplete pro iste ID de servitor.',
	'externaldata-db-could-not-get-url' => 'Non poteva obtener le URL post $1 {{PLURAL:$1|tentativa|tentativas}}.',
	'externaldata-db-unknown-type' => 'Error: Typo de base de datos incognite.',
	'externaldata-db-could-not-connect' => 'Error: Impossibile connecter se al base de datos.',
	'externaldata-db-no-return-values' => 'Error: Nulle valor de retorno specificate.',
	'externaldata-db-invalid-query' => 'Consulta invalide.',
);

/** Indonesian (Bahasa Indonesia)
 * @author Bennylin
 * @author Farras
 * @author IvanLanin
 * @author Iwan Novirion
 */
$messages['id'] = array(
	'getdata' => 'Ambil data',
	'externaldata-desc' => 'Memungkinkan untuk mengambil data terstruktur dari URL eksternal, database dan sumber lainnya',
	'externaldata-web-invalid-format' => 'Format salah: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Tidak dapat terhubung ke $1',
	'externaldata-xml-error' => 'Galat XML: $1 pada baris $2',
	'externaldata-db-incomplete-information' => 'Galat: Informasi tak lengkap untuk ID server ini.',
	'externaldata-db-could-not-get-url' => 'Tidak dapat mengambil URL setelah dicoba {{PLURAL:$1||}}$1 kali.',
	'externaldata-db-unknown-type' => 'Galat: Jenis basis data tidak diketahui.',
	'externaldata-db-could-not-connect' => 'Galat: Tidak dapat terhubung ke basis data.',
	'externaldata-db-no-return-values' => 'Galat: Nilai pengembalian tidak dispesifikasi.',
	'externaldata-db-invalid-query' => 'Kueri tidak sah.',
);

/** Italian (italiano)
 * @author Beta16
 * @author Pietrodn
 */
$messages['it'] = array(
	'getdata' => 'Ottieni dati',
	'externaldata-desc' => 'Consente di recuperare dati strutturati da URL esterni, database o altre sorgenti',
	'externaldata-web-invalid-format' => 'Formato non valido: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Impossibile connettersi a $1',
	'externaldata-xml-error' => 'Errore XML: $1 alla linea $2',
	'externaldata-db-incomplete-information' => 'Errore: informazioni incomplete per questo server ID.',
	'externaldata-db-could-not-get-url' => "Impossibile raggiungere l'URL dopo $1 {{PLURAL:$1|tentativo|tentativi}}.",
	'externaldata-db-unknown-type' => 'Errore: tipo di database sconosciuto.',
	'externaldata-db-could-not-connect' => 'Errore: impossibile connettersi al database.',
	'externaldata-db-unknown-collection' => 'Errore: collezione MongoDB sconosciuta.',
	'externaldata-db-no-return-values' => 'Errore: non è stato specificato alcun valore di ritorno.',
	'externaldata-db-invalid-query' => 'Query non valida.',
);

/** Japanese (日本語)
 * @author Fryed-peach
 * @author Schu
 * @author Shirayuki
 * @author 青子守歌
 */
$messages['ja'] = array(
	'getdata' => 'データ取得',
	'externaldata-desc' => '外部 URL やデータベース、その他のソースからデータを取得できるようにする',
	'externaldata-web-invalid-format' => '無効な書式:「$1」',
	'externaldata-ldap-unable-to-connect' => '$1 に接続できません',
	'externaldata-xml-error' => 'XML エラー: 行$2で$1',
	'externaldata-db-incomplete-information' => 'エラー: このデータベース ID に対する情報が不十分です。',
	'externaldata-db-could-not-get-url' => '$1 回試行しましたが URL を取得できませんでした。',
	'externaldata-db-unknown-type' => 'エラー: データベースの種類が不明です。',
	'externaldata-db-could-not-connect' => 'エラー: データベースに接続できませんでした。',
	'externaldata-db-unknown-collection' => 'エラー: 不明な MongoDB コレクションです。',
	'externaldata-db-no-return-values' => 'エラー: 戻り値が指定されていません。',
	'externaldata-db-invalid-query' => '無効なクエリです。',
);

/** Georgian (ქართული)
 * @author David1010
 */
$messages['ka'] = array(
	'externaldata-db-invalid-query' => 'არასწორი მოთხონა.',
);

/** Khmer (ភាសាខ្មែរ)
 * @author វ័ណថារិទ្ធ
 */
$messages['km'] = array(
	'getdata' => 'យក​ទិន្នន័យ',
);

/** Colognian (Ripoarisch)
 * @author Purodha
 */
$messages['ksh'] = array(
	'getdata' => 'Date holle!',
	'externaldata-desc' => 'Määt et müjjelich, Date en beshtemmpte Fomaate fun främbde <i lang="en">URLs</i>, Daatebangke, un ander Quälle ze holle.',
	'externaldata-web-invalid-format' => 'Dat Formaat es onjöltsch: „$1“',
	'externaldata-ldap-unable-to-connect' => 'Kann nit noh $1 verbenge',
	'externaldata-xml-error' => 'Fähler em XML, op Reih $2: $1',
	'externaldata-db-incomplete-information' => '<span style="text-transform: uppercase">Fähler:</span> De Enfomazjuhne vör di ẞööver-Kännong sin nit kumplätt.',
	'externaldata-db-could-not-get-url' => 'Kunnt {{PLURAL:$1|noh eimohl Versöhke|och noh $1 Mohl Versöhke|ohne enne Versöhk}} nix vun däm <i lang="en">URL</i> krijje.',
	'externaldata-db-unknown-type' => '<span style="text-transform: uppercase">Fähler:</span> Di Zoot Datebangk es unbikannt.',
	'externaldata-db-could-not-connect' => '<span style="text-transform: uppercase">Fähler:</span> Kunnt kein Verbendung noh dä Datebangk krijje.',
	'externaldata-db-unknown-collection' => '<span style="text-transform: uppercase">Fähler:</span> Dat es en onbikannte <i lang"en">MongoDB</i>-Zosammeschtällong.',
	'externaldata-db-no-return-values' => '<span style="text-transform: uppercase">Fähler:</span> Kein Wääte för Zerökzeävve aanjejovve.',
	'externaldata-db-invalid-query' => 'Onjöltesch Frooch aan de Datebangk.',
);

/** Luxembourgish (Lëtzebuergesch)
 * @author Robby
 */
$messages['lb'] = array(
	'getdata' => 'Donnéeë kréien',
	'externaldata-desc' => 'Erlaabt et Donnéeën vun externen URLen, Datebanken an anere Quellen ze verschaffen',
	'externaldata-web-invalid-format' => 'Net valabele Format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Onméiglech sech op $1 ze connectéieren',
	'externaldata-xml-error' => 'XML Feeler: $1 an der Linn $2',
	'externaldata-db-incomplete-information' => 'Feeler: Informatioun fir dës Server ID net komplett.',
	'externaldata-db-could-not-get-url' => "D'URL konnt no {{PLURAL:$1|enger Kéier|$1 Versich}} net opgemaach ginn.",
	'externaldata-db-unknown-type' => 'Feeler: Onbekannten Datebank-Typ.',
	'externaldata-db-could-not-connect' => "Feeler: D'Verbindung mat der Datebank konnt net opgebaut ginn.",
	'externaldata-db-unknown-collection' => 'Feeler:Onbekannte MongoDB Sammlung.',
	'externaldata-db-no-return-values' => 'Feeler: Kee Retour-Wäert festgeluecht.',
	'externaldata-db-invalid-query' => 'Net valabel Ufro.',
);

/** Latvian (latviešu)
 * @author Papuass
 */
$messages['lv'] = array(
	'getdata' => 'Saņemt datus',
);

/** Macedonian (македонски)
 * @author Bjankuloski06
 */
$messages['mk'] = array(
	'getdata' => 'Земи податоци',
	'externaldata-desc' => 'Овозможува добивање структурирани податоци од надворешни URL-адреси, бази на податоци и други извори',
	'externaldata-web-invalid-format' => 'Неважечки формат: „$1“',
	'externaldata-ldap-unable-to-connect' => 'Не можам да се поврзам со  $1',
	'externaldata-xml-error' => 'XML грешка: $1 во ред $2',
	'externaldata-db-incomplete-information' => 'Грешка: Нецелосни информации за овој опслужувачки ид. бр.',
	'externaldata-db-could-not-get-url' => 'Не можев да ја добијам URL адресата по $1 {{PLURAL:$1|обид|обиди}}.',
	'externaldata-db-unknown-type' => 'Грешка: Непознат тип на база на податоци.',
	'externaldata-db-could-not-connect' => 'Грешка: Не можев да се поврзам со базата на податоци.',
	'externaldata-db-unknown-collection' => 'Грешка: Непозната збирка од MongoDB.',
	'externaldata-db-no-return-values' => 'Грешка: Нема назначено повратни вредности.',
	'externaldata-db-invalid-query' => 'Грешно барање.',
);

/** Malay (Bahasa Melayu)
 * @author Anakmalaysia
 */
$messages['ms'] = array(
	'getdata' => 'Dapatkan data',
	'externaldata-desc' => 'Membolehkan pengambilan data berstruktur dari URL luaran, pangkalan data atau sumber-sumber lain',
	'externaldata-web-invalid-format' => 'Format tidak sah: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Tidak dapat bersambung dengan $1',
	'externaldata-xml-error' => 'Ralat XML: $1 di baris $2',
	'externaldata-db-incomplete-information' => 'Ralat: Maklumat tidak lengkap untuk ID pelayan ini.',
	'externaldata-db-could-not-get-url' => 'URL tidak dapat diterima selepas $1 cubaan.',
	'externaldata-db-unknown-type' => 'Ralat: Jenis pangkalan data tidak dikenali.',
	'externaldata-db-could-not-connect' => 'Ralat: Tidak dapat bersambung dengan pangkalan data.',
	'externaldata-db-unknown-collection' => 'Ralat: Koleksi MongoDB tidak dikenali.',
	'externaldata-db-no-return-values' => 'Ralat: Tiada nilai pulangan yang ditentukan.',
	'externaldata-db-invalid-query' => 'Pertanyaan tidak sah.',
);

/** Erzya (эрзянь)
 * @author Botuzhaleny-sodamo
 */
$messages['myv'] = array(
	'getdata' => 'Дата мельга',
);

/** Norwegian Bokmål (norsk (bokmål)‎)
 * @author Harald Khan
 * @author Nghtwlkr
 * @author Njardarlogar
 */
$messages['nb'] = array(
	'getdata' => 'Hent data',
	'externaldata-desc' => 'Gir mulighet til å hente strukturerte data fra eksterne internettadresser, databaser og andre kilder',
	'externaldata-ldap-unable-to-connect' => 'Klarte ikke å koble til $1',
	'externaldata-xml-error' => 'XML-feil: $1 på linje $2',
	'externaldata-db-incomplete-information' => 'Feil: Ufullstendig informasjon for denne tjener-IDen.',
	'externaldata-db-could-not-get-url' => 'Kunne ikke hente URL etter {{PLURAL:$1|ett forsøk|$1 forsøk}}.',
	'externaldata-db-unknown-type' => 'Feil: Ukjent databasetype.',
	'externaldata-db-could-not-connect' => 'Feil: Kunne ikke koble til database.',
	'externaldata-db-no-return-values' => 'Feil: Ingen returverdi spesifisert.',
	'externaldata-db-invalid-query' => 'Ugyldig spørring.',
);

/** Dutch (Nederlands)
 * @author SPQRobin
 * @author Siebrand
 */
$messages['nl'] = array(
	'getdata' => 'Gegevens ophalen',
	'externaldata-desc' => "Maakt het mogelijk gegevens van externe URL's, database en andere externe bronnen op te halen",
	'externaldata-web-invalid-format' => 'Ongeldige indeling: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Het was niet mogelijk te verbinden met $1',
	'externaldata-xml-error' => 'XML-fout: $1 op regel $2',
	'externaldata-db-incomplete-information' => 'Fout: onvolledige informatie voor dit servernummer.',
	'externaldata-db-could-not-get-url' => 'Na $1 {{PLURAL:$1|poging|pogingen}} gaf de URL geen resultaat.',
	'externaldata-db-unknown-type' => 'Fout: onbekend databasetype.',
	'externaldata-db-could-not-connect' => 'Fout: het was niet mogelijk met de database te verbinden.',
	'externaldata-db-unknown-collection' => 'Fout: onbekende MongoDB-collectie.',
	'externaldata-db-no-return-values' => 'Fout: er zijn geen return-waarden ingesteld.',
	'externaldata-db-invalid-query' => 'Ongeldige zoekopdracht.',
);

/** Norwegian Nynorsk (norsk (nynorsk)‎)
 * @author Gunnernett
 * @author Harald Khan
 * @author Njardarlogar
 */
$messages['nn'] = array(
	'getdata' => 'Hent data',
	'externaldata-desc' => 'Gjev høve til å henta strukturerte data frå eksterne URL-ar, databasar og andre kjelder',
	'externaldata-ldap-unable-to-connect' => 'Kunne ikkje kopla til $1',
	'externaldata-xml-error' => 'XML-feil: $1 på line $2',
	'externaldata-db-incomplete-information' => 'Feil: Ufullstendig informasjon for denne tenar-ID-en.',
	'externaldata-db-could-not-get-url' => 'Kunne ikkje henta URL etter {{PLURAL:$1|eitt forsøk|$1 forsøk}}.',
	'externaldata-db-unknown-type' => 'Feil: Ukjend databasetype.',
	'externaldata-db-could-not-connect' => 'Feil: Kunne ikkje kopla til databasen.',
	'externaldata-db-no-return-values' => 'Feil: Ingen returverdiar oppgjevne.',
	'externaldata-db-invalid-query' => 'Ugyldig spørjing.',
);

/** Occitan (occitan)
 * @author Cedric31
 */
$messages['oc'] = array(
	'getdata' => 'Obténer de donadas',
	'externaldata-desc' => "Permet de recuperar de donadas estructuradas a partir d'URL extèrnas, de bancas de donadas e d'autras fonts",
	'externaldata-ldap-unable-to-connect' => 'Impossible de se connectar a $1',
	'externaldata-xml-error' => 'Error XML : $1 a la linha $2',
	'externaldata-db-incomplete-information' => 'Error : Informacions incompletas per aqueste identificant de servidor.',
	'externaldata-db-could-not-get-url' => "Impossible d'obténer l'URL aprèp $1 {{PLURAL:$1|ensag|ensages}}.",
	'externaldata-db-unknown-type' => 'ERROR: Tipe de banca de donadas desconegut.',
	'externaldata-db-could-not-connect' => 'Error : Impossible de se connectar a la banca de donadas.',
	'externaldata-db-no-return-values' => 'Error : Cap de valor de retorn es pas estada especificada.',
	'externaldata-db-invalid-query' => 'Requèsta invalida.',
);

/** Oriya (ଓଡ଼ିଆ)
 * @author Jnanaranjan Sahu
 */
$messages['or'] = array(
	'getdata' => 'ତଥ୍ୟ ହାସଲ କରିବେ',
	'externaldata-ldap-unable-to-connect' => '$1ସହ ସଂଯୋଗ କରାଯାଇପାରିଲା ନାହିଁ',
	'externaldata-db-could-not-connect' => 'ଅସୁବିଧା : ଡାଟାବେସ ସହ ସଂଯୋଗ କରାଯାଇପାରିଲା ନାହିଁ ।',
);

/** Polish (polski)
 * @author BeginaFelicysym
 * @author Leinad
 * @author Sp5uhe
 */
$messages['pl'] = array(
	'getdata' => 'Pobierz dane',
	'externaldata-desc' => 'Umożliwia pobieranie strukturalnych danych z zewnętrznych adresów URL, baz danych i innych źródeł',
	'externaldata-web-invalid-format' => 'Nieprawidłowy format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Nie można połączyć się z $1',
	'externaldata-xml-error' => 'Błąd XML – $1 w wierszu $2',
	'externaldata-db-incomplete-information' => 'Błąd – niepełne informacje o tym identyfikatorze serwera.',
	'externaldata-db-could-not-get-url' => 'Nie można uzyskać adresu URL po $1 {{PLURAL:$1|próbie|próbach}}.',
	'externaldata-db-unknown-type' => 'Błąd: Nieznany typ bazy danych.',
	'externaldata-db-could-not-connect' => 'Błąd: Nie można połączyć się z bazą danych.',
	'externaldata-db-no-return-values' => 'Błąd – nie określono zwracanej wartości.',
	'externaldata-db-invalid-query' => 'Nieprawidłowe zapytanie.',
);

/** Piedmontese (Piemontèis)
 * @author Borichèt
 * @author Dragonòt
 */
$messages['pms'] = array(
	'getdata' => 'Oten dij dat',
	'externaldata-desc' => "A përmët d'arcuperé dat struturà da adrësse dl'aragnà esterne, base ëd dàit e d'àutre sorgiss",
	'externaldata-web-invalid-format' => 'Formà pa bon: "$1"',
	'externaldata-ldap-unable-to-connect' => 'A peul pa coleghesse a $1',
	'externaldata-xml-error' => 'Eror XML: $1 a la linia $2',
	'externaldata-db-incomplete-information' => 'Eror: Anformassion pa completa për sto server ID-sì.',
	'externaldata-db-could-not-get-url' => "A peul pa oten-e l'URL d'apress ëd $1 {{PLURAL:$1|preuva|preuve}}.",
	'externaldata-db-unknown-type' => 'Eror: Sòrt ëd database pa conossùa',
	'externaldata-db-could-not-connect' => 'Eror: a peul pa coleghesse al database.',
	'externaldata-db-unknown-collection' => 'Eoro: Colession MongoDB pa conossùa.',
	'externaldata-db-no-return-values' => "Eror: Pa gnun valor d'artorn spessifià.",
	'externaldata-db-invalid-query' => 'Ciamà pa bon-a.',
);

/** Portuguese (português)
 * @author Giro720
 * @author Hamilton Abreu
 * @author Waldir
 */
$messages['pt'] = array(
	'getdata' => 'Obter dados',
	'externaldata-desc' => 'Permite a importação de dados estruturados a partir de URLs, bases de dados e outras fontes externas',
	'externaldata-web-invalid-format' => 'Formato inválido: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Não foi possível estabelecer ligação a $1',
	'externaldata-xml-error' => 'Erro XML: $1 na linha $2',
	'externaldata-db-incomplete-information' => 'Erro: Informação incompleta para este identificador de servidor.',
	'externaldata-db-could-not-get-url' => 'Não foi possível importar a URL após {{PLURAL:$1|uma tentativa|$1 tentativas}}.',
	'externaldata-db-unknown-type' => 'Erro: Tipo de base de dados desconhecido.',
	'externaldata-db-could-not-connect' => 'Erro: Não foi possível estabelecer ligação à base de dados.',
	'externaldata-db-no-return-values' => 'Erro: Não foram especificados valores de retorno.',
	'externaldata-db-invalid-query' => 'Consulta inválida.',
);

/** Brazilian Portuguese (português do Brasil)
 * @author Eduardo.mps
 * @author Giro720
 * @author Jaideraf
 */
$messages['pt-br'] = array(
	'getdata' => 'Obter dados',
	'externaldata-desc' => 'Permite a obtenção de dados em CSV, JSON e XML a partir de URLs externos, banco de dados e outras fontes',
	'externaldata-web-invalid-format' => 'Formato inválido: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Não foi possível conectar-se a $1',
	'externaldata-xml-error' => 'Erro no XML: $1 na linha $2',
	'externaldata-db-incomplete-information' => 'Erro: Informação incompleta para o ID deste servidor</P>',
	'externaldata-db-could-not-get-url' => 'Não foi possível obter o URL após $1 {{PLURAL:$1|tentativa|tentativas}}.',
	'externaldata-db-unknown-type' => 'Erro: Tipo de base de dados desconhecido.',
	'externaldata-db-could-not-connect' => 'Erro: Não foi possível conectar-se a base de dados.',
	'externaldata-db-unknown-collection' => 'Erro: coleção do MongoDB desconhecida.',
	'externaldata-db-no-return-values' => 'Erro: Nenhum valor de retorno especificado.',
	'externaldata-db-invalid-query' => 'Consulta inválida.',
);

/** Romanian (română)
 * @author Firilacroco
 * @author KlaudiuMihaila
 * @author Stelistcristi
 */
$messages['ro'] = array(
	'getdata' => 'Obține date',
	'externaldata-desc' => 'Permite obținerea datelor în format CSV, JSON și XML din atât adrese URL externe, cât și pagini wiki locale', # Fuzzy
	'externaldata-web-invalid-format' => 'Fomat invalid: „$1”',
	'externaldata-ldap-unable-to-connect' => 'Nu se poate conecta la $1',
	'externaldata-xml-error' => 'Eroare XML: $1 la linia $2',
	'externaldata-db-unknown-type' => 'Eroare: Tipul bazei de date necunoscut.',
	'externaldata-db-could-not-connect' => 'Eroare: Nu s-a putut conecta la baza de date.',
	'externaldata-db-invalid-query' => 'Interogare invalidă.',
);

/** tarandíne (tarandíne)
 * @author Joetaras
 */
$messages['roa-tara'] = array(
	'getdata' => 'Pigghie le date',
	'externaldata-desc' => 'Permette de repigghià data strutturate da URL fore a Uicchipèdie, database e otre sorgende',
);

/** Russian (русский)
 * @author Ferrer
 * @author Александр Сигачёв
 */
$messages['ru'] = array(
	'getdata' => 'Получить данные',
	'externaldata-desc' => 'Позволяет получать структурированные данные с внешних адресов, баз данных и других источников',
	'externaldata-web-invalid-format' => 'Недопустимый формат:  "$1"',
	'externaldata-ldap-unable-to-connect' => 'Не удаётся подключиться к $1',
	'externaldata-xml-error' => 'Ошибка XML. $1 в строке $2',
	'externaldata-db-incomplete-information' => 'ОШИБКА. Неполная информация для этого ID сервера.',
	'externaldata-db-could-not-get-url' => 'Не удалось получить URL после $1 {{PLURAL:$1|попытки|попыток|попыток}}.',
	'externaldata-db-unknown-type' => 'ОШИБКА. Неизвестный тип базы данных.',
	'externaldata-db-could-not-connect' => 'ОШИБКА. Не удаётся подключиться к базе данных.',
	'externaldata-db-no-return-values' => 'ОШИБКА. Не указаны возвращаемые значение.',
	'externaldata-db-invalid-query' => 'Ошибочный запрос.',
);

/** Sinhala (සිංහල)
 * @author පසිඳු කාවින්ද
 */
$messages['si'] = array(
	'getdata' => 'දත්ත ලබා ගන්න',
	'externaldata-web-invalid-format' => 'වලංගු නොවන ආකෘතිය: "$1"',
	'externaldata-ldap-unable-to-connect' => '$1 වෙත සම්බන්ධ විය නොහැක',
	'externaldata-xml-error' => 'XML දෝෂය: $1 පේළිය $2',
	'externaldata-db-unknown-type' => 'දෝෂය: නොදන්නා දත්ත සංචිත වර්ගය.',
	'externaldata-db-could-not-connect' => 'දෝෂය: දත්ත සංචිතය වෙත සම්බන්ධ විය නොහැක.',
	'externaldata-db-invalid-query' => 'වලංගු නොවන ප්‍රශ්නය.',
);

/** Slovak (slovenčina)
 * @author Helix84
 */
$messages['sk'] = array(
	'getdata' => 'Získať dáta',
	'externaldata-desc' => 'Umožňuje získavanie štrukturovaných údajov z externých URL, databáz a iných zdrojov',
	'externaldata-ldap-unable-to-connect' => 'Nepodarilo sa pripojiť k $1',
	'externaldata-xml-error' => 'Chyba XML: $1 na riadku $2',
	'externaldata-db-incomplete-information' => 'Chyba: Nekompletné informácie s týmto ID servera.',
	'externaldata-db-could-not-get-url' => 'Nepodarilo sa získať URL po $1 {{PLURAL:$1|pokuse|pokusoch}}.',
	'externaldata-db-unknown-type' => 'Chyba: Neznámy typ databázy.',
	'externaldata-db-could-not-connect' => 'Chyba: Nepodarilo sa pripojiť k databáze.',
	'externaldata-db-no-return-values' => 'Chyba: Neboli zadané žiadne návratové hodnoty.',
	'externaldata-db-invalid-query' => 'Neplatná požiadavka.',
);

/** Serbian (Cyrillic script) (српски (ћирилица)‎)
 * @author Charmed94
 * @author Михајло Анђелковић
 */
$messages['sr-ec'] = array(
	'getdata' => 'Преузми податке',
	'externaldata-desc' => 'Омогућава преузимање података из спољашњих адреса, бази података и других извора',
	'externaldata-ldap-unable-to-connect' => 'Повезивање на $1 није успело',
	'externaldata-xml-error' => 'XML грешка: $1 по линији $2',
	'externaldata-db-incomplete-information' => 'Грешка: Непотпуни подаци за овај ID сервера.',
	'externaldata-db-could-not-get-url' => 'Преузимање адресе после $1 {{PLURAL:$1|try|покушаја}} није успело.',
	'externaldata-db-unknown-type' => 'Грешка: Непозната врста базе података.',
	'externaldata-db-could-not-connect' => 'Грешка: Повезивање с базом података није успело.',
	'externaldata-db-no-return-values' => 'Грешка: Повратне вредности нису одређене.',
	'externaldata-db-invalid-query' => 'Неисправан упит.',
);

/** Serbian (Latin script) (srpski (latinica)‎)
 * @author Michaello
 */
$messages['sr-el'] = array(
	'getdata' => 'Preuzmi podatke',
	'externaldata-desc' => 'Omogućava preuzimanje podataka iz spoljašnjih adresa, bazi podataka i drugih izvora',
	'externaldata-ldap-unable-to-connect' => 'Povezivanje na $1 nije uspelo',
	'externaldata-xml-error' => 'XML greška: $1 po liniji $2',
	'externaldata-db-incomplete-information' => 'Greška: Nepotpuni podaci za ovaj ID servera.',
	'externaldata-db-could-not-get-url' => 'Preuzimanje adrese posle $1 {{PLURAL:$1|try|pokušaja}} nije uspelo.',
	'externaldata-db-unknown-type' => 'Greška: Nepoznata vrsta baze podataka.',
	'externaldata-db-could-not-connect' => 'Greška: Povezivanje s bazom podataka nije uspelo.',
	'externaldata-db-no-return-values' => 'Greška: Povratne vrednosti nisu određene.',
	'externaldata-db-invalid-query' => 'Neispravan upit.',
);

/** Swedish (svenska)
 * @author Ainali
 * @author Boivie
 * @author Lokal Profil
 * @author Najami
 * @author Per
 * @author WikiPhoenix
 */
$messages['sv'] = array(
	'getdata' => 'Hämta data',
	'externaldata-desc' => 'Ger möjlighet att hämta strukturerad data från externa URL:er, databaser och andra källor',
	'externaldata-web-invalid-format' => 'Ogiltigt format: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Kunde inte koppla till $1',
	'externaldata-xml-error' => 'XML-fel: $1 på rad $2',
	'externaldata-db-incomplete-information' => 'Fel: Informationen för server-ID inte komplett.',
	'externaldata-db-could-not-get-url' => 'Kunde inte hämta URL på $1 {{PLURAL:$1|försök|försök}}.',
	'externaldata-db-unknown-type' => 'Fel: Okänd databastyp.',
	'externaldata-db-could-not-connect' => 'Fel: Kunde inte koppla till databasen.',
	'externaldata-db-unknown-collection' => 'Fel: Okänd MongoDB samling.',
	'externaldata-db-no-return-values' => 'Fel: Inga returvärden specificerade.',
	'externaldata-db-invalid-query' => 'Ogiltig fråga.',
);

/** Tamil (தமிழ்)
 * @author Karthi.dr
 * @author மதனாஹரன்
 */
$messages['ta'] = array(
	'getdata' => 'தகவலைப் பெறு',
	'externaldata-db-unknown-type' => 'தவறு: அறியாத தரவுத் தள வகை.',
	'externaldata-db-could-not-connect' => 'தவறு: தரவுத் தளத்துடன் தொடர்பு கொள்ள முடியவில்லை.',
	'externaldata-db-invalid-query' => 'செல்லாத வினவல்.',
);

/** Telugu (తెలుగు)
 * @author Chaduvari
 * @author Kiranmayee
 */
$messages['te'] = array(
	'getdata' => 'విషయములు తీసుకునిరా',
	'externaldata-ldap-unable-to-connect' => '$1 కు కనెక్టు కాలేకున్నాం',
);

/** Tagalog (Tagalog)
 * @author AnakngAraw
 * @author Sky Harbor
 */
$messages['tl'] = array(
	'getdata' => 'Kunin ang dato',
	'externaldata-desc' => 'Nagpapahintulot sa pagkuha ng nakabalangkas na datos mula sa panlabas na mga URL, mga kalipunan ng datos at sa ibang mga pinagmulan',
	'externaldata-web-invalid-format' => 'Hindi katanggap-tanggap na anyo: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Hindi makakunekta sa $1',
	'externaldata-xml-error' => 'Kamalian sa XML: $1 sa linyang $2',
	'externaldata-db-incomplete-information' => 'Kamalian: Hindi-kumpletong impormasyon para sa itong ID ng serbidor.',
	'externaldata-db-could-not-get-url' => 'Hindi makuha ang URL pagkatapos ng $1 {{PLURAL:$1|pagsubok|pagsubok}}',
	'externaldata-db-unknown-type' => 'Kamalian: Hindi-kilalang uri ng kalipunan ng datos.',
	'externaldata-db-could-not-connect' => 'Kamalian: Hindi makakunekta sa talaan ng dato.',
	'externaldata-db-no-return-values' => 'Kamalian: Walang tinukoy na halagang pabalik.',
	'externaldata-db-invalid-query' => 'Hindi tanggap na katanungan.',
);

/** Turkish (Türkçe)
 * @author Karduelis
 * @author Vito Genovese
 */
$messages['tr'] = array(
	'getdata' => 'Veri al',
	'externaldata-db-unknown-type' => 'Hata: Bilinmeyen veritabanı türü.',
	'externaldata-db-could-not-connect' => 'Hata: Veritabanına bağlanılamıyor.',
	'externaldata-db-no-return-values' => 'Hata: Dönüş değeri belirtilmedi.',
	'externaldata-db-invalid-query' => 'Geçersiz sorgu.',
);

/** Ukrainian (українська)
 * @author Base
 * @author Ата
 * @author Тест
 */
$messages['uk'] = array(
	'getdata' => 'Отримати дані',
	'externaldata-desc' => 'Дозволяє отримувати структуровані дані із зовнішніх URL-адрес, баз даних та інших джерел',
	'externaldata-web-invalid-format' => 'Неприпустимий формат: "$1"',
	'externaldata-ldap-unable-to-connect' => 'Не вдається підключитися до $1',
	'externaldata-xml-error' => 'Помилка XML: $1 в рядку $2',
	'externaldata-db-incomplete-information' => 'Помилка: Неповна інформація для цього ID сервера.',
	'externaldata-db-could-not-get-url' => 'Не вдалося отримати URL після $1 {{PLURAL:$1|спроби|спроб}}.',
	'externaldata-db-unknown-type' => 'Помилка: Невідомий тип бази даних.',
	'externaldata-db-could-not-connect' => 'Помилка: не вдалося підключитися до бази даних.',
	'externaldata-db-unknown-collection' => 'Помилка: Невідома колекція MongoDB.',
	'externaldata-db-no-return-values' => 'Помилка: Не вказано зворотних значень.',
	'externaldata-db-invalid-query' => 'Неприпустимий запит.',
);

/** Veps (vepsän kel’)
 * @author Игорь Бродский
 */
$messages['vep'] = array(
	'getdata' => 'Sada andmused',
);

/** Vietnamese (Tiếng Việt)
 * @author Minh Nguyen
 * @author Vinhtantran
 */
$messages['vi'] = array(
	'getdata' => 'Lấy dữ liệu',
	'externaldata-desc' => 'Cho phép truy xuất dữ liệu từ các địa chỉ URL bên ngoài, cơ sở dữ liệu, và nguồn khác',
	'externaldata-xml-error' => 'Lỗi XML ở dòng $2: $1',
);

/** Yiddish (ייִדיש)
 * @author פוילישער
 */
$messages['yi'] = array(
	'getdata' => 'באַקומען דאַטן',
);

/** Simplified Chinese (中文（简体）‎)
 * @author Hydra
 * @author Yfdyh000
 */
$messages['zh-hans'] = array(
	'getdata' => '获取数据',
	'externaldata-desc' => '允许从外部URL，数据库及其他来源接收结构化数据',
	'externaldata-web-invalid-format' => '无效的格式：“$1”',
	'externaldata-ldap-unable-to-connect' => '无法连接到 $1',
	'externaldata-xml-error' => 'XML错误：$1 在行 $2',
	'externaldata-db-incomplete-information' => '错误：此服务器ID信息不完整。',
	'externaldata-db-could-not-get-url' => '$1次尝试后仍无法获取URL。',
	'externaldata-db-unknown-type' => '错误：未知的数据库类型。',
	'externaldata-db-could-not-connect' => '错误：无法连接到数据库。',
	'externaldata-db-unknown-collection' => '错误：未知的MongoDB集合。',
	'externaldata-db-no-return-values' => '错误：没有返回指定的值。',
	'externaldata-db-invalid-query' => '无效的查询。',
);

/** Traditional Chinese (中文（繁體）‎)
 */
$messages['zh-hant'] = array(
	'getdata' => '獲取數據',
	'externaldata-db-invalid-query' => '無效的查詢。',
);
