-- Daten filtern: WHERE-Klausel

SELECT artnr, bezeichnung, gruppe, vkpreis
FROM wawi.artikel
WHERE vkpreis >= 439.95;

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE abtlg = 'VK';

SELECT persnr, nachname, vorname
FROM wawi.personal
WHERE abtlg = 'VK';

-- Hochkomma innerhalb eines Textes

SELECT persnr, nachname, vorname, abtlg
FROM wawi.personal
WHERE nachname = 'O''Brian';

