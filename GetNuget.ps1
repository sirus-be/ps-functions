# GetNuget.ps1
#
# If nuget is not in the tools folder then it will be downloaded there.
#
# Usage:
#      . .\GetNuget.ps1
#	   GetNuget
#	   GetNuget $targetDir
#	   GetNuget $targetDir $downloadUrl
#

function GetNuget(
	$toolsDir = ("$env:LOCALAPPDATA\ps-scripts\tools\"), 

	$nugetDownloadUrl = "http://nuget.org/nuget.exe"
)
{
	# path to nuget executable
	$nugetDestPath = Join-Path -Path $toolsDir -ChildPath nuget.exe
  
	if(!(Test-Path $toolsDir))
	{ 
		New-Item -Path $toolsDir -ItemType Directory | Out-Null
	}
		      
	if(!(Test-Path $nugetDestPath))
	{
		Write-Host "Downloading nuget.exe to $nugetDestPath"
		# download nuget
		$webclient = New-Object System.Net.WebClient
		$webclient.DownloadFile($nugetDownloadUrl, $nugetDestPath) | Out-Null

		# double check that is was written to disk
		if(!(Test-Path $nugetDestPath))
		{
			throw 'unable to download nuget'
		}
	}
	else
	{
		Write-Host "Nuget already installed at $nugetDestPath"
	}

	$nugetDestPath;
}

