@echo off
title MySQL Server Service Script

set serviceName=MySQL80



:: Check admin privileges
:checkAdminRights
	net session > nul 2>nul
	if not %errorlevel%==0 (
		color 06
		echo Admin privileges are needed to toggle the service's state!
		echo Restart the script with admin privileges for starting or stopping the service.
		echo With no admin privileges the service's actual state will be displayed.
		sc queryex %serviceName%
		echo.
		goto end
	) else (goto disableAutoStartup)



:: Disable automatic startup (this can be disabled once the service is set as manual/on demand)
:disableAutoStartup
	echo Disabling service's automatic startup...
	sc config %serviceName% start=demand > nul

	if %errorlevel%==0 (goto toggleService) else (goto error)



:: Try to start MySQL Server's service
:toggleService
	echo Checking service...
	sc start %serviceName% > nul 2>nul

	if %errorlevel%==0 (
		color 0a
		echo The service is starting...
		goto end
	)
	if %errorlevel%==1056 (goto serviceAlreadyRunning) else (goto error)



:: If the service is running ask if it should be stopped
:serviceAlreadyRunning
	echo The service is already running.
	set /p option=Should it be stopped? [Y]/[N]: 
	
	if %option%==y (set option=Y)
	if %option%==Y (goto stopService) else (goto end)



:: Stop the service
:stopService
	sc stop %serviceName% > nul 2>nul
	if %errorlevel%==0 (
		color 0b
		echo The service is stopping...
		goto end
	) else (goto error)



:: Script end
:end
	echo Click on the [X] or press (almost) any key to close this window...
	pause > nul
	exit



:: Unexpected error
:error
	color 0c
	echo An unexpected error has ocurred!
	echo The script will be closed.
	goto end