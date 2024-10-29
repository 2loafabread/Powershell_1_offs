# Set the directory containing your .pcap files
$pcapDirectory = "C:\Users\Account\Downloads\PCAP"

# Path to tshark executable
$tsharkPath = "C:\Program Files\Wireshark\tshark.exe"

# Loop through each .pcap file in the directory
Get-ChildItem -Path $pcapDirectory -Filter *.pcapng | ForEach-Object {
    $pcapFile = $_.FullName
    Write-Host "Processing file: $pcapFile"

    # Run tshark to display the protocol hierarchy for the current .pcap file
    #& "$tsharkPath" -r $pcapFile -q -z io,phs
    & "$tsharkPath"  -r $pcapFile -Y 'smb2 && smb2.filename' -T fields -e smb2.filename | sort -u

}
