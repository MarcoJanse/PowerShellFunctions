<#
.SYNOPSIS
    PowerShell function to copy one file multiple times
.DESCRIPTION
    This PowerShell function can be used to copy one file multiple times to test storage and network
    performance

    You can specify source and destination, the filename and the amount of copies you would like
    Each copied file will get a number added to the filename
.NOTES
    Version information:

    Copy-OneFileMultipleTimes.ps1
    Version 1.0
    By Marco Janse
    https://ictstuff.info

    Version history:

    1.0 - Initial tested version without comment based help

    To Do:
    - Test Force parameter to check if files get overwritten
    - Add error handling (try/catch blocks)
    - Add writing output to a logfile
.LINK
    https://github.com/MarcoJanse/PowerShellFunctions/blob/main/FileSystem/Copy-OneFileMultipleTimes.ps1
.PARAMETER SourcePath
    The source path for the copy, without the filename
.PARAMETER SourceFileName
    The filename of the file to copy, without the extension
.PARAMETER DestinationPath
    The destionation path for the copy, without the filename
.PARAMETER DestinationFileName
    An optional parameter to give the copied file a different name
.PARAMETER FileExtension
    The file extension of the source file (.txt,.png,.dat,.tiff, etc.")
.PARAMETER NumberOfCopies
    The number of copies to make
.PARAMETER Force
    An optional switch parameter, that when added, will Force overwrite of existing files
.EXAMPLE
    Copy-OneFileMultipleTimes -SourcePath D:\Temp -SourceFileName 'testfile' -DestinationPath \\server01\share02 -FileExtension 'dat' -NumberOfCopies 2 -Verbose

    This will copy D:\Temp\testfile.dat twice to \\server01\share02 and give you verbose output
.EXAMPLE
    The Example below is a controller script using the Copy-OneFileMultipleTimes funtions
    which can be easily adjusted for own usage

    ############################################################################################
    # CopyTestControllerScript
    # This is a controller script using the Copy-OneFileMultipleTimes function.
    # The hashtables with parameters can be adjusted as needed

    # Load Function
    . C:\Scripts\Copy-OneFileMultipleTimes.ps1

    Write-Host -ForegroundColor Cyan "start your wireshark capture filter now for \\server01 (host 192.168.1.1)"

    pause

    $ParamsServer01 = @{
        SourcePath = 'D:\Temp'
        SourceFileName = 'testfile-05gb'
        DestinationPath = '\\Server01\ShareName'
        FileExtension = 'dat'
        NumberOfCopies = 2
    }

    Write-Host "[$((Get-Date).DateTime) - Beginning copy action to Server01"
    Measure-Command -Expression { Copy-OneFileMultipleTimes @paramsServer01 -Verbose }
    Write-Host "[$((Get-Date).DateTime) - Finished copying to \\Server01"
#>

function Copy-OneFileMultipleTimes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory='true',
        HelpMessage="Enter the source path for the copy, without the filename")]
        [string]
        $SourcePath,

        [Parameter(Mandatory='true',
        HelpMessage="Enter the filename of the file you want to copy, without the extension")]
        [string]
        $SourceFileName,

        [Parameter(Mandatory='true',
        HelpMessage="Enter the destination path for the copy, without the filename")]
        [string]
        $DestinationPath,

        [Parameter(HelpMessage="an optional parameter if you want to give the copy a different name")]
        [string]
        $DestinationFileName,

        [Parameter(Mandatory='true',
        HelpMessage="Enter the file extension of the source file (.txt,.png,.dat,.tiff, etc.")]
        [string]
        $FileExtension,

        [Parameter(Mandatory='true',
        HelpMessage='Enter the number of copies you want')]
        [Int32]
        $NumberOfCopies,

        [Parameter(HelpMessage="Optional Force parameter to force overwriting destination filenames with the same name")]
        [switch]
        $Force
    )
    
    begin {
        Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [BEGIN] - Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        if ($DestionationFileName) {
            Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - 'DestionationFileName' specified"
            Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - Copy $SourcePath\$SourceFileName $NumberOfCopies times to $DestinationPath\$DestionationFileName"

            if ($Force) {
                Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - 'Force' specified, overwriting destination filenames with the same name (if exist)"

                1..$NumberOfCopies | ForEach-Object {
                    Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - Copying $SourcePath\$SourceFileName.$FileExtension to $DestinationPath\$DestionationFileName-$_.$FileExtension"
                    Copy-Item -Path $SourcePath\$SourceFileName.$FileExtension -Destination $DestinationPath\$DestionationFileName-$_.$FileExtension -Force -Confirm:$false
                } # ForEachNumberOfCopies

            } # if $Force specified

            else { # no $Force specified

                1..$NumberOfCopies | ForEach-Object {
                    Copy-Item -Path $SourcePath\$SourceFileName.$FileExtension -Destination $DestinationPath\$DestionationFileName-$_.$FileExtension
                } # ForEachNumberOfCopies

            } # else no $Force specified

        } # if $DestionationFileName specified


        else { # no $DestinationFileName specified

            Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - Copy $SourcePath\$SourceFileName $NumberOfCopies times to $DestinationPath"

            if ($Force) { 
                Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - 'Force' specified, overwriting destination filenames with the same name (if exist)"

                1..$NumberOfCopies | ForEach-Object {
                    Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - Copying $SourcePath\$SourceFileName.$FileExtension to $DestinationPath\$SourceFileName-$_.$FileExtension"
                    Copy-Item -Path $SourcePath\$SourceFileName.$FileExtension -Destination $DestinationPath\$SourceFileName-$_.$FileExtension -Force -Confirm:$false
                } # ForEachNumberOfCopies

            } # if $Force specified

            else { # no $Force specified

                1..$NumberOfCopies | ForEach-Object {
                    Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [PROCESS] - Copying $SourcePath\$SourceFileName.$FileExtension to $DestinationPath\$SourceFileName-$_.$FileExtension"
                    Copy-Item -Path $SourcePath\$SourceFileName.$FileExtension -Destination $DestinationPath\$SourceFileName-$_.$FileExtension
                } # ForEachNumberOfCopies

            } # else no $Force specified

        } # else no $DestinationFileName specified


    } # process END
    
    end {
        Write-Verbose -Message "$((Get-Date).ToString("yyyy-MM-dd H:mm")) - [END] - End of $($MyInvocation.MyCommand)"
    }

}