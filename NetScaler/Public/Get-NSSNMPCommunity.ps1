function Get-NSSNMPCommunity {
    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(Position = 0)]
        [string]$CommunityName
        )

    begin {
        _AssertSessionActive
        $params = @{
            Session = $Session
            Method = 'GET'
            Type = 'snmpcommunity'
        }
        if($CommunityName) {
            $params.add('Resource',$CommunityName)
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