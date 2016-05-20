Get-NetRoute -AddressFamily IPv4

Get-NetIPConfiguration -InterfaceAlias Wi-Fi | % { $interfaceWiFi = New-Object psobject -property @{ 
 'Interface' = $_.InterfaceIndex
 'DefaultGateway' = $_.IPv4DefaultGateway.NextHop 
}
}

Get-NetIPConfiguration -InterfaceAlias Ethernet | % { $interfaceLAN = New-Object psobject -property @{ 
 'Interface' = $_.InterfaceIndex
 'DefaultGateway' = $_.IPv4DefaultGateway.NextHop 
}
}

Remove-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0*"
Remove-NetRoute -AddressFamily IPv4 -DestinationPrefix "10.161.*"

New-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $interfaceWiFi.Interface -NextHop $interfaceWiFi.DefaultGateway
New-NetRoute -AddressFamily IPv4 -DestinationPrefix "10.161.0.0/32" -InterfaceIndex $interfaceLAN.Interface  -NextHop $interfaceLAN.DefaultGateway

Get-NetRoute -AddressFamily IPv4