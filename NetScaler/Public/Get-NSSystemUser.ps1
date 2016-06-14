function Get-NSSystemUser {

    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(Position = 0)]
        [string]$username
        
    )
    begin {
        _AssertSessionActive
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'systemuser'
        }
        if($username) {
            $params.add('Resource',$username)
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