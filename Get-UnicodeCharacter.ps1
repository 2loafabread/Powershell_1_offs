#v1
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
#END

#v2
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
#A few examples used for testing
#Get-UnicodeCharacter -char ⣎
#Write-Host 
#$OutputEncoding
#END

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
#END

#v4 (2 functions)
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

#subfunction that modifies variables the other function depends on
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
#END

#example script usage 1
Get-UnicodeCharacter -Char ⣎
#example script usage 2
Get-UnicodeCharacter -Start 0x19 -End 0x80
