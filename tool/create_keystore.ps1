# Créer la clé pour signer l'app sur le Play Store
# Lancer depuis le dossier du projet : .\tool\create_keystore.ps1

$ErrorActionPreference = 'Stop'

$keytool = 'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe'
if (-not (Test-Path $keytool)) {
    Write-Host "keytool introuvable : $keytool" -ForegroundColor Red
    exit 1
}

$dir = Join-Path $PSScriptRoot '..\keystore'
$dir = [System.IO.Path]::GetFullPath($dir)
$jks = Join-Path $dir 'upload-keystore.jks'
$props = Join-Path $dir 'keystore.properties'

if (Test-Path $jks) {
    Write-Host "Une clé existe déjà : $jks" -ForegroundColor Yellow
    Write-Host 'Je ne touche à rien (la remplacer empêcherait les mises à jour).'
    exit 1
}

New-Item -ItemType Directory -Force $dir | Out-Null

$secure = Read-Host 'Mot de passe de la clé (6 caractères minimum)' -AsSecureString
$check = Read-Host 'Retape le mot de passe' -AsSecureString
$password = [System.Net.NetworkCredential]::new('', $secure).Password
if ($password -ne [System.Net.NetworkCredential]::new('', $check).Password) {
    Write-Host 'Les deux mots de passe sont différents.' -ForegroundColor Red
    exit 1
}
if ($password.Length -lt 6) {
    Write-Host 'Mot de passe trop court.' -ForegroundColor Red
    exit 1
}
if ($password -notmatch '^[\x21-\x7E]+$') {
    Write-Host 'Pas d''accents ni d''espaces dans le mot de passe.' -ForegroundColor Red
    exit 1
}
$escaped = $password -replace '\\', '\\'

& $keytool -genkeypair -v `
    -keystore $jks `
    -storetype PKCS12 `
    -keyalg RSA -keysize 2048 -validity 10000 `
    -alias upload `
    -storepass $password -keypass $password `
    -dname 'CN=Meuh Score'
if ($LASTEXITCODE -ne 0) { exit 1 }

@"
storePassword=$escaped
keyPassword=$escaped
keyAlias=upload
storeFile=$($jks -replace '\\', '/')
"@ | Set-Content -Encoding ascii $props

Write-Host ''
Write-Host "Clé créée : $jks" -ForegroundColor Green
Write-Host 'Sauvegarde le dossier keystore (clé USB, cloud perso...) et le mot de passe dans NordPass.'
