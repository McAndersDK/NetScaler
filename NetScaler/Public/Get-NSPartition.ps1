function Get-NSPartition {
    <#
    .SYNOPSIS
        Get partition objects.
  
    .DESCRIPTION
        Get partition objects.
  
    .EXAMPLE
        get-NSpartition
    
        Get all partition objects.
    
    .EXAMPLE
        get-NSpartition -PartitionName 'partition01'
    
        Get partition named 'partition01'.

    .PARAMETER Session
        The NetScaler session object.
      
    .PARAMETER PartitionName 
        The name or names of the partition to get. 

    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,
  
        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)] 
        [string[]]$PartitionName = @() 
    )
  
    begin {
        _AssertSessionActive
        $response = @()
    }
    process { 
        if ($PartitionName.Count -gt 0) { 
            foreach ($item in $PartitionName) { 
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type nspartition -Resource $item -Action Get 
                if ($response.errorcode -ne 0) { throw $response } 
                if ($Response.psobject.properties.name -contains 'nspartition') { 
                    $response.nspartition 
                }
            }
        }
        else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type nspartition -Action Get 
            if ($response.errorcode -ne 0) { throw $response } 
            if ($Response.psobject.properties.name -contains 'nspartition') { 
                $response.nspartition 
            } 
        }
    }
}
