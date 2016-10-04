. ../TransformXml.ps1

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$testDir = Join-Path -Path $scriptPath -ChildPath "temp"

$sourceFile = Join-Path -Path $scriptPath -ChildPath "Web.config";
$transformationFile = Join-Path -Path $scriptPath -ChildPath "Web.Debug.Config"
$transformationFile2 = Join-Path -Path $scriptPath -ChildPath "Web.Release.Config"

$targetFile = Join-Path -Path $testDir -ChildPath "Debug.Config"
$targetFile2 = Join-Path -Path $testDir -ChildPath "Release.Config"

TransformXml $sourceFile $transformationFile $targetFile

TransformXml $sourceFile $transformationFile2 $targetFile2
