function Set-NSActivePartition {
    <#
    .SYNOPSIS
        Set the Active partition.

    .DESCRIPTION
        Set the Active partition.

    .EXAMPLE
        Set-NSActivePartition -PartitionName 'partition01'

        Sets the Active Partition to 'partition01'.

    .EXAMPLE
        Get-NSPartition -PartitionName 'partition01' | Set-NSActivePartition
    
        Sets the Active Partition to 'partition01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER PartitionName
        The name Partition to set active.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string]$partitionName = (Read-Host -Prompt 'Partition Name')
    )

    begin {
        _AssertSessionActive
    }

    process {
      $response = _InvokeNSRestApi -Session $Session -Method POST -Type nspartition -Payload @{partitionname=$PartitionName} -Action switch
      if($response) {
        if ($response.errorcode -ne 0) { throw $response }
      }
    }
}
