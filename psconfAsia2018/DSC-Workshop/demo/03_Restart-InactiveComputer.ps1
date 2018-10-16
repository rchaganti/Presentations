function Restart-InactiveComputer
{
    if (-not ( Get-Process explorer -ErrorAction SilentlyContinue ) )
    {
        Restart-Computer -Force
    }
}