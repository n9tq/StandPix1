write-host "Welome to Read Chip Version 2.1.0"
$pixCount = 0
$CWD = Get-Location
$CurrentDate = Get-Date
[bool] $openstandpix = 1
$cameraChips = @()


# (Get-Partition -DriveLetter "e").disknumber
# (get-disk -number 1).isboot
$DriveLetterList = (get-psdrive -psprovider filesystem).name # Get a list of drive letters 

foreach ($each in $DriveLetterList) {
    if (test-path -pathtype leaf -path "${each}:\*") {
        $diskNumber = (Get-Partition -DriveLetter $each).disknumber
        if (!(get-disk -number $diskNumber).isboot){
            $cameraChips += $each
        }
    }
}


foreach ($each in $cameraChips) {
    $checkstand = $each + ":\stand.txt"
    $checkdrive = $each + ":"
    if (test-path -pathtype leaf -path $checkstand) {
        set-location $checkdrive
        $standNumber = Get-Content $checkstand -Raw
        $openstandpix = 0
        break
    }
}

if($openstandpix -and $cameraChips.Length -gt0)
{
    foreach ($each in $cameraChips) {
        write-host "Unlabled camera chip has been detected in Drive: $each"
        $response = Read-Host "Would you like to label it now? [Y/N]: "
        if (($respnse -contains "Y") -or ($response -contains "y")) {
            $standLabel = Read-Host "Please enter Stand Label: "
            write-host "New label is $standLabel"
            $standLabel | Out-File "${each}:\stand.txt"
            $standNumber = $standLabel
            Set-Location "${each}:"
            $openstandpix = 0
        }

        
    }
}
If(($openstandpix))
{
    # Check to see if there are any chips inserted...
    #if(test-path -PathType leaf -path 
    
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


$dateOfRun = Get-Date -UFormat %y_%m_%d
$LogDir="C:\Users\wirsb\OneDrive\Documents\StandPix\Log"
$LogFile="${LogDir}/${standnumber}-${dateOfRun}.log"
$masterPath = "${LogDir}\${standNumber}\${dateOfRun}"
$masterPathBase = "${LogDir}\${standNumber}\"
if( !(test-path -PathType Container $masterPath))
{
     New-Item -ItemType Directory -Path $masterPath
}



foreach ($doda in $myfile) {
  # $doda.CreationTime
  if($doda.CreationTime -gt $CurrentDate)
  {
      $futureFile = $doda.Name
      write-host "WARNING! $futureFile has creation date in the future! Skipping this picture"
      "WARNING: $futureFile has creation date in the future! Skipping this picture" | Out-File -Append $LogFile
  } else
  {
      $EpochTime = Get-Date $doda.CreationTime -UFormat %y_%m_%d-%H_%M_%S
      #if(!(Test-Path -PathType Leaf -path "C:\Users\wirsb\OneDrive\Documents\StandPix\${standNumber}\${EpochTime}.jpg"))
      if(!(Get-ChildItem -path "${path}" -filter "${EpochTime}.jpg" -recurse -ErrorAction SilentlyContinue -Force ))
      {
          Write-Host $EpochTime
          #New-Item -ItemType SymbolicLink -Path "C:\Users\wirsb\OneDrive\Documents\StandPix\$EpochTime" -Target $doda.FullName
          $sourceName = $doda.Name
          Copy-Item -Path $doda.FullName -Destination "${Path}\${EpochTime}.jpg"
          "${EpochTime} ${sourceName} ${EpochTime}.jpg" | Out-File -Append $LogFile
          if ($pixCount -eq 0)
          { 
              $firstDate = $EpochTime
              $firstPix = "${Path}\${EpochTime}.jpg"
          }
          $pixCount++
      }
  }
}



Set-Location $CWD
write-host "$pixCount Pictures Imported"
if ($pixCount -gt 0)
{
    write-host "Start Date: ${firstDate}"
    write-host "Last Date: ${EpochTime}"
}
#invoke-item C:\Users\wirsb\OneDrive\Documents\StandPix
$response = Read-Host "Press enter too Open the Stand Folder and exit the ReadChip"
if (!($respnse -eq "x") -and !($response -eq "X"))
{
    if($pixCount -eq 0)
    {
        invoke-item $path
    }
    else
    {
        invoke-item $path
        invoke-item $firstPix
    }
}