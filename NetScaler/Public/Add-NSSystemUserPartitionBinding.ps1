function Add-NSSystemUserPartitionBinding {
  <#
    .SYNOPSIS
      Bind a system user to a partition.

    .DESCRIPTION
        Bind a system user to a partition.

    .EXAMPLE
        Add-NSSystemUserPartitionBinding -PartitionName 'partition01' -Username 'User01'

        Bind system user 'User01' to partition 'partition01'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Username
        The name of the system user to bind.
  #>
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true)] 
      $Session = $script:session,
      [string]$Username,
      [string]$PartitionName        
  )

  params = @{
    username=$Username
    partitionname=$PartitionName
  }
  begin {
    _AssertSessionActive
  }
  
  process {
    $response = _InvokeNSRestApi -Session $Session -Method PUT -Type systemuser_nspartition_binding -Payload @params
    if ($response.errorcode -ne 0) { throw $response }  
  }
}
