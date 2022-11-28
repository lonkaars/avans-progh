# programmeerbare hardware huiswerk

hier staan de opdrachten voor programmeerbare hardware.

## aantekeningen per weekopdracht

### 4-bits adder (week 1)

- er wordt een testbench voor **elk** component verwacht, dus ook de 1-bit full
  adder

### adder en display (week 2)

- er moet ook een input zijn voor de carry in input van de adder

### alu (week 3)

- de output van de alu is 'eigenlijk' 9-bits. in de handleiding wordt dit
  verwarrend beschreven. dit houdt niet in dat het resultaat 8-bits is en dat
  de sign bit gewoon de meest significante bit is, maar dit betekent dat de
  sign bit eigenlijk de 9e bit is van een 9-bits signed getal (geldt alleen
  voor de operators waar de carry out bit niet beschreven is in de
  handleiding).
- test of (-128) + (-128) weergeeft als -256, niet -0 (op echte hardware, niet
  testbench)

