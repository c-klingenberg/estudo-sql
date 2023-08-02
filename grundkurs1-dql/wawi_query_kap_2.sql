-- Die Data Query Language - DQL

SELECT artnr, bezeichnung, vkpreis
FROM artikel;

/* alles ab hier
ein Kommentar,
selbst in der nächsten Zeile
*/

SELECT artnr, bezeichnung, /* Kommentar ...*/ vkpreis
FROM artikel;

-- das Schema

SELECT persnr, nachname, vorname
FROM /*Schemaname.Tabelle -> nötig wenn nicht Standard-Schema*/ wawi.personal;

-- Ausdrücke

SELECT SYSDATE(); -- oder
SELECT now();

SELECT 3 + 7;

-- mathematische Ausdrücke

SELECT bestnr, pos, bezeichnung, menge, preis, rabatt,
	ROUND(menge * preis * (100 - rabatt) / 100, 2) AS gesamtpreis
FROM wawi.bestellpositionen;

-- Aliasname

SELECT artnr, bezeichnung, gruppe, vkpreis AS vk_brutto, mwst,
	ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto
FROM wawi.artikel;
