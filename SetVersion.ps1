# SetVersion.ps1
#
# Set the version in all the AssemblyInfo.cs or AssemblyInfo.vb files in any subdirectory.
#
# Usage:  
#	. ./SetVersion.ps1
#	SetVersion $version $folder
#	SetVersion $version

function global:SetVersion($directory, $version)
{
	# validate arguments 
	$r = [System.Text.RegularExpressions.Regex]::Match($version, "^[0-9]+(\.[0-9]+){1,3}$")

	if ($r.Success)
	{
		if(Test-Path $directory)
		{
			_SearchAndUpdateInfoFiles $directory $version
		}
	}
	else
	{
		throw "Invalid version format";
	}
}

function _SearchAndUpdateInfoFiles($directory, $version)
{
	foreach ($file in "AssemblyInfo.cs", "AssemblyInfo.vb" ) 
	{
		get-childitem -path $directory -recurse |? {$_.Name -eq $file} | _UpdateFileVersion $file $version 
	}
}

function _UpdateFileVersion($input, $version)
{
  $NewVersion = 'AssemblyVersion("' + $version + '")'
  $NewFileVersion = 'AssemblyFileVersion("' + $version + '")'

  foreach ($o in $input) 
  {
    Write-output $o.FullName
    $TmpFile = $o.FullName + ".tmp"

     get-content $o.FullName | 
        %{$_ -replace 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $NewVersion } |
        %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $NewFileVersion }  > $TmpFile

     move-item $TmpFile $o.FullName -force
  }
}
