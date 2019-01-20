Import-Module SHiPS -Force
Import-Module C:\GitHub\PSGalleryDrive\PSGalleryDrive.psm1 -Force

New-PSDrive -Name psg -PSProvider SHiPS -Root 'PSGalleryDrive#PSGRoot'