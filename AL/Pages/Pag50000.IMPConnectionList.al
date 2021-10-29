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

                grid(GrpFilterLine)
                {
                    GridLayout = Rows;

                    field(EnvironmentName; EnvironmentName)
                    {
                        Caption = 'Environment';
                        ApplicationArea = All;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ValidateEnvironmentName();
                        end;

                        trigger OnDrillDown()
                        begin
                            SelectEnvironmentNameFilter();
                        end;
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        Caption = 'Customer';
                        ApplicationArea = All;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ValidateCustomerNoFilter();
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
                            ValidateVersionFilter();
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
            }
            group(ActServer)
            {
                Caption = 'Server';
                Image = Setup;

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

                action(ActShowServerDetails)
                {
                    Caption = 'Show';
                    ApplicationArea = All;
                    Image = ShowList;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServerDetail(Rec);
                    end;
                }
                action(ActEditServerDetails)
                {
                    Caption = 'Edit';
                    ApplicationArea = All;
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServerDetailEdit(Rec);
                    end;
                }
                action(ActEditServerStart)
                {
                    Caption = 'Start';
                    ApplicationArea = All;
                    Image = Start;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToStart, true, true);
                    end;
                }
                action(ActEditServerReStart)
                {
                    Caption = 'Restart';
                    ApplicationArea = All;
                    Image = NextSet;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToRestart, true, true);
                    end;
                }
                action(ActEditServerStop)
                {
                    Caption = 'Stop';
                    ApplicationArea = All;
                    Image = Stop;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceAction(Rec, IMPServiceStatus::ToStop, true, true);
                    end;
                }
                action(ActEditServerCreate)
                {
                    Caption = 'Create';
                    ApplicationArea = All;
                    Image = New;

                    trigger OnAction()
                    begin
                        ImpAdmn.CallServiceCreate(Rec, true, true);
                    end;
                }
                action(ActEditServerRemove)
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
        LoadServerFilter();
        EnvironmentName := Rec.GetFilter("Environment Name");
        CustomerNo := Rec.GetFilter("Customer No.");
        Version := Rec.GetFilter("Service Version");
        if (Rec.GetFilter("Environment Name") = '') then
            EnvironmentName := ImpAdmn.GetCurrentComputerName().ToUpper();
        ValidateEnvironmentName();
        ValidateCustomerNoFilter();
        ValidateVersionFilter();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        EnableService := (Rec.Environment = Rec.Environment::Service);
    end;

    #endregion Triggers

    #region Methods

    procedure LoadServerFilter()
    var
        lc_Rec: Record "IMP Connection";
    begin
        ServerFilter := '';
        // Servers
        lc_Rec.Reset();
        lc_Rec.SetRange(Environment, lc_Rec.Environment::Server);
        if lc_Rec.FindSet() then
            repeat
                if (ServerFilter <> '') then
                    ServerFilter += '&';
                ServerFilter += '<>' + lc_Rec."Environment Name".ToUpper();
            until lc_Rec.Next() = 0;
    end;

    procedure SelectEnvironmentNameFilter()
    var
        lc_Rec: Record "IMP Connection";
        lc_Temp: Record "Name/Value Buffer" temporary;
        lc_Page: Page "IMP Selection List";
        lc_Fields: List of [Integer];
        lc_Id: Integer;
    begin
        // Clear
        lc_Id := 0;
        lc_Temp.DeleteAll();
        // All
        lc_Id += 1;
        lc_Temp.Init();
        lc_Temp.ID := lc_Id;
        lc_Temp.Name := 'All';
        lc_Temp.Insert();
        // Cloud
        lc_Id += 1;
        lc_Temp.Init();
        lc_Temp.ID := lc_Id;
        lc_Temp.Name := 'Cloud';
        lc_Temp.Insert();
        // Select
        lc_Rec.Reset();
        lc_Rec.SetRange(Environment, lc_Rec.Environment::Server);
        if lc_Rec.FindSet() then
            repeat
                lc_Id += 1;
                lc_Temp.Init();
                lc_Temp.ID := lc_Id;
                lc_Temp.Name := lc_Rec."Environment Name".ToUpper();
                lc_Temp.Insert();
            until lc_Rec.Next() = 0;
        // Show data
        lc_Fields.Add(lc_Temp.FieldNo(Name));
        lc_Page.HideAllEntries();
        lc_Page.SetFields(lc_Fields, false, true);
        lc_Page.SetData(lc_Temp);
        lc_Page.LookupMode := true;
        if lc_Page.RunModal() = Action::LookupOK then begin
            lc_Page.GetSelection(lc_Temp);
            if lc_Temp.Name.ToLower().Contains('all') then
                EnvironmentName := ''
            else
                if lc_Temp.Name.ToLower().Contains('cloud') then
                    EnvironmentName := 'cloud'
                else
                    EnvironmentName := lc_Temp.Name;
            ValidateEnvironmentName();
        end;
    end;

    procedure ValidateEnvironmentName()
    begin
        if (EnvironmentName = '') then
            Rec.SetRange("Environment Name")
        else
            if EnvironmentName.ToLower().Contains('cloud') then
                Rec.SetFilter("Environment Name", ServerFilter)
            else
                Rec.SetFilter("Environment Name", '%1', '@' + EnvironmentName);
        CurrPage.Update(false);
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
            ValidateCustomerNoFilter();
        end;
    end;

    procedure ValidateCustomerNoFilter()
    begin
        if (CustomerNo = '') then
            Rec.SetRange("Customer No.")
        else
            Rec.SetFilter("Customer No.", CustomerNo);
        CurrPage.Update(false);
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
        ValidateVersionFilter();
    end;

    procedure ValidateVersionFilter()
    begin
        if (Version = '') then
            Rec.SetRange("Service Version")
        else
            Rec.SetFilter("Service Version", Version);
        CurrPage.Update(false);
    end;

    #endregion Methods

    var
        ImpAdmn: Codeunit "IMP Administration";
        ImpMgmt: Codeunit "IMP Management";
        DatMgmt: Codeunit "IMP Data Management";
        EnableService: Boolean;
        ServerFilter: Text;
        EnvironmentName: Text;
        CustomerNo: Text;
        Version: Text;
}
