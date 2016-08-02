function get-NSService {
    [CmdletBinding()]
    param (
        $Session = $script:session,
        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @()
    )
    begin {
        _AssertSessionActive
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type service -Resource $item -Action Get 
                if ($response.errorcode -ne 0) { throw $response }
                if ($Response.psobject.properties.name -contains 'service') {
                    $response.service
                }
            }
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type service -Action Get
            if ($response.errorcode -ne 0) { throw $response }
            if ($Response.psobject.properties.name -contains 'service') {
                $response.service
            }
        }
    }
}
