function Add-NSVlan {

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param (
        $Session = $script:session,
        [int]$vlanid,
        [string]$aliasname,
        [int]$mtu
        
    )
    
    begin {
        _AssertSessionActive
    }

    Process {
        if ($PSCmdlet.ShouldProcess($vlanid, 'Add vlan')) {
            try {
                $params = @{
                    Session = $Session
                    Method = 'POST'
                    Type = 'vlan'
                    Action = 'add'
                    Payload = @{
                        id=$vlanid
                        aliasname=$aliasname
                        mtu=$mtu
                    }
                }
                $response = _InvokeNSRestApi @params
            } catch {
                throw $_
            }
        }
    }
    
    
     
    }
 