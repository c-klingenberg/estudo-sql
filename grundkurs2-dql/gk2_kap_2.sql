-- Mehrere Werte zusammenfassen: Gruppenfunktionen/Aggregatfunktionen/Multiple-row-Funktionen

-- > Summe, Anzahl, Minimum, Maxim, Mittelwert, Standardabweichung, Varianz

SELECT	COUNT(vkpreis) AS anzahl,
		MIN(vkpreis) AS minimum,
		MAX(vkpreis) AS maximum,
        AVG(vkpreis) AS mittelwert,					-- ROUND()
        SUM(vkpreis) AS summe,
        STDDEV(vkpreis) AS standardabweichung,		-- ROUND()
        VARIANCE(vkpreis) AS varianz				-- ROUND()
FROM wawi.artikel;

-- Immer eine Ergebniszeile

SELECT	COUNT(vkpreis) AS anzahl,
		MIN(vkpreis) AS minimum,
		MAX(vkpreis) AS maximum,
        AVG(vkpreis) AS mittelwert,					
        SUM(vkpreis) AS summe,
        STDDEV(vkpreis) AS standardabweichung,		
        VARIANCE(vkpreis) AS varianz				
FROM wawi.artikel
WHERE gruppe IN('BE', 'GE');

-- selbst, wenn keine Datensätze
SELECT	COUNT(vkpreis) AS anzahl,
		MIN(vkpreis) AS minimum,
		MAX(vkpreis) AS maximum,
        AVG(vkpreis) AS mittelwert,					
        SUM(vkpreis) AS summe,
        STDDEV(vkpreis) AS standardabweichung,		
        VARIANCE(vkpreis) AS varianz				
FROM wawi.artikel
WHERE gruppe = 'XX';

-- NULL-Werte bei Gruppenfunktionen

SELECT	COUNT(*) AS datensaetze,
		COUNT(persnr) AS inhalte,
		COUNT(akad) AS akademiker,			-- Alle nicht-NULL-Werte werden angezeigt
        COUNT(DISTINCT akad) AS akademiker	-- Alle unterschiedliche Werte/Eintrage werden angezeigt
FROM wawi.personal;

SELECT	COUNT(lieferzeit),
		AVG(lieferzeit),			-- NULL-Werte werden nicht berücksichtigt
        AVG(IFNULL(lieferzeit, 0))
FROM wawi.artikel;

-- GROUP BY

-- je Artikelgruppe
SELECT	a.gruppe AS artikelgruppe,
		g.bezeichnung AS bezeichnung,
		MIN(a.vkpreis) as minimum,
		MAX(a.vkpreis) as maximum,
		AVG(a.vkpreis) AS mittelwert,
        COUNT(a.vkpreis) AS anzahl
FROM wawi.artikel a
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
GROUP BY a.gruppe;

-- Achtung - Fehlergefahr! ... in MySQL nicht ganz so schlimm ;)
SELECT	a.gruppe AS artikelgruppe, ekpreis,	-- ungültig: kein GROUP-BY-Ausdruck! --> das "Anti-Heugabel-Prinzip"
		g.bezeichnung AS bezeichnung,
		MIN(a.vkpreis) as minimum,
		MAX(a.vkpreis) as maximum,
		AVG(a.vkpreis) AS mittelwert,
        COUNT(a.vkpreis) AS anzahl
FROM wawi.artikel a
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
GROUP BY a.gruppe;

-- GROUP BY und WHERE gemeinsam verwenden

-- nur für Artikel ab 25,--
SELECT	a.gruppe AS artikelgruppe,
		g.bezeichnung AS bezeichnung,
		ROUND(MIN(a.vkpreis), 2) as minimum,
		ROUND(MAX(a.vkpreis), 2) as maximum,
		ROUND(AVG(a.vkpreis), 2) AS mittelwert,
        COUNT(a.vkpreis) AS anzahl
FROM wawi.artikel a
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
WHERE vkpreis >= 25
GROUP BY a.gruppe
ORDER BY artikelgruppe;

-- Anzahl der aktiven('Filter') Mitarbeiter je Abteilung('Gruppierung')
SELECT abtlg, a.bezeichnung AS abteilung, COUNT(*) AS mitarbeiter
FROM wawi.personal p
INNER JOIN wawi.abteilungen a ON p.abtlg = a.abtnr
WHERE p.austritt IS NULL OR austritt > NOW()
GROUP BY p.abtlg, a.bezeichnung
ORDER BY mitarbeiter DESC;

-- Gruppieren nach mehreren Spalten

-- Wie viele Interessen hat jeder Kunde?
SELECT	k.nachname, k.vorname, COUNT(i.intcode) AS interessen
FROM wawi.kunden k
INNER JOIN wawi.kundeninteressen i ON k.kdnr = i.kdnr
GROUP BY k.nachname, k.vorname;

SELECT	k.kdnr, k.nachname, k.vorname,
		COUNT(i.intcode) AS interessen
FROM wawi.kunden k
INNER JOIN wawi.kundeninteressen i ON k.kdnr = i.kdnr
GROUP BY k.nachname, k.vorname, k.kdnr
ORDER BY k.nachname, k.vorname;

-- Das Ergebnis der Gruppierung einschränken: HAVING

-- Beispiel: In welcher Abteilung arbeiten mehr als 2 aktive Mitarbeiter?
-- > Kriterium 1: Mitarbeiter sind aktiv
-- > Kriterium 2: Anzahl der Mitarbeiter mind. zwei

SELECT abtlg, COUNT(*) AS anzahl
FROM wawi.personal
WHERE austritt IS NULL AND COUNT(*) > 2 -- In der WHERE-Klausel darf kein Aggregat auftreten
GROUP BY abtlg
ORDER BY anzahl;

SELECT abtlg, COUNT(*) AS anzahl
FROM wawi.personal
WHERE austritt IS NULL	-- Grunddaten VOR der Gruppierung
GROUP BY abtlg
HAVING COUNT(*) > 2		-- Ergebnis der Grupperiung DANACH
ORDER BY anzahl;

-- Schlechtes Beispiel
SELECT abtlg, COUNT(*) AS anzahl
FROM wawi.personal
GROUP BY abtlg
HAVING abtlg IN('EK', 'VK', 'MA');

-- besser:
SELECT abtlg, COUNT(*) AS anzahl
FROM wawi.personal
WHERE abtlg IN('EK', 'VK', 'MA')
GROUP BY abtlg;

-- Einfach Kreuztabelle / Pivot-Tabelle

SELECT abtlg, geschlecht, COUNT(*) AS anzahl
FROM wawi.personal
WHERE austritt IS NULL
GROUP BY abtlg, geschlecht
ORDER BY abtlg, geschlecht;

SELECT	vorname,
		CASE WHEN geschlecht = 1 THEN 'X' END AS damen,
      	CASE WHEN geschlecht = 2 THEN 'X' END AS herren
FROM wawi.personal;

SELECT	abtlg ,
		COUNT(CASE WHEN geschlecht = 1 THEN 'X' END) AS damen,
      	COUNT(CASE WHEN geschlecht = 2 THEN 'X' END) AS herren,
		COUNT(*) AS gesamt
FROM wawi.personal
GROUP BY abtlg;

SELECT	a.bezeichnung AS abteilung,
		COUNT(CASE WHEN p.geschlecht = 1 THEN 'X' END) AS damen,
      	COUNT(CASE WHEN p.geschlecht = 2 THEN 'X' END) AS herren,
		COUNT(*) AS gesamt
FROM wawi.personal p
INNER JOIN wawi.abteilungen a ON p.abtlg = a.abtnr
GROUP BY abteilung		-- auch: GROUP BY a.bezeichnung
ORDER BY abteilung;

-- Zwischen- und Gesamtwerte: ROLLUP

SELECT gruppe, COUNT(*) AS anzahl
FROM wawi.artikel
GROUP BY gruppe;

SELECT gruppe, COUNT(*) AS anzahl
FROM wawi.artikel
GROUP BY gruppe WITH ROLLUP;

-- Oracle: ROLLUP() / MSSQLServer: beide Varianten

SELECT IFNULL(gruppe, 'Gesamt') AS gruppe, COUNT(*) AS anzahl
FROM wawi.artikel
GROUP BY gruppe WITH ROLLUP;

-- ROLLUP mit Sortierung
SELECT IFNULL(gruppe, 'Gesamt') AS gruppe, COUNT(*) AS anzahl
FROM wawi.artikel
GROUP BY gruppe WITH ROLLUP
ORDER BY anzahl DESC;

-- GROUPING()
SELECT IFNULL(gruppe, 'Gesamt') AS gruppe, COUNT(*) AS anzahl
FROM wawi.artikel
GROUP BY gruppe WITH ROLLUP
ORDER BY GROUPING(gruppe), anzahl DESC;

-- Weiteres Beispiel
SELECT	a.bezeichnung AS abteilung,
		COUNT(CASE WHEN p.geschlecht = 1 THEN 'X' END) AS damen,
      	COUNT(CASE WHEN p.geschlecht = 2 THEN 'X' END) AS herren,
		COUNT(*) AS gesamt
FROM wawi.personal p
INNER JOIN wawi.abteilungen a ON p.abtlg = a.abtnr
GROUP BY a.bezeichnung WITH ROLLUP
ORDER BY GROUPING(a.bezeichnung), gesamt DESC;

-- ROLLUP vs CUBE
-- Bsp: Warenwert je Artikelgruppe und Lager

SELECT	l.bezeichnung AS lager,
		g.bezeichnung AS artikelgruppe,
        SUM(menge*a.ekpreis) AS wert
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
WHERE l.lagnr != 5
GROUP BY l.bezeichnung, g.bezeichnung;

-- ROLLUP
SELECT	l.bezeichnung AS lager,
		g.bezeichnung AS artikelgruppe,
        SUM(menge*a.ekpreis) AS wert
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
WHERE l.lagnr != 5
GROUP BY l.bezeichnung, g.bezeichnung WITH ROLLUP;

-- CUBE wird noch nicht in MySQL unterstützt
SELECT	l.bezeichnung AS lager,
		g.bezeichnung AS artikelgruppe,
        SUM(menge*a.ekpreis) AS wert
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
WHERE l.lagnr != 5
GROUP BY CUBE(l.bezeichnung, g.bezeichnung);

