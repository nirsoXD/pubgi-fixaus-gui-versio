# pubgi-fixaus-gui-versio
GUI versio pubgin fixaus himmelistä

If you want the kill pubg part of the script to work you need to create a shortcut to the script to run it as admin.

Steps to do it here:

1. Right-click on an empty area on your desktop or in a file explorer window.
2. Select "New" and then "Shortcut".
3. In the "Create Shortcut" window, enter the following command in the "Type the location of the item" field:

    powershell.exe -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\Path\To\YourScript.ps1""' -Verb RunAs"

    Replace "C:\Path\To\pubgi-fix-gui.ps1" with the actual path to your PowerShell script.
    Click "Next".
    Provide a name for the shortcut and click "Finish".

Now, whenever you double-click the shortcut, it will run the PowerShell script with elevated permissions.

If you just want the gameusersettings reset and movie delete right-click the script and click "run with powershell"