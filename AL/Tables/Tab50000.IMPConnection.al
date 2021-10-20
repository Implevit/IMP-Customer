table 50000 "IMP Connection"
{
    Caption = 'Connection';
    DataCaptionFields = "List Name";
    LookupPageID = "IMP Connection List";
    DrillDownPageId = "IMP Connection List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(10; Computer; Text[100])
        {
            Caption = 'Computer';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec.Computer <> xRec.Computer) then
                    AlreadyExists(true);
                SetUrl();
            end;
        }
        field(11; Dns; Text[100])
        {
            Caption = 'Dns';
            DataClassification = CustomerContent;
        }
        field(20; "Environment"; Option)
        {
            Caption = 'Environment';
            OptionMembers = " ",Service,Docker,Cloud,Server,SQLServer,SQLInstance,SQLDatabase;
            OptionCaption = ',Service,Docker,Cloud,Server,SQLServer,SQLInstance,SQLDatabase';

            trigger OnValidate()
            begin
                if (Rec.Environment <> xRec.Environment) then
                    AlreadyExists(true);
                SetUrl();
            end;
        }
        field(30; "Environment Name"; Text[80])
        {
            Caption = 'Environment Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec."Environment Name" <> xRec."Environment Name") then
                    AlreadyExists(true);
                SetListName();
                SetUrl();
            end;
        }
        field(40; "Service Name"; Text[80])
        {
            Caption = 'Service Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                SetListName();
                SetUrl();
            end;
        }
        field(50; "Environment Type"; Option)
        {
            Caption = 'Environment Type';
            OptionMembers = " ",OnPrem,Sandbox,Production;
            OptionCaption = ',OnPrem,Sandbox,Production';

            trigger OnValidate()
            begin
                if (Rec."Environment Type" = Rec."Environment Type"::Production) then
                    Rec."Environment Name" := 'Production';
                SetListName();
                SetUrl();
            end;
        }
        field(51; "Environment Id"; Text[250])
        {
            Caption = 'Environment Id';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Txt1_Txt: Label 'Tenant id has to be set up in the customer page!';
            begin
                if (Rec."Environment Id" <> xRec."Environment Id") then begin
                    AlreadyExists(true);
                    if (Rec.Environment = Rec.Environment::Cloud) then
                        Error(lc_Txt1_Txt);
                end;
                SetUrl();
            end;
        }
        field(52; "Environment State"; Text[30])
        {
            Caption = 'Environment State"';
            DataClassification = CustomerContent;
        }
        field(60; "Service State"; Text[50])
        {
            Caption = 'Service Status';
            DataClassification = CustomerContent;
        }
        field(61; "Service Account"; Text[80])
        {
            Caption = 'Service Account';
            DataClassification = CustomerContent;
        }
        field(62; "Service Full Version"; Text[80])
        {
            Caption = 'Service Full Version';
            DataClassification = CustomerContent;
        }
        field(63; "Service Version"; Text[80])
        {
            Caption = 'Service Version';
            DataClassification = CustomerContent;
        }
        field(64; "Service NAV Version"; Text[20])
        {
            Caption = 'Nav Version';
            DataClassification = CustomerContent;
        }
        field(70; DatabaseServer; Text[30])
        {
            Caption = 'SQL Server';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lc_Rec: Record "IMP Connection";
            begin
                lc_Rec.Reset();
                lc_Rec.SetRange(Environment, lc_Rec.Environment::SQLServer);
                if (Rec.DatabaseServer <> '') then
                    lc_Rec.SetRange(DatabaseServer, Rec.DatabaseServer);
                if lc_Rec.FindSet() then;
                lc_Rec.SetRange(DatabaseServer);
                if Page.RunModal(Page::"IMP Databases", lc_Rec) = Action::LookupOK then begin
                    Rec.DatabaseServer := lc_Rec.DatabaseServer;
                    Rec.DatabaseInstance := '';
                    Rec.DatabaseName := '';
                end;
            end;
        }
        field(71; DatabaseInstance; Text[30])
        {
            Caption = 'SQL Instance';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lc_Rec: Record "IMP Connection";
            begin
                lc_Rec.Reset();
                lc_Rec.SetRange(Environment, lc_Rec.Environment::SQLInstance);
                if (Rec.DatabaseServer <> '') then
                    lc_Rec.SetRange(DatabaseServer, Rec.DatabaseServer);
                if (Rec.DatabaseInstance <> '') then
                    lc_Rec.SetRange(DatabaseInstance, Rec.DatabaseInstance);
                if lc_Rec.FindSet() then;
                lc_Rec.SetRange(DatabaseInstance);
                if Page.RunModal(Page::"IMP Databases", lc_Rec) = Action::LookupOK then begin
                    Rec.DatabaseServer := lc_Rec.DatabaseServer;
                    Rec.DatabaseInstance := lc_Rec.DatabaseInstance;
                    Rec.DatabaseName := '';
                end;
            end;
        }
        field(72; DatabaseName; Text[30])
        {
            Caption = 'DB Name';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lc_Rec: Record "IMP Connection";
            begin
                lc_Rec.Reset();
                lc_Rec.SetRange(Environment, lc_Rec.Environment::SQLDatabase);
                if (Rec.DatabaseServer <> '') then
                    lc_Rec.SetRange(DatabaseServer, Rec.DatabaseServer);
                if (Rec.DatabaseInstance <> '') then
                    lc_Rec.SetRange(DatabaseInstance, Rec.DatabaseInstance);
                if (Rec.DatabaseName <> '') then
                    lc_Rec.SetRange(DatabaseName, Rec.DatabaseName);
                if lc_Rec.FindSet() then;
                lc_Rec.SetRange(DatabaseName);
                if Page.RunModal(Page::"IMP Databases", lc_Rec) = Action::LookupOK then begin
                    Rec.DatabaseServer := lc_Rec.DatabaseServer;
                    Rec.DatabaseInstance := lc_Rec.DatabaseInstance;
                    Rec.DatabaseName := lc_Rec.DatabaseName;
                end;
            end;
        }
        field(80; ManagementServicesPort; Integer)
        {
            Caption = 'Mgmt.';
            DataClassification = CustomerContent;
        }
        field(81; ClientServicesPort; Integer)
        {
            Caption = 'Client';
            DataClassification = CustomerContent;
        }
        field(82; SOAPServicesPort; Integer)
        {
            Caption = 'SOAP';
            DataClassification = CustomerContent;
        }
        field(83; ODataServicesPort; Integer)
        {
            Caption = 'OData';
            DataClassification = CustomerContent;
        }
        field(84; DeveloperServiceServerPort; Integer)
        {
            Caption = 'Dev';
            DataClassification = CustomerContent;
        }
        field(90; ClientServicesCredentialType; Text[30])
        {
            Caption = 'Login';
            DataClassification = CustomerContent;
        }
        field(100; ServicesCertificateThumbprint; Text[50])
        {
            Caption = 'Thumbprint';
            DataClassification = CustomerContent;
        }
        field(110; "List Name"; Text[80])
        {
            Caption = 'List Name';
            DataClassification = CustomerContent;
        }
        field(120; "Url"; Text[250])
        {
            Caption = 'Url';
            DataClassification = CustomerContent;
        }
        field(130; "Authorisation No."; Integer)
        {
            Caption = 'Authorisation No.';
            TableRelation = "IMP Authorisation"."Entry No.";
        }
        field(140; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                lc_Cust: Record Customer;
            begin
                if ((Rec.Environment = Rec.Environment::Cloud) and (Rec."Customer No." <> xRec."Customer No.")) then begin
                    if (Rec."Customer No." = '') then
                        Rec."Environment Id" := ''
                    else
                        if lc_Cust.Get(Rec."Customer No.") then begin
                            lc_Cust.TestField("IMP Tenant Id");
                            Rec."Environment Id" := CopyStr(LowerCase(lc_Cust."IMP Tenant Id"), 1, MaxStrLen(Rec."Environment Id"));
                        end;
                    Rec.SetListName();
                    Rec.SetUrl();
                end;
            end;
        }
        field(150; "Company Name"; Text[30])
        {
            Caption = 'Company Name';

            trigger OnLookup()
            var
                lc_Comp: Record Company;
                lc_AS: Record "Active Session";
                lc_IA: Record "IMP Authorisation";
                lc_CompName: Text;
                lc_CompId: Text;
            begin
                // Get local companies
                lc_AS.Reset();
                if lc_AS.FindLast() then
                    if ((Rec.Dns.ToLower().Replace('impent02', 'impent01') = lc_AS."Server Computer Name".ToLower()) and (Rec.DatabaseName.ToLower() = lc_AS."Database Name".ToLower())) then begin
                        lc_Comp.Reset();
                        if (Rec."Company Name" <> '') then
                            lc_Comp.SetRange(Name, Rec."Company Name");
                        if lc_Comp.FindSet() then;
                        lc_Comp.SetRange(Name);
                        if (page.RunModal(Page::Companies, lc_Comp) = Action::LookupOK) then begin
                            Rec."Company Name" := lc_Comp.Name;
                            Rec."Company Id" := lc_Comp.Id;
                        end;
                        exit;
                    end;
                // Get webservice companies
                lc_IA.Get(Rec."Authorisation No.");
                if DatMgmt.SelectCompany(Rec.GetUrlOdata(), lc_CompName, lc_CompId, lc_IA.Name, lc_IA.Password, lc_IA.Token, lc_IA."Client Id", lc_IA."Secret Id") then begin
                    Rec."Company Name" := CopyStr(lc_CompName, 1, MaxStrLen(Rec."Company Name"));
                    Rec."Company Id" := lc_CompId;
                end;
            end;

            trigger OnValidate()
            var
                lc_Comp: Record Company;
            begin
                if ((Rec."Company Name" <> '') and (Rec."Company Name" <> xRec."Company Name")) then begin
                    lc_Comp.Get(Rec."Company Name");
                    Rec."Company Id" := lc_Comp.Id;
                end;
            end;
        }
        field(151; "Company Id"; Guid)
        {
            Caption = 'Company Id';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "List Name")
        {
        }
        key(Key3; Computer, Environment, "Environment Name", "Environment Id")
        {
        }
        key(Key4; "Customer No.")
        {
        }
        key(Key5; Computer, "Service Name", "Company Name")
        {
        }
        key(Key6; Environment, "DatabaseServer", "DatabaseInstance", DatabaseName)
        {
        }
    }

    #region Triggers

    trigger OnInsert()
    var
        lc_CompInfo: Record "Company Information";
        lc_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        lc_CompInfo.Get();
        lc_CompInfo.TestField("IMP Connection Nos.");
        lc_NoSeriesMgt.InitSeries(lc_CompInfo."IMP Connection Nos.", '', 0D, Rec."No.", lc_CompInfo."IMP Connection Nos.");
    end;

    #endregion Triggers

    #region Methodes

    procedure AlreadyExists(_WithError: Boolean) RetValue: Boolean
    var
        lc_Rec: Record "IMP Connection";
        lc_Txt1_Txt: Label 'Entry %1 has already this setting';
    begin
        // Find
        lc_Rec.Reset();
        lc_Rec.SetCurrentKey(Computer, Environment, "Environment Name", "Environment Id");
        lc_Rec.SetRange(Computer, Rec.Computer);
        lc_Rec.SetRange(Environment, Rec.Environment);
        lc_Rec.SetRange("Environment Type", Rec."Environment Type");
        lc_Rec.SetRange("Environment Name", Rec."Environment Name");
        lc_Rec.SetRange("Environment Id", Rec."Environment Id");
        lc_Rec.SetRange("Service Name", Rec."Service Name");
        lc_Rec.SetFilter("No.", '<>%1', Rec."No.");
        RetValue := lc_Rec.FindFirst();
        // Show message
        if ((RetValue) and (_WithError) and (GuiAllowed())) then
            Error(lc_Txt1_Txt, lc_Rec."No.");
    end;

    procedure SetUrl()
    begin
        Rec.Url := CopyStr(GetUrlClient(), 1, MaxStrLen(Rec.Url));
    end;

    procedure GetUrlBase() RetValue: Text
    begin
        if (Rec.Environment = Rec.Environment::Cloud) then
            RetValue := 'https://'
        else
            RetValue := 'http://';
    end;

    procedure GetUrlClient() RetValue: Text
    begin
        RetValue := GetUrlClient(GetUrlBase());
    end;

    procedure GetUrlClient(_BaseUrl: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := _BaseUrl + Rec.Computer + ':8080/' + Rec."Service Name";
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'businesscentral.dynamics.com/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlApi() RetValue: Text
    begin
        RetValue := GetUrlApi(GetUrlBase(), 'v2.0')
    end;

    procedure GetUrlApi(_BaseUrl: Text; _Version: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := _BaseUrl + Rec.Computer + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/api';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'api.businesscentral.dynamics.com/' + _Version + '/' + Rec."Environment Id" + '/Production/api/' + _Version;
        end;
    end;

    procedure GetUrlOdata() RetValue: Text
    begin
        RetValue := GetUrlOdata(GetUrlBase());
    end;

    procedure GetUrlOdata(_BaseUrl: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := _BaseUrl + Rec.Dns + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'api.businesscentral.dynamics.com/v2.0/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlOdataService() RetValue: Text
    begin
        GetUrlOdataService(CompanyName);
    end;

    procedure GetUrlOdataService(_CompanyName: Text) RetValue: Text
    begin
        RetValue := GetUrlOdata(GetUrlBase());
        RetValue += 'ODataV4/IMPWebService_odata?Company=' + '''' + _CompanyName + '''';
    end;

    procedure GetUrlSOAP() RetValue: Text
    begin
        RetValue := GetUrlSOAP(GetUrlBase())
    end;

    procedure GetUrlSOAP(_BaseUrl: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := _BaseUrl + Rec.Dns + ':' + Format(Rec.SOAPServicesPort) + '/' + Rec."Service Name" + '/WS';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'businesscentral.dynamics.com/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlOdataIMPProd(_CompanyName: Text) RetValue: Text
    var
        lc_AS: Record "Active Session";
        lc_IC: Record "IMP Connection";
        lc_List: List of [Text];
        lc_Computer: Text;
    begin
        // Get current session
        lc_AS.Get(ServiceInstanceId(), SessionId());

        // Get Computer
        if lc_AS."Server Computer Name".Contains('.') then begin
            lc_List := lc_AS."Server Computer Name".Split('.');
            lc_Computer := lc_List.Get(1);
        end else
            lc_Computer := lc_AS."Server Computer Name";

        // Set default connection
        RetValue := 'http://' + lc_Computer + '.imp.local:8348/IMP-BC180-PROD/';

        // Get connection
        lc_IC.Reset();
        lc_IC.SetCurrentKey("Service Name");
        lc_IC.SetRange("Service Name", lc_AS."Server Instance Name");
        lc_IC.SetRange(Computer, lc_Computer);
        if lc_IC.FindFirst() then
            RetValue := lc_IC.GetUrlOdata();

        // Finish connection
        if not RetValue.EndsWith('/') then
            RetValue += '/';

        // Add odata and company
        RetValue += 'ODataV4/IMPWebService_odata?Company=' + '''' + CompanyName + '''';
    end;

    procedure SetListName()
    var
        lc_Cust: Record Customer;
    begin
        if (Rec.Environment = Rec.Environment::Service) then
            Rec."List Name" := Rec."Service Name";
        if (Rec.Environment = Rec.Environment::Docker) then
            Rec."List Name" := Rec."Environment Name";
        if (Rec.Environment = Rec.Environment::Cloud) then
            if lc_Cust.Get(Rec."Customer No.") then begin
                lc_Cust.TestField("IMP Abbreviation");
                Rec."List Name" := CopyStr(lc_Cust."IMP Abbreviation" + '-' + Rec."Environment Name", 1, MaxStrLen(Rec."List Name"));
            end;
    end;

    procedure GetAsJsonFileName() RetValue: Text
    begin
        RetValue := Rec."List Name";
        RetValue := RetValue.Replace(' ', '');
        RetValue := RetValue.Replace('/', '');
        RetValue := RetValue.Replace('\', '');
        RetValue += '.json';
    end;

    procedure LoadAsJson(var _Rec: Record "IMP Connection"; var _Object: JsonObject)
    var
        lc_Array: JsonArray;
        lc_Entry: JsonObject;
    begin
        _Object.Add('data', 'ServerInstance');
        if _Rec.Find('-') then begin
            repeat
                clear(lc_Entry);
                lc_Entry.Add('no', _Rec."No.");
                lc_Entry.Add('listName', _Rec."List Name");
                lc_Entry.Add('computer', _Rec.Computer);
                lc_Entry.Add('environment', _Rec.Environment);
                lc_Entry.Add('environmentType', _Rec."Environment Type");
                lc_Entry.Add('environmentId', _Rec."Environment Id");
                lc_Entry.Add('environmentName', _Rec."Environment Name");
                lc_Entry.Add('serviceName', _Rec."Service Name");
                lc_Entry.Add('url', _Rec.Url);
                lc_Entry.Add('customerNo', _Rec."Customer No.");
                lc_Entry.Add('authorisationEntryNo', _Rec."Authorisation No.");
            until _Rec.Next() = 0;
            lc_Array.Add(lc_Entry);
        end;
        _Object.Add('instances', lc_Array);
    end;

    procedure ImportSQLServerFull(_Root: JsonObject; var _Response: JsonObject) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        lc_Instances: JsonArray;
        lc_Instance: JsonToken;
        lc_Databases: JsonArray;
        lc_Database: JsonToken;
        lc_Token: JsonToken;
        lc_Server: Text;
        lc_InstanceName: Text;
        lc_InstanceVersion: Text;
        lc_DBName: Text;
        lc_DBRecoveryModel: Text;
    begin

        #region Json syntax

        /*
        {
            "data":  "SqlServerFull",
            "server":  "IMPSQL01",
            "instances":  [
                {
                    "name" : "SQL2014",
                    "version" :  "12.0.6164",
                    "databases":  [
                                    {
                                        "name":  "XXX-XXXXXX-XXXX",
                                        "recoveryModel":  "Simple"
                                    }
                    ]
                }
            ],
        */

        #endregion Json syntax

        // Init
        RetValue := false;

        // Get server
        if not _Root.Get('server', lc_Token) then begin
            _Response.Add('error', 'Token server missing in json');
            exit;
        end else
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();

        // Clear
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Computer, Environment, "Environment Name", "Environment Id");
        lc_IC.SetRange(Computer, lc_Server);
        lc_IC.SetFilter(Environment, '%1|%2|%3', lc_IC.Environment::SQLServer, lc_IC.Environment::SQLInstance, lc_IC.Environment::SQLDatabase);
        if lc_IC.FindSet() then
            lc_IC.DeleteAll(true);

        // Save server
        clear(lc_IC);
        lc_IC.Init();
        lc_IC.Computer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.Computer));
        lc_IC.Environment := lc_IC.Environment::SQLServer;
        lc_IC."Environment Name" := CopyStr(lc_Server, 1, MaxStrLen(lc_IC."Environment Name"));
        lc_IC."List Name" := CopyStr(lc_Server, 1, MaxStrLen(lc_IC."Environment Name"));
        lc_IC.DatabaseServer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.DatabaseServer));
        if not lc_IC.Insert(true) then begin
            _Response.Add('error', 'Couldn''t insert server in ' + lc_IC.TableName);
            exit;
        end;

        // Get instances
        if not _Root.Get('instances', lc_Token) then begin
            _Response.Add('error', 'Token instances missing in json');
            exit;
        end;

        // Check instances
        if not (lc_Token.IsArray()) then begin
            _Response.Add('error', 'Token instances has to be an array');
            exit;
        end;

        // Read instances
        lc_Instances := lc_Token.AsArray();
        foreach lc_Instance in lc_Instances do begin
            // Check name
            if not lc_Instance.AsObject().Get('name', lc_Token) then begin
                _Response.Add('error', 'Token instances.name missing in json');
                exit;
            end else
                lc_InstanceName := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();

            // Check version
            if not lc_Instance.AsObject().Get('version', lc_Token) then begin
                _Response.Add('error', 'Token instances.version missing in json');
                exit;
            end else
                lc_InstanceVersion := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

            // Get or create instance
            lc_IC.Reset();
            lc_IC.SetCurrentKey(Environment, "DatabaseServer", "DatabaseInstance", DatabaseName);
            lc_IC.SetRange(Environment, lc_IC.Environment::SQLInstance);
            lc_IC.SetRange(DatabaseServer, lc_Server);
            lc_IC.SetRange(DatabaseInstance, lc_InstanceName);
            if not lc_IC.FindFirst() then begin
                Clear(lc_IC);
                lc_IC.Init();
                lc_IC.Environment := lc_IC.Environment::SQLInstance;
                lc_IC."Environment Name" := CopyStr(lc_Server, 1, MaxStrLen("Environment Name"));
                lc_IC."Environment State" := CopyStr(lc_InstanceVersion, 1, MaxStrLen(lc_IC."Environment State"));
                lc_IC.Computer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.Computer));
                lc_IC.DatabaseServer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.DatabaseServer));
                lc_IC.DatabaseInstance := CopyStr(lc_InstanceName, 1, MaxStrLen(lc_IC.DatabaseInstance));
                lc_IC."List Name" := CopyStr(lc_IC.DatabaseServer + '/' + lc_IC.DatabaseInstance, 1, MaxStrLen(lc_IC."List Name"));
                if not lc_IC.Insert(true) then begin
                    _Response.Add('error', 'Couldn''t insert instance in ' + lc_IC.TableName);
                    exit;
                end;
            end;

            // Get databases
            if not lc_Instance.AsObject().Get('databases', lc_Token) then begin
                _Response.Add('error', 'Token databases missing in json');
                exit;
            end;

            // Check databases
            if not (lc_Token.IsArray()) then begin
                _Response.Add('error', 'Token databases has to be an array');
                exit;
            end;

            // Read databases
            lc_Databases := lc_Token.AsArray();
            foreach lc_Database in lc_Databases do begin
                // Check name
                if not lc_Database.AsObject().Get('name', lc_Token) then begin
                    _Response.Add('error', 'Token instances.databases.name missing in json');
                    exit;
                end else
                    lc_DBName := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();

                // Check version
                if not lc_Database.AsObject().Get('recoveryModel', lc_Token) then begin
                    _Response.Add('error', 'Token instances.databases.recoveryModel missing in json');
                    exit;
                end else
                    lc_DBRecoveryModel := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

                // Get or create database
                lc_IC.Reset();
                lc_IC.SetCurrentKey(Environment, "DatabaseServer", "DatabaseInstance", DatabaseName);
                lc_IC.SetRange(Environment, lc_IC.Environment::SQLDatabase);
                lc_IC.SetRange(DatabaseServer, lc_Server);
                lc_IC.SetRange(DatabaseInstance, lc_InstanceName);
                lc_IC.SetRange(DatabaseName, lc_DBName);
                if not lc_IC.FindFirst() then begin
                    clear(lc_IC);
                    lc_IC.Init();
                    lc_IC.Environment := lc_IC.Environment::SQLDatabase;
                    lc_IC.Computer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.Computer));
                    lc_IC.DatabaseServer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.DatabaseServer));
                    lc_IC.DatabaseInstance := CopyStr(lc_InstanceName, 1, MaxStrLen(lc_IC.DatabaseInstance));
                    lc_IC.DatabaseName := CopyStr(lc_DBName, 1, MaxStrLen(lc_IC.DatabaseName));
                    lc_IC."Environment State" := CopyStr(lc_DBRecoveryModel, 1, MaxStrLen(lc_IC."Environment State"));
                    lc_IC."List Name" := CopyStr(lc_IC.DatabaseInstance + '/' + lc_IC.DatabaseName, 1, MaxStrLen(lc_IC."List Name"));
                    if not lc_IC.Insert(true) then begin
                        _Response.Add('error', 'Couldn''t insert database in ' + lc_IC.TableName);
                        exit;
                    end;
                end;
            end;
        end;

        // Store data
        Commit();

        // Set response
        _Response.Add('response', 'Thank you for sending full sql server list');

        // Return
        RetValue := true;
    end;

    procedure SelectVersions(_SingleEntry: Boolean) RetValue: List of [Text];
    var
        lc_IC: Record "IMP Connection";
        lc_List: Record "Name/Value Buffer" temporary;
        lc_Version: List of [Text];
        lc_Fields: List of [Integer];
        lc_Text: Text;
        lc_Int: Integer;
        lc_Computer: Text;
        lc_Txt1_Txt: Label 'Load first version list from server';
    begin
        // Init
        lc_Int := 0;
        Clear(RetValue);

        // Get computer
        lc_Computer := ImpAdmn.GetCurrentComputerName();

        // Find version list
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Computer, Environment, "Environment Name", "Environment Id");
        lc_IC.SetRange(Computer, lc_Computer);
        lc_IC.SetRange(Environment, lc_IC.Environment::Server);
        if not lc_IC.FindFirst() then
            Error(lc_Txt1_Txt);

        // Check entry
        if (lc_IC."Environment Id" = '') then
            Error(lc_Txt1_Txt);

        // Clear list
        lc_List.Reset();
        lc_List.DeleteAll(true);

        // Load selection
        lc_Version := lc_IC."Environment Id".Split(',');
        foreach lc_Text in lc_Version do begin
            lc_Int += 1;
            lc_List.Init();
            lc_List.ID := lc_Int;
            lc_List.Name := CopyStr(lc_Text, 1, MaxStrLen(lc_List.Name));
            if lc_List.Insert(true) then;
        end;

        // Set fields to visible
        lc_Fields.Add(lc_List.FieldNo(Name));
        //lc_Fields.Add(lc_List.FieldNo(Value));

        // Raise selection event
        ImpMgmt.SelectEntry(lc_List, lc_Fields, _SingleEntry);

        // Set return
        if lc_List.Find('-') then
            repeat
                RetValue.Add(lc_List.Name);
            until lc_List.Next() = 0;
    end;

    procedure ImportVersions(_Root: JsonObject; var _Response: JsonObject) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        lc_Array: JsonArray;
        lc_Token: JsonToken;
        lc_Server: Text;
        lc_Dns: Text;
        lc_TList: list of [Text];
        lc_VList: array[1000] of Text;
        lc_Min: Integer;
        lc_Max: Integer;
        lc_Int: Integer;
        lc_Versions: Text;
    begin

        #region Json syntax

        /*
        {
            "data":  "ServerVersions",
            "server":  "IMPENT01",
            "dns" : "IMPENT01.imp.local",
            "versions":  [],
        */

        #endregion Json syntax

        // Init
        RetValue := false;
        lc_Versions := '';
        clear(lc_VList);

        // Server
        if not _Root.Get('server', lc_Token) then begin
            _Response.Add('error', 'Token server missing in json');
            exit;
        end else
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();

        // Dns
        if not _Root.SelectToken('dns', lc_Token) then begin
            _Response.Add('error', 'Token dns missing in json');
            exit;
        end else
            lc_Dns := BscMgmt.JsonGetTokenValue(lc_Token, 'dns').AsText();

        // Check versions
        if not (_Root.Get('versions', lc_Token)) then begin
            _Response.Add('error', 'Token versions missing in json');
            exit;
        end;

        // Versions
        if _Root.Get('versions', lc_Token) then begin
            lc_Min := 1000;
            lc_Max := 0;
            lc_Array := lc_Token.AsArray();
            // Loop throught array
            foreach lc_Token in lc_Array do begin
                lc_TList := lc_Token.AsValue().AsText().Split('.');
                Evaluate(lc_Int, lc_TList.Get(1));
                lc_VList[lc_Int] := lc_Token.AsValue().AsText();
                if (lc_Max < lc_Int) then
                    lc_Max := lc_Int;
                if (lc_Min > lc_Int) then
                    lc_Min := lc_Int;
            end;
            // Create list
            for lc_Int := lc_Min to lc_Max do
                if (lc_VList[lc_Int] <> '') then begin
                    if (lc_Versions <> '') then
                        lc_Versions += ',';
                    lc_Versions += lc_VList[lc_Int];
                end;
        end;

        // Save data
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Computer, Environment, "Environment Name", "Environment Id");
        lc_IC.SetRange(Computer, lc_Server);
        lc_IC.SetRange(Environment, lc_IC.Environment::Server);
        if not lc_IC.FindFirst() then begin
            lc_IC.Init();
            lc_IC.Computer := CopyStr(lc_Server, 1, MaxStrLen(lc_IC.Computer));
            lc_IC.Environment := lc_IC.Environment::Server;
            lc_IC."Environment Name" := CopyStr(lc_Server, 1, MaxStrLen(lc_IC."Environment Name"));
            lc_IC."List Name" := CopyStr(lc_Server, 1, MaxStrLen(lc_IC."Environment Name"));
            lc_IC.Url := CopyStr('\\' + lc_Server, 1, MaxStrLen(lc_IC.Url));
            if not lc_IC.Insert(true) then begin
                _Response.Add('error', 'Couldn''t insert versions in ' + lc_IC.TableName);
                exit;
            end;
        end;
        // Save versions
        lc_IC."Environment Id" := CopyStr(lc_Versions, 1, MaxStrLen(lc_IC."Environment Id"));
        // Modify entry
        if not lc_IC.Modify(true) then begin
            _Response.Add('error', 'Couldn''t modify versions in ' + lc_IC.TableName);
            exit;
        end;

        // Store data
        Commit();

        // Set response
        _Response.Add('response', 'Thank you for sending version list');

        // Return
        RetValue := true;
    end;

    /*
    procedure LoadVersionFromServer(_ServerName: Text) RetValue: List of [Text]
    var
        lc_HttpClient: HttpClient;
        lc_HttpContent: HttpContent;
        lc_HttpRequest: HttpRequestMessage;
        lc_HttpResponse: HttpResponseMessage;
        lc_ResponseJson: JsonObject;
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_Request: Text;
        lc_Response: Text;
        lc_Command: Text;
        lc_Method: Text;
    begin
        // Init
        lc_Command := 'http://' + _ServerName + ':5000/NAVVersions';
        lc_Method := 'GET';

        // Clear Web Service
        Clear(lc_HttpClient);

        // Save Request In Content
        lc_HttpContent.WriteFrom(lc_Request);

        // Set Content To Control
        lc_HttpRequest.Content(lc_HttpContent);

        // Set Operation
        lc_HttpRequest.Method(lc_Method);

        // Set and send Command
        if not lc_HttpClient.Get(lc_Command, lc_HttpResponse) then
            Error(lc_HttpResponse.ReasonPhrase);

        // Read Request
        if not lc_HttpResponse.Content.ReadAs(lc_Response) then
            Error('No response');

        // Read Json
        if not lc_ResponseJson.ReadFrom(lc_Response) then
            Error(('No json in request:\\' + lc_Response));

        // Clear List
        clear(RetValue);

        // Get data
        if not lc_ResponseJson.Get('data', lc_Token) then
            Error('Data token missing in json');

        // Check data
        if not (BscMgmt.JsonGetTokenValue(lc_Token, 'data').AsText().ToLower() = 'serverversion') then
            Error('Data "%1" is no valid entry', BscMgmt.JsonGetTokenValue(lc_Token, 'data').AsText());

        // Get versions
        if not lc_ResponseJson.Get('versions', lc_Token) then
            Error('Token versions missing in json');

        // Check array
        if not lc_Token.IsArray() then
            Error('Token versions as to be an array');

        // Process array
        lc_Array := lc_Token.AsArray();
        foreach lc_Token in lc_Array do
            RetValue.Add(lc_Token.AsValue().AsText().ToLower());
    end;

    procedure LoadServerInstancesFromServer(_ServerName: Text)
    var
        lc_Temp: Record "IMP Connection" temporary;
        lc_HttpClient: HttpClient;
        lc_HttpContent: HttpContent;
        lc_HttpRequest: HttpRequestMessage;
        lc_HttpResponse: HttpResponseMessage;
        lc_ResponseJson: JsonObject;
        lc_Data: JsonToken;
        lc_Request: Text;
        lc_Response: Text;
        lc_Command: Text;
        lc_Method: Text;
        lc_Message: Text;
    begin
        // Init
        lc_Command := 'http://' + _ServerName + ':5000/NAVInstances';
        lc_Method := 'GET';

        // Clear Web Service
        Clear(lc_HttpClient);

        // Save Request In Content
        lc_HttpContent.WriteFrom(lc_Request);

        // Set Content To Control
        lc_HttpRequest.Content(lc_HttpContent);

        // Set Operation
        lc_HttpRequest.Method(lc_Method);

        // Set and send Command
        if not lc_HttpClient.Get(lc_Command, lc_HttpResponse) then
            Error(lc_HttpResponse.ReasonPhrase);

        // Read Request
        if not lc_HttpResponse.Content.ReadAs(lc_Response) then
            Error('No response');

        // Read Json
        if not lc_ResponseJson.ReadFrom(lc_Response) then
            Error(('No json in request:\\' + lc_Response));

        // Clear List
        Rec.Reset();
        Rec.SetRange(Computer, _ServerName);
        if Rec.FindSet() then begin
            repeat
                lc_Temp.Init();
                lc_Temp.TransferFields(Rec);
                lc_Temp.Insert(true);
            until rEC.Next() = 0;
            if Confirm(format(lc_Temp.Count())) then;
            Rec.DeleteAll();
        end;

        // Get data
        if not lc_ResponseJson.Get('data', lc_Data) then
            Error('Data token missing in json');

        case BscMgmt.JsonGetTokenValue(lc_Data, 'data').AsText().ToLower() of
            'serverinstances':
                if ImportServerInstances(lc_Temp, lc_ResponseJson, lc_Message) then
                    Commit()
                else
                    Error(lc_Message);
            else
                Error('Data "%1" is no valid entry', BscMgmt.JsonGetTokenValue(lc_Data, 'data').AsText());
        end;
    end;
    */

    procedure ImportServerInstances(_Root: JsonObject; var _Response: JsonObject) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        lc_ICTemp: Record "IMP Connection" temporary;
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_Server: Text;
        lc_Dns: Text;
        lc_Version: Text;
        lc_ServerInstance: Text;
        lc_Message: Text;
    begin

        #region Json syntax

        /*
        {
            "data":  "ServerInstance",
            "server":  "IMPENT01",
            "version": "14.0",
            "dns" : "IMPENT01.imp.local",
            "services":  [],
            "dockers":  []
        */

        #endregion Json syntax

        // Init
        RetValue := false;
        lc_ServerInstance := '';

        // Server
        if not _Root.Get('server', lc_Token) then begin
            _Response.Add('error', 'Token server missing in json');
            exit;
        end else
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();

        // Version
        if not _Root.Get('version', lc_Token) then
            lc_Version := ''
        else
            lc_Version := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

        // Dns
        if not _Root.SelectToken('dns', lc_Token) then begin
            _Response.Add('error', 'Token dns missing in json');
            exit;
        end else
            lc_Dns := BscMgmt.JsonGetTokenValue(lc_Token, 'dns').AsText();

        // Check services
        if not (_Root.Get('services', lc_Token)) then begin
            _Response.Add('error', 'Token services missing in json');
            exit;
        end;

        // Check array
        if not lc_Token.IsArray() then begin
            _Response.Add('error', 'Token services has to an array');
            exit;
        end else begin
            lc_Array := lc_Token.AsArray();
            if (lc_Array.Count() = 1) then
                if lc_Array.Get(1, lc_Token) then
                    lc_ServerInstance := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();
        end;

        // Clear List
        lc_IC.Reset();
        // Only servers
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);
        // Only this computer
        lc_IC.SetRange(Computer, lc_Server);
        // Only this version
        if (lc_Version <> '') then
            lc_IC.SetRange("Service Version", lc_Version);
        // Only this server instance
        if (lc_ServerInstance <> '') then
            lc_IC.SetRange("Service Name", lc_ServerInstance);
        // Find set
        if lc_IC.FindSet() then begin
            repeat
                // Crate temp entry
                lc_ICTemp.Init();
                lc_ICTemp.TransferFields(lc_IC);
                lc_ICTemp.Insert(true);
            until lc_IC.Next() = 0;
            // Delete current entries
            lc_IC.DeleteAll();
        end;

        // Services
        foreach lc_Token in lc_Array do
            if not ImportServerInstance(lc_ICTemp, lc_Server, lc_Dns, lc_Token, lc_Message) then
                exit;

        // Store data
        Commit();

        // Return
        RetValue := true;
    end;

    procedure ImportDockers(_Root: JsonObject; var _Response: Text) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        lc_ICTemp: Record "IMP Connection" temporary;
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_Server: Text;
        lc_Dns: Text;
        lc_Version: Text;
    begin

        #region Json syntax

        /*
        {
            "data":  "ServerInstance",
            "server":  "IMPENT01",
            "version": "14.0",
            "dns" : "IMPENT01.imp.local",
            "services":  [],
            "dockers":  []
        */

        #endregion Json syntax

        // Init
        RetValue := false;

        // Server
        if not _Root.Get('server', lc_Token) then begin
            _Response := 'Token server missing in json';
            exit;
        end else
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();

        // Version
        if not _Root.Get('version', lc_Token) then
            lc_Version := ''
        else
            lc_Version := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

        // Dns
        if not _Root.SelectToken('dns', lc_Token) then begin
            _Response := 'Token dns missing in json';
            exit;
        end else
            lc_Dns := BscMgmt.JsonGetTokenValue(lc_Token, 'dns').AsText();

        // Check services or dockers
        if not ((_Root.Get('services', lc_Token) or (_Root.Get('dockers', lc_Token)))) then begin
            _Response := 'Token services or dockers missing in json';
            exit;
        end;

        // Check array
        if not lc_Token.IsArray() then begin
            _Response := 'Token services or dockers has to an array';
            exit;
        end;

        // Clear List
        lc_IC.Reset();
        lc_IC.SetRange(Computer, lc_Server);
        if (lc_Version <> '') then
            lc_IC.SetRange("Service Version", lc_Version);
        if lc_IC.FindSet() then begin
            repeat
                lc_ICTemp.Init();
                lc_ICTemp.TransferFields(Rec);
                lc_ICTemp.Insert(true);
            until rEC.Next() = 0;
            lc_IC.DeleteAll();
        end;

        // Services
        if _Root.Get('services', lc_Token) then begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Token in lc_Array do
                if not ImportServerInstance(lc_ICTemp, lc_Server, lc_Dns, lc_Token, _Response) then
                    exit;
        end;

        // Dockers
        if _Root.Get('dockers', lc_Token) then begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Token in lc_Array do
                if not ImportServerInstance(lc_ICTemp, lc_Server, lc_Dns, lc_Token, _Response) then
                    exit;
        end;

        // Store data
        Commit();

        // Return
        RetValue := true;
    end;

    procedure ImportServerInstance(var _Temp: Record "IMP Connection"; _Server: Text; _Dns: Text; _Root: JsonToken; var _Message: Text) RetValue: Boolean
    var
        lc_ISI: Record "IMP Connection";
        lc_Array: JsonArray;
        lc_Entry: JsonToken;
        lc_Token: JsonToken;
        lc_Value: JsonValue;
        lc_EntryName: Text;
    begin
        // Init
        RetValue := false;

        // Process
        lc_ISI.Init();

        // Computer
        lc_ISI.Computer := CopyStr(_Server, 1, MaxStrLen(lc_ISI.Computer));

        // Dns
        lc_ISI.Dns := CopyStr(_Dns, 1, MaxStrLen(lc_ISI.Dns));

        // Environment
        if not _Root.SelectToken('environment', lc_Token) then begin
            _Message := 'Environment missing as token in services';
            exit;
        end else
            case BscMgmt.JsonGetTokenValue(lc_Token, 'environment').AsText().ToLower() of
                'server':
                    lc_ISI.Environment := lc_ISI.Environment::Service;
                'cloud':
                    lc_ISI.Environment := lc_ISI.Environment::Cloud;
                'docker':
                    lc_ISI.Environment := lc_ISI.Environment::Docker;
            end;

        // Environment type
        if not _Root.SelectToken('environmenttype', lc_Token) then begin
            _Message := 'Environmenttype missing as token in services';
            exit;
        end else
            case BscMgmt.JsonGetTokenValue(lc_Token, 'environmenttype').AsText().ToLower() of
                'onprem':
                    lc_ISI."Environment Type" := lc_ISI."Environment Type"::OnPrem;
                'sandbox':
                    lc_ISI."Environment Type" := lc_ISI."Environment Type"::Sandbox;
                'production':
                    lc_ISI."Environment Type" := lc_ISI."Environment Type"::Production;
            end;

        // Environment id
        if not _Root.SelectToken('environmentid', lc_Token) then begin
            _Message := 'Environmentid missing as token in container';
            exit;
        end else
            lc_ISI."Environment Id" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentid').AsText(), 1, MaxStrLen(lc_ISI."Environment Id"));

        // Environment name
        if not _Root.SelectToken('environmentname', lc_Token) then begin
            _Message := 'Environmentname missing as token in dockers';
            exit;
        end else
            lc_ISI.Validate("Environment Name", CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentname').AsText(), 1, MaxStrLen(lc_ISI."Environment Name")));

        // Environment state
        if not _Root.SelectToken('environmentstate', lc_Token) then begin
            _Message := 'Environmentstate missing as token in container';
            exit;
        end else
            lc_ISI."Environment State" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentstate').AsText(), 1, MaxStrLen(lc_ISI."Environment State"));

        // Name
        if not _Root.SelectToken('name', lc_Token) then begin
            _Message := 'Name missing as token in services';
            exit;
        end else
            lc_ISI.Validate("Service Name", CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText(), 1, MaxStrLen(lc_ISI."Service Name")));

        // State
        if not _Root.SelectToken('state', lc_Token) then begin
            _Message := 'State missing as token in services';
            exit;
        end else
            lc_ISI."Service State" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'state').AsText(), 1, MaxStrLen(lc_ISI."Service State"));

        // Navision
        if not _Root.SelectToken('navision', lc_Token) then begin
            _Message := 'Navision missing as token in services';
            exit;
        end else
            lc_ISI."Service NAV Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'navision').AsText(), 1, MaxStrLen(lc_ISI."Service NAV Version"));

        // Version
        if not _Root.SelectToken('version', lc_Token) then begin
            _Message := 'Version missing as token in services';
            exit;
        end else
            lc_ISI."Service Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText(), 1, MaxStrLen(lc_ISI."Service Version"));

        // FullVersion
        if not _Root.SelectToken('fullversion', lc_Token) then begin
            _Message := 'Fullversion missing as token in services';
            exit;
        end else
            lc_ISI."Service Full Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'fullversion').AsText(), 1, MaxStrLen(lc_ISI."Service Full Version"));

        // Acount
        if not _Root.SelectToken('account', lc_Token) then begin
            _Message := 'Account missing as token in services';
            exit;
        end else
            lc_ISI."Service Account" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'account').AsText(), 1, MaxStrLen(lc_ISI."Service Account"));

        // Keys
        if not _Root.SelectToken('keys', lc_Token) then begin
            _Message := 'Keys missing as token in services';
            exit;
        end else begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Entry in lc_Array do begin
                lc_EntryName := BscMgmt.JsonGetTokenValue(lc_Entry, 'key').AsText();
                lc_Value := BscMgmt.JsonGetTokenValue(lc_Entry, 'value');
                case lc_EntryName.ToLower() of
                    LowerCase('DatabaseServer'):
                        lc_ISI.DatabaseServer := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.DatabaseServer));
                    LowerCase('DatabaseInstance'):
                        lc_ISI.DatabaseInstance := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.DatabaseInstance));
                    LowerCase('DatabaseName'):
                        lc_ISI.DatabaseName := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.DatabaseName));
                    LowerCase('ManagementServicesPort'):
                        lc_ISI.ManagementServicesPort := lc_Value.AsInteger();
                    LowerCase('ClientServicesPort'):
                        lc_ISI.ClientServicesPort := lc_Value.AsInteger();
                    LowerCase('SOAPServicesPort'):
                        lc_ISI.SOAPServicesPort := lc_Value.AsInteger();
                    LowerCase('ODataServicesPort'):
                        lc_ISI.ODataServicesPort := lc_Value.AsInteger();
                    LowerCase('DeveloperServiceServerPort'):
                        lc_ISI.DeveloperServiceServerPort := lc_Value.AsInteger();
                    LowerCase('ClientServicesCredentialType'):
                        lc_ISI.ClientServicesCredentialType := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.ClientServicesCredentialType));
                    LowerCase('ServicesCertificateThumbprint'):
                        lc_ISI.ServicesCertificateThumbprint := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.ServicesCertificateThumbprint));
                end;
            end;
        end;

        // Reset stored data
        case lc_ISI.Environment of
            lc_ISI.Environment::Service:
                begin
                    _Temp.SetRange("Service Name", lc_ISI."Service Name");
                    if _Temp.FindFirst() then begin
                        lc_ISI."No." := _Temp."No.";
                        lc_ISI."Customer No." := _Temp."Customer No.";
                        lc_ISI."Authorisation No." := _Temp."Authorisation No.";
                    end;
                    _Temp.SetRange("Service Name");
                end;
            lc_ISI.Environment::Docker:
                begin
                    _Temp.SetRange("Environment Id", lc_ISI."Environment Id");
                    if _Temp.FindFirst() then begin
                        lc_ISI."No." := _Temp."No.";
                        lc_ISI."Customer No." := _Temp."Customer No.";
                        lc_ISI."Authorisation No." := _Temp."Authorisation No.";
                    end;
                    _Temp.SetRange("Environment Id");
                end;
        end;

        // Insert
        lc_ISI.Insert(true);

        // Set return value
        RetValue := true;
    end;

    procedure NewRecord(var _BelowxRec: Boolean; _CustomerNo: Text; var _Rec: Record "IMP Connection") RetValue: Boolean
    var
        lc_Cust: Record Customer;
        lc_IC: Record "IMP Connection";
        lc_List: List of [Text];
        lc_Type: Integer;
        lc_Login: Integer;
        lc_TVersion: Text;
        lc_IVersion: Integer;
        lc_NVersion: Text;
        lc_ServicesCertificateThumbprint: Text;
    begin
        // Init
        RetValue := false;

        // Select type
        lc_Type := StrMenu('Service,Docker', 0, 'Select your type of service');
        if (lc_Type = 0) then
            exit;

        // Dockers 
        if (lc_Type = 2) then
            Error('Docker not possible yet!');

        // Select version
        if (lc_Type = 1) then begin
            lc_List := Rec.SelectVersions(true);
            if lc_List.Count() = 0 then
                exit;
            lc_TVersion := lc_List.Get(1);
        end;

        // Set version
        lc_List := lc_TVersion.Split('.');
        case lc_List.Get(1) of
            '7':
                begin
                    lc_IVersion := 71;
                    lc_NVersion := '2013R2';
                end;
            '8':
                begin
                    lc_IVersion := 80;
                    lc_NVersion := '2015';
                end;
            '9':
                begin
                    lc_IVersion := 90;
                    lc_NVersion := '2016';
                end;
            '10':
                begin
                    lc_IVersion := 100;
                    lc_NVersion := '2017';
                end;
            '11':
                begin
                    lc_IVersion := 110;
                    lc_NVersion := '2018';
                end;
            else begin
                    Evaluate(lc_IVersion, lc_List.Get(1) + '0');
                    lc_NVersion := 'BC' + Format(lc_IVersion);
                end;
        end;

        // Select customer
        if not lc_Cust.Get(_CustomerNo) then
            if Page.RunModal(0, lc_Cust) <> Action::LookupOK then
                exit;

        // Select login
        lc_Login := StrMenu('Windows,UserName,NavUserPassword', 3, 'Select your access type'); // AccessControlService
        if (lc_Login = 0) then
            exit;

        // Check customer
        lc_Cust.TestField("IMP Abbreviation");

        // Set computer 
        Rec.Computer := CopyStr(ImpAdmn.GetCurrentComputerName(), 1, MaxStrLen(Rec.Computer));

        // Set dns
        Rec.Dns := CopyStr(Rec.Computer + 'imp.local', 1, MaxStrLen(Rec.Dns));

        // Set name
        Rec."Service Name" := lc_Cust."IMP Abbreviation" + '-' + lc_NVersion + '-DEV';
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Computer, "Service Name", "Company Name");
        lc_IC.SetRange(Computer, Rec.Computer);
        lc_IC.SetFilter("Service Name", '%1*', Rec."Service Name");
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);
        if not lc_IC.FindLast() then
            Rec."Service Name" += '1'
        else
            Rec."Service Name" := IncStr(lc_IC."Service Name");

        // Set version
        Rec."Service Version" := CopyStr(lc_TVersion, 1, MaxStrLen(Rec."Service Version"));

        // Set ports
        Rec.ManagementServicesPort := GetNextPortNo(Rec.Computer);
        Rec.ClientServicesPort := Rec.ManagementServicesPort + 1;
        Rec.SOAPServicesPort := Rec.ManagementServicesPort + 2;
        Rec.ODataServicesPort := Rec.ManagementServicesPort + 3;
        Rec.DeveloperServiceServerPort := Rec.ManagementServicesPort + 4;

        // Get current certificate thumbprint
        lc_IC.Reset();
        lc_IC.SetRange(Computer, Rec.Computer);
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);
        lc_IC.SetFilter(ServicesCertificateThumbprint, '<>%1', '');
        if lc_IC.FindLast() then
            lc_ServicesCertificateThumbprint := lc_IC.ServicesCertificateThumbprint
        else
            lc_ServicesCertificateThumbprint := '';

        // Set login
        case lc_Login of
            1:
                Rec.ClientServicesCredentialType := 'Windows';
            2:
                Rec.ClientServicesCredentialType := 'UserName';
            3:
                begin
                    Rec.ClientServicesCredentialType := 'NavUserPassword';
                    Rec.ServicesCertificateThumbprint := CopyStr(lc_ServicesCertificateThumbprint, 1, MaxStrLen(Rec.ServicesCertificateThumbprint));
                end;
            4:
                Rec.ClientServicesCredentialType := 'AccessControlService';
        end;
    end;

    procedure GetNextPortNo(_Computer: Text) RetValue:
                                                 Integer
    var
        lc_IC: Record "IMP Connection";
    begin
        // Init 
        RetValue := 7045;
        // Find last number
        lc_IC.Reset();
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);
        lc_IC.SetRange(Computer, _Computer);
        if lc_IC.FindLast() then
            RetValue := lc_IC.ManagementServicesPort + 10;
    end;


    #endregion Methodes

    var
        BscMgmt: Codeunit "IMP Basic Management";
        DatMgmt: Codeunit "IMP Data Management";
        ImpMgmt: Codeunit "IMP Management";
        ImpAdmn: Codeunit "IMP Administration";
}