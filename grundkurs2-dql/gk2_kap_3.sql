-- Unterabfragen / Subqueries
-- In WHERE-Klausel, FROM-Klausel und als Ausdruck möglich

-- WHERE-Klausel

-- Alle Kollegen (m/w) von Mitarbeiterin Kossegg
-- (Wer ist in derselben Abteilung wie Kossegg?)

/*
-- Hauptabfrage?
SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = ??

-- Unterabgrafe:
SELECT abtlg
FROM wawi.personal
WHERE nachname = 'Kossegg';
*/

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = (	SELECT abtlg
				FROM wawi.personal
                WHERE nachname = 'Kossegg')
AND nachname != 'Kossegg';

-- Fehler!
SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = (	SELECT abtlg
				FROM wawi.personal
                WHERE nachname LIKE 'K%');	-- Mehreren Zeilen

-- Mehrere Zeilen aus Unterabfragen:
SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg IN (SELECT abtlg
				FROM wawi.personal
                WHERE nachname LIKE 'K%');

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = (	SELECT abtlg, eintritt		-- 2 Spalten --> Fehlermeldung
				FROM wawi.personal
                WHERE nachname LIKE 'K%');
                
-- Unterabfragen auf mehreren Ebenen

-- Bsp.: Wer ist als erste(r) nach Kofler eingestellt worden?

-- > Was ist das Eintrittsdatum von Kofler?
-- > Was ist das kleinste Eintrittsdatum, das darüber liegt?
-- > Wer hat dieses Eintrittsdatum?

SELECT nachname, vorname, eintritt
FROM wawi.personal
WHERE eintritt = (	SELECT MIN(eintritt)
					FROM wawi.personal
					WHERE eintritt > (	SELECT eintritt
										FROM wawi.personal
										WHERE nachname = 'Kofler'));

-- Alternative
SELECT nachname, vorname, eintritt
FROM wawi.personal
WHERE eintritt = ( 	SELECT eintritt
					FROM wawi.personal
					WHERE nachname = 'Kofler')
ORDER BY eintritt
LIMIT 1;

-- Paarweise unterabfrage (bei MSSQLSERVER nicht)

SELECT nachname, vorname
FROM wawi.personal
WHERE (abtlg, geschlecht) = (	SELECT abtlg, geschlecht
								FROM wawi.personal
                                WHERE nachname = 'Kofler')
AND nachname != 'Kofler';
			
-- Synchronisierte / korrelierte Unterabfrage

-- Artikel, die mehr kosten als der Durchschnitt

SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE vkpreis > (	SELECT AVG(vkpreis)
					FROM wawi.artikel)
ORDER BY gruppe, vkpreis;

-- Artikel, die mehr kosten als der Durchschnitt ihrer Artikelgruppe

SELECT artnr, bezeichnung, vkpreis, gruppe
FROM wawi.artikel
WHERE vkpreis > (	SELECT AVG(vkpreis)
					FROM wawi.artikel)
ORDER BY gruppe, vkpreis;