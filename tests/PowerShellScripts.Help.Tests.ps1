Describe "PowerShell script help quality tests" -Tag "Quality" {

    $Scripts = @()
    $Scripts += (Get-ChildItem -Path $PSScriptRoot\..\*.ps1)

    foreach ($Script in $Scripts) {

        $Help = Get-Help $Script.FullName

        Context $Script.BaseName {

            It "Has a synopsis" {
                $Help.Synopsis | Should Not BeNullOrEmpty
            }

            It "Has a description" {
                $Help.Description | Should Not BeNullOrEmpty
            }

            It "Has an example" {
                $Help.Examples | Should Not BeNullOrEmpty
            }
            
            foreach ($Parameter in $Help.Parameters.Parameter) {
                if ($Parameter -notmatch 'whatif|confirm') {
                    It "Has a Parameter description for $($Parameter.Name)" {
                        $Parameter.Description.Text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}