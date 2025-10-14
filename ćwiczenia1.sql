
CREATE DATABASE firma;
GO
USE firma;
GO

CREATE SCHEMA ksiegowosc;
GO

CREATE TABLE ksiegowosc.pracownicy (
id_pracownika INT IDENTITY(1,1) PRIMARY KEY,
imie NVARCHAR(50) NOT NULL,
nazwisko NVARCHAR(50) NOT NULL,
adres NVARCHAR(100),
telefon NVARCHAR(15)
);
GO

EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'Tabela przechowuje dane osobowe pracowników.',
@level0type = N'SCHEMA', @level0name = 'ksiegowosc',
@level1type = N'TABLE', @level1name = 'pracownicy';
GO

CREATE TABLE ksiegowosc.godziny (
id_godziny INT IDENTITY(1,1) PRIMARY KEY,
data DATE not null,
liczba_godzin decimal(4,2),
id_pracownika int not null,
foreign key (id_pracownika) references ksiegowosc.pracownicy(id_pracownika)
);
GO
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'Tabela przechowuje liczbê przepracowanych godzin przez pracownikó firmy.',
@level0type = N'SCHEMA', @level0name = 'ksiegowosc',
@level1type = N'TABLE', @level1name = 'godziny';
GO

CREATE TABLE ksiegowosc.pensja (
id_pensji int identity(1,1) primary key,
stanowisko nvarchar(50) not null,
kwota decimal(10,2)
);
GO
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'Tabela przechowuje informacje o pensji dla stanowisk',
@level0type = N'SCHEMA', @level0name = 'ksiegowosc',
@level1type = N'TABLE', @level1name = 'pensja';
GO
CREATE TABLE ksiegowosc.premia (
id_premii int identity(1,1) primary key,
rodzaj nvarchar(50),
kwota decimal(10,2)
);
go
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'Tabela przechowuje informacje o rodzajach i wysokoœci premii.',
@level0type = N'SCHEMA', @level0name = 'ksiegowosc',
@level1type = N'TABLE', @level1name = 'premia';
GO

CREATE TABLE ksiegowosc.wynagrodzenie (
id_wynagrodzenia int identity(1,1) primary key,
data date not null,
id_pracownika int not null,
id_godziny int,
id_pensji int,
id_premii int,
foreign key (id_pracownika) references ksiegowosc.pracownicy(id_pracownika),
foreign key (id_godziny) references ksiegowosc.godziny(id_godziny),
foreign key (id_pensji) references ksiegowosc.pensja(id_pensji),
foreign key (id_premii) references ksiegowosc.premia(id_premii)
);
go
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'Tabela przechowuje informacje o wyp³atavh dla pracowników.',
@level0type = N'SCHEMA', @level0name = 'ksiegowosc',
@level1type = N'TABLE', @level1name = 'wynagrodzenie';
GO

INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
(N'Anna', N'Kowalska', N'Warszawa, ul. Lipowa 10', N'501123456'),
(N'Jan', N'Nowak', N'Kraków, ul. Polna 3', N'502234567'),
(N'Marta', N'Wiœniewska', N'Gdañsk, ul. D³uga 5', N'503345678'),
(N'Piotr', N'Kaczmarek', N'Poznañ, ul. Leœna 12', N'504456789'),
(N'Katarzyna', N'Lewandowska', N'£ódŸ, ul. Ogrodowa 8', N'505567890'),
(N'Adam', N'Wójcik', N'Lublin, ul. Spacerowa 6', N'506678901'),
(N'Joanna', N'Szymañska', N'Rzeszów, ul. Zamkowa 4', N'507789012'),
(N'Pawe³', N'D¹browski', N'Szczecin, ul. Krótka 9', N'508890123'),
(N'Barbara', N'Król', N'Katowice, ul. Mickiewicza 2', N'509901234'),
(N'Andrzej', N'Majewski', N'Toruñ, ul. S³oneczna 15', N'510012345');

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
(N'Ksiêgowy', 5200.00),
(N'Specjalista ds. kadr', 4800.00),
(N'Asystent biura', 4000.00),
(N'Analityk finansowy', 7000.00),
(N'Menad¿er', 8500.00),
(N'Programista', 9000.00),
(N'Sprzedawca', 4500.00),
(N'Magazynier', 3800.00),
(N'Sekretarka', 4200.00),
(N'Dyrektor', 12000.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
(N'Brak', 0.00),
(N'Uznaniowa', 500.00),
(N'Roczna', 1500.00),
(N'Projektowa', 2000.00),
(N'Frekwencyjna', 300.00),
(N'Motywacyjna', 800.00),
(N'Œwi¹teczna', 1000.00),
(N'Za sta¿', 600.00),
(N'Za wyniki', 1200.00),
(N'Specjalna', 2500.00);

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2025-10-01', 8.00, 1),
('2025-10-02', 7.50, 2),
('2025-10-03', 8.00, 3),
('2025-10-04', 6.00, 4),
('2025-10-05', 8.00, 5),
('2025-10-06', 7.00, 6),
('2025-10-07', 8.00, 7),
('2025-10-08', 8.00, 8),
('2025-10-09', 8.00, 9),
('2025-10-10', 8.00, 10);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2025-10-10', 1, 1, 1, 2),
('2025-10-10', 2, 2, 2, 3),
('2025-10-10', 3, 3, 3, 1),
('2025-10-10', 4, 4, 4, 4),
('2025-10-10', 5, 5, 5, 2),
('2025-10-10', 6, 6, 6, 6),
('2025-10-10', 7, 7, 7, 5),
('2025-10-10', 8, 8, 8, 8),
('2025-10-10', 9, 9, 9, 9),
('2025-10-10', 10, 10, 10, 10);

use firma;
go
--a)
select id_pracownika, nazwisko
from ksiegowosc.pracownicy;
--b
select distinct p.id_pracownika
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
where pe.kwota > 1000;
--c
select distinct p.id_pracownika
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
where (pr.id_premii is null or pr.kwota = 0)
  and pe.kwota > 2000;
--d
select imie, nazwisko
from ksiegowosc.pracownicy
where imie like N'j%';
--e
select imie, nazwisko
from ksiegowosc.pracownicy
where nazwisko like N'%n%' and imie like N'%a';
--f
select 
    p.imie, 
    p.nazwisko, 
    sum(g.liczba_godzin) - 160 as nadgodziny
from ksiegowosc.pracownicy p
join ksiegowosc.godziny g on p.id_pracownika = g.id_pracownika
group by p.imie, p.nazwisko;
--g
select distinct p.imie, p.nazwisko
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
where pe.kwota between 1500 and 4100;
--h
select distinct p.imie, p.nazwisko
from ksiegowosc.pracownicy p
join ksiegowosc.godziny g on p.id_pracownika = g.id_pracownika
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
group by p.imie, p.nazwisko, pr.kwota
having sum(g.liczba_godzin) > 160 and (pr.kwota is null or pr.kwota = 0);
--i
select distinct p.imie, p.nazwisko, pe.kwota as pensja
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
order by pe.kwota asc;
--j
select distinct p.imie, p.nazwisko, pe.kwota as pensja, pr.kwota as premia
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
order by pe.kwota desc, pr.kwota desc;
--k
select pe.stanowisko, count(p.id_pracownika) as liczba_pracownikow
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
group by pe.stanowisko;
--l
select 
    stanowisko,
    avg(kwota) as srednia_pensja,
    min(kwota) as min_pensja,
    max(kwota) as max_pensja
from ksiegowosc.pensja
where stanowisko = N'menad¿er'
group by stanowisko;
--m
select sum(pe.kwota + isnull(pr.kwota, 0)) as suma_wynagrodzen
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii;
--n
select pe.stanowisko, sum(pe.kwota + isnull(pr.kwota, 0)) as suma_wynagrodzen
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
group by pe.stanowisko;
--o
select pe.stanowisko, count(pr.id_premii) as liczba_premii
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
group by pe.stanowisko;
--p
delete p
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
where pe.kwota < 1200;
