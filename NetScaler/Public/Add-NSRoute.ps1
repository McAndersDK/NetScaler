function Add-NSRoute {
    [CmdletBinding()]
    param (
        $Session = $script:session,
        [string]$Network,
        [string]$Netmask,
        [switch]$NullRoute,
        [string]$Gateway,
        [int]$Distance
    )
    
    begin {
        _AssertSessionActive
        if($NullRoute) {
            $gateway = 'null'
            $Distance = 255
        }
        $params = @{
        session = $Session
        Method = 'post'
        Type = 'route'
        payload = @{
                network=$Network
                netmask=$Netmask
                gateway=$Gateway
                distance=$Distance
            }
        }
    }

    Process {
        $response = _InvokeNSRestApi @params
    }
}