-- Operatoren in SQL: Gleich/Ungleich/Kleiner/Größer

SELECT * FROM wawi.status;

SELECT *
FROM wawi.status
WHERE status = 4;

-- Ungleich
SELECT *
FROM wawi.status
WHERE status <> 4;

SELECT *
FROM wawi.status
WHERE status != 4;

-- Mustervergleiche: LIKE

-- > beliebige Zeichen: %
-- > genau ein Zeichen: _

SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel;

-- "beginnt mit ..."

SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE bezeichnung LIKE 'gardena%';

SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE bezeichnung LIKE 'koch%';

-- "endet auf ..."
SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE bezeichnung LIKE '%koch';

-- "enthält ..."
SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE bezeichnung LIKE '%koch%';

-- "mindestens ein Zeichen vorne oder hinten"
SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE bezeichnung LIKE '_%koch%_';

-- gültige E-Mailadressen filtern

SELECT kdnr, nachname, vorname, email
FROM wawi.kunden
WHERE email LIKE '__%@%__.%__';

-- Buchstabenaufzählung mit [] mit LIKE

SELECT persnr, nachname, vorname
FROM wawi.personal
ORDER BY nachname;

-- Beginnt mit K oder L

SELECT persnr, nachname, vorname
FROM wawi.personal
WHERE nachname LIKE '[kl%]'
ORDER BY nachname;

-- Beginnt NICHT mit K oder L

SELECT persnr, nachname, vorname
FROM wawi.personal
WHERE nachname LIKE '[^kl]%'
ORDER BY nachname;

-- Beginnt mit K bis N

SELECT persnr, nachname, vorname
FROM wawi.personal
WHERE nachname LIKE '[k-n]%'
ORDER BY nachname;

-- Beginnt mit K bis N, oder A, oder S

SELECT persnr, nachname, vorname
FROM wawi.personal
WHERE nachname LIKE '[ak-ns]%'
ORDER BY nachname;

-- Sondervariante mit LIKE / Suche nach Prozent und Unterstrich

SELECT bezeichnung
FROM wawi.liketest;

SELECT bezeichnung
FROM wawi.liketest
WHERE bezeichnung LIKE 'test#%wert' ESCAPE '#';

SELECT bezeichnung
FROM wawi.liketest
WHERE bezeichnung LIKE '%µ_%' ESCAPE 'µ';

-- Nicht-CHAR 

SELECT persnr, nachname, eintritt
FROM wawi.personal
WHERE eintritt LIKE '%2019';

SELECT persnr, nachname, eintritt
FROM wawi.personal
WHERE eintritt LIKE '%2019%'; -- Fehleranfällig: implizite Datenumwandlung

SELECT persnr, nachname, eintritt
FROM wawi.personal
WHERE DATE_FORMAT(eintritt, '%d.%m.%Y') LIKE '%2019%';

SELECT persnr, nachname, eintritt
FROM wawi.personal
WHERE YEAR(eintritt) = 2019;

-- Bereiche: BETWEEN

SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
ORDER BY vkpreis;

-- z.B.: Artikel mit einem Preis von 100 - 115
SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
WHERE vkpreis BETWEEN 100 AND 115
ORDER BY vkpreis;

-- Grenzwerte inklusive
SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
WHERE vkpreis BETWEEN 107.92 AND 108.79
ORDER BY vkpreis;

-- Mitarbeiter*innen, die in den 90ern geboren sind
SELECT persnr, nachname, vorname, gebdatum
FROM wawi.personal
WHERE gebdatum BETWEEN '1990-01-01' AND '1999-12-31';

-- Mehrere Werte: IN()

SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
WHERE gruppe IN('BE', 'GE', 'KG');

SELECT persnr, nachname, vorname, gebdatum, abtlg
FROM wawi.personal
WHERE abtlg IN('MA', 'VK', 'EK', 'GL')
ORDER BY nachname;

SELECT persnr, nachname, vorname, gebdatum, abtlg
FROM wawi.personal
WHERE gebdatum IN ('1969-01-29', '1991-08-15', '2000-08-01');

-- ANY() und ALL()

-- > kombiniert mit: <, <=, > oder >=
-- > > ANY ... größer als der kleinste Wert
-- > < ANY ... kleiner als der größte Wert
-- > > ALL ... größer als der größte Wert
-- > < ALL ... kleiner als der kleinste Wert

-- NULL-Werte filtern: IS NULL / IS NOT NULL

SELECT nachname, vorname, email
FROM wawi.kunden
WHERE email = NULL;

SELECT nachname, vorname, email
FROM wawi.kunden
WHERE email IS NULL;

SELECT nachname, vorname, email
FROM wawi.kunden
WHERE email IS NOT NULL;

