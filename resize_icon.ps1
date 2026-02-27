    Add-Type -AssemblyName System.Drawing

$sourceIcon = "C:\Users\ilesm\Documents\ICONOS VARIOS SIRH\icon.png"
$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

Write-Host "Cargando imagen original..." -ForegroundColor Cyan
$originalImage = [System.Drawing.Image]::FromFile($sourceIcon)
Write-Host "Dimensiones originales: $($originalImage.Width)x$($originalImage.Height)" -ForegroundColor Yellow

foreach ($folder in $sizes.Keys) {
    $size = $sizes[$folder]
    $outputPath = "android\app\src\main\res\$folder"
    
    if (-not (Test-Path $outputPath)) {
        New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
    }
    
    # Crear bitmap con soporte para transparencia
    $newImage = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($newImage)
    
    # Configurar calidad máxima y transparencia
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Fondo transparente
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # Dibujar imagen redimensionada
    $destRect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
    $srcRect = New-Object System.Drawing.Rectangle(0, 0, $originalImage.Width, $originalImage.Height)
    $graphics.DrawImage($originalImage, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $outputFile = "$outputPath\ic_launcher.png"
    $newImage.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $newImage.Dispose()
    $graphics.Dispose()
    
    Write-Host "✓ Creado: $outputFile ($size x $size)" -ForegroundColor Green
}

$originalImage.Dispose()
Write-Host "`n✅ ¡Iconos creados con transparencia exitosamente!" -ForegroundColor Green
