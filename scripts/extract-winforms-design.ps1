function Extract-WinFormsColors {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $colors = @{}
    
    $designerFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.Designer.cs" -ErrorAction SilentlyContinue
    $csFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.cs" -ErrorAction SilentlyContinue
    $resxFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.resx" -ErrorAction SilentlyContinue
    
    foreach ($file in $designerFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $argbMatches = [regex]::Matches($content, 'Color\.FromArgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d+)\s*)?\)')
        foreach ($match in $argbMatches) {
            $a = [int]$match.Groups[1].Value
            $r = [int]$match.Groups[2].Value
            $g = [int]$match.Groups[3].Value
            $b = [int]$match.Groups[4].Value
            
            if ($a -eq 255) {
                $hex = "#" + [string]::Format("{0:X2}{1:X2}{2:X2}", $r, $g, $b)
            } else {
                $hex = "#" + [string]::Format("{0:X2}{1:X2}{2:X2}{3:X2}", $a, $r, $g, $b)
            }
            
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            if (-not $colors[$hex].Contains($file.Name)) {
                $colors[$hex] += $file.Name
            }
        }
        
        $knownColorMatches = [regex]::Matches($content, 'Color\.([A-Z][a-zA-Z]+)')
        foreach ($match in $knownColorMatches) {
            $colorName = $match.Groups[1].Value
            if (-not $colors.ContainsKey($colorName)) {
                $colors[$colorName] = @()
            }
            if (-not $colors[$colorName].Contains($file.Name)) {
                $colors[$colorName] += $file.Name
            }
        }
        
        $hexMatches = [regex]::Matches($content, 'Color\.FromName\s*\(\s*["\']([^"\']+)["\']\s*\)')
        foreach ($match in $hexMatches) {
            $colorName = $match.Groups[1].Value
            if (-not $colors.ContainsKey($colorName)) {
                $colors[$colorName] = @()
            }
            if (-not $colors[$colorName].Contains($file.Name)) {
                $colors[$colorName] += $file.Name
            }
        }
    }
    
    foreach ($file in $csFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $argbMatches = [regex]::Matches($content, 'Color\.FromArgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d+)\s*)?\)')
        foreach ($match in $argbMatches) {
            $a = [int]$match.Groups[1].Value
            $r = [int]$match.Groups[2].Value
            $g = [int]$match.Groups[3].Value
            $b = [int]$match.Groups[4].Value
            
            if ($a -eq 255) {
                $hex = "#" + [string]::Format("{0:X2}{1:X2}{2:X2}", $r, $g, $b)
            } else {
                $hex = "#" + [string]::Format("{0:X2}{1:X2}{2:X2}{3:X2}", $a, $r, $g, $b)
            }
            
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            if (-not $colors[$hex].Contains($file.Name)) {
                $colors[$hex] += $file.Name
            }
        }
    }
    
    foreach ($file in $resxFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $colorMatches = [regex]::Matches($content, '<value>\s*(#[0-9A-Fa-f]+)\s*</value>')
        foreach ($match in $colorMatches) {
            $hex = $match.Groups[1].Value.ToUpper()
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            if (-not $colors[$hex].Contains($file.Name)) {
                $colors[$hex] += $file.Name
            }
        }
    }
    
    Write-Host "`n=== Extracted WinForms Colors ==="
    foreach ($key in $colors.Keys | Sort-Object) {
        Write-Host "$key - Found in: $($colors[$key] -join ', ')"
    }
    Write-Host "`nTotal colors: $($colors.Count)"
    
    return $colors
}

function Extract-WinFormsTypography {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $typography = @{
        fontFamily = @()
        fontSize = @()
        fontWeight = @()
        fontStyle = @()
        fontSizesInt = @()
    }
    
    $designerFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.Designer.cs" -ErrorAction SilentlyContinue
    $csFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.cs" -ErrorAction SilentlyContinue
    
    foreach ($file in $designerFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $fontMatches = [regex]::Matches($content, 'new\s+Font\s*\(\s*["\']([^"\']+)["\']\s*,\s*([\d.]+)\s*(?:,\s*(FontStyle\.[a-zA-Z]+))?')
        foreach ($match in $fontMatches) {
            $family = $match.Groups[1].Value
            $size = $match.Groups[2].Value
            $style = $match.Groups[3].Value
            
            if (-not $typography.fontFamily.Contains($family)) {
                $typography.fontFamily += $family
            }
            if (-not $typography.fontSize.Contains($size)) {
                $typography.fontSize += $size
            }
            if ($style -and -not $typography.fontStyle.Contains($style)) {
                $typography.fontStyle += $style
            }
            
            $sizeInt = [int]$size
            if (-not $typography.fontSizesInt.Contains($sizeInt)) {
                $typography.fontSizesInt += $sizeInt
            }
        }
        
        $fontFamilyMatches = [regex]::Matches($content, '\.Font\s*=\s*new\s+Font\s*\(\s*["\']([^"\']+)["\']')
        foreach ($match in $fontFamilyMatches) {
            $family = $match.Groups[1].Value
            if (-not $typography.fontFamily.Contains($family)) {
                $typography.fontFamily += $family
            }
        }
    }
    
    foreach ($file in $csFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $fontMatches = [regex]::Matches($content, 'new\s+Font\s*\(\s*["\']([^"\']+)["\']\s*,\s*([\d.]+)')
        foreach ($match in $fontMatches) {
            $family = $match.Groups[1].Value
            $size = $match.Groups[2].Value
            
            if (-not $typography.fontFamily.Contains($family)) {
                $typography.fontFamily += $family
            }
            if (-not $typography.fontSize.Contains($size)) {
                $typography.fontSize += $size
            }
        }
    }
    
    Write-Host "`n=== Extracted WinForms Typography ==="
    Write-Host "Font Families: $($typography.fontFamily -join ', ')"
    Write-Host "Font Sizes: $($typography.fontSize -join ', ')"
    Write-Host "Font Styles: $($typography.fontStyle -join ', ')"
    
    return $typography
}

function Extract-WinFormsComponents {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $components = @{}
    
    $designerFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.Designer.cs" -ErrorAction SilentlyContinue
    
    foreach ($file in $designerFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $controlMatches = [regex]::Matches($content, 'this\.\w+\s*=\s*new\s+([A-Z][a-zA-Z]+)\s*\(')
        foreach ($match in $controlMatches) {
            $controlType = $match.Groups[1].Value
            if (-not $components.ContainsKey($controlType)) {
                $components[$controlType] = @()
            }
            if (-not $components[$controlType].Contains($file.Name)) {
                $components[$controlType] += $file.Name
            }
        }
        
        $customControlMatches = [regex]::Matches($content, 'this\.\w+\s*=\s*new\s+(\w+\.\w+)\s*\(')
        foreach ($match in $customControlMatches) {
            $controlType = $match.Groups[1].Value
            if (-not $components.ContainsKey($controlType)) {
                $components[$controlType] = @()
            }
            if (-not $components[$controlType].Contains($file.Name)) {
                $components[$controlType] += $file.Name
            }
        }
    }
    
    Write-Host "`n=== Extracted WinForms Components ==="
    foreach ($key in $components.Keys | Sort-Object) {
        Write-Host "$key - Found in: $($components[$key] -join ', ')"
    }
    
    return $components
}

function Extract-WinFormsLayout {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $layout = @{
        margins = @()
        paddings = @()
        sizes = @()
        positions = @()
    }
    
    $designerFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.Designer.cs" -ErrorAction SilentlyContinue
    
    foreach ($file in $designerFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $marginMatches = [regex]::Matches($content, '\.Margin\s*=\s*new\s+Padding\s*\(\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*)?)?)?\)')
        foreach ($match in $marginMatches) {
            $margin = "($($match.Groups[1].Value)"
            if ($match.Groups[2].Success) { $margin += ", $($match.Groups[2].Value)" }
            if ($match.Groups[3].Success) { $margin += ", $($match.Groups[3].Value)" }
            if ($match.Groups[4].Success) { $margin += ", $($match.Groups[4].Value)" }
            $margin += ")"
            
            if (-not $layout.margins.Contains($margin)) {
                $layout.margins += $margin
            }
        }
        
        $paddingMatches = [regex]::Matches($content, '\.Padding\s*=\s*new\s+Padding\s*\(\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*(?:,\s*(\d+)\s*)?)?)?\)')
        foreach ($match in $paddingMatches) {
            $padding = "($($match.Groups[1].Value)"
            if ($match.Groups[2].Success) { $padding += ", $($match.Groups[2].Value)" }
            if ($match.Groups[3].Success) { $padding += ", $($match.Groups[3].Value)" }
            if ($match.Groups[4].Success) { $padding += ", $($match.Groups[4].Value)" }
            $padding += ")"
            
            if (-not $layout.paddings.Contains($padding)) {
                $layout.paddings += $padding
            }
        }
        
        $sizeMatches = [regex]::Matches($content, '\.(Size|Width|Height)\s*=\s*(\d+)')
        foreach ($match in $sizeMatches) {
            $size = "$($match.Groups[1].Value): $($match.Groups[2].Value)"
            if (-not $layout.sizes.Contains($size)) {
                $layout.sizes += $size
            }
        }
    }
    
    Write-Host "`n=== Extracted WinForms Layout ==="
    Write-Host "Margins: $($layout.margins -join ', ')"
    Write-Host "Paddings: $($layout.paddings -join ', ')"
    Write-Host "Sizes: $($layout.sizes | Select-Object -First 20)"
    
    return $layout
}

function Analyze-WinFormsProject {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    Write-Host "`n======================================"
    Write-Host "Analyzing WinForms Project: $ProjectPath"
    Write-Host "======================================`n"
    
    $colors = Extract-WinFormsColors -ProjectPath $ProjectPath
    $typography = Extract-WinFormsTypography -ProjectPath $ProjectPath
    $components = Extract-WinFormsComponents -ProjectPath $ProjectPath
    $layout = Extract-WinFormsLayout -ProjectPath $ProjectPath
    
    $result = @{
        colors = $colors
        typography = $typography
        components = $components
        layout = $layout
    }
    
    return $result
}