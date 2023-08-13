#build the connection template parameters, according to the connector definition instructions
function Get-ConnectionsTemplateParameters($activeResource){

    $paramTestForDefinition = [PSCustomObject]@{
        defaultValue = "connectorDefinitionName";
        type = "string";
        minLength = 1;
    }

    $workspaceParameter = [PSCustomObject]@{
        defaultValue = "[parameters('workspace')]";
        type = "string";
    }

    $dcrConfigParameter = [PSCustomObject]@{
        defaultValue = [PSCustomObject]@{
            dataCollectionEndpoint = "data collection Endpoint";
            dataCollectionRuleImmutableId = "data collection rule immutableId";
        };
        type = "object";
    }

    $templateParameter = [PSCustomObject]@{
        connectorDefinitionName = $paramTestForDefinition;
        workspace = $workspaceParameter;
        dcrConfig = $dcrConfigParameter;
    }

    $connectorDefinitionObject =  $activeResource | where-object -Property "type" -eq 'Microsoft.OperationalInsights/workspaces/providers/dataConnectorDefinitions'
    foreach ($instructionSteps in $connectorDefinitionObject.properties.connectorUiConfig.instructionSteps) {
        foreach ($instruction in $instructionSteps.instructions){
            if($instruction.type -eq "Textbox")
            {
                $newParameter = [PSCustomObject]@{
                    defaultValue = $instruction.parameters.name;
                    type = "string";
                    minLength = 1;
                }
                $templateParameter | Add-Member -MemberType NoteProperty -Name $instruction.parameters.name -Value $newParameter
            }
            elseif($instruction.type -eq "OAuthForm")
            {
                $newParameter = [PSCustomObject]@{
                    defaultValue = "-NA-";
                    type = "string";
                    minLength = 1;
                }
                $templateParameter | Add-Member -MemberType NoteProperty -Name "ClientId" -Value $newParameter
                $templateParameter | Add-Member -MemberType NoteProperty -Name "ClientSecret" -Value $newParameter
                $templateParameter | Add-Member -MemberType NoteProperty -Name "AuthorizationCode" -Value $newParameter
            }
            
        }
    }

    return $templateParameter;
}