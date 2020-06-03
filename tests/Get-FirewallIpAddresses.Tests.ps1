Push-Location -Path $PSScriptRoot\..\

# Uncomment if Az module not installed
# function Get-AzResource ($Name, $ResourceType) {}

Describe "Get-FirewallIpAddresses parameter tests" -Tag "Unit" {

    Mock Get-AzResource { return $null }

    It "Should check all types if no ResourceTypes specified" {
        .\Get-FirewallIpAddresses
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.Sql/servers" }
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.DocumentDB/databaseAccounts" }
    }

    It "Should check for Microsoft.Sql/servers only if ResourceTypes SqlServer specified" {
        .\Get-FirewallIpAddresses -ResourceTypes SqlServer
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.Sql/servers" }
        Assert-MockCalled Get-AzResource -Scope It -Exactly 0 -parameterFilter { $ResourceType -eq "Microsoft.DocumentDB/databaseAccounts" }
    }

    It "Should check for Microsoft.DocumentDB/databaseAccounts only if ResourceTypes CosmosDB specified" {
        .\Get-FirewallIpAddresses -ResourceTypes CosmosDB
        Assert-MockCalled Get-AzResource -Scope It -Exactly 0 -parameterFilter { $ResourceType -eq "Microsoft.Sql/servers" }
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.DocumentDB/databaseAccounts" }
    }

    It "Should check both SQL and Cosmos types if both ResourceTypes specified" {
        .\Get-FirewallIpAddresses -ResourceTypes SqlServer,CosmosDB
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.Sql/servers" }
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $ResourceType -eq "Microsoft.DocumentDB/databaseAccounts" }
    }

    It "Should throw an exception if an invalid type passed" {
        { .\Get-FirewallIpAddresses -ResourceTypes Website } | Should -Throw
    }

    It "Should wilcard the prefix" {
        .\Get-FirewallIpAddresses -Prefix foo -ResourceTypes SqlServer
        Assert-MockCalled Get-AzResource -Scope It -Exactly 1 -parameterFilter { $Name -eq "foo*" -and $ResourceType -eq "Microsoft.Sql/servers" }
    }

}

Push-Location -Path $PSScriptRoot