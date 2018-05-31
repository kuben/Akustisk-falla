# Akustisk-falla

Vi har följande filer

levitation.m                 -   Mainfilen för tillfället
Transducer.m                 -   Definerar klassen Transducer. Innehåller den mesta koden.
Exempel.m                    -   Se här för exempel på hur man använder Transducer
gorkov.m                     -   Beräknar Gorkovpotentialen
latex_fonts.m                -   Kör en gång för att få snygga LaTeX fonts i figurer
generera_p.m                 -   Den här behövs egentligen inte längre, vi har tagit fram analytiska uttryck för trycken
BFGS_N.m                     -   Optimerar faserna för potentialgroparna i en Nx3 matris av positioner. Övriga BFGS är nu mer överflödiga.
produktenSimulations.m       -   Fil för beräkning av optimala faser för olika rörelsemönster.
produktenInspection.m        -   Fil för för att undersöka de beräknade faserna.
produktenVisualisation.m     -   Fil för beräkning av olika sorters visualisering av faser av fält.
laplFunPhase.m               -   Beräknar värdet av laplacianen av Gorkov potentialen map en position och faser.


Vi har följande underdirectories

Konstanter                   -   Här sparas och avläses konstanter från fasoptimering.
MCU                          -   Kod till styrning av MCU.
