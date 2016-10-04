. ../SetVersion.ps1

# Copy an AssemblyInfo file to the test dir
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$testDir = Join-Path -Path $scriptPath -ChildPath "temp"
$assemblyInfoFile = Join-Path -Path $scriptPath -ChildPath "AssemblyInfo.cs";
$assemblyInfoFileTarget = Join-Path -Path $testDir -ChildPath "AssemblyInfo.cs"
if(!(Test-Path $testDir))
{
	New-Item $testDir -ItemType Directory | Out-Null
}
Copy-Item $assemblyInfoFile $assemblyInfoFileTarget -Force | Out-Null

# Set version
SetVersion $testDir "2.3.4.0"
Write-Host "[v] Can set version"

# Bad version throws error
try
{
	SetVersion $testDir "bad;version"
}
catch{
	Write-Host "[v] Bad version throws error"
}

PAUSE