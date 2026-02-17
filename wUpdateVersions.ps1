# wUpdateVersion v0.1
# Copyright (c) 2026 Vladislav Salikov aka W0LF aka 'dreamforce'

[CmdletBinding()]
param (
	[Parameter (Position = 1)]
	[string]$VersionFile = $(throw "ERROR!!! Required parameter 'VersionFile' is missing!"),

	[Parameter (Position = 2)]
	[string]$ResourceFile = $(throw "ERROR!!! Required parameter 'ResourceFile' is missing!")
)

$date = Get-Date
$buildDateTime = "Build date: $($date.GetDateTimeFormats('u').Replace('Z', ''))"
$logString = "Starting wUpdateVersion script..." > .\wUpdateVersion.log
$logString = $buildDateTime >> .\wUpdateVersion.log
$newVersionStr = "0"
$newVersionNum = "0"
$content = ""

if ( Test-Path -Path $VersionFile ) {
	$content = Select-String -Path $VersionFile -Pattern 'APP_VERSION' -SimpleMatch | Select-Object -ExpandProperty Line
	$newVersionStr = $content.Split()[-1].Trim('"')
	$newVersionNum = $newVersionStr.Replace('.', ',')
}
else {
	$logString = "Can't open file '$($VersionFile)'" >> .\wUpdateVersion.log
	Write-Host "Can't open file '$($VersionFile)'"
	exit 1
}

if ( Test-Path -Path $ResourceFile ) {
	$ResourceFileBak = $ResourceFile + '.bak'
	if (Test-Path -Path $ResourceFileBak) {
		Remove-Item -Path $ResourceFileBak
	}
	Rename-Item -Path $ResourceFile -NewName $ResourceFileBak
	Get-Content -Path $ResourceFileBak -Encoding UTF8 `
	| % { $_ -replace '"(FileVersion|ProductVersion)",\s*"?[\d\.]+"?', "`"`$1`", `"$newVersionStr`"" -replace '(FileVersion|ProductVersion)\s*[\d\,]+', "`$1 $newVersionNum" } <# MAGIC !!! #> `
	| Set-Content $ResourceFile -Encoding UTF8
}
else {
	$logString = "Can't open file '$($ResourceFile)'" >> .\wUpdateVersion.log
	Write-Host "Can't open file '$($ResourceFile)'"
	exit 2
}

$logString = "End of wUpdateVersion script." >> .\wUpdateVersion.log
exit 0
