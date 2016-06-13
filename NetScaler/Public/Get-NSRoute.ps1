function Get-NSRoute {

    [CmdletBinding()]
    param (
        $Session = $script:session
    )
    
    begin {
        _AssertSessionActive
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'route'
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
 