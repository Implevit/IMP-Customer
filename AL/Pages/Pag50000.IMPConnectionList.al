page 50000 "IMP Connection List"
{
    Caption = 'Connections';
    PageType = List;
    SourceTable = "IMP Connection";
    SourceTableView = sorting("List Name") where(Environment = Filter(Server | Service | Docker | Cloud));
    CardPageId = "IMP Connection Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(GrpFilters)
            {
                Caption = 'Filters';
                Visible = ShowFilter;

                grid(GrpFilterLine)
                {
                    GridLayout = Rows;

                    field(ServerFilter; ServerFilter)
                    {
                        Caption = 'Server';
                        ApplicationArea = All;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ValidateSetFilter();
                        end;

                        trigger OnDrillDown()
                        begin
                            SelectServerFilter();
                        end;
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        Caption = 'Customer';
                        ApplicationArea = All;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ValidateSetFilter();
                        end;

                        trigger OnDrillDown()
                        begin
                            SelectCustomerNoFilter();
                        end;
                    }
                    field(Version; Version)
                    {
                        Caption = 'Version';
                        ApplicationArea = All;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ValidateSetFilter();
                        end;

                        trigger OnDrillDown()
                        begin
                            SelectVersionFilter();
                        end;
                    }
                }
            }

            repeater(Group)
            {
                FreezeColumn = "List Name";

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Server; Rec.Server)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
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
                    Enabled = false;
                }
                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                }
                field("Service State"; Rec."Service State")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field("Service Status"; Rec."Service Status")
                {
                    ApplicationArea = All;
                    Enabled = false;
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
                    Editable = false;
                }
                field(SOAPServicesPort; Rec.SOAPServicesPort)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ODataServicesPort; Rec.ODataServicesPort)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DeveloperServiceServerPort; Rec.DeveloperServiceServerPort)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                Image = Web;

                action(ActConnectionsGetConnection)
                {
                    Caption = 'Get connection';
                    ApplicationArea = All;
                    Image = Export;

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
                    Image = Link;

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
                    Image = Export;

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
                action(ActConnectionsServiceLoad)
                {
                    Caption = 'Load connections';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServerLists(true, true);
                    end;
                }
            }
            group(ActService)
            {
                Caption = 'Service';
                Image = SetupLines;
                Enabled = EnableService;

                action(ActServiceShow)
                {
                    Caption = 'Show';
                    ApplicationArea = All;
                    Image = ShowList;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServerDetail(Rec);
                    end;
                }
                action(ActServiceEdit)
                {
                    Caption = 'Edit';
                    ApplicationArea = All;
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServerDetailEdit(Rec);
                    end;
                }
                action(ActServiceStart)
                {
                    Caption = 'Start';
                    ApplicationArea = All;
                    Image = Start;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToStart, true, true);
                    end;
                }
                action(ActServiceRestart)
                {
                    Caption = 'Restart';
                    ApplicationArea = All;
                    Image = NextSet;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToRestart, true, true);
                    end;
                }
                action(ActServiceStop)
                {
                    Caption = 'Stop';
                    ApplicationArea = All;
                    Image = Stop;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToStop, true, true);
                    end;
                }
                action(ActServiceCreate)
                {
                    Caption = 'Create';
                    ApplicationArea = All;
                    Image = New;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceCreate(Rec, true, true);
                    end;
                }
                action(ActServiceRemove)
                {
                    Caption = 'Remove';
                    ApplicationArea = All;
                    Image = Delete;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToRemove, true, true);
                    end;
                }
            }
        }
    }

    #region Triggers

    trigger OnOpenPage()
    begin
        ServerFilter := Rec.GetFilter(Server);
        CustomerNo := Rec.GetFilter("Customer No.");
        Version := Rec.GetFilter("Service Version");
        ShowFilter := ((ServerFilter = '') and (CustomerNo = '') and (Version = ''));
        if (ServerFilter = '') then
            ServerFilter := ImpAdmn.GetCurrentComputerName();
        ValidateSetFilter();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        EnableService := (Rec.Environment = Rec.Environment::Service);
    end;

    #endregion Triggers

    #region Methods

    procedure SelectServerFilter()
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Reset();
        if (ServerFilter <> '') then
            lc_IS.SetFilter(Name, ServerFilter);
        if lc_IS.FindSet() then;
        lc_IS.SetRange(Name);
        if Page.RunModal(Page::"IMP Server List", lc_IS) = Action::LookupOK then begin
            if (ServerFilter <> '') then
                ServerFilter += '|';
            ServerFilter += lc_IS.Name;
        end;
        ValidateSetFilter();
    end;

    procedure SelectCustomerNoFilter();
    var
        lc_Cust: Record Customer;
    begin
        lc_Cust.Reset();
        if (CustomerNo <> '') then
            lc_Cust.SetRange("No.", CustomerNo);
        lc_Cust.SetFilter("IMP Abbreviation", '<>%1', '');
        if lc_Cust.FindSet() then;
        lc_Cust.SetRange("No.");
        if Page.RunModal(0, lc_Cust) = Action::LookupOK then begin
            CustomerNo := lc_Cust."No.";
            ValidateSetFilter();
        end;
    end;

    procedure SelectVersionFilter();
    var
        lc_IS: Record "IMP Server";
        lc_List: List of [Text];
        lc_Entry: Text;
    begin
        lc_IS.Get(ImpAdmn.GetCurrentComputerName());
        lc_List := lc_IS.NAVVersionsSelect(false);
        Version := '';
        foreach lc_Entry in lc_List do begin
            if (Version <> '') then
                Version += '|';
            Version += lc_Entry;
        end;
        ValidateSetFilter();
    end;

    procedure ValidateSetFilter()
    begin
        if (ServerFilter = '') then
            Rec.SetRange(Server)
        else
            Rec.SetFilter(Server, ServerFilter);

        if (CustomerNo = '') then
            Rec.SetRange("Customer No.")
        else
            Rec.SetFilter("Customer No.", CustomerNo);

        if (Version = '') then
            Rec.SetRange("Service Version")
        else
            Rec.SetFilter("Service Version", Version);
        CurrPage.Update(true);
    end;

    #endregion Methods

    var
        ImpAdmn: Codeunit "IMP Administration";
        ImpMgmt: Codeunit "IMP Management";
        DatMgmt: Codeunit "IMP Data Management";
        EnableService: Boolean;
        ShowFilter: Boolean;
        ServerFilter: Text;
        CustomerNo: Text;
        Version: Text;
}
