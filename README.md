# Powershell helper functions

## Usage

Import with dot sourcing.

	. .\SetVersion.ps1
	. .\GetNuget.ps1
	. .\TransformXml.ps1

GetNuget usage:

	GetNuget

SetVersion usage:

	SetVersion $folder "1.2.3.4"

TransformXml usage:

	TransformXml $sourceFile $transformationFile $targetFile

See Tests folder for more samples.
