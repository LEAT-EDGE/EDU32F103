@ECHO OFF
powershell.exe -Command "Start-Process powershell.exe -ArgumentList ('-NoExit','-ExecutionPolicy','Bypass','-Command',('cd \\\"{0}\\\"; & .\_Uninstall.ps1' -f (Get-Location).path)) -Verb RunAs"
