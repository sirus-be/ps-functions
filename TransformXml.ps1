# TransformXml.ps1
#
# Transform any XML file using XDT. This script will download it's dependencies automatically.
#
# Usage:  
#	. .\TransformXml.ps1
#	TransformXml $sourceFile $transformFile $destFile
#
$currentPath = split-path -parent $MyInvocation.MyCommand.Definition
. "$currentPath/GetNuget.ps1"

function TransformXml($sourceFile, $transformFile, $destFile, $toolsDir = ("$env:LOCALAPPDATA\ps-scripts\tools\")){
    $nugetDownloadUrl = 'http://nuget.org/nuget.exe'

    # slowcheetah.xdt.exe <source file> <transform> <dest file>
    $cmdArgs = @((Resolve-Path $sourceFile).ToString(),
                    (Resolve-Path $transformFile).ToString(),
                    $destFile)

	# get exe and execute transformation
    &(_GetTransformXmlExe $toolsDir) $cmdArgs
}

function _GetTransformXmlExe($toolsDir){
	$nuget = GetNuget $toolsDir

    $xdtExe = (Get-ChildItem -Path $toolsDir -Include 'SlowCheetah.Xdt.exe' -Recurse) | Select-Object -First 1

    if(!$xdtExe){
        'Downloading xdt since it was not found in the tools folder' | Write-Verbose
        
		# nuget install SlowCheetah.Xdt -Prerelease -OutputDirectory toolsDir\
        $cmdArgs = @('install','SlowCheetah.Xdt','-Prerelease','-OutputDirectory',(Resolve-Path $toolsDir).ToString())

		# install with nuget
        &($nuget) $cmdArgs | Out-Null

        $xdtExe = (Get-ChildItem -Path $toolsDir -Include 'SlowCheetah.Xdt.exe' -Recurse) | Select-Object -First 1
        # copy the xdt assemlby if the xdt directory is missing it
        $xdtDllExpectedPath = (Join-Path $xdtExe.Directory.FullName 'Microsoft.Web.XmlTransform.dll')
            
        if(!(Test-Path $xdtDllExpectedPath)){
            # copy the xdt.dll next to the slowcheetah .exe
            $xdtDll = (Get-ChildItem -Path $toolsDir -Include 'Microsoft.Web.XmlTransform.dll' -Recurse) | Select-Object -First 1

            if(!$xdtDll){ throw 'Microsoft.Web.XmlTransform.dll not found' }

            Copy-Item -Path $xdtDll.Fullname -Destination $xdtDllExpectedPath | Out-Null
        }
    }

    if(!$xdtExe){
        throw ('SlowCheetah.Xdt not found. Expected location: [{0}]' -f $xdtExe)
    }

    $xdtExe    
}