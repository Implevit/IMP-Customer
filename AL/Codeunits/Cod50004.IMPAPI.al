codeunit 50004 BCConnector
{
    var
        ClientIdTxt: Label 'ade320f7-954c-4a37-9363-17b1069e5edc'; // '3870c15c-5700-4704-8b1b-e020052cc860';
        ClientSecretTxt: Label 'a56393cd-6963-4adf-a10b-491ca05fc090'; // '~FJRgS5q0YsAEefkW-_pA4ENJ_vIh-5RV9';
        AadTenantIdTxt: Label '06e77f86-5e8f-4477-8004-535d939ff179'; // 'kauffmann.nl';
        AuthorityTxt: Label 'https://login.microsoftonline.com/{AadTenantId}/oauth2/v2.0/token';
        BCEnvironmentNameTxt: Label 'sandbox_yma'; // 'sandbox';
        BCCompanyIdTxt: Label '0987d6a4-fb7c-eb11-b853-000d3abf1475';
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
                Error('Request to Business Central failed\%', GetLastErrorText());

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
            Error('Failed to retrieve access token\', GetLastErrorText());
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