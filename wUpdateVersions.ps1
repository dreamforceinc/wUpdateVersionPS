# wUpdateVersion v0.1

# MIT License
# Copyright (c) 2026 Vladislav Salikov
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
