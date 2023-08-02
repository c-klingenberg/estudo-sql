-- Bedingungen in Ausdrücken: CASE

-- Das WENN (bedingung; dann; sonst) von Excel

-- einfache Syntax

SELECT	persnr,
		CASE geschlecht WHEN 1 THEN 'Frau'
						WHEN 2 THEN 'Herr'
                        ELSE 'undef.' END AS anrede, -- optional
        nachname, vorname
FROM wawi.personal
WHERE austritt IS NULL;

-- erweitete Syntax

SELECT	persnr,
		CASE geschlecht WHEN 1 THEN 'Frau'
						WHEN 2 THEN 'Herr'
                        ELSE 'undef.' END AS anrede, -- optional
        nachname, vorname, eintritt,
        CASE WHEN geschlecht = 1 AND eintritt >= '2019-01-01' THEN 'Jungmitarbeiterin'
			 WHEN geschlecht = 2 AND eintritt >= '2019-01-01' THEN 'Jungmitarbeiter'
             WHEN geschlecht = 1 AND eintritt < '2019-01-01' THEN 'Mitarbeiterin'
             WHEN geschlecht = 2 AND eintritt < '2019-01-01' THEN 'Mitarbeiter'
             ELSE 'undef.' END AS kategorie
FROM wawi.personal
WHERE austritt IS NULL;

-- Variante "kurz":
SELECT	persnr,
		CASE geschlecht WHEN 1 THEN 'Frau'
						WHEN 2 THEN 'Herr'
                        ELSE 'undef.' END AS anrede, -- optional
        nachname, vorname, eintritt,
        CASE WHEN geschlecht = 1 AND eintritt >= '2019-01-01' THEN 'Jungmitarbeiterin'
			 WHEN eintritt >= '2019-01-01' THEN 'Jungmitarbeiter'
             WHEN geschlecht = 1 THEN 'Mitarbeiterin'
             ELSE 'Mitarbeiter' END AS kategorie
FROM wawi.personal
WHERE austritt IS NULL;

