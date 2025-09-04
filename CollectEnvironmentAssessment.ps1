[CmdletBinding()]
param (
    # Indicates CSV file for input
    [Parameter()][string]
    $ContentFile ,

    # Minimum level for inclusion in summary (defaults to High)
    [Parameter()][string]
    $DataverseEnvironmentUrl ,

    # Minimum level for inclusion in summary (defaults to High)
    [Parameter()][string]
    $DataverseClientId ,

    # Minimum level for inclusion in summary (defaults to High)
    [Parameter()][string]
    $DataverseClientSecret ,

    # Show Top N Recommendations Per Slide (default 6)
    [Parameter()][int]
    $ShowTop = 6 ,

    [Parameter()]
    [switch] $CloudAdoption,

    [Parameter()]
    [switch] $DevOpsCapability

)
#region CSV Files
#=========================================================================
#Working with CSV Files
#=========================================================================
function ReadPatternFile($fileLocation){
    # Import the CSV file
    $testData = Import-Csv -Path $fileLocation
        $patternData = Import-Csv $fileLocation | ForEach-Object {
        if($_.PatternType -eq "DataversePattern"){
        [PSCustomObject]@{
            PatternType  = $_.PatternType
            Age   = $_.Answer
            City  = $_.PatternSeverity
            }
            $dataversePatterns += $_
        }
    }

}
function BuildCsvFile($content, $fileLocation){
# Define an array of objects with the required properties
$data = @(
    [PSCustomObject]@{
        PatternId          = 1
        PatternCategory    = "Security"
        PatternDocLink     = "https://example.com/pattern1"
        PatternRule        = "Rule1"
        PatternCondition   = "Condition1"
        PatternValue       = "Value1"
        PatternDescription = "Description of Pattern 1"
        PatternScore       = 85
        PatternSeverity    = "High"
        PatternType        = "Type1"
    },
    [PSCustomObject]@{
        PatternId          = 2
        PatternCategory    = "Performance"
        PatternDocLink     = "https://example.com/pattern2"
        PatternRule        = "Rule2"
        PatternCondition   = "Condition2"
        PatternValue       = "Value2"
        PatternDescription = "Description of Pattern 2"
        PatternScore       = 70
        PatternSeverity    = "Medium"
        PatternType        = "Type2"
    }
)

# Export the data to a CSV file
$data | Export-Csv -Path .\PatternsResults.csv -NoTypeInformation -Encoding UTF8

Write-Host "CSV file 'Patterns.csv' has been created successfully."
}
#endregion

#region Dataverse DAL
function ConnectToDataverseEnvironment(){
    #Establish Connecton Object using OAuth and S2S User
    $conn = Get-CrmConnection -ConnectionString "AuthType=ClientSecret;Url=https://orgb7c3ba80.crm.dynamics.com;ClientId=d8f0b403-936c-4f2f-8ca9-ffed01fe534d;ClientSecret=KOt8Q~uLThJRRA25ONqn57EuhXt9HcTRYx3KYa76"
    
    #Display D365 Org Name
    Write-Host 'You are now connected to ' + $conn.ConnectedOrgFriendlyName
    return $conn
}
function Get-SecurityRole(){
    param(
        [string] $securityRole
    )

    ##this gets all the roles ids from each BU
    $secRole = Get-CrmRecords -EntityLogicalName role -Fields name -FilterAttribute name -FilterOperator "eq" -filtervalue $securityRole
    return $secRole.CrmRecords[0].roleid
}
function Get-User(){
    param(
        [string] $emailAddress
    )

    $crmUser = Get-CrmRecords -EntityLogicalName systemuser -FilterAttribute domainname -FilterOperator eq -FilterValue $emailAddress
    return $crmUser.CrmRecords[0].systemuserid
}
#region Get Current Environment Setup
function ReadSolutionHistory($conn){
    $qe = new-object Microsoft.Crm.Sdk.Messages.FetchXmlToQueryExpressionRequest 
    $qe.FetchXml=@"
    <fetch version='1.0' mapping='logical'>
  <entity name='msdyn_solutionhistory'>
    <order attribute='msdyn_starttime' descending='true' />
    <filter type='and'>
      <condition attribute='msdyn_starttime' operator='last-month' />
      <condition attribute='msdyn_result' operator='eq' value='0' />
    </filter>
  </entity>
</fetch>
"@

$solutionHistories = Get-CrmRecordsByFetch -conn $conn -Fetch $qe.FetchXml

}
function GetEnvironmentSettings($conn){
    return Get-CrmSystemSettings -conn $conn 
}
function GetFeatureEnabledState($conn, $featureName){
        $featureStateRequest = [PSCustomObject]@{
            FeatureName = $featureName
            } | ConvertTo-Json
        $header = @{authorization = "Bearer $($conn.CurrentAccessToken)"}
        $featureStateResponse = Invoke-WebRequest "$($conn.ConnectedOrgPublishedEndpoints['WebApplication'])/api/data/v9.2/GetFeatureEnabledState" -Headers $header -Method Post -ContentType 'application/json' -Body $featureStateRequest
        $jsonContent = $featureStateResponse.Content | ConvertFrom-Json
        return $jsonContent.IsFeatureEnabled
}
#endregion
#endregion

#region Dataverse BL
function ProcessDataversePatterns($dataversePatterns){

    if ($dataversePatterns.Count -gt 0){
     # Dataverse Operations
        $dataverseConn = ConnectToDataverseEnvironment
        $solutionHistories = ReadSolutionHistory -conn $dataverseConn
        $environmentSettings = GetEnvironmentSettings -conn $dataverseConn
        GetFeatureEnabledState -conn $dataverseConn -featureName 'EnableDesktopFlowShareVanillaImage'

    }

}
#endregion

#region Assessment Helpers
function StartRiskAssessment(){


}
function GetRiskAssessment(){


}
#endregion

#region Get Power Platform Recommendations
function GetPowerPlatformApiRecommendations(){


}
#endregion


# Import Micrsoft.Xrm.Data.Powershell module 
        #Prework - Install Xrm.PowerShell module 
        #uncomment below if you have not installed or in DevOps....
        #===================================================================================
        #Set-ExecutionPolicy –ExecutionPolicy RemoteSigned –Scope CurrentUser
        #Install-Module Microsoft.Xrm.Data.PowerShell -Scope CurrentUser -Force -verbose
        #===================================================================================
Import-Module Microsoft.Xrm.Data.Powershell

# Initialize variables
$dataversePatterns = @()

# Get Patterns To Check
$patternFile = ReadPatternFile -fileLocation "C:\Data\Patterns.csv"



# Power Platform Operations



# Build Assessment Results
BuildCsvFile -content "test" -fileLocation "C:/Data"


$appKey=""
$appId=""
$resource="https://api5.applicationinsights.io"
$secpasswd = ConvertTo-SecureString $appKey -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($appId, $secpasswd)

#Connect-AzAccount -ServicePrincipal -Tenant "hanxia.onmicrosoft.com" -Credential $mycreds
#$res=Get-AzAccessToken -ResourceUrl $resource


#$headers=@{"Authorization"="Bearer "+$res.Token}
#$body=@{"timespan"="P7D"; "query"="requests| summarize totalCount=sum(itemCount) by bin(timestamp, 30m)"}| ConvertTo-Json

#Invoke-RestMethod 'https://api.applicationinsights.io/v1/apps/bd7cacd8-9607-4b53-b57b-995255292f36/query' -Method 'POST' -Headers $headers -Body $body -ContentType "application/json"