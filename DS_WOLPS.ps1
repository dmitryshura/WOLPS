# Script created by Dmitry Shura
# https://github.com/dmitryshura/WOLPS

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Default values ---
$defaultBroadcast = "255.255.255.255"
$defaultPort = 9

# --- Create Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Wake-on-LAN Sender"
$form.Size = New-Object System.Drawing.Size(400, 220)
$form.StartPosition = "CenterScreen"

# --- MAC Address Label & TextBox ---
$lblMac = New-Object System.Windows.Forms.Label
$lblMac.Text = "MAC Address:"
$lblMac.Location = New-Object System.Drawing.Point(20, 20)
$lblMac.AutoSize = $true
$form.Controls.Add($lblMac)

$txtMac = New-Object System.Windows.Forms.TextBox
$txtMac.Location = New-Object System.Drawing.Point(120, 18)
$txtMac.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($txtMac)

# --- Broadcast Label & TextBox ---
$lblBroadcast = New-Object System.Windows.Forms.Label
$lblBroadcast.Text = "Broadcast IP:"
$lblBroadcast.Location = New-Object System.Drawing.Point(20, 60)
$lblBroadcast.AutoSize = $true
$form.Controls.Add($lblBroadcast)

$txtBroadcast = New-Object System.Windows.Forms.TextBox
$txtBroadcast.Location = New-Object System.Drawing.Point(120, 58)
$txtBroadcast.Size = New-Object System.Drawing.Size(200, 20)
$txtBroadcast.Text = $defaultBroadcast
$form.Controls.Add($txtBroadcast)

# --- Port Label & TextBox ---
$lblPort = New-Object System.Windows.Forms.Label
$lblPort.Text = "Port:"
$lblPort.Location = New-Object System.Drawing.Point(20, 100)
$lblPort.AutoSize = $true
$form.Controls.Add($lblPort)

$txtPort = New-Object System.Windows.Forms.TextBox
$txtPort.Location = New-Object System.Drawing.Point(120, 98)
$txtPort.Size = New-Object System.Drawing.Size(200, 20)
$txtPort.Text = $defaultPort
$form.Controls.Add($txtPort)

# --- Status Label ---
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20, 140)
$lblStatus.Size = New-Object System.Drawing.Size(350, 20)
$form.Controls.Add($lblStatus)

# --- Send Button ---
$btnSend = New-Object System.Windows.Forms.Button
$btnSend.Text = "Send Magic Packet"
$btnSend.Location = New-Object System.Drawing.Point(120, 170)
$btnSend.Size = New-Object System.Drawing.Size(150, 30)
$form.Controls.Add($btnSend)

# --- Send Button Click Event ---
$btnSend.Add_Click({
    $macAddress = $txtMac.Text.Trim()
    $broadcastAddress = $txtBroadcast.Text.Trim()
    $port = $txtPort.Text.Trim()

    try {
        # Validate MAC
        if ($macAddress -notmatch '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$') {
            throw "Invalid MAC address format."
        }
        # Validate Port
        if (-not [int]::TryParse($port, [ref]0) -or [int]$port -lt 1 -or [int]$port -gt 65535) {
            throw "Invalid port number."
        }

        # Convert MAC to bytes
        $macBytes = $macAddress -split '[:-]' | ForEach-Object { [byte]("0x$_") }

        # Build magic packet
        $packet = [byte[]](,0xFF * 6 + ($macBytes * 16))

        # Send packet
        $udpClient = New-Object System.Net.Sockets.UdpClient
        $udpClient.EnableBroadcast = $true
        $udpClient.Connect($broadcastAddress, [int]$port)
        [void]$udpClient.Send($packet, $packet.Length)
        $udpClient.Close()

        $lblStatus.ForeColor = 'Green'
        $lblStatus.Text = "✅ Magic packet sent to $macAddress"
    }
    catch {
        $lblStatus.ForeColor = 'Red'
        $lblStatus.Text = "❌ Error: $_"
    }
})

# --- Show Form ---
[void]$form.ShowDialog()
