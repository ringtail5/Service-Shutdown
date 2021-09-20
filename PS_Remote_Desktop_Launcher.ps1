#Define Functions
function start-rdp{
    Param(
    [System.Object]$IPAddress,
    [int]$Computer
    )
    $ip = [string]$IPAddress.Text
    $un = [string]$userName.Text
    New-Item -ItemType Directory -Name RemoteConnectionTempFolder -Path C:\
    Out-File -InputObject "full address:s:$ip" -FilePath "c:\RemoteConnectionTempFolder\Connection$Computer.rdp"
    Set-Location c:\RemoteConnectionTempFolder\
    Start-Process -FilePath ./Connection$Computer.rdp
}
#Define the Class
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Create the Window and add Elements (title, size, etc.)
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = 'Remote Desktop Launcher'
$mainForm.Width = '550'
$mainForm.Height = '300'
$mainForm.StartPosition = 'CenterScreen'
$mainForm.AutoSize = $false
$mainForm.AutoScale = $false

#Add Done Button
$doneButton = New-Object System.Windows.Forms.Button
$doneButton.Size = New-Object System.Drawing.Size(70,25)
$doneButton.Top = '228'
$doneButton.Left = '235'
$doneButton.Text = 'Done'
$doneButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$mainForm.CancelButton = $doneButton
$mainForm.Controls.Add($doneButton)

#Domain Controller Controls
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox1.Location = '5,5'
$groupBox1.Size = '525,40'
$groupBox1.Text = "Domain Controller"
$label1 = New-Object System.Windows.Forms.label
$label1.Text = "What is the IP Address for the Domain Controller:"
$label1.Location = '10,20'
$label1.AutoSize = $true
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = '280,15'
$textBox1.Size = '150,20'
$textbox1.Text = "0.0.0.0"
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = '450,14'
$button1.Size = '50,20'
$button1.Text = "Launch"
$groupBox1.Controls.AddRange(@($label1,$textBox1,$button1))
$mainForm.Controls.Add($groupBox1)
$mainForm.Add_Shown({$textBox1.Select()})

#Client Server One Controls
$groupBox2 = New-Object System.Windows.Forms.GroupBox
$groupBox2.Location = '5,55'
$groupBox2.Size = '525,40'
$groupBox2.Text = "Server One"
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "What is the IP Address for Server One:"
$label2.Location = '10,20'
$label2.AutoSize = $true
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = '280,15'
$textBox2.Size = '150,20'
$button2 = New-Object System.Windows.Forms.Button
$button2.Location = '450,14'
$button2.Size = '50,20'
$button2.Text = "Launch"
$groupBox2.Controls.AddRange(@($label2,$textBox2,$button2))
$mainForm.Controls.Add($groupBox2)

#Client Server Two
$groupBox3 = New-Object System.Windows.Forms.GroupBox
$groupBox3.Location = '5,105'
$groupBox3.Size = '525,40'
$groupBox3.Text = "Server Two"
$label3 = New-Object System.Windows.Forms.Label
$label3.Text = "What is the IP Address for Server Two:"
$label3.Location = '10,20'
$label3.AutoSize = $true
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = '280,15'
$textBox3.Size = '150,20'
$button3 = New-Object System.Windows.Forms.Button
$button3.Location = '450,14'
$button3.Size = '50,20'
$button3.Text = "Launch"
$groupBox3.Controls.AddRange(@($label3,$textBox3,$button3))
$mainForm.Controls.Add($groupBox3)

#Section for username
$label4 = New-Object System.Windows.Forms.Label
$label4.Text = "User Name:"
$label4.Location = '10,200'
$label4.AutoSize = $true
$textBox4 = New-Object System.Windows.Forms.TextBox
$textBox4.Location = '80,197'
$textBox4.Size = '150,20'
$mainForm.Controls.Add($label4)
$mainForm.Controls.Add($textBox4)

#button Functionality
$button1.Add_Click(
    {
        Start-RDP -IPAddress $textBox1 -Computer 1 -userName $textBox4
    }
)
$button2.Add_Click(
    {
        Start-RDP -IPAddress $textBox2
    }
)
$button3.Add_Click(
    {
        Start-RDP -IPAddress $textBox3
    }
)
#Clean up from previous session
Remove-Item -Path C:\RemoteConnectionTempFolder\ -Recurse -ErrorAction SilentlyContinue

#Display Window
$result = $mainForm.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    sleep -Seconds 10
    Remove-Item -Path C:\RemoteConnectionTempFolder\ -Recurse
}