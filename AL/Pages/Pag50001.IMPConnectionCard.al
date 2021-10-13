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
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Dns; Rec.Dns)
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
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                }
                field("Authorisation No."; Rec."Authorisation No.")
                {
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if (Rec.Url <> '') then
                            Hyperlink(Rec.Url);
                    end;
                }
            }
            group(GrpEnvironment)
            {
                Caption = 'Environment';

                field(Environment; Rec.Environment)
                {
                    ApplicationArea = All;
                }
                field("Environment Type"; Rec."Environment Type")
                {
                    ApplicationArea = All;
                }
                field("Environment Name"; Rec."Environment Name")
                {
                    ApplicationArea = All;
                }
                field("Environment Id"; Rec."Environment Id")
                {
                    ApplicationArea = All;
                }
                field("Environment State"; Rec."Environment State")
                {
                    ApplicationArea = All;
                }
            }
            group(GrpServerInstance)
            {
                Caption = 'Service';

                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                }
                field("Service State"; Rec."Service State")
                {
                    ApplicationArea = All;
                }
                field("Service NAV Version"; Rec."Service NAV Version")
                {
                    ApplicationArea = All;
                }
                field("Service Version"; Rec."Service Version")
                {
                    ApplicationArea = All;
                }
                field("Service Full Version"; Rec."Service Full Version")
                {
                    ApplicationArea = All;
                }
                field("Service Account"; Rec."Service Account")
                {
                    ApplicationArea = All;
                }
            }
            group(GrpPorts)
            {
                Caption = 'Ports';

                field(ManagementServicesPort; Rec.ManagementServicesPort)
                {
                    ApplicationArea = All;
                }
                field(ClientServicesPort; Rec.ClientServicesPort)
                {
                    ApplicationArea = All;
                }
                field(SOAPServicesPort; Rec.SOAPServicesPort)
                {
                    ApplicationArea = All;
                }
                field(ODataServicesPort; Rec.ODataServicesPort)
                {
                    ApplicationArea = All;
                }
                field(DeveloperServiceServerPort; Rec.DeveloperServiceServerPort)
                {
                    ApplicationArea = All;
                }
            }
            group(GrpDatabase)
            {
                Caption = 'SQL Server';

                field(DatabaseServer; Rec.DatabaseServer)
                {
                    ApplicationArea = All;
                }
                field(DatabaseInstance; Rec.DatabaseInstance)
                {
                    ApplicationArea = All;
                }
                field(DatabaseName; Rec.DatabaseName)
                {
                    ApplicationArea = All;
                }
            }
            group(GrpCredential)
            {
                Caption = 'Credential';

                field(ClientServicesCredentialType; Rec.ClientServicesCredentialType)
                {
                    ApplicationArea = All;
                }
                field(ServicesCertificateThumbprint; Rec.ServicesCertificateThumbprint)
                {
                    ApplicationArea = All;
                }

            }
            group(GrpCompany)
            {
                Caption = 'Company';

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
        Rec.NewRecord(BelowxRec, '', Rec);
    end;

    #endregion Triggers

}
