<#
.SYNOPSIS
Gets Firewall IP addresses from Azure resources

.DESCRIPTION
Gets Firewall IP addresses from Azure resources

.PARAMETER Prefix
Optionally specify a prefix to apply

.PARAMETER ResourceTypes
Optionally specify the type of resource to list.
Options are CosmosDB & SqlServer
Will list all if not specified

.EXAMPLE
Get-FirewallIpAddresses
#>

[CmdletBinding()]
param (
    [String] $Prefix,
    [ValidateSet("CosmosDB","SqlServer","All")]
    [String[]] $ResourceTypes = "All"
)

$nameWildcard = $null
if ($Prefix) {
    $nameWildcard = "$Prefix*"
    Write-Verbose "Using wildcard $nameWildcard"
}

if ("All" -in $ResourceTypes) {
    $ResourceTypes = @("CosmosDB","SqlServer")
}

$azureTypes = @{
    SqlServer = "Microsoft.Sql/servers"
    CosmosDB  = "Microsoft.DocumentDB/databaseAccounts"
}

foreach ($type in $ResourceTypes) {
    if ($nameWildcard) {
        $resources = Get-AzResource -Name $nameWildcard -ResourceType $azureTypes[$type]
    }
    else {
        $resources = Get-AzResource -ResourceType $azureTypes[$type]
    }

    foreach ($resource in $resources) {
        Write-Output "Checking $($resource.ResourceGroupName)/$($resource.Name) ($($resource.ResourceType))"

        switch ($type) {
            "SqlServer" {
                $firewallRules = Get-AzSqlServerFirewallRule -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name
                foreach ($rule in $firewallRules) {
                    if ($rule.StartIpAddress -eq $rule.EndIpAddress) {
                        Write-Output "$($rule.FirewallRuleName): $($rule.StartIpAddress)"
                    }
                    else {
                        Write-Output "$($rule.FirewallRuleName): $($rule.StartIpAddress) - $($rule.EndIpAddress)"
                    }
                }
            }
        }
    }
}