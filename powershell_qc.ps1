# Author(s): Ronan Morris
#
# EEL4744 
# Dr. Eric Schwartz
#
Add-Type -AssemblyName System.Windows.Forms

function Show-MessageBox($message, $title) {
    [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Retrieve the QUARTUS_ROOTDIR environment variable
$quartusRootDir = [System.Environment]::GetEnvironmentVariable("QUARTUS_ROOTDIR", [System.EnvironmentVariableTarget]::Machine)
if (-not $quartusRootDir) {
    Show-MessageBox "The environment variable QUARTUS_ROOTDIR is not set." "Error"
    exit
}

$quartusBin = Join-Path -Path $quartusRootDir -ChildPath "bin"
if (-not (Test-Path $quartusBin)) {
    $quartusBin = Join-Path -Path $quartusRootDir -ChildPath "bin64"
    if (-not (Test-Path $quartusBin)) {
        Show-MessageBox "Neither 'bin' nor 'bin64' directory was found under QUARTUS_ROOTDIR." "Error"
        exit
    }
}


Show-MessageBox "Connect the first DE10 before proceeding"
$continue = $true

while ($continue) {
    & "$quartusBin\quartus_pgm.exe" -m jtag -c 1 -o "p;DE10_LITE_Default.sof"

    $dialogResult = [System.Windows.Forms.MessageBox]::Show("Press KEY0. Does the Device Work? (Faulty LEDs count as not working)", "Validation", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)

    Write-Host $dialogResult

    switch($dialogResult){
        "Yes"{
            & "$quartusBin\quartus_pgm.exe" -m jtag -c 1 -o "pvb;safe.pof"
            Show-MessageBox "Programming done. Place the GOOD DE10 in the section corresponding to tested stock." "Good Device"
        }
        "No"{
            & "$quartusBin\quartus_pgm.exe" -m jtag -c 1 -o "pvb;DE10_LITE_Default.pof"
            Show-MessageBox "Programming done. Place the BAD DE10 in the section corresponding to its fault." "Bad Device"
        }
        "Cancel"{
            Write-Host "Exiting Program." "Done"
            $continue = $false
            break
        }
        default{
            Write-Host "Unknown Input. Exiting Program." "Done"
            $continue = $false
            break
        }
    }


    Add-Type -AssemblyName System.Windows.Forms

    $dialogResult = [System.Windows.Forms.MessageBox]::Show("Connect the next device and enter when ready. (Cancel to quit)", "Awaiting DE10", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Question)

    Write-Host $dialogResult

    switch($dialogResult){
        "OK"{
            Write-Host "Preparing to program next device..."
        }
        "Cancel"{
            Write-Host "Exiting Program." "Done"
            $continue = $false
            break
        }
    }



}
