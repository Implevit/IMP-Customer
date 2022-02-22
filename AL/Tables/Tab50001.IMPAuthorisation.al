table 50001 "IMP Authorisation"
{
    Caption = 'Authorisation';
    DataClassification = ToBeClassified;
    LookupPageId = "IMP Authorisation List";
    DrillDownPageId = "IMP Authorisation List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; Type; Enum IMPHttpAuthorisation)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(11; "User Type"; Option)
        {
            Caption = 'User Type';
            OptionMembers = O365,NAVUser,Windows,Webservice;
            OptionCaption = 'O365,NAVUser,Windows,Webservice';
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(30; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(31; Password; Text[50])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }
        field(40; Token; Text[250])
        {
            Caption = 'Token';
            DataClassification = CustomerContent;
        }
        field(50; "Client Id"; Text[100])
        {
            Caption = 'Client Id';
            DataClassification = CustomerContent;
        }
        field(60; "Client Secret"; Text[100])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
        }
        field(70; "Callback URL"; Text[250])
        {
            Caption = 'Callbarck URL';
            DataClassification = CustomerContent;
        }
        field(80; "Auth URL"; Text[250])
        {
            Caption = 'Auth URL';
            DataClassification = CustomerContent;
        }
        field(90; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; Name, Type, "Client Id")
        {
        }
        key(Key3; "Customer No.")
        {
        }
    }

    #region Triggers

    trigger OnInsert()
    var
        lc_Rec: Record "IMP Authorisation";
    begin
        if (Rec."Entry No." = 0) then begin
            lc_Rec.Reset();
            if lc_Rec.FindLast() then
                Rec."Entry No." := lc_Rec."Entry No." + 1
            else
                Rec."Entry No." := 1;
        end;
    end;

    #endregion Triggers

    #region Methodes

    procedure GetAsJsonFileName() RetValue: Text
    begin
        RetValue := Rec."Customer No." + '-' + Rec.Name;
        RetValue := RetValue.Replace(' ', '');
        RetValue := RetValue.Replace('/', '');
        RetValue := RetValue.Replace('\', '');
        RetValue := RetValue.Replace('@', 'à');
        RetValue += '.json';
    end;

    procedure SetMicrosoftAuthorisation(_TenantId: Text)
    begin
        if (_TenantId = '') then
            exit;

        Rec."Auth URL" := CopyStr('https://login.windows.net/' + _TenantId + '/oauth2/authorize?resource=https://api.businesscentral.dynamics.com', 1, MaxStrLen(Rec."Auth URL"));
        Rec."Access Token URL" := CopyStr('https://login.windows.net/' + _TenantId + '/oauth2/token?resource=https://api.businesscentral.dynamics.com', 1, MaxStrLen(Rec."Access Token URL"));
        Rec."Callback URL" := 'https://api.businesscentral.dynamics.com/.default';
        Rec.Modify(true);
    end;

    #endregion Methodes

}