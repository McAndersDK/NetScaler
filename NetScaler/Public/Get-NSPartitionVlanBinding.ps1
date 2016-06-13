function Get-NSPartitionVlanBinding {
     <#
    .SYNOPSIS
        Get Vlan bindings for a partition.
  
    .DESCRIPTION
        Get Vlan bindings for a partition.
  
    .EXAMPLE
        Get-NSPartitionVlanBinding -PartitionName 'partition01'
    
        Get Vlan bindings for partition 'partition01'.
    
    .EXAMPLE
        Get-NSPartitionVlanBinding -PartitionName 'partition01','partition02'
    
        Get Vlan bindings for partition 'partition01' and 'partition02'.

    .PARAMETER Session
        The NetScaler session object.
      
    .PARAMETER PartitionName 
        The name or names of the partition to get. 

    #>
    [CmdletBinding()]
    param (
        $Session = $script:session,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,Position = 0)]
        [string[]]$PartitionName,
        [int]$vlanid
    )
    begin {
        _AssertSessionActive
        $response = @()
    }
    process { 
        $params = @{
            Method = 'GET'
            Session = $Session
            Type = 'nspartition_vlan_binding'
        }
        if($vlanid) {
            $params.Add('filter', @{
                'vlanid' = $vlanid 
            })
        }
        if ($PartitionName.Count -gt 0) { 
            foreach ($item in $PartitionName) {
                if($params.ContainsKey('arguments')) {
                    $params.arguments = @{
                        partitionname=$item
                    }
                }
                else {
                    $params.add('arguments', @{
                        partitionname=$item
                    })
                }
                $response = _InvokeNSRestApi @params
                if ($response.errorcode -ne 0) { throw $response } 
                if ($Response.psobject.properties.name -contains 'nspartition_vlan_binding') { 
                    $response.nspartition_vlan_binding 
                }
            }
        }
        else {
            $params.add('arguments', @{
                    partitionname=$PartitionName
                })
            $response = _InvokeNSRestApi @params
            if ($response.errorcode -ne 0) { throw $response } 
            if ($Response.psobject.properties.name -contains 'nspartition') { 
                $response.nspartition 
            } 
        }
    }
}