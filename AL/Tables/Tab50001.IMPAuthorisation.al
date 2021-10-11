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
        field(40; Token; Text[100])
        {
            Caption = 'Token';
            DataClassification = CustomerContent;
        }
        field(50; "Client Id"; Text[100])
        {
            Caption = 'Client Id';
            DataClassification = CustomerContent;
        }
        field(60; "Secret Id"; Text[100])
        {
            Caption = 'Secret Id';
            DataClassification = CustomerContent;
        }
        field(70; "Redirect Uri"; Text[250])
        {
            Caption = 'Redirect Uri';
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

    #endregion Methodes

}