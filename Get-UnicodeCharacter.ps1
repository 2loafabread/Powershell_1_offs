#Finally I can search for Elon's son's name in google
function Get-UnicodeCharacter {
    [CmdletBinding()]
    param (
        [int]$Start = 0,
        [int]$End = 0xFFFF,
        [int]$Columns = 16
    )

    $row = 0
    $col = 0
    $maxcols = $Columns
    for ($i = $Start; $i -le $End; $i++) {
        $char = [char]$i
        Write-Host -NoNewline "$char "
        $col++
        if ($col -ge $maxcols) {
            $col = 0
            $row++
            Write-Host
        }
    }
}

#example script usage
Get-UnicodeCharacter -Start 0x19 -End 0x80














#this one does the unicode search in reverse too
function Get-UnicodeCharacter {
    [CmdletBinding()]
    param (
        [int]$Start = 0,
        [int]$End = 0xFFFF,
        [int]$Columns = 16,
        [char]$Char
    )

    if ($Char) {
        $hex = "{0:x}" -f [int][char]$Char
        Write-Host "Unicode code point for '$Char' is U+$hex"
    }

    $row = 0
    $col = 0
    $maxcols = $Columns
    for ($i = $Start; $i -le $End; $i++) {
        $char = [char]$i
        Write-Host -NoNewline "$char "
        $col++
        if ($col -ge $maxcols) {
            $col = 0
            $row++
            Write-Host
        }
    }
}

Get-UnicodeCharacter -char ⣎
Write-Host 
$OutputEncoding


#v3
function Get-UnicodeCharacter {
    [CmdletBinding()]
    param (
        [int]$Start = 0,
        [int]$End = 0xFFFF,
        [int]$Columns = 16,
        [char]$Char,
        [switch]$Code
    )

    if ($Char) {
        $hex = "{0:x}" -f [int][char]$Char
        Write-Host "Unicode code point for '$Char' is U+$hex"
        if ($Code) { return }
    }

    $row = 0
    $col = 0
    $maxcols = $Columns
    for ($i = $Start; $i -le $End; $i++) {
        $char = [char]$i
        Write-Host -NoNewline "$char "
        $col++
        if ($col -ge $maxcols) {
            $col = 0
            $row++
            Write-Host
        }
    }
}

#v4

function Get-UnicodeCharacter {
    param (
        [string]$Char,
        [switch]$Code
    )
    $OutputEncoding = [System.Text.Encoding]::Unicode
    if ($Code) {
        return "U+{0:X4}" -f [int][char]$Char
    } else {
        $charArray = [char[]]$Char
        $charArray | ForEach-Object {
            $codePoint = "U+{0:X4}" -f [int][char]$_
            $charName = (Get-CharInfo $_).Name
            [PSCustomObject]@{
                Char = $_
                CodePoint = $codePoint
                Name = $charName
            }
        } | Format-Table -AutoSize
    }
}

#subfunction that does some stuff that makes my brain wrinkle
function Get-CharInfo {
    param (
        [char]$Char
    )
    $outputEncoding = [System.Text.Encoding]::Unicode
    $charBytes = $outputEncoding.GetBytes($Char)
    $escapedBytes = $charBytes | ForEach-Object { '\x{0:X2}' -f $_ }
    $escapedString = [string]::Join('', $escapedBytes)
    $charInfo = Invoke-Expression("`"" + 'echo ' + $escapedString + ' ^| Format-Hex' + "`"")
    $charInfo -replace '\s{2,}', ' ' | ConvertFrom-Csv -Delimiter ' ' -Header 'Offset','Bytes','Ascii','Hex','Description'
}

Get-UnicodeCharacter -Char ⣎