﻿function Add-NSService {
    <#
    .SYNOPSIS
        Add a new service resource
    .DESCRIPTION
        Add a new service resource
    .PARAMETER NSSession
        An existing custom NetScaler Web Request Session object returned by Connect-NSAppliance
    .PARAMETER Name
        Name for the service
    .PARAMETER ServerName
        Name of the server that hosts the service
    .PARAMETER ServerIPAddress
        IPv4 or IPv6 address of the server that hosts the service
        By providing this parameter, it attempts to create a server resource for you that's named the same as the IP address provided
    .PARAMETER Type
        Protocol in which data is exchanged with the service
    .PARAMETER Port
        Port number of the service
    .PARAMETER InsertClientIPHeader
        Before forwarding a request to the service, insert an HTTP header with the client's IPv4 or IPv6 address as its value
        Used if the server needs the client's IP address for security, accounting, or other purposes, and setting the Use Source IP parameter is not a viable option
    .PARAMETER ClientIPHeader
        Name for the HTTP header whose value must be set to the IP address of the client
        Used with the Client IP parameter
        If you set the Client IP parameter, and you do not specify a name for the header, the appliance uses the header name specified for the global Client IP Header parameter
        If the global Client IP Header parameter is not specified, the appliance inserts a header with the name "client-ip."
    .EXAMPLE
        Add-NSService -NSSession $Session -Name "Server1_Service" -ServerName "Server1" -ServerIPAddress "10.108.151.3" -Type "HTTP" -Port 80
    .NOTES
        Copyright (c) Citrix Systems, Inc. All rights reserved.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param (
        $Session = $script:session,
        [Parameter(Mandatory=$true)] [string]$Name,
        [Parameter(Mandatory=$true,ParameterSetName='By Name')] [string]$ServerName,
        [Parameter(Mandatory=$true,ParameterSetName='By Address')] [string]$ServerIPAddress,
        [Parameter(Mandatory=$true)] [ValidateSet(
        "HTTP","FTP","TCP","UDP","SSL","SSL_BRIDGE","SSL_TCP","DTLS","NNTP","RPCSVR","DNS","ADNS","SNMP","RTSP","DHCPRA",
        "ANY","SIP_UDP","DNS_TCP","ADNS_TCP","MYSQL","MSSQL","ORACLE","RADIUS","RDP","DIAMETER","SSL_DIAMETER","TFTP"
        )] [string]$Type,
        [Parameter(Mandatory=$true)] [ValidateRange(1,65535)] [int]$Port,
        [Parameter(Mandatory=$false)] [switch]$InsertClientIPHeader,
        [Parameter(Mandatory=$false)] [string]$ClientIPHeader
    )

    begin {
        _AssertSessionActive
    }

    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Add Service')) {
            $cip = if ($InsertClientIPHeader) { "ENABLED" } else { "DISABLED" }
            $payload = @{name=$Name;servicetype=$Type;port=$Port;cip=$cip}
            if ($ClientIPHeader) {
                $payload.Add("cipheader",$ClientIPHeader)
            }
            if ($PSCmdlet.ParameterSetName -eq 'By Name') {
                $payload.Add("servername",$ServerName)
            } elseif ($PSCmdlet.ParameterSetName -eq 'By Address') {
                Write-Verbose "Validating IP Address"
                $IPAddressObj = New-Object -TypeName System.Net.IPAddress -ArgumentList 0
                if (-not [System.Net.IPAddress]::TryParse($ServerIPAddress,[ref]$IPAddressObj)) {
                    throw "'$ServerIPAddress' is an invalid IP address"
                }
                $payload.Add("ip",$ServerIPAddress)
            }
            try {
                $response = _InvokeNSRestApi -Session $Session -Method POST -Type service -Payload $payload -Action add
             } catch {
                throw $_
            }
        }
    }
}