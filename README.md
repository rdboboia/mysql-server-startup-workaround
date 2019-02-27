# MySQL Server startup bug workaround (+ script for manual start/stop)

Introduction: I just found out (probably I'm not the first) that MySQL server doesn't start properly when using a Windows user with no administrator rights. I'm very inclined to think that there is some kind of permission problem since this didn't happen to me on an PC with an admin account (the environment was quite different too, so who knows). But seeing that delaying the start seems to fix it, I'm kinda confused right now; maybe it doesn't even have to do anything with permissions. Rambling apart, here goes some information that you may find useful about this problem.

Environment variables that I think might be useful to take into account:
  - Logging in with a Windows user without admin privileges.
  - Having the MySQL server service (MySQL80 by default) configured as automatic at startup.
  - Connecting to the MySQL server from MySQL Workbench.
  - Using Windows 10.

Observed behaviour:
  - The service seems to start properly (checking in Service app it appears as started) but when trying to connect to the server from MySQL Workbench it seems to enter in a loop and freezes (also uses a lot of CPU).

Possible fixes:
  - Letting Windows still manage this service.
    - Change the MySQL service startup setting from "automatic" to "automatic (delayed)".
      - While not perfect, this seems like a good fix. The only problem that I have with this is that Windows delays its start around 2 minutes after you're already logged in, so you can't access it right away. If this is not a problem for you, then I think it's a clean and easy fix.
  - Managing the service manually from the Services app.
    - Change the MySQL service startup setting to "manual/on demand".
      - If you don't mind to open the Services app each time you have to start the server, then this could work for you. I personally find it some kind of a hassle, specially when you have to start it with admin privileges and put your admin account password in since you can't toggle any service without admin rights.
  - Managing the service manually with a batch script.
    - Since I'm kinda lazy, I don't really feel like going into the Services app each time I have to start/stop MySQL Server's service, so I came up with a script to do it for me. If you're not logged in an admin account you still have to start the script with admin privileges (and use that annoying password), but at least you can save some time by not starting the Services app and searching for the desired service.

Now, here's what my script does:
  - First it configures the service name which will be started or stopped (you can change this if you want to use this script for other service).
  - Then it checks for admin privileges.
    - If doesn't have admin rights, it will just display the service's status.
  - Assuming it has admin rights, it will disable the service's "automatic startup" (no reason to start a service that won't work properly). Note that this could be done manually and only once, but since it doesn't really affect the execution time and I wanted to make it as easy as possible for the people this is the way this version will be. Maybe later this week I'll put this in a separate script so that it doesn't perform the same thing again and again if not needed.
  - It will try to start the service.
    - If the service is already running it will ask the user if he wants to stop it.
      - If the user agrees, it will stop the service.
    - If the service was not running, it will start it.

BTW: I tryied to make the script as easy to understand as possible, so feel free to check it out and edit it if needed.
