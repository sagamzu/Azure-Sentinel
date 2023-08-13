<h2>Create Solution template for data Connectors</h2></br>

Please go over the following steps to generate a solution template:
- Add under "input" directory the relevant ARM resources files in Json format(dataConnectorDefinition, DataConnectors, DCR, tables). </br>
Each resource should have the right resource type:
  - Table: Microsoft.OperationalInsights/workspaces/tables
  - Dcr: Microsoft.Insights/dataCollectionRules
  - DataConnectorDefinitions: Microsoft.SecurityInsights/dataConnectorDefinitions
  - DataConnectors: Microsoft.SecurityInsights/dataConnectors

- Update input/solutionMetadata.json file properties values according to your solution.</br>
Please note `SolutionTier` should be one of the follwing values: Community, Partner, Microsoft
- Update the dataConnectors resources (under "input" directory) to use the connector definition parameters. </br>
   - the connector parameters will be added to the template service according to the instuctions steps in the dataConnectorDefinition resource
   - parameters usage example: 
     - ConnectorDefinition resource has definition for 'organization' input text
     - Dataconnector resource, can use the 'organization' property value as part of the resource.</br>
    "request.apiEndpoint" property value can be: </br>
   "[[concat('https://api.meraki.com/api/v1/organizations/',parameters('organization'),'/networks']" </br>
   Note: the string with a parameter reference start with double '[' and end with one ']', this is due to template spec syntax for using parameters in nestead template
- Execute the createSolutionV3.ps script, the script will generate a new file "mainTemplate.json" for the template.