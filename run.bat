@echo off
cls
:start
echo [STARTED]
ruby main.rb
echo [STOPPED]
pause>nul
goto start