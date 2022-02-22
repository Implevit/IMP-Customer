codeunit 50004 BCConnector
{
    var
        ClientIdTxt: Label '087d0ed0-cfd9-4671-abfc-7e2b965019f7';
        ClientSecretTxt: Label 'fva7Q~501hoDnImIUuGucpFXUBEsdt9O-~rEQ';
        AadTenantIdTxt: Label '06e77f86-5e8f-4477-8004-535d939ff179';
        AuthorityTxt: Label 'https://login.microsoftonline.com/{AadTenantId}/oauth2/v2.0/token?resource=https://api.businesscentral.dynamics.com';
        BCEnvironmentNameTxt: Label 'dev1';
        BCCompanyIdTxt: Label '3d6d6b75-6b50-eb11-bb51-000d3aa935c7';
        BCBaseUrlTxt: Label 'https://api.businesscentral.dynamics.com/v2.0/{BCEnvironmentName}/api/v2.0/companies({BCCompanyId})';
        AccessToken: Text;
        AccesTokenExpires: DateTime;

    trigger OnRun()
    var
        Customers: Text;
        Items: Text;
    begin
        Customers := CallBusinessCentralAPI(BCEnvironmentNameTxt, BCCompanyIdTxt, 'customers');
        Items := CallBusinessCentralAPI(BCEnvironmentNameTxt, BCCompanyIdTxt, 'items');
        Message(Customers);
        Message(Items);
    end;

    procedure CallBusinessCentralAPI(BCEnvironmentName: Text; BCCompanyId: Text; Resource: Text) Result: Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Url: Text;
    begin
        if (AccessToken = '') or (AccesTokenExpires = 0DT) or (AccesTokenExpires > CurrentDateTime) then
            GetAccessToken(AadTenantIdTxt);

        Client.DefaultRequestHeaders.Add('Authorization', GetAuthenticationHeaderValue(AccessToken));
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        Url := GetBCAPIUrl(BCEnvironmentName, BCCompanyId, Resource);
        if not Client.Get(Url, Response) then
            if Response.IsBlockedByEnvironment then
                Error('Request was blocked by environment')
            else
                Error('Request to Business Central failed\%1', GetLastErrorText());

        if not Response.IsSuccessStatusCode then
            Error('Request to Business Central failed\%1 %2', Response.HttpStatusCode, Response.ReasonPhrase);

        Response.Content.ReadAs(Result);
    end;

    local procedure GetAccessToken(AadTenantId: Text)
    var
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        Scopes.Add('https://api.businesscentral.dynamics.com/.default');
        if not OAuth2.AcquireTokenWithClientCredentials(ClientIdTxt, ClientSecretTxt, GetAuthorityUrl(AadTenantId), '', Scopes, AccessToken) then
            Error('Failed to retrieve access token\%1', GetLastErrorText());
        AccesTokenExpires := CurrentDateTime + (3599 * 1000);
    end;

    local procedure GetAuthenticationHeaderValue(AccessToken: Text) Value: Text;
    begin
        Value := StrSubstNo('Bearer %1', AccessToken);
    end;

    local procedure GetAuthorityUrl(AadTenantId: Text) Url: Text
    begin
        Url := AuthorityTxt;
        Url := Url.Replace('{AadTenantId}', AadTenantId);
    end;

    local procedure GetBCAPIUrl(BCEnvironmentName: Text; BCCOmpanyId: Text; Resource: Text) Url: Text;
    begin
        Url := BCBaseUrlTxt;
        Url := Url.Replace('{BCEnvironmentName}', BCEnvironmentName)
                  .Replace('{BCCompanyId}', BCCOmpanyId);
        Url := StrSubstNo('%1/%2', Url, Resource);
    end;
}