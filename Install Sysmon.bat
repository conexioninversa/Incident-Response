@echo off
setlocal
set hour=%time:~0,2%
set minute=%time:~3,2%
set /A minute+=2
if %minute% GTR 59 (
 set /A minute-=60
 set /A hour+=1
)
if %hour%==24 set hour=00
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
if "%hour:~1,1%"=="" set hour=0%hour%
if "%minute:~1,1%"=="" set minute=0%minute%
set tasktime=%hour%:%minute%
mkdir C:\ProgramData\sysmon
pushd "C:\ProgramData\sysmon\"
echo [+] Descargando Sysmon...
@powershell (new-object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon64.exe','C:\ProgramData\sysmon\sysmon64.exe')"
echo [+] Descargando la configuración de Sysmon...
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/psanchezcordero/Incident-Response/master/SYSMON-Lateral-PowerShell.xml','C:\ProgramData\sysmon\SYSMON-Lateral-PowerShell.xml')"
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/psanchezcordero/Incident-Response/master/Auto_Update.bat','C:\ProgramData\sysmon\Auto_Update.bat')"
sysmon64.exe -accepteula -i sysmonconfig-export.xml
sc failure Sysmon actions= restart/10000/restart/10000// reset= 120
echo [+] Sysmon Successfully Installed!
echo [+] Creando una tarea de autoactualización por hora..
SchTasks /Create /RU SYSTEM /RL HIGHEST /SC HOURLY /TN Actualiza_Reglas_Sysmon /TR C:\ProgramData\sysmon\Auto_Update.bat /F /ST %tasktime%
timeout /t 10
exit