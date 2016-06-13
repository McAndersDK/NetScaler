function Get-NSVlan {

    [CmdletBinding()]
    param (
        $Session = $script:session,
        [int[]]$vlanid = @()
        
    )
    
    begin {
        _AssertSessionActive
        $get = $vlanid
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'vlan'
        }
    }

    Process {
         if ($get.Count -gt 0) { 
            foreach($item in $get) {
                try {
                    $response = _InvokeNSRestApi @params -Resource $item
                    if ($response.errorcode -ne 0) { throw $response } 
                    if ($Response.psobject.properties.name -contains "$($params.Type)") { 
                        $response."$($params.Type)"
                    }
                } catch {
                    throw $_
                }
            }
            
        }
        else {
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
}
 