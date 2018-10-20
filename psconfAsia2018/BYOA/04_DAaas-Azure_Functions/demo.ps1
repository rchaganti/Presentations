Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
    ServicePoint srvPoint, X509Certificate certificate,
    WebRequest request, int certificateProblem) {
        return true;
    }
}
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$allProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $allProtocols

#Get Infrastruture Type
$uri = 'https://psconfsg2019.azurewebsites.net/api/InfrastructureType?code=Va5NmNoZXz1FC4ZFuYioWKZU6HJYCQGYTn8B47IsLWZUapDiewz/PQ=='
Invoke-RestMethod -Method GET -UseBasicParsing -Uri $uri

#Get Usage Model
$uri = 'https://psconfsg2019.azurewebsites.net/api/usageModel?code=mmnaETvJO2vIfCZxGgnwklmcMFzETrhdPeMqaxikmq/cq5KqH1W2gw==&infrastructureType=Microsoft Storage Spaces Direct'
Invoke-RestMethod -Method GET -UseBasicParsing -Uri $uri

#Get Deployment Model
$uri = 'https://psconfsg2019.azurewebsites.net/api/deploymentModel?code=tzpj/Qqo54ycyz3SVPanX5Nxgu8IO6bdnhUwpCpMDZal3K/DC35iLw==&infrastructureType="Microsoft Storage Spaces Direct"&usageModel="Hyper-Converged Infrastructure"'
Invoke-RestMethod -Method GET -UseBasicParsing -Uri $uri
