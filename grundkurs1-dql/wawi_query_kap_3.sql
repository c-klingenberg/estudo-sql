-- Ausdrücke mit Zeichenfolgen/Strings

SELECT persnr, nachname, vorname, akad, akad2
FROM wawi.personal;

SELECT	persnr, nachname, vorname, akad, akad2,
		akad + ' ' + vorname + ' ' + upper(nachname) + ',' + akad2 AS "mitarbeiter(in)"
FROM	wawi.personal;

-- MySQL

SELECT	persnr, nachname, vorname, akad, akad2,
		CONCAT(akad, ' ', vorname, ' ', upper(nachname), ',', akad2) AS "mitarbeiter(in)"
FROM	wawi.personal;

-- Null-Werte unterdrücken: IFNULL(wert, ersatzwert)

SELECT	persnr, nachname, vorname, akad, akad2,
		CONCAT(IFNULL(CONCAT(akad, ' '), ''), vorname, ' ',
			UPPER(nachname), IFNULL(CONCAT(',', akad2), '')) AS "mitarbeiter(in)"
FROM	wawi.personal;

-- Beispiele: E-Mailadresse generieren
-- Aufbau: v.nnnnnn@databases.at

SELECT	nachname, vorname,
		LOWER(
			REPLACE(
				CONCAT(
					LEFT(vorname, 1), '.', nachname, '@databases.at'), 'ö', 'oe')) AS email
FROM wawi.personal;

-- Sonderzeichen ersetzen: REPLACE(text, suchzeichen, ersatz)
-- Hochkomma innerhalb einer Zeichenfolge: 

SELECT 'O''Brian' AS name; -- 2x Hochkomma


