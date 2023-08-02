-- Case-sensitiv?

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = 'VK';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = 'vk';
-- nicht case-sensitiv! 
-- bei Oracle nicht -> nivellieren:
-- WHERE LOWER(nachname) = 'meister' ODER
-- WHERE UPPER(nachname) = 'MEISTER'

-- Collation / Oracle

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE LOWER(nachname) = 'meister';

SELECT persnr, nachname, vorname, abtlg, COLLATION(nachname)
FROM wawi.personal
WHERE LOWER(nachname) = 'meister';

SELECT persnr, nachname, vorname, abtlg, COLLATION(nachname)
FROM wawi.personal
WHERE nachname COLLATE german_ci = 'meister'; -- ci: case-insensitiv / cs: case-sensitiv

SELECT persnr, nachname, vorname, abtlg, COLLATION(nachname)
FROM wawi.personal
WHERE nachname COLLATE german_ci = 'koßegg'; -- ß -> ss genauso ss -> ß

SELECT persnr, nachname, vorname, abtlg, COLLATION(nachname)
FROM wawi.personal
WHERE nachname COLLATE german_ai = 'prügger'; -- ai: accent-insensitiv / as: case-sensitiv / ü -> u

-- Relevant bei Vergleichung von Zeichenfolgen
SELECT * FROM v$nls_valid_values;

-- MySQL
SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_general_cs = 'meister';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_general_ci = 'meister';

SHOW CHARACTER SET;
SHOW COLLATION WHERE Charset = 'latin1';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_general_ci = 'kossegg';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_german1_ci = 'kossegg';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_german2_ci = 'kossegg';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_german1_ci = 'prugger';

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname COLLATE latin1_german2_ci = 'prugger';