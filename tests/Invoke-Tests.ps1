<#
.SYNOPSIS
Test Runner to run all tests in the folder

.DESCRIPTION
Test Runner to run all tests in the folder

.EXAMPLE 
Invoke-Tests.ps1
#>
[CmdletBinding()]
param ()

$pathToTests = $PSScriptRoot
$pathToScripts = (Get-Item $PSScriptRoot).Parent
$testResult = "$PSScriptRoot\TestResult.xml"
$codeCoverageResult = "$PSScriptRoot\CODECOVERAGE.xml"

$TestParameters = @{
    OutputFormat = 'NUnitXml'
    OutputFile   = $testResult
    Script       = $pathToTests
    PassThru     = $True
    CodeCoverage = $pathToScripts
    CodeCoverageOutputFile = $codeCoverageResult
}

# Invoke tests
$Result = Invoke-Pester @TestParameters

# report failures
if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}
