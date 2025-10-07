-- =============================================
-- Створення бази даних та таблиць
-- Схема відповідає наданій ER-діаграмі.
-- =============================================
CREATE DATABASE IF NOT EXISTS WarehouseDB;
USE WarehouseDB;

-- =============================================
-- Таблиця POSTACH (Постачальник)
-- =============================================
CREATE TABLE POSTACH (
    kod_postach INT AUTO_INCREMENT PRIMARY KEY, -- (К) kod postach
    nazva_postach VARCHAR(255) NOT NULL,
    kontakt_info VARCHAR(255)
);

-- =============================================
-- Таблиця SYROVYNA (Сировина)
-- =============================================
CREATE TABLE SYROVYNA (
    vyd_syrovyny INT AUTO_INCREMENT PRIMARY KEY, -- (К) vyd syrovyny
    nazva_syrovyny VARCHAR(255) NOT NULL UNIQUE,
    odynytsya_vymiru VARCHAR(20) NOT NULL -- odynytsya vymiru
);

-- =============================================
-- Таблиця CEKH (Цех)
-- =============================================
CREATE TABLE CEKH (
    id_cehu INT AUTO_INCREMENT PRIMARY KEY, -- (К) id cehu
    nazva_cehu VARCHAR(100) NOT NULL UNIQUE
);

-- =============================================
-- Таблиця DOGOVIR (Договір) - Зв'язок POSTACH та SYROVYNA
-- =============================================
CREATE TABLE DOGOVIR (
    nomer_dogovoru INT AUTO_INCREMENT PRIMARY KEY, -- (К) nomer dogovoru
    kod_postach INT NOT NULL,
    vyd_syrovyny INT NOT NULL,
    data_ukladannya DATE NOT NULL,
    termin_diyi DATE NOT NULL, -- Можна замінити на data_zakinchennya
    kilkist DECIMAL(10,2) NOT NULL CHECK (kilkist > 0), -- Згідно логіки, додав поле для кількості

    CONSTRAINT FK_DOGOVIR_POSTACH FOREIGN KEY (kod_postach)
        REFERENCES POSTACH(kod_postach)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT FK_DOGOVIR_SYROVYNA FOREIGN KEY (vyd_syrovyny)
        REFERENCES SYROVYNA(vyd_syrovyny)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =============================================
-- Таблиця PRYBUT_NAKLAD (Прибуткова Накладна) - Зв'язок POSTACH та SYROVYNA
-- =============================================
CREATE TABLE PRYBUT_NAKLAD (
    id_pr_naklad INT AUTO_INCREMENT PRIMARY KEY, -- (К) id pr. naklad.
    kod_postach INT NOT NULL,
    vyd_syrovyny INT NOT NULL,
    data_nadkhodzhennya DATE NOT NULL,
    kilkist_otrymana DECIMAL(10,2) NOT NULL CHECK (kilkist_otrymana > 0), -- Згідно зв'язку 'otrymana'

    CONSTRAINT FK_PR_NAKLAD_POSTACH FOREIGN KEY (kod_postach)
        REFERENCES POSTACH(kod_postach)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT FK_PR_NAKLAD_SYROVYNA FOREIGN KEY (vyd_syrovyny)
        REFERENCES SYROVYNA(vyd_syrovyny)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =============================================
-- Таблиця VYDAT_NAKLAD (Видаткова Накладна) - Зв'язок CEKH та SYROVYNA
-- =============================================
CREATE TABLE VYDAT_NAKLAD (
    id_vyd_naklad INT AUTO_INCREMENT PRIMARY KEY, -- (К) id vyd. naklad.
    id_cehu INT NOT NULL,
    vyd_syrovyny INT NOT NULL,
    data_vidvantazhennya DATE NOT NULL,
    kilkist DECIMAL(10,2) NOT NULL CHECK (kilkist > 0),

    CONSTRAINT FK_VYD_NAKLAD_CEKH FOREIGN KEY (id_cehu)
        REFERENCES CEKH(id_cehu)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT FK_VYD_NAKLAD_SYROVYNA FOREIGN KEY (vyd_syrovyny)
        REFERENCES SYROVYNA(vyd_syrovyny)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
