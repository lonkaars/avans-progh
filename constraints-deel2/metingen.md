## 6

|Resource|Utilization|
|-|-|
|LUT|32 (0.15%)|
|FF|113 (0.27%)|
|IO|50 (47.17%)|

| |Setup|Hold|
|-|-|-|
|Aantal violating paths|6|0|
|WNS|-1.942 ns|0.011 ns|
|TNS|-7.696 ns|0.000 ns|

## 7

de critical path is de carry tussen de full adders

## 8

- 32 inputs missen een input delay specificatie
- 17 outputs missen een output delay specificatie

## 9

Aan de globale inputs/outputs kan ik geen berekende constraints toevoegen. Ik
kan aannemen dat het wenselijk is voor een adder om een berekening binnen een
klokcyclus uit te voeren. Met deze aanname zou ik de maximale delay die het
carry signaal kan hebben kunnen uitrekenen. De verdeling tussen setup/hold tijd
en propagation delay is alleen weer iets dat ik niet kan uitrekenen.

Om verder te gaan met deze opdracht zal ik dezelfde waardes gebruiken als in de
lab 1 tutorial van Xilinx (groene regels in tabel 2 en 3), omdat deze inputs en
outputs ook op een systeemklok van 100 MHz werden gebruikt.

Na het uitvoeren van `check_timing` zijn er geen missende specificaties meer

## 10

|Resource|Utilization|
|-|-|
|LUT|32 (0.15%)|
|FF|113 (0.27%)|
|IO|50 (47.17%)|

| |Setup|Hold|
|-|-|-|
|Aantal violating paths|28|32|
|WNS|-5.564 ns|-1.006 ns|
|TNS|-105.730 ns|-31.562 ns|

Het aantal violating setup paden is nu toegenomen omdat Vivado nu ook de paden
die eerst geen specificatie hadden meeneemt in de design timing summary.

Het `fulladder2bit` component heeft de belangrijkste bijdrage omdat deze in een
ketting gesynthetiseerd wordt.

## 12

Door het aanpassen van de constraints binnen Vivado verlies je alleen de
mogelijkheid om een timing fout op te sporen voor het testen op echte hardware.
Dit is dus een hardwarelimitatie.

## 13

|Resource|Utilization|
|-|-|
|LUT|32 (0.15%)|
|FF|113 (0.27%)|
|IO|50 (47.17%)|

| |Setup|Hold|
|-|-|-|
|Aantal violating paths|28|0|
|WNS|-6.960 ns|0.014 ns|
|TNS|-150.921 ns|0.000 ns|

De hold tijd is een stuk omlaag gegaan, waardoor de failing paths voor de hold
constraint 0 is geworden.

## 14

|Resource|Utilization|
|-|-|
|LUT|22 (0.11%)|
|FF|113 (0.27%)|
|IO|50 (47.17%)|

| |Setup|Hold|
|-|-|-|
|Aantal violating paths|27|0|
|WNS|-6.960 ns|0.017 ns|
|TNS|-143.813 ns|0.000 ns|

Het aantal failing paths voor de setup constraint is met maarliefst 1 omlaag
gegaan! Er worden ook 10 minder LUTs gebruikt nu. Ook ziet de schematic er nu
ontzettend rommelig uit na implementation.

