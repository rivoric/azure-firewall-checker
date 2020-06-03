# Tests

Pester test for the PowerShell script.
Can be started by using the cmdlet Invoke-Tests.ps1

## Unit tests

The 

## Generalised quality tests

Generalised tests that enforce a minimum level of quality around code.
They do not test funtionality but rather all files have a minimum amount of documentation or the code follows best practice.
One of these tests uses [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) to ensure all PowerShell scripts in the PSScripts directory follow best practices.
You will need to install this module if it is not on your system in order for the test to run.