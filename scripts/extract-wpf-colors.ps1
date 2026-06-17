function Extract-WpfColors {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $colors = @{}
    
    $xamlFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.xaml" -ErrorAction SilentlyContinue
    
    foreach ($file in $xamlFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $solidColorMatches = [regex]::Matches($content, 'SolidColorBrush[^>]*Color="#([^"]+)"')
        foreach ($match in $solidColorMatches) {
            $hex = "#" + $match.Groups[1].Value.ToUpper()
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            if (-not $colors[$hex].Contains($file.Name)) {
                $colors[$hex] += $file.Name
            }
        }
        
        $colorMatches = [regex]::Matches($content, 'Color="#([^"]+)"')
        foreach ($match in $colorMatches) {
            $hex = "#" + $match.Groups[1].Value.ToUpper()
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            if (-not $colors[$hex].Contains($file.Name)) {
                $colors[$hex] += $file.Name
            }
        }
        
        $resourceMatches = [regex]::Matches($content, '<Color\s+Name="([^"]+)"\s*>(#[^<]+)</Color>')
        foreach ($match in $resourceMatches) {
            $name = $match.Groups[1].Value
            $hex = $match.Groups[2].Value.ToUpper()
            $key = "$name|$hex"
            if (-not $colors.ContainsKey($key)) {
                $colors[$key] = @()
            }
            if (-not $colors[$key].Contains($file.Name)) {
                $colors[$key] += $file.Name
            }
        }
    }
    
    Write-Host "`n=== Extracted WPF Colors ==="
    foreach ($key in $colors.Keys | Sort-Object) {
        Write-Host "$key - Found in: $($colors[$key] -join ', ')"
    }
    Write-Host "`nTotal colors: $($colors.Count)"
    
    return $colors
}

function Extract-WpfTypography {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $typography = @{}
    $xamlFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.xaml" -ErrorAction SilentlyContinue
    
    foreach ($file in $xamlFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $fontMatches = [regex]::Matches($content, 'FontFamily="([^"]+)"')
        foreach ($match in $fontMatches) {
            $font = $match.Groups[1].Value
            if (-not $typography.ContainsKey("font-family")) {
                $typography["font-family"] = @()
            }
            if (-not $typography["font-family"].Contains($font)) {
                $typography["font-family"] += $font
            }
        }
        
        $sizeMatches = [regex]::Matches($content, 'FontSize="([^"]+)"')
        foreach ($match in $sizeMatches) {
            $size = $match.Groups[1].Value
            if (-not $typography.ContainsKey("font-size")) {
                $typography["font-size"] = @()
            }
            if (-not $typography["font-size"].Contains($size)) {
                $typography["font-size"] += $size
            }
        }
        
        $weightMatches = [regex]::Matches($content, 'FontWeight="([^"]+)"')
        foreach ($match in $weightMatches) {
            $weight = $match.Groups[1].Value
            if (-not $typography.ContainsKey("font-weight")) {
                $typography["font-weight"] = @()
            }
            if (-not $typography["font-weight"].Contains($weight)) {
                $typography["font-weight"] += $weight
            }
        }
    }
    
    Write-Host "`n=== Extracted WPF Typography ==="
    foreach ($key in $typography.Keys) {
        Write-Host "$key: $($typography[$key] -join ', ')"
    }
    
    return $typography
}

function Extract-WpfComponents {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    $components = @{}
    $xamlFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.xaml" -ErrorAction SilentlyContinue
    
    foreach ($file in $xamlFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $styleMatches = [regex]::Matches($content, '<Style\s+TargetType="\{x:Type\s+([^}]+)\}"')
        foreach ($match in $styleMatches) {
            $targetType = $match.Groups[1].Value
            if (-not $components.ContainsKey($targetType)) {
                $components[$targetType] = @()
            }
            if (-not $components[$targetType].Contains($file.Name)) {
                $components[$targetType] += $file.Name
            }
        }
        
        $templateMatches = [regex]::Matches($content, '<ControlTemplate\s+TargetType="\{x:Type\s+([^}]+)\}"')
        foreach ($match in $templateMatches) {
            $targetType = $match.Groups[1].Value
            $key = "$targetType (Template)"
            if (-not $components.ContainsKey($key)) {
                $components[$key] = @()
            }
            if (-not $components[$key].Contains($file.Name)) {
                $components[$key] += $file.Name
            }
        }
    }
    
    Write-Host "`n=== Extracted WPF Components ==="
    foreach ($key in $components.Keys | Sort-Object) {
        Write-Host "$key - Defined in: $($components[$key] -join ', ')"
    }
    
    return $components
}

function Analyze-WpfProject {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    Write-Host "`n======================================"
    Write-Host "Analyzing WPF Project: $ProjectPath"
    Write-Host "======================================`n"
    
    $colors = Extract-WpfColors -ProjectPath $ProjectPath
    $typography = Extract-WpfTypography -ProjectPath $ProjectPath
    $components = Extract-WpfComponents -ProjectPath $ProjectPath
    
    $result = @{
        colors = $colors
        typography = $typography
        components = $components
    }
    
    return $result
}