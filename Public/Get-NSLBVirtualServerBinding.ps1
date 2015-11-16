<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Get-NSLBVirtualServerBinding {
    <#
    .SYNOPSIS
        Gets the specified load balancer virtual server binding object.

    .DESCRIPTION
        Gets the specified load balancer virtual server binding object.

    .EXAMPLE
        Get-NSLBVirtualServer

        Get all load balancer virtual server objects.

    .EXAMPLE
        Get-NSLBVirtualServer -Name 'vserver01'
    
        Get the load balancer virtual server named 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual server to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server binding name')
    )

    begin {
        _AssertSessionActive
        $bindings = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $bindings = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item)
                $bindings
            }
        } else {
            $vServers = Get-NSLBVirtualServer
            foreach ($item in $vServers) {
                $bindings = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item.name)
                $bindings
            }
        }
    }
}