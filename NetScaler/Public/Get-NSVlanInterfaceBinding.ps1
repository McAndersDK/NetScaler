function Get-NSVlanInterfaceBinding {

    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(Position = 0)]
        [int]$vlanid
        
    )
    begin {
        _AssertSessionActive
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'vlan_interface_binding'
        }
        if($vlanid) {
            $params.add('Resource',$vlanid)
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