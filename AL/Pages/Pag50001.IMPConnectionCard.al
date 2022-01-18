page 50001 "IMP Connection Card"
{
    Caption = 'Connection';
    PageType = Card;
    SourceTable = "IMP Connection";

    layout
    {
        area(content)
        {
            group(GrpGeneral)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(Server; Rec.Server)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Customer Abbreviation"; Rec."Customer Abbreviation")
                {
                    ApplicationArea = All;
                }
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if (Rec.Url <> '') then
                            Hyperlink(Rec.Url);
                    end;
                }
                field("WebService In Launch"; Rec."WebService In Launch")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(GrpEnvironment)
            {
                Caption = 'Environment';

                field(Environment; Rec.Environment)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Environment Type"; Rec."Environment Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Environment Name"; Rec."Environment Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Visible = ShowEnvironment;
                }
                field("Environment Id"; Rec."Environment Id")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                    Visible = ShowEnvironment;
                }
                field("Environment State"; Rec."Environment State")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                    Visible = ShowEnvironment;
                }
            }
            group(GrpServerInstance)
            {
                Caption = 'Service';
                Visible = ShowService;

                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Service State"; Rec."Service State")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Service NAV Version"; Rec."Service NAV Version")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Service Version"; Rec."Service Version")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Service Full Version"; Rec."Service Full Version")
                {
                    ApplicationArea = All;
                }
                field("Service Account"; Rec."Service Account")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(GrpPorts)
            {
                Caption = 'Ports';
                Visible = ShowPorts;

                field(ManagementServicesPort; Rec.ManagementServicesPort)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(ClientServicesPort; Rec.ClientServicesPort)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(SOAPServicesPort; Rec.SOAPServicesPort)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(ODataServicesPort; Rec.ODataServicesPort)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(DeveloperServicesPort; Rec.DeveloperServicesPort)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
            }
            group(GrpDatabase)
            {
                Caption = 'SQL Server';
                Visible = ShowDatabase;

                field(DatabaseServer; Rec.DatabaseServer)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(DatabaseInstance; Rec.DatabaseInstance)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(DatabaseName; Rec.DatabaseName)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(GrpCredential)
            {
                Caption = 'Credential';
                Visible = ShowCredential;

                field(ClientServicesCredentialType; Rec.ClientServicesCredentialType)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(ServicesCertificateThumbprint; Rec.ServicesCertificateThumbprint)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

            }
            group(GrpAuthorisation)
            {

                Caption = 'Authorisation';
                Visible = ShowAuthorisation;

                field("Authorisation No."; Rec."Authorisation No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        GetDetail();
                    end;
                }
                field(AuthorisationName; Authorisation.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
            }
            group(GrpCompany)
            {
                Caption = 'Company';
                Visible = ShowCompany;

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Company Id"; Rec."Company Id")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
        }
    }

    #region Triggers

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Set new
        Rec.NewRecord(BelowxRec, Rec.GetFilter("Customer No."), Rec);

        // Set visibility
        ShowPorts := (Rec.Environment <> Rec.Environment::Cloud);
        ShowService := (Rec.Environment <> Rec.Environment::Cloud);
        ShowDatabase := (Rec.Environment <> Rec.Environment::Cloud);
        ShowCredential := (Rec.Environment <> Rec.Environment::Cloud);
        ShowCompany := (Rec.Environment = Rec.Environment::Cloud);
        ShowAuthorisation := true; // (Rec.Environment = Rec.Environment::Cloud);
        ShowEnvironment := (Rec.Environment <> Rec.Environment::Service);

        // Show deatil
        GetDetail();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec."Service State" := CopyStr(Rec.GetStatusToRemove(), 1, MaxStrLen(Rec."Service State"));
        Rec."Service Status" := Rec."Service Status"::ToRemove;
    end;

    trigger OnOpenPage()
    begin
        // Set visibility
        ShowPorts := (Rec.Environment <> Rec.Environment::Cloud);
        ShowService := (Rec.Environment <> Rec.Environment::Cloud);
        ShowDatabase := (Rec.Environment <> Rec.Environment::Cloud);
        ShowCredential := (Rec.Environment <> Rec.Environment::Cloud);
        ShowCompany := (Rec.Environment = Rec.Environment::Cloud);
        ShowAuthorisation := true; // (Rec.Environment = Rec.Environment::Cloud);
        ShowEnvironment := (Rec.Environment <> Rec.Environment::Service);

        // Show deatil
        GetDetail();
    end;

    trigger OnClosePage()
    var
        lc_AdmMgmt: Codeunit "IMP Administration";
    begin
        if ((Rec."No." <> '') and (Rec.Environment = Rec.Environment::Service)) then
            case Rec."Service Status" of
                Rec."Service Status"::ToCreate:
                    lc_AdmMgmt.CallServiceCreate(Rec, true, true);
                Rec."Service Status"::ToRemove:
                    lc_AdmMgmt.CallServiceAction(Rec, IMPServiceStatus::ToRemove, true, true);
            end;
    end;

    #endregion Triggers

    #region Methodes

    local procedure GetDetail()
    begin
        if not Authorisation.Get(Rec."Authorisation No.") then
            Authorisation.Init();
    end;

    #endregion Methodes

    var
        Authorisation: Record "IMP Authorisation";
        ShowCompany: Boolean;
        ShowAuthorisation: Boolean;
        ShowPorts: Boolean;
        ShowService: Boolean;
        ShowDatabase: Boolean;
        ShowCredential: Boolean;
        ShowEnvironment: Boolean;
}
