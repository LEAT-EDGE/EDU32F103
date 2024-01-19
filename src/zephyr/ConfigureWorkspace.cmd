@ECHO OFF
powershell.exe -Command "Start-Process powershell.exe -ArgumentList ('-NoExit','-ExecutionPolicy','Bypass','-Command',('cd \\\"{0}\\\"; & .\_ConfigureWorkspace.ps1' -f (Get-Location).path))"
