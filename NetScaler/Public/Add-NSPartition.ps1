function Add-NSPartition {
  <#
    .SYNOPSIS
        Add an new partition to the NetScaler appliance.

    .DESCRIPTION
        Add an new partition to the NetScaler appliance.

    .EXAMPLE
        Add-NSPartition -PartitionName 'partition01'

        Create a new partition named 'partition01', with default settings.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER PartitionName
        The name of the new partition to add.

    .PARAMETER MaxBandwidth
        The maximum bandwidth limit for the partition.

    .PARAMETER MaxConn
        The maximum Connectings limit for the partition.

    .PARAMETER MaxMemLimit
        The memory limit for the partition.

    .PARAMETER MinBandwidth
        The minimum bandwidth limit for the partition.

    .PARAMETER Passthru 
        Return the partition object. 

    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        [parameter(Mandatory)]
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$PartitionName = (Read-Host -Prompt 'Partition Name'),
        [int]$MaxBandwidth = 10240,
        [int]$MaxConn = 1024,
        [int]$MaxMemLimit = 20,
        [int]$MinBandwidth = 10240,
        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }
    process {
    
        if ($PSCmdlet.ShouldProcess($item, 'Add Partition')) {
            try {
                $params = @{
                    partitionname=$PartitionName
                    maxbandwidth=$maxbandwidth
                    maxconn=$maxconn
                    maxmemlimit=$maxmemlimit
                    minbandwidth=$minbandwidth
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type nspartition -Payload $params -Action add
                if ($PSBoundParameters.ContainsKey('PassThru')) { 
                    return (Get-NSPartition -Session $session -PartitionName $PartitionName) 
                } 
            } catch {
                throw $_
            }
        }
    }
}
