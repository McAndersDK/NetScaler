function Add-NSSNMPCommunity {
    [CmdletBinding()]
    param (
        $Session = $script:session,
        [Parameter(Mandatory=$true,Position = 0)]
        [string]$CommunityName,
        [Parameter(Mandatory=$true,Position = 1)]
        [validateset('GET_NEXT','GET','ALL','GET_BULK','SET')]
        [string]$Permissions
    )

    begin {
        _AssertSessionActive
        $params = @{
            session = $Session
            Method = 'post'
            Type = 'snmpcommunity'
            payload = @{
                communityname=$CommunityName
                permissions=$Permissions
            }
        }
    }

    Process {
        _InvokeNSRestApi @params
    }
}