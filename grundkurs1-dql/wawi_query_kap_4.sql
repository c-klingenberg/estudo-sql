-- Berechnungen mit Datumswerten

-- Zeitraum dazu/weg

-- A) Addition/Subtraktion einer Zahl
-- B) Datumsfunktion

SELECT	datum,
		DATE_ADD(datum, INTERVAL 1 DAY) AS plus_1_tag,
		DATE_ADD(datum, INTERVAL 12 HOUR) AS plus_12_stunden,
        DATE_ADD(datum, INTERVAL 3 WEEK) AS plus_3_wochen,
        DATE_ADD(datum, INTERVAL -2 MONTH) AS minus_2_monate,
        DATE_ADD(datum, INTERVAL 1 QUARTER) AS plus_1_quartal,
        DATE_ADD(datum, INTERVAL 5 YEAR) AS plus_5_jahre
FROM wawi.bestellungen;

-- Berechnung von Zeitspannen

SELECT datum, NOW() as jetzt, CURDATE() as heute
FROM wawi.bestellungen;

SELECT	datum, NOW() as jetzt, CURDATE() as heute,
		TIMESTAMPDIFF(hour, datum, CURDATE()) AS stunden,
        TIMESTAMPDIFF(hour, datum, NOW()) AS stunden_jetzt,
        TIMESTAMPDIFF(day, datum, CURDATE()) AS tage,
        TIMESTAMPDIFF(week, datum, CURDATE()) AS wochen,
        TIMESTAMPDIFF(month, datum, CURDATE()) AS monate,
        TIMESTAMPDIFF(year, datum, CURDATE()) AS jahre
FROM wawi.bestellungen;

SELECT	datum, NOW() as jetzt, CURDATE() as heute,
		TIMESTAMPADD(day, 1, datum) AS plus_1_tage,
        TIMESTAMPADD(hour, 12, datum) AS plus_12_stunden,
        TIMESTAMPADD(week, 3, datum) AS plus_3_wochen,
        TIMESTAMPADD(month, -2, datum) AS minus_2_monate,
        TIMESTAMPADD(month, 3, datum) AS plus_1_quarter,
        TIMESTAMPADD(year, 5, datum) AS plus_5_jahre
FROM wawi.bestellungen;







