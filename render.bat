@echo off
set QUARTO_R=C:\Program Files\R\R-4.5.2\bin\x64
set R_PROFILE_USER=
set R_ENVIRON_USER=
set R_PROFILE=
set R_ENVIRON=
quarto render project-proposal.qmd --to html --execute
pause
