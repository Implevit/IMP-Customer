page 50002 "IMP Authorisation List"
{
    Caption = 'Authorisation List';
    PageType = List;
    SourceTable = "IMP Authorisation";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Token; Rec.Token)
                {
                    ApplicationArea = All;
                }
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                }
                field("Secret Id"; Rec."Secret Id")
                {
                    ApplicationArea = All;
                }
                field("Redirect Uri"; Rec."Redirect Uri")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActOAuth2)
            {
                Caption = 'Test OAuth2';
                ApplicationArea = All;
                RunObject = Page "Test OAuth2 Flows";
            }
            action(ActGetToken)
            {
                Caption = 'Get Token';
                ApplicationArea = All;

                trigger OnAction()
                var
                    lc_OAuth2: Codeunit Oauth2;
                    lc_Scopes: List of [Text];
                    lc_MicrosoftOAuth2Url: Text;
                    //lc_OAuthAdminConsentUrl: Text;
                    lc_RedirectUrl: Text;
                    lc_ResourceUrl: Text;
                    lc_Tenant: Text;
                    lc_Client: Text;
                    lc_Username: Text;
                    lc_Password: Text;
                    lc_AccessToken: Text;
                    lc_TokenId: Text;
                    lc_Version: Integer;
                begin
                    lc_Version := 1;
                    // Init
                    lc_AccessToken := '';
                    lc_TokenId := '';
                    lc_Username := 'admin@imlevit.onmicrosoft.com';
                    lc_Password := 'q1BdBIC7D';
                    lc_Tenant := '06e77f86-5e8f-4477-8004-535d939ff179';
                    lc_ResourceUrl := 'https://api.businesscentral.dynamics.com/';
                    // Version 1
                    if (lc_Version = 1) then begin
                        lc_Client := '4ff52ddf-2795-4f85-bc8d-e88bbf508ab1';
                        lc_RedirectUrl := '';
                        lc_RedirectUrl := 'https://login.microsoftonline.com/common/oauth2/nativeclient';
                        lc_OAuth2.GetDefaultRedirectURL(lc_RedirectUrl);
                    end;
                    // Version 2
                    if (lc_Version = 2) then begin
                        lc_Client := '087d0ed0-cfd9-4671-abfc-7e2b965019f7';
                        lc_RedirectUrl := 'https://businesscentral.dynamics.com';
                    end;
                    // Version 3
                    if (lc_Version = 3) then begin
                        lc_Client := 'ade320f7-954c-4a37-9363-17b1069e5edc';
                        lc_RedirectUrl := 'https://login.microsoftonline.com/common/oauth2/nativeclient';
                        //lc_ResourceUrl := 'https://graph.microsoft.com/';
                    end;
                    lc_MicrosoftOAuth2Url := 'https://login.microsoftonline.com/' + lc_Tenant + '/oauth2/v2.0/token';
                    //lc_OAuthAdminConsentUrl := 'https://login.microsoftonline.com/common/adminconsent';
                    lc_Scopes.Add(lc_ResourceUrl + '.default');
                    // Get token
                    lc_OAuth2.AcquireTokensWithUserCredentials(lc_MicrosoftOAuth2Url, lc_Client, lc_Scopes, lc_Username, lc_Password, lc_AccessToken, lc_TokenId);
                    // Check token
                    if (lc_AccessToken <> '') then
                        Message('Token: ' + lc_AccessToken)
                    else
                        Error('No token found!');
                end;
            }
            action(ActGetAPI)
            {
                Caption = 'Get API';
                ApplicationArea = All;

                trigger OnAction()
                var
                    lc_ImpMgmt: Codeunit "IMP Management";
                begin
                    lc_ImpMgmt.CallAPI();
                end;
            }
            action(ActTest)
            {
                Caption = 'Test...';
                ApplicationArea = All;

                trigger OnAction()
                var
                    lc_BCConnector: Codeunit BCConnector;
                begin
                    lc_BCConnector.Run();
                end;
            }
        }
    }
}
