Describe "Code quality tests" -Tag "Quality" {

    $Scripts = @()
    $Scripts += (Get-ChildItem -Path $PSScriptRoot\..\*.ps1)
    $Rules = Get-ScriptAnalyzerRule

    foreach ($Script in $Scripts) {
        Context $Script.BaseName {
            forEach ($Rule in $Rules) {
                It "Should pass Script Analyzer rule $Rule" {
                    $Result = Invoke-ScriptAnalyzer -Path $Script.FullName -IncludeRule $Rule
                    $Result.Count | Should Be 0
                }
            }
        }
    }
}
