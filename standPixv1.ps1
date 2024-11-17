$CWD = Get-Location
[bool] $openstandpix = 1

foreach ($each in (get-psdrive -psprovider filesystem).name) {
    $checkstand = $each + ":\stand.txt"
    $checkdrive = $each + ":"
    if (test-path -pathtype leaf -path $checkstand) {
        set-location $checkdrive
        $standNumber = Get-Content $checkstand -Raw
        $openstandpix = 0
        break
    }
}

If(($openstandpix))
{
    write-host "Chip not dectected...opening local picutures"
    #invoke-item C:\Users\wirsb\OneDrive\Documents\StandPix
    invoke-item C:\Users\wirsb\OneDrive\Documents\StandPix
    Start-Sleep 5
    exit
}


#get-childitem -recurse -filter "*.jpg" | sort CreationTime | select name, creationTime, FullName
$myfile = get-childitem -recurse -filter "*.jpg" | sort CreationTime | select name, creationTime, FullName
# $standNumber = Get-Content stand.txt -Raw

$path = "C:\Users\wirsb\OneDrive\Documents\StandPix\${standNumber}"
#$PATH = $checkdrive + "\Users\wirsb\OneDrive\Documents\StandPix\" + $standNumber
write-host "Reading chip for Stand ${standnumber}"
If(!(test-path -PathType container $path))
{
      New-Item -ItemType Directory -Path $path
}

# Create new date directory for under stand master directory
$dateOfRun = Get-Date -UFormat %y_%m_%d
$masterPath = "C:\Users\wirsb\OneDrive\Documents\StandPix\Master\${standNumber}\${dateOfRun}"
if( !(test-path -PathType Container $masterPath))
{
     New-Item -ItemType Directory -Path $masterPath
}
write-host $masterPath


foreach ($doda in $myfile) {
  # $doda.CreationTime
  $EpochTime = Get-Date $doda.CreationTime -UFormat %y_%m_%d-%H_%M_%S
  #if(!(Test-Path -PathType Leaf -path "C:\Users\wirsb\OneDrive\Documents\StandPix\${standNumber}\${EpochTime}.jpg"))
  if(!(Test-Path -PathType Leaf -path "${path}\${EpochTime}.jpg") -and !(Test-Path -PathType Leaf -path "${masterPath}\${EpochTime}.jpg"))
  {
  Write-Host $EpochTime
  #New-Item -ItemType SymbolicLink -Path "C:\Users\wirsb\OneDrive\Documents\StandPix\$EpochTime" -Target $doda.FullName
  Copy-Item -Path $doda.FullName -Destination "${masterPath}\${EpochTime}.jpg"
  }
}

#new-item -path C:\Users\wirsb\OneDrive\Documents\StandPix\2\24_10_10-12_17_10 -ItemType symboliclink -value C:\Users\wirsb\OneDrive\Documents\StandPix\Master\2\24_10_13\24_10_10-12_17_10.jpg

Set-Location $CWD
invoke-item C:\Users\wirsb\OneDrive\Documents\StandPix
Start-Sleep -s 10