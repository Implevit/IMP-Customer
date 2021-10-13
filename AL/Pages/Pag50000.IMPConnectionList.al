page 50000 "IMP Connection List"
{
    Caption = 'Connections';
    PageType = List;
    SourceTable = "IMP Connection";
    SourceTableView = sorting("List Name");
    CardPageId = "IMP Connection Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = All;
                }
                field(Dns; Rec.Dns)
                {
                    ApplicationArea = All;
                }
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
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;

                }
                field("Company Id"; Rec."Company Id")
                {
                    ApplicationArea = All;
                }
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
                field(ClientServicesCredentialType; Rec.ClientServicesCredentialType)
                {
                    ApplicationArea = All;
                }
                field(ServicesCertificateThumbprint; Rec.ServicesCertificateThumbprint)
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
            /*
            action(ActLoadSimpleServices)
            {
                Caption = 'Load Simple Service List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                begin
                    ImpAdmn.LoadSimpleServerList();
                    CurrPage.Update(true);
                end;
            }
            action(ActLoadFullServices)
            {
                Caption = 'Load Full Service List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                begin
                    ImpAdmn.LoadFullServerList(true, true);
                    CurrPage.Update(true);
                end;
            }
            action(ActLoadVersionList)
            {
                Caption = 'Load Version List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                var
                    lc_List: list of [Text];
                begin
                    lc_List := ImpAdmn.LoadVersionList()
                end;
            }
            */

            group(ActConnections)
            {
                Caption = 'Connections';

                action(ActConnectionsGetConnection)
                {
                    Caption = 'Get connection';
                    ApplicationArea = All;
                    Image = Web;

                    trigger OnAction()
                    var
                        lc_Json: JsonObject;
                    begin
                        if ImpMgmt.GetODataConnection(lc_Json, Rec."No.", Rec."Company Name", Rec."Company Id", true) then
                            DatMgmt.JsonExport(Rec.GetAsJsonFileName(), lc_Json);
                    end;
                }
                action(ActConnectionsShowConnection)
                {
                    Caption = 'Show connection';
                    ApplicationArea = All;
                    Image = Web;

                    trigger OnAction()
                    var
                        lc_Json: JsonObject;
                    begin
                        if ImpMgmt.GetODataConnection(lc_Json, Rec."No.", Rec."Company Name", Rec."Company Id", false) then
                            DatMgmt.JsonExport(Rec.GetAsJsonFileName(), lc_Json);
                    end;
                }
                action(ActConnectionsGetAuthorisation)
                {
                    Caption = 'Get Authorisation';
                    ApplicationArea = All;
                    Image = UserCertificate;

                    trigger OnAction()
                    var
                        lc_IA: Record "IMP Authorisation";
                        lc_Json: JsonObject;
                    begin
                        if not lc_IA.Get(Rec."Authorisation No.") then begin
                            lc_IA.Reset();
                            lc_IA.SetCurrentKey("Customer No.");
                            lc_IA.SetRange("Customer No.", Rec."Customer No.");
                            if lc_IA.FindSet() then;
                            if not (Page.RunModal(Page::"IMP Authorisation List", lc_IA) = Action::LookupOK) then
                                exit;
                        end;
                        if ImpMgmt.GetODataAuthorisation(lc_Json, lc_IA."Entry No.", true) then
                            DatMgmt.JsonExport(lc_IA.GetAsJsonFileName(), lc_Json);
                    end;
                }
                action(ActConnectionsShowAuthorisation)
                {
                    Caption = 'Show Authorisation';
                    ApplicationArea = All;
                    Image = UserCertificate;

                    trigger OnAction()
                    var
                        lc_IA: Record "IMP Authorisation";
                        lc_Json: JsonObject;
                    begin
                        if not lc_IA.Get(Rec."Authorisation No.") then begin
                            lc_IA.Reset();
                            lc_IA.SetCurrentKey("Customer No.");
                            lc_IA.SetRange("Customer No.", Rec."Customer No.");
                            if lc_IA.FindSet() then;
                            if not (Page.RunModal(Page::"IMP Authorisation List", lc_IA) = Action::LookupOK) then
                                exit;
                        end;
                        if ImpMgmt.GetODataAuthorisation(lc_Json, lc_IA."Entry No.", false) then
                            DatMgmt.JsonExport(lc_IA.GetAsJsonFileName(), lc_Json);
                    end;
                }
            }

            group(ActServer)
            {
                Caption = 'Server';

                action(ActLoadVersions)
                {
                    Caption = 'Load versions';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallVersionList();
                        CurrPage.Update(false);
                    end;
                }
                action(ActLoadServices)
                {
                    Caption = 'Load services';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    var
                        lc_List: List of [Text];
                        lc_Entry: Text;
                    begin
                        // Call selection
                        lc_List := Rec.SelectVersions(false);
                        // Loop through selected versions
                        foreach lc_Entry in lc_List do
                            ImpAdmn.CallServerList(lc_Entry);
                    end;
                }
            }
        }
    }

    #region Triggers

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Environment, '<>%1', Rec.Environment::Versions);
    end;

    #endregion Triggers

    var
        ImpAdmn: Codeunit "IMP Administration";
        ImpMgmt: Codeunit "IMP Management";
        DatMgmt: Codeunit "IMP Data Management";
}
