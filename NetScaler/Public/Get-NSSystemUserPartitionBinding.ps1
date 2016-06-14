function Get-NSSystemUserPartitionBinding {

    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(Mandatory=$true,Position = 0)]
        [string]$Username        
    )
    begin {
        _AssertSessionActive
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'systemuser_nspartition_binding'
        }
        if($Username) {
            $params.add('Resource',$Username)
        }
    }

    Process {
        try {
            $response = _InvokeNSRestApi @params
            if ($response.errorcode -ne 0) { throw $response } 
            if ($Response.psobject.properties.name -contains "$($params.Type)") { 
                $response."$($params.Type)"
            }
        } catch {
            throw $_
        } 
    }
}