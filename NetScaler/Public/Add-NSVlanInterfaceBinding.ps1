function Add-NSVlanInterfaceBinding {

    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(Mandatory=$true,Position = 0)]
        [int]$vlanid,
        [parameter(Mandatory=$true,Position = 1)]
        [string]$ifnumber,
        [parameter(Position = 2)]
        [ValidateSet("true","false")]
        [string]$tagged = 'true'
        
    )
    begin {
        _AssertSessionActive
        $params = @{
            session = $Session
            Method = 'put'
            Type = 'vlan_interface_binding'
            Actoin = 'add'
            payload = @{
                id=$vlanid
                ifnum=$ifnumber
                tagged=$tagged
            }
        }
    }

    Process {
        _InvokeNSRestApi @params
    }
}