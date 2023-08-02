-- Sortieren der Ausgabe: ORDER BY

SELECT persnr, nachname, vorname, abtlg, eintritt
FROM wawi.personal
WHERE land = 'DE' AND austritt IS NULL
ORDER BY eintritt;

-- Absteigend: DESC
SELECT persnr, nachname, vorname, abtlg, eintritt
FROM wawi.personal
WHERE land = 'DE' AND austritt IS NULL
ORDER BY eintritt DESC;

-- Aufsteigend: ASC
SELECT persnr, nachname, vorname, abtlg, eintritt
FROM wawi.personal
WHERE land = 'DE' AND austritt IS NULL
ORDER BY eintritt ASC;

SELECT persnr, nachname, vorname, abtlg, eintritt
FROM wawi.personal
WHERE land = 'DE' AND austritt IS NULL
ORDER BY nachname;

-- Arten der Sortierung

-- Spaltenname
SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
ORDER BY vkpreis;

-- Aliasname
SELECT artnr, bezeichnung, gruppe, vkpreis, vkpreis - ekpreis AS spanne
FROM wawi.artikel
-- WHERE spanne > 20 -- geht nicht!
-- WHERE vkpreis - ekpreis > 20
ORDER BY spanne;

-- Ausdruck
SELECT artnr, bezeichnung, gruppe, vkpreis, vkpreis - ekpreis AS spanne
FROM wawi.artikel
ORDER BY vkpreis - ekpreis;

-- Position in der SELECT-Klausel
SELECT artnr, bezeichnung, gruppe, vkpreis, vkpreis - ekpreis AS spanne
FROM wawi.artikel
ORDER BY 2; -- Nr. der Spalte Kontext-abhängig

-- Sortieren nach mehreren Kriterien

SELECT artnr, bezeichnung, gruppe, vkpreis, ekpreis
FROM wawi.artikel
ORDER BY gruppe, vkpreis;

SELECT artnr, bezeichnung, gruppe, vkpreis, ekpreis
FROM wawi.artikel
ORDER BY gruppe, vkpreis DESC;

SELECT artnr, bezeichnung, gruppe, vkpreis, ekpreis
FROM wawi.artikel
ORDER BY gruppe DESC, vkpreis DESC;

-- NULL in der Sortierung
SELECT artnr, bezeichnung, gruppe, vkpreis, ekpreis
FROM wawi.artikel
ORDER BY ekpreis, gruppe;

-- TOP - Auswertungen
-- > Filtern aufgrund der Sortierung

-- > LIMIT (wie FETCH bei in Oracle)

SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
ORDER BY vkpreis DESC;

-- die teuersten 5 Artikel
SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
ORDER BY vkpreis DESC
LIMIT 5;

-- die drei längstdienenden Mitarbeiter*innen
SELECT persnr, nachname, vorname, eintritt
FROM wawi.personal
ORDER BY eintritt
LIMIT 3;

-- Paging mit Offset

SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
WHERE gruppe IN('GA', 'HH', 'HW') AND vkpreis BETWEEN 30 and 100
ORDER BY vkpreis, bezeichnung;

-- 10 Zeile je Seite/Page 

-- Zeilen 1-10
SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
WHERE gruppe IN('GA', 'HH', 'HW') AND vkpreis BETWEEN 30 and 100
ORDER BY vkpreis, bezeichnung
LIMIT 10; -- LIMIT 0, 10

-- Zeilen 11-20
SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
WHERE gruppe IN('GA', 'HH', 'HW') AND vkpreis BETWEEN 30 and 100
ORDER BY vkpreis, bezeichnung
LIMIT 10, 10;

-- Zeilen 111-120
SELECT artnr, bezeichnung, vkpreis
FROM wawi.artikel
WHERE gruppe IN('GA', 'HH', 'HW') AND vkpreis BETWEEN 30 and 100
ORDER BY vkpreis, bezeichnung
LIMIT 110, 10;