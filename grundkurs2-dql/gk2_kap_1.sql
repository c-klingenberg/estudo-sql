-- Foreign key: Bestandteil der DB-Struktur - Erzwingen Regeln (referentielle Integrität) 
-- Hohe Voraussetzungen für die Erstellung (Datentyp, Größe)

-- Join: Verfahrensanweisung in einer SQL-Anweisung - Keinerlei Regeln - Sehr geringe Voraussetzungen

-- EQUIJOIN --> nur mit Gleichheit --> Voraussetzung: muss eine Beziehung bestehen (foreign key)
-- NONEQUIJOIN --> alles, was man in einer Bedingungen fassen kann, kann im joinen verwendet werden. (außer Gleichheit)

-- INNER JOIN
-- Es werden nur diejenigen Daten gezeigt, die in beiden Tabellen Entsprechungen finden.alter

-- OUTER JOIN
-- LEFT/RIGHT OUTER JOIN: aus einer der Tabellen werden auch jene Daten angezeigt, für die es keine Entsprechungen gibt.
-- FULL OUTER JOIN: In Sonderfällen ist es auch möglich, aus beiden Tabellen alles anzuzeigen.

-- ANSIJOIN

SELECT * FROM wawi.artikel;
SELECT * FROM wawi.artikelgruppen;

SELECT artnr,
wawi.artikel.bezeichnung AS artikel,
wawi.artikelgruppen.bezeichnung AS artikelgruppe,
vkpreis
FROM wawi.artikel INNER JOIN wawi.artikelgruppen ON gruppe = artgr
WHERE vkpreis <= 80
ORDER BY vkpreis;

-- Veraltete Syntax: JOIN über die WHERE-Klausel

SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
WHERE vkpreis <= 80
ORDER BY vkpreis;

-- Artikelgruppe ergänzen
SELECT	artnr,
		wawi.artikel.bezeichnung,
        wawi.artikel.bezeichnung AS gruppen,
        vkpreis
FROM wawi.artikel, wawi.artikelgruppen   -- > wen?
WHERE gruppe = artgr                     -- > wie?
AND vkpreis <= 80 
ORDER BY vkpreis;

-- JOIN-Bedingung fehlt: Kreuzprodukt/karthesisches Produkt
SELECT	artnr,
		wawi.artikel.bezeichnung,
        wawi.artikel.bezeichnung AS gruppen,
        vkpreis
FROM wawi.artikel, wawi.artikelgruppen   -- > wen?
WHERE gruppe = artgr                     -- > wie?
AND vkpreis <= 80 
ORDER BY vkpreis;

-- Kunden und Kundeninteressen
SELECT * FROM wawi.kunden;
SELECT * FROM wawi.interessen;
SELECT * FROM wawi.kundeninteressen ORDER BY kdnr;

SELECT kdnr, nachname, vorname, intcode AS interesse
FROM wawi.kunden
INNER JOIN wawi.kundeninteressen ON kdnr = kdnr
ORDER BY nachname, interesse;

-- Herkunft ergänzen, wenn Namensgleichheit
SELECT wawi.kunden.kdnr, nachname, vorname, intcode AS interesse
FROM wawi.kunden
INNER JOIN wawi.kundeninteressen ON wawi.kunden.kdnr = wawi.kundeninteressen.kdnr
ORDER BY nachname, interesse;

-- Besser: sobald > 1 Tabelle, Herkunft bei JEDER Spalte anzugeben
SELECT	wawi.kunden.kdnr,
		wawi.kunden.nachname,
        wawi.kunden.vorname,
        wawi.kundeninteressen.intcode AS interesse
FROM wawi.kunden
INNER JOIN wawi.kundeninteressen ON wawi.kunden.kdnr = wawi.kundeninteressen.kdnr
ORDER BY wawi.kunden.nachname, interesse;

-- Optimal: Einsatz von Tabellenaliasnamen
SELECT	k.kdnr, k.nachname, k.vorname, i.intcode AS interesse
FROM wawi.kunden k -- = wawi.kunden AS k
INNER JOIN wawi.kundeninteressen i ON k.kdnr = i.kdnr
ORDER BY k.nachname, interesse;

-- Join mit mehr als 2 Tabellen

-- Wer, mit welcher Anrede, hat wann, was bei welchem Lieferanten bestellt?

SELECT	a.bezeichnung AS anrede, p.nachname, p.vorname, b.datum,
		bp.artikel, bp.bezeichnung AS artikelbezeichnung, l.firma1, l.firma2
FROM wawi.personal p              										-- Startpflock                                    
INNER JOIN wawi.anreden a ON p.geschlecht = a.anrnr						-- 1. Lassowurf
INNER JOIN wawi.bestellungen b ON b.bearbeiter = p.persnr				-- 2. Lassowurf
INNER JOIN wawi.bestellpositionen bp ON b.bestnr = bp.bestnr			-- 3. Lassowurf
INNER JOIN wawi.lieferanten l ON b.lieferant = l.liefnr					-- 4. Lassowurf
INNER JOIN wawi.abteilungen ab ON p.abtlg = ab.abtnr
ORDER BY b.bestnr;

-- Bsp.: Welche Artikel (wawi.artikel) aus welchen Artikelgruppen (wawi.artikelgruppen) liegen 
-- mit welchen Werten (Einkaufpreis - wawi.artikel)
-- und Mengen (wawi.lagerstand) in welchen Lagern(wawi.lager)? (Kapputtteilelager <> Wert!)

SELECT	l.lagnr, l.bezeichnung as lager, ls.artnr,
        a.bezeichnung AS artikel, a.gruppe, ag.bezeichnung, a.ekpreis, ls.menge
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen ag ON a.gruppe = ag.artgr
WHERE l.lagnr != 5
ORDER BY ls.artnr, l.lagnr;

-- Berechnung vom Warenwert
SELECT	l.lagnr, l.bezeichnung as lager, ls.artnr,
        a.bezeichnung AS artikel, a.gruppe, ag.bezeichnung, a.ekpreis, ls.menge,
        ls.menge * a.ekpreis AS warentwert
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen ag ON a.gruppe = ag.artgr
WHERE l.lagnr != 5
ORDER BY ls.artnr, l.lagnr;

-- Kosmetik
SELECT	l.lagnr, l.bezeichnung as lager, ls.artnr,  					
        a.bezeichnung AS artikel, a.ekpreis, ag.bezeichnung, ls.menge,
        -- Preis nach der Artikelbezeichnung; a.gruppe unnötig
        ls.menge * a.ekpreis AS warentwert
FROM wawi.lager l
INNER JOIN wawi.lagerstand ls ON l.lagnr = ls.lagnr
INNER JOIN wawi.artikel a ON ls.artnr = a.artnr
INNER JOIN wawi.artikelgruppen ag ON a.gruppe = ag.artgr
WHERE l.lagnr != 5 AND ls.menge > 0 -- Weiter ausfiltern
ORDER BY ls.artnr, l.lagnr; -- Sortierung

-- OUTER JOIN

-- > auch jene Daten aus Tabelle x, die in Tabelle y nicht vorkommen

-- Bsp.: bestellte Artikel

SELECT a.artnr, a.bezeichnung, p.menge
FROM wawi.bestellpositionen p 
INNER JOIN wawi.artikel a ON p.artikel = a.artnr
ORDER BY a.bezeichnung;
-- 33 Ergebnisse

-- > auch noch nie bestellte Artikel sollen angezeigt werden
SELECT a.artnr, a.bezeichnung, p.menge
FROM wawi.bestellpositionen p 
RIGHT OUTER JOIN wawi.artikel a ON p.artikel = a.artnr -- OUTER OPTIONAL
ORDER BY a.bezeichnung;
-- 1117 Ergebnisse

-- OUTER JOIN: was gibt es in der anderen Tabelle nicht?

-- z.B.: Welchen nartikelgruppen ist derzeit kein Artikel zugeordnet?

SELECT * FROM wawi.artikelgruppen;

SELECT g.bezeichnung AS artikelgruppe, a.bezeichnung AS artikel
FROM wawi.artikel a 
INNER JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
ORDER BY artikelgruppe, artikel;

-- > OUTER JOIN, damit ALLE Gruppen angezeigt werden
SELECT g.bezeichnung AS artikelgruppe, a.bezeichnung AS artikel
FROM wawi.artikel a 
RIGHT JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
ORDER BY artikelgruppe, artikel;

-- > mit WHERE alle Treffer herausfiltern
SELECT g.bezeichnung AS artikelgruppe, a.bezeichnung AS artikel
FROM wawi.artikel a 
RIGHT JOIN wawi.artikelgruppen g ON a.gruppe = g.artgr
WHERE a.bezeichnung IS NULL  -- a.gruppe (primär Schlüssel)
ORDER BY artikelgruppe, artikel;

-- OUTER JOIN mit mehr als 2 Tabellen

SELECT k.nachname, k.vorname, i.bezeichnung AS interesse
FROM wawi.kunden k
INNER JOIN wawi.kundeninteressen ki ON k.kdnr = ki.kdnr
INNER JOIN wawi.interessen i ON ki.intcode = i.intcode
ORDER BY k.nachname, k.vorname, interesse;

-- auch Kunden, ohne ein einziges Interesse anzeigen
SELECT k.nachname, k.vorname, i.bezeichnung AS interesse
FROM wawi.kunden k
LEFT JOIN wawi.kundeninteressen ki ON k.kdnr = ki.kdnr
LEFT JOIN wawi.interessen i ON ki.intcode = i.intcode
ORDER BY k.nachname, k.vorname, interesse;

-- JOIN in anderer Reihenfolge:
SELECT k.nachname, k.vorname, i.bezeichnung AS interesse
FROM wawi.interessen i
INNER JOIN wawi.kundeninteressen ki ON ki.intcode = i.intcode
RIGHT JOIN wawi.kunden k ON ki.kdnr = k.kdnr
ORDER BY k.nachname, k.vorname, interesse;

-- NONEQUI-JOIN
-- beziehungslose Tabelle

SELECT persnr, nachname, gehalt FROM wawi.personal;
SELECT * FROM wawi.gehaltstufen;

SELECT p.persnr, p.vorname, p.nachname, p.gehalt, g.stufe
FROM wawi.personal p
INNER JOIN wawi.gehaltstufen g /*Bedingung*/ ON  p.gehalt BETWEEN g.von AND g.bis
ORDER BY p.gehalt;

-- SELF-JOIN

SELECT persnr, nachname, vorgesetzter
FROM wawi.personal
ORDER BY persnr;

-- Wer ist Chef(in) von wem?
SELECT c.nachname AS "Chef(in)", m.nachname AS "Mitarbeiter(in)"
FROM wawi.personal m
INNER JOIN wawi.personal c ON m.vorgesetzter = c.persnr
ORDER BY c.nachname, m.nachname;

-- Auch alle ohne Chef(in) anzeigen
SELECT IFNULL(c.nachname, 'seine Frau...') AS "Chef(in)", m.nachname AS "Mitarbeiter(in)"
FROM wawi.personal m
LEFT JOIN wawi.personal c ON m.vorgesetzter = c.persnr
ORDER BY c.nachname, m.nachname;

-- CROSS JOIN 

-- Spiele unserer Abteilungsliga
SELECT h.bezeichnung AS heim, g.bezeichnung AS gast
FROM wawi.abteilungen h
CROSS JOIN wawi.abteilungen g
WHERE h.abtnr != g.abtnr
ORDER BY heim, gast;

