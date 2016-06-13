function New-NSPartitionVlanBinding {
     <#
    .SYNOPSIS
        New Vlan partition binding.
  
    .DESCRIPTION
        New Vlan partition binding.
  
    .EXAMPLE
        New-NSPartitionVlanBinding -PartitionName 'partition01' -VlanId 10
    
        Binding vlanId 10 to partition named 'partition01'.
    
    .EXAMPLE
        Get-NSPartition -PartitionName 'partition01' | New-NSPartitionVlanBinding  -VlanId 10
    
        Binding vlanId 10 to partition named 'partition01'.

    .PARAMETER Session
        The NetScaler session object.
      
    .PARAMETER VlanId 
        The vlan id to bind. 
          
    .PARAMETER PartitionName 
        The name of the partition to bind the vlan id to. 


    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param (
        $Session = $script:session,
        [parameter(Mandatory=$true,Position = 0, ValueFromPipelineByPropertyName)] 
        [int]$VlanId,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)] 
        [string]$PartitionName
    )
    begin {
        _AssertSessionActive
    }
    process {
        if ($PSCmdlet.ShouldProcess($PartitionName, 'Create partition Vlan Id binding')) {
                try {
                    $payload = @{
                        vlan=$VlanId
                        partitionname=$PartitionName
                    }
                    _InvokeNSRestApi -Session $Session -Method PUT -Type nspartition_vlan_binding -Payload $payload

                } catch {
                    throw $_
                }
       
        }
    }
}