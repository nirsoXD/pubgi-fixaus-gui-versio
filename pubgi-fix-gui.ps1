Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "PUPKI FIXINGS"
$form.Width = 400
$form.Height = 235


$button = New-Object System.Windows.Forms.Button
$button.Text = "Delete movies"
$button.Location = New-Object System.Drawing.Point(0, 0)
$button.Width = 200
$button.Height = 50
$form.Controls.Add($button)
$button.Add_Click({
	$programName = "PUBG: BATTLEGROUNDS"

	#Etsitään polku pubgi asennukseen
	$program = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
			   Where-Object { $_.DisplayName -eq $programName } |
			   Select-Object -First 1

	if ($program) {
		$installationLocation = $program.InstallLocation
		Write-Host "Program Name: $($program.DisplayName)"
		Write-Host "Installation Location: $installationLocation"
	} else {
		Write-Host "Pubgi ei asennettu koneelle"
		Pause
		Exit
		
	}

	#Lisätään polkuja tiedostoihin jotka säilytetään ja poistetaan
	$movieLocation = "\TslGame\Content\Movies"
	$atozPClocation = "\TslGame\Content\Movies\AtoZ\PC"
	$atozSTADIAlocation = "\TslGame\Content\Movies\AtoZ\STADIA"
	$atozXBOXlocation = "\TslGame\Content\Movies\AtoZ\XBOX_PS"
	$folderPath = "{0}{1}" -f $installationLocation, $movieLocation
	$keepPathPC = "{0}{1}" -f $installationLocation, $atozPClocation
	$keepPathSTADIA = "{0}{1}" -f $installationLocation, $atozSTADIAlocation
	$keepPathXBOX = "{0}{1}" -f $installationLocation, $atozXBOXlocation

	$excludedFolders = @(
		$keepPathPC,
		$keepPathSTADIA,
		$keepPathXBOX
		# Add additional excluded folder paths as needed
	)

	#Poistetaan leffat
	Get-ChildItem -Path $folderPath -File -Recurse | Where-Object { $excludedFolders -notcontains $_.Directory.FullName } | Remove-Item -Force
	Get-ChildItem -Path $folderPath -File | Where-Object { $excludedFolders -notcontains $_.Directory.FullName } | Remove-Item -Force

})


$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "Reset gameusersettings folder"
$button2.Location = New-Object System.Drawing.Point(0, 50)
$button2.Width = 200
$button2.Height = 50
$form.Controls.Add($button2)
$button2.Add_Click({
	#Gameusersettings hommat
	#Etsitään appdata polku TSLGAME kansioon
	$folderName = "TslGame"
	$appDataFolderPath = Join-Path $env:LOCALAPPDATA $folderName
	Write-Host "Path to $folderName folder in AppData: $appDataFolderPath"

	#Lisätään polkuun gameusersettings.ini tiedoston sijainti turvaan kopiointia varten
	$gameusersettingslisapolku = "\Saved\Config\WindowsNoEditor\GameUserSettings.ini"

	#Yhdistetään polut ja kopioidaan tiedosto turvaan
	$sourceFilePath = "{0}{1}" -f $appDataFolderPath, $gameusersettingslisapolku
	Copy-Item -Path $sourceFilePath -Destination $appDataFolderPath

	$appDataPoistettavat = "{0}{1}" -f $appDataFolderPath, "\Saved"

	#Deletoidaan kansion sisältö
	Get-ChildItem -Path $appDataPoistettavat -File -Recurse | Remove-Item -Force

	$poistettavatKansiot = Get-ChildItem -Path $appDataPoistettavat -Directory -Recurse | Select-Object -ExpandProperty FullName

	foreach ($kansio in $poistettavatKansiot) {
		Get-ChildItem -Path $kansio -File | Remove-Item -Force
	}

	#Kopioidaan gameusersettings.ini takaisin paikoilleen
	$gameusersettingsalkup = "{0}{1}" -f $appDataFolderPath, "\Saved\Config\WindowsNoEditor\"
	$gameusersettingsbackup = "{0}{1}" -f $appDataFolderPath, "\GameUserSettings.ini"
	Move-Item -Path $gameusersettingsbackup -Destination $gameusersettingsalkup
})


$button3 = New-Object System.Windows.Forms.Button
$button3.Text = "Check interesting 
values in gameusersettings.ini"
$button3.Width = 200
$button3.Height = 100
$button3.Location = New-Object System.Drawing.Point(0, 100)
$form.Controls.Add($button3)
$button3.Add_Click({
	$folderName = "TslGame"
	$appDataFolderPath = Join-Path $env:LOCALAPPDATA $folderName
	$gameusersettingslisapolku = "\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
	$gameusersettings = "{0}{1}" -f $appDataFolderPath, $gameusersettingslisapolku
	Write-Host "path: $gameusersettings"
	$keywords = "ScreenScale", "InGameFrameRateLimitType", "InGameCustomFrameRateLimit",`
	"MasterSoundVolume", "EffectSoundVolume", "EmoteSoundVolume", "UISoundVolume",`
	"BGMSoundVolume", "PlaygroundBGMSoundVolume",`
	"PlaygroundWebSoundVolume", "FpsCameraFov", "Gamma" 
	$excludedKeyword = "TslPersistant"

	Get-Content -Path $gameusersettings |
		Select-String -Pattern $keywords |
		Where-Object { $_ -notmatch $excludedKeyword } |
		Write-Host

})

$button4 = New-Object System.Windows.Forms.Button
$button4.Text = "Kill PUBG"
$button4.Width = 200
$button4.Height = 100
$button4.Location = New-Object System.Drawing.Point(200, 0)
$form.Controls.Add($button4)
$button4.Add_Click({
$processNames = "ExecPubg", "TslGame", "TslGame_BE", "TslGame_UC", "zkvsc",`
"BEService"

foreach ($processName in $processNames) {
    # Get the process by name
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue

    # Check if the process exists
    if ($process) {
        # Kill the process
        $process | Stop-Process -Force
        Write-Host "Killed process: $processName"
    } else {
        Write-Host "Process not found: $processName"
    }
}

})


$button5 = New-Object System.Windows.Forms.Button
$button5.Text = "START PUBG"
$button5.Width = 200
$button5.Height = 100
$button5.Location = New-Object System.Drawing.Point(200, 100)
$form.Controls.Add($button5)
$button5.Add_Click({
Start-Process "steam://rungameid/578080"

})


$form.ShowDialog()
