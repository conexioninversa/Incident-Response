@echo on
cd C:\ProgramData\sysmon\
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/psanchezcordero/Incident-Response/master/SYSMON-Lateral-PowerShell.xml','C:\ProgramData\sysmon\SYSMON-Lateral-PowerShell.xml')"
sysmon64 -c sysmonconfig-export.xml
exit