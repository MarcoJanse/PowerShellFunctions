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
        HelpMessage="Enter the destionation path for the copy, without the filename")]
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