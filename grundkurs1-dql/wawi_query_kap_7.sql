-- Kriterien für Datumsfelder

SELECT persnr, nachname, vorname, eintritt
FROM wawi.personal;

-- ab 1. Mai 2019 eingestellt

SELECT persnur, nachname, vorname, eintritt
FROM wawi.personal
WHERE eintritt >= '01.05.2019'; -- alle Mitarbeiter*innen angezeigt

-- Standardformat verwenden: ISO-Format YYYY-MM-DD
SELECT persnr, nachname, vorname, eintritt
FROM wawi.personal
WHERE eintritt >= '2019-05-01';

-- explizit konvertieren
SELECT persnr, nachname, vorname, eintritt
FROM wawi.personal
WHERE eintritt >= str_to_date('01.05.2019', '%d.%m.%y');