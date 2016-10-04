. ../GetNuget.ps1
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$testDir = Join-Path -Path $scriptPath -ChildPath "temp"
$nugetUrl = "http://nuget.org/nuget.exe"

# Test without arguments
$nugetExe = GetNuget

# Test with argument
$nugetExe = GetNuget $testDir $nugetUrl

PAUSE