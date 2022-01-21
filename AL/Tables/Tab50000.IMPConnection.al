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
        field(10; Server; Code[30])
        {
            Caption = 'Server';
            DataClassification = CustomerContent;
            TableRelation = "IMP Server".Name;
        }
        field(20; "Environment"; Option)
        {
            Caption = 'Environment';
            //OptionMembers = " ",Service,Docker,Cloud,Server,SQLServer,SQLInstance,SQLDatabase;
            //OptionCaption = ',Service,Docker,Cloud,Server,SQLServer,SQLInstance,SQLDatabase';
            OptionMembers = " ",Service,Docker,Cloud,,,SQLInstance,SQLDatabase;
            OptionCaption = ',Service,Docker,Cloud,,,SQLInstance,SQLDatabase';

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
            var
                lc_IC: Record "IMP Connection";
            begin
                // Set to upper
                Rec."Service Name" := Rec."Service Name".ToUpper();

                // Check name
                lc_IC.Reset();
                lc_IC.SetCurrentKey(Server, "Service Name", "Company Name");
                lc_IC.SetRange(Server, Rec.Server);
                lc_IC.SetFilter("Service Name", '%1', '@' + Rec."Service Name");
                lc_IC.SetRange(Environment, lc_IC.Environment::Service);
                if not lc_IC.IsEmpty() then begin
                    lc_IC.SetFilter("Service Name", '%1', '@' + Rec."Service Name" + '*');
                    lc_IC.SetRange(Environment, lc_IC.Environment::Service);
                    if lc_IC.FindLast() then
                        if (CopyStr(lc_IC."Service Name", StrLen(lc_IC."Service Name"), 1) in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']) then
                            Rec."Service Name" := IncStr(lc_IC."Service Name")
                        else
                            Rec."Service Name" := CopyStr(lc_IC."Service Name" + '1', 1, MaxStrLen(Rec."Service Name"));
                end;

                // Find service on other servers
                if (Rec."Environment State".ToLower() = Rec.GetStatusToCreate().ToLower()) then begin
                    lc_IC.SetFilter(Server, '<>%1', '@' + BscMgmt.System_GetCurrentComputerName());
                    lc_IC.SetFilter("Service Name", '%1', '@' + Rec."Service Name");
                    if lc_IC.FindFirst() then
                        Rec.Validate(ManagementServicesPort, lc_IC.ManagementServicesPort);
                end;

                // Set listname
                SetListName();

                // Set url
                SetUrl();
            end;
        }
        field(50; "Environment Type"; Option)
        {
            Caption = 'Environment Type';
            DataClassification = CustomerContent;
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
            Caption = 'Environment State';
            DataClassification = CustomerContent;
        }
        field(60; "Service State"; Text[50])
        {
            Caption = 'Service State';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                case Rec."Service State".ToLower().Replace(' ', '') of
                    'running':
                        Rec."Service Status" := Rec."Service Status"::Running;
                    'Stopped':
                        Rec."Service Status" := Rec."Service Status"::Stopped;
                    else
                        Rec."Service Status" := Rec."Service Status"::None;
                end;
            end;
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
        field(65; "Service Status"; Enum IMPServiceStatus)
        {
            Caption = 'Service Status';
            DataClassification = CustomerContent;
        }
        field(70; DatabaseServer; Text[30])
        {
            Caption = 'SQL Server';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lc_IS: Record "IMP Server";
            begin
                lc_IS.Reset();
                lc_IS.SetRange(Type, lc_IS.Type::Sql);
                if (Rec.DatabaseServer <> '') then
                    lc_IS.SetRange(Name, Rec.DatabaseServer);
                if lc_IS.FindSet() then;
                lc_IS.SetRange(Name);
                if Page.RunModal(Page::"IMP Server List", lc_IS) = Action::LookupOK then begin
                    Rec.DatabaseServer := lc_IS.Name;
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

            trigger OnValidate()
            begin
                if (Rec.ManagementServicesPort = 0) then begin
                    Rec.ClientServicesPort := 0;
                    Rec.SOAPServicesPort := 0;
                    Rec.ODataServicesPort := 0;
                    Rec.DeveloperServicesPort := 0;
                end else
                    if (Rec.ManagementServicesPort <> xRec.ManagementServicesPort) then begin
                        if not Format((Rec.ManagementServicesPort)).EndsWith('5') then
                            Evaluate(Rec.ManagementServicesPort, CopyStr(Format(Rec.ManagementServicesPort), 1, StrLen(Format(Rec.ManagementServicesPort)) - 1) + '5');
                        Rec.ClientServicesPort := Rec.ManagementServicesPort + 1;
                        Rec.SOAPServicesPort := Rec.ManagementServicesPort + 2;
                        Rec.ODataServicesPort := Rec.ManagementServicesPort + 3;
                        Rec.DeveloperServicesPort := Rec.ManagementServicesPort + 4;
                    end;
            end;
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
        field(84; DeveloperServicesPort; Integer)
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
        field(141; "Customer Abbreviation"; Code[10])
        {
            Caption = 'Customer Abbreviation';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."IMP Abbreviation" where("No." = field("Customer No.")));
            Editable = false;
        }
        field(150; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lc_Comp: Record Company;
                lc_AS: Record "Active Session";
                lc_IA: Record "IMP Authorisation";
                lc_CompName: Text;
                lc_CompId: Text;
            begin
                // Get local companies
                lc_AS.Get(ServiceInstanceId(), SessionId());
                if ((Rec.Server = lc_AS."Server Computer Name".ToUpper()) and (Rec.DatabaseName.ToLower() = lc_AS."Database Name".ToLower())) then begin
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
            DataClassification = CustomerContent;
        }
        field(160; "WebService In Launch"; Boolean)
        {
            Caption = 'WebService In Launch';
            DataClassification = CustomerContent;
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
        key(Key3; Environment, "Environment Name", "Environment Id")
        {
        }
        key(Key4; "Customer No.")
        {
        }
        key(Key5; Server, "Service Name", "Company Name")
        {
        }
        key(Key6; Environment, "DatabaseServer", "DatabaseInstance", DatabaseName)
        {
        }
        key(Key7; Environment, ManagementServicesPort, Server)
        {
        }
    }

    #region Triggers

    trigger OnInsert()
    var
        lc_CompInfo: Record "Company Information";
        lc_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if ((not Rec.IsTemporary) and (Rec."No." = '')) then begin
            lc_CompInfo.Get();
            lc_CompInfo.TestField("IMP Connection Nos.");
            lc_NoSeriesMgt.InitSeries(lc_CompInfo."IMP Connection Nos.", '', 0D, Rec."No.", lc_CompInfo."IMP Connection Nos.");
        end;
    end;

    #endregion Triggers

    #region Methods Urls

    procedure SetUrl()
    var
    begin
        Rec.Url := CopyStr(GetUrlClient(), 1, MaxStrLen(Rec.Url));
    end;

    procedure GetUrlBase() RetValue: Text
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Get(Rec.Server);
        RetValue := lc_IS.GetBaseUrl();
    end;

    procedure GetUrlClient() RetValue: Text
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Get(Rec.Server);
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := lc_IS.GetClientUrl() + ':8080/' + Rec."Service Name";
            Rec.Environment::Docker:
                RetValue := lc_IS.GetClientUrl() + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := lc_IS.GetClientUrl() + '/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlApi() RetValue: Text
    begin
        RetValue := GetUrlApi(GetUrlBase(), 'v2.0')
    end;

    procedure GetUrlApi(_BaseUrl: Text; _Version: Text) RetValue: Text
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Get(Rec.Server);
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := lc_IS.GetClientUrl() + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/api';
            Rec.Environment::Docker:
                RetValue := lc_IS.GetClientUrl() + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := lc_IS.GetDnsUrl() + _Version + '/' + Rec."Environment Id" + '/Production/api/' + _Version;
        end;
    end;

    procedure GetUrlOdata() RetValue: Text
    begin
        RetValue := GetUrlOdata(GetUrlBase());
    end;

    procedure GetUrlOdata(_BaseUrl: Text) RetValue: Text
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Get(Rec.Server);
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := lc_IS.GetDnsUrl() + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/';
            Rec.Environment::Docker:
                RetValue := lc_IS.GetClientUrl() + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := lc_IS.GetDnsUrl() + '/v2.0/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlOdataService() RetValue: Text
    begin
        GetUrlOdataService(CompanyName);
    end;

    procedure GetUrlOdataService(_CompanyName: Text) RetValue: Text
    begin
        RetValue += GetUrlOdata() + 'ODataV4/IMPWebService_odata?Company=' + '''' + _CompanyName + '''';
    end;

    procedure GetUrlSOAP() RetValue: Text
    begin
        RetValue := GetUrlSOAP(GetUrlBase())
    end;

    procedure GetUrlSOAP(_BaseUrl: Text) RetValue: Text
    var
        lc_IS: Record "IMP Server";
    begin
        lc_IS.Get(Rec.Server);
        case Rec.Environment of
            Rec.Environment::Service:
                RetValue := lc_IS.GetDnsUrl() + ':' + Format(Rec.SOAPServicesPort) + '/' + Rec."Service Name" + '/WS';
            Rec.Environment::Docker:
                RetValue := lc_IS.GetClientUrl() + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := lc_IS.GetDnsUrl() + '/' + Rec."Environment Id" + '/' + Rec."Environment Name";
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
        lc_IC.SetRange("Environment Name", "Environment Name");
        if lc_IC.FindFirst() then
            RetValue := lc_IC.GetUrlOdata();

        // Finish connection
        if not RetValue.EndsWith('/') then
            RetValue += '/';

        // Add odata and company
        RetValue += 'ODataV4/IMPWebService_odata?Company=' + '''' + CompanyName + '''';
    end;

    #endregion Methods Urls

    #region Methods Misc

    procedure AlreadyExists(_WithError: Boolean) RetValue: Boolean
    var
        lc_Rec: Record "IMP Connection";
        lc_Txt1_Txt: Label 'Entry %1 has already this setting';
    begin
        // Find
        lc_Rec.Reset();
        lc_Rec.SetCurrentKey(Environment, "Environment Name", "Environment Id");
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
                //lc_Entry.Add('computer', _Rec.Computer);
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

    procedure AddToLaunchJson(var _Rec: Record "IMP Connection")
    begin
        ActToLaunchJson(_Rec, 'add');
    end;

    procedure ReplaceLaunchJson(var _Rec: Record "IMP Connection")
    begin
        ActToLaunchJson(_Rec, 'replace');
    end;

    local procedure ActToLaunchJson(var _Rec: Record "IMP Connection"; _Type: Text)
    var
        lc_TempBlob: Codeunit "Temp Blob";
        lc_FullFileName: Text;
        lc_InStream: InStream;
        lc_Json: JsonObject;
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_New: JsonObject;
        lc_FileName: Text;
        lc_Txt0_Txt: Label 'Select file';
    begin
        // Only with selection
        if not _Rec.Find('-') then
            Error('Select a connection first!');

        // Init
        lc_FileName := 'launch.json';

        // Get current json to add entries
        if (_Type.ToLower() = 'add') then begin
            lc_TempBlob.CreateInStream(lc_InStream);
            if not UploadIntoStream(lc_Txt0_Txt, '', BscMgmt.GetFileFilter(IMPDataFormat::Json, false), lc_FileName, lc_InStream) then
                exit;

            // Transfer in json
            if not lc_Json.ReadFrom(lc_InStream) then
                Error('"%1" no json file!', lc_FullFileName);

            // Check json
            if not lc_Json.Get('configurations', lc_Token) then
                Error('Token configurations missing in "%1"', lc_FullFileName);

            // Load array
            lc_Array := lc_Token.AsArray();
        end;

        // Add selected connections to array
        repeat
            // Remove connection from current array
            if (_Type.ToLower() = 'add') then
                RemoveAlreadyExistsEntryInLaunch(_Rec, lc_Array);
            // Add connection
            case _Rec.Environment of
                _Rec.Environment::Service:
                    begin
                        clear(lc_New);
                        lc_New.Add('type', 'al');
                        lc_New.Add('request', 'launch');
                        lc_New.Add('name', _Rec."List Name");
                        lc_New.Add('server', 'http://' + _Rec.Server);
                        lc_New.Add('authentication', 'UserPassword');
                        lc_New.Add('serverInstance', _Rec."Service Name");
                        lc_New.Add('startupObjectType', 'Page');
                        lc_New.Add('startupObjectId', 9005);
                        lc_New.Add('breakOnError', true);
                        lc_New.Add('launchBrowser', true);
                        lc_New.Add('enableLongRunningSqlStatements', true);
                        lc_New.Add('enableSqlInformationDebugger', true);
                        lc_New.Add('port', _Rec.DeveloperServicesPort);
                        lc_New.Add('schemaUpdateMode', 'Synchronize');
                        lc_Array.Add(lc_New);
                        if (_Rec."WebService In Launch") then begin
                            clear(lc_New);
                            lc_New.Add('type', 'al');
                            lc_New.Add('request', 'attach');
                            lc_New.Add('name', 'Debug WebserviceClient ' + _Rec."List Name");
                            lc_New.Add('server', 'http://' + _Rec.Server);
                            lc_New.Add('authentication', 'UserPassword');
                            lc_New.Add('serverInstance', _Rec."Service Name");
                            lc_New.Add('breakOnError', true);
                            lc_New.Add('breakOnRecordWrite', false);
                            lc_New.Add('breakOnNext', 'WebServiceClient');
                            lc_New.Add('port', _Rec.DeveloperServicesPort);
                            lc_Array.Add(lc_New);
                        end;
                    end;
                _Rec.Environment::Cloud:
                    begin
                        clear(lc_New);
                        lc_New.Add('type', 'al');
                        lc_New.Add('request', 'launch');
                        lc_New.Add('name', _Rec."List Name");
                        lc_New.Add('startupObjectType', 'Page');
                        lc_New.Add('startupObjectId', 379);
                        lc_New.Add('environmentType', Format(_Rec."Environment Type"));
                        lc_New.Add('environmentName', _Rec."Environment Name");
                        lc_New.Add('breakOnError', true);
                        lc_New.Add('breakOnRecordWrite', false);
                        lc_New.Add('launchBrowser', true);
                        lc_New.Add('tenant', _Rec."Environment Id");
                        lc_New.Add('schemaUpdateMode', 'Synchronize');
                        lc_New.Add('dependencyPublishingOption', 'Ignore');
                        lc_Array.Add(lc_New);
                    end;
                _Rec.Environment::Docker:
                    begin
                        lc_New.Add('type', 'al');
                        lc_New.Add('request', 'launch');
                        lc_New.Add('name', _Rec."Environment Name" + '(Docker)');
                        lc_New.Add('environmentType', Format(_Rec."Environment Type"));
                        lc_New.Add('server', 'http://' + _Rec.Server + '/' + _Rec."Environment Name");
                        lc_New.Add('serverInstance', _Rec."Service Name");
                        lc_New.Add('authentication', 'UserPassword');
                        lc_New.Add('startupObjectType', 'Page');
                        lc_New.Add('startupObjectId', 9005);
                        lc_New.Add('tenant', 'default');
                        lc_New.Add('breakOnError', true);
                        lc_New.Add('launchBrowser', true);
                        lc_New.Add('breakOnRecordWrite', false);
                        lc_New.Add('enableLongRunningSqlStatements', true);
                        lc_New.Add('enableSqlInformationDebugger', true);
                        lc_New.Add('longRunningSqlStatementsThreshold', 500);
                        lc_New.Add('numberOfSqlStatements', 10);
                        lc_New.Add('schemaUpdateMode', 'Synchronize');
                    end;
            end;
        until _Rec.Next() = 0;

        // Write array
        case _Type.ToLower() of
            'add':
                lc_Json.Replace('configurations', lc_Array);
            'replace':
                begin
                    clear(lc_Json);
                    lc_Json.Add('version', '0.2.0');
                    lc_Json.Add('configurations', lc_Array);
                end;
        end;

        // Write and export file
        WriteAndExportLaunch(lc_Json, lc_FileName);
    end;

    local procedure RemoveAlreadyExistsEntryInLaunch(var _Rec: Record "IMP Connection"; var _Array: JsonArray)
    var
        lc_Entry: JsonToken;
        lc_Token: JsonToken;
        lc_New: JsonArray;
        lc_Name: Text;
    begin
        clear(lc_New);
        foreach lc_Entry in _Array do
            case _Rec.Environment of
                _Rec.Environment::Service:
                    if lc_Entry.AsObject().Get('name', lc_Token) then begin
                        lc_Name := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();
                        if _Rec."List Name".ToLower() <> lc_Name.ToLower() then
                            lc_New.Add(lc_Entry);
                    end;
                _Rec.Environment::Cloud:
                    if lc_Entry.AsObject().Get('name', lc_Token) then begin
                        lc_Name := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();
                        if _Rec."List Name".ToLower() <> lc_Name.ToLower() then
                            lc_New.Add(lc_Entry);
                    end;
            end;
        _Array := lc_New;
    end;

    local procedure EntryAlreadyExistsInLaunch(var _Rec: Record "IMP Connection"; var _Array: JsonArray) RetValue: Boolean
    var
        lc_Entry: JsonToken;
        lc_Token: JsonToken;
        lc_Name: Text;
    begin
        RetValue := false;
        foreach lc_Entry in _Array do
            case _Rec.Environment of
                _Rec.Environment::Service:
                    if lc_Entry.AsObject().Get('serverInstance', lc_Token) then begin
                        lc_Name := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();
                        if _Rec."Service Name".ToLower() = lc_Name.ToLower() then begin
                            RetValue := true;
                            exit;
                        end;
                    end;
                _Rec.Environment::Cloud:
                    if lc_Entry.AsObject().Get('environmentName', lc_Token) then begin
                        lc_Name := BscMgmt.JsonGetTokenValue(lc_Token, 'environmentName').AsText();
                        if _Rec."Environment Name".ToLower() = lc_Name.ToLower() then begin
                            RetValue := true;
                            exit;
                        end;
                    end;
            end;
    end;

    local procedure WriteAndExportLaunch(var _Json: JsonObject; _FileName: Text)
    var
        lc_TempBlob: Codeunit "Temp Blob";
        lc_OutStream: OutStream;
        lc_InStream: InStream;
        lc_Entry: JsonToken;
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_CrLf: Text;
        lc_Counter: Integer;
    begin
        // Init
        lc_CrLf[1] := 13;
        lc_CrLf[2] := 10;

        // Create oustream
        lc_TempBlob.CreateOutStream(lc_OutStream, TextEncoding::UTF8);

        // Start json
        lc_OutStream.WriteText('{' + lc_CrLf);
        if (_Json.Get('version', lc_Token)) then
            lc_OutStream.WriteText('    "version" : "' + BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText() + '",' + lc_CrLf);
        if (_Json.Get('configurations', lc_Token)) then
            lc_OutStream.WriteText('    "configurations" : [' + lc_CrLf);
        // Write configuarions
        if lc_Token.IsArray() then begin
            lc_Array := lc_Token.AsArray();
            lc_Counter := 0;
            foreach lc_Entry in lc_Array do begin
                lc_Counter += 1;

                // Separate configuration
                if (lc_Counter > 1) then
                    lc_OutStream.WriteText('       ,' + lc_CrLf);

                // Start configuration
                lc_OutStream.WriteText('       {' + lc_CrLf);

                if (lc_Entry.AsObject().Get('type', lc_Token)) then
                    lc_OutStream.WriteText('           "type" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('request', lc_Token)) then
                    lc_OutStream.WriteText('           "request" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('name', lc_Token)) then
                    lc_OutStream.WriteText('           "name" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('server', lc_Token)) then
                    lc_OutStream.WriteText('           "server" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('authentication', lc_Token)) then
                    lc_OutStream.WriteText('           "authentication" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('serverInstance', lc_Token)) then
                    lc_OutStream.WriteText('           "serverInstance" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('startupObjectType', lc_Token)) then
                    lc_OutStream.WriteText('           "startupObjectType" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('startupObjectId', lc_Token)) then
                    lc_OutStream.WriteText('           "startupObjectId" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('breakOnRecordWrite', lc_Token)) then
                    lc_OutStream.WriteText('           "breakOnRecordWrite" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('breakOnNext', lc_Token)) then
                    lc_OutStream.WriteText('           "breakOnNext" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('launchBrowser', lc_Token)) then
                    lc_OutStream.WriteText('           "launchBrowser" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('enableLongRunningSqlStatements', lc_Token)) then
                    lc_OutStream.WriteText('           "enableLongRunningSqlStatements" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('enableSqlInformationDebugger', lc_Token)) then
                    lc_OutStream.WriteText('           "enableSqlInformationDebugger" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('schemaUpdateMode', lc_Token)) then
                    lc_OutStream.WriteText('           "schemaUpdateMode" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('port', lc_Token)) then
                    lc_OutStream.WriteText('           "port" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('environmentType', lc_Token)) then
                    lc_OutStream.WriteText('           "environmentType" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('environmentName', lc_Token)) then
                    lc_OutStream.WriteText('           "environmentName" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('tenant', lc_Token)) then
                    lc_OutStream.WriteText('           "tenant" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('dependencyPublishingOption', lc_Token)) then
                    lc_OutStream.WriteText('           "dependencyPublishingOption" : "' + lc_Token.AsValue().AsText() + '",' + lc_CrLf);
                if (lc_Entry.AsObject().Get('longRunningSqlStatementsThreshold', lc_Token)) then
                    lc_OutStream.WriteText('           "longRunningSqlStatementsThreshold" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);
                if (lc_Entry.AsObject().Get('numberOfSqlStatements', lc_Token)) then
                    lc_OutStream.WriteText('           "numberOfSqlStatements" : ' + lc_Token.AsValue().AsText() + ',' + lc_CrLf);

                // Last setting
                if (lc_Entry.AsObject().Get('breakOnError', lc_Token)) then
                    lc_OutStream.WriteText('           "breakOnError" : ' + lc_Token.AsValue().AsText() + lc_CrLf);

                // Finish configuration
                lc_OutStream.WriteText('       }' + lc_CrLf);
            end;
        end;

        // Finish json
        lc_OutStream.WriteText('    ]' + lc_CrLf);
        lc_OutStream.WriteText('}' + lc_CrLf);

        // Create instram
        lc_TempBlob.CreateInStream(lc_InStream, TextEncoding::UTF8);

        // Export file
        DownloadFromStream(lc_InStream, 'Export', '', '', _FileName);
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
        lc_IC.SetCurrentKey(Environment, "Environment Name", "Environment Id");
        lc_IC.SetFilter(Environment, '%1|%2', lc_IC.Environment::SQLInstance, lc_IC.Environment::SQLDatabase);
        lc_IC.SetRange("Environment Name", lc_Server);
        if lc_IC.FindSet() then
            lc_IC.DeleteAll(true);

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
                    lc_IC."Environment Name" := CopyStr(lc_Server, 1, MaxStrLen(lc_IC."Environment Name"));
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

    procedure ImportServerInstances(_Root: JsonObject; var _Response: JsonObject) RetValue: Boolean
    var
        lc_IS: Record "IMP Server";
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
        */

        #endregion Json syntax

        // Init
        RetValue := false;
        lc_ServerInstance := '';

        // Server
        if not _Root.Get('server', lc_Token) then begin
            _Response.Add('error', 'Token server missing in json');
            exit;
        end else begin
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();
            if not lc_IS.Get(lc_Server) then begin
                _Response.Add('error', 'Server "' + lc_Server + '" missing in table ' + lc_IS.TableName());
                exit;
            end;
        end;

        // Version
        if not _Root.Get('version', lc_Token) then
            lc_Version := ''
        else
            lc_Version := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

        // Dns
        if not _Root.SelectToken('dns', lc_Token) then begin
            _Response.Add('error', 'Token dns missing in json');
            exit;
        end else begin
            lc_Dns := BscMgmt.JsonGetTokenValue(lc_Token, 'dns').AsText();
            if (lc_IS.Dns.ToLower() <> lc_Dns.ToLower()) then begin
                _Response.Add('error', 'The dns "' + lc_Dns + '" dosen''t match with the server dns "' + lc_IS.Dns + '"');
                exit;
            end;
        end;

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
                if lc_Array.Get(0, lc_Token) then
                    lc_ServerInstance := BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText();
        end;

        // Clear List
        lc_IC.Reset();
        // Only servers
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);
        // Only this computer
        lc_IC.SetRange(Server, lc_Server);
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
            if not ImportServerInstance(lc_ICTemp, lc_IS, lc_Token, lc_Message) then
                exit;

        // Store data
        Commit();

        // Return
        RetValue := true;
    end;

    procedure ImportServerInstance(var _Temp: Record "IMP Connection"; _IS: Record "IMP Server"; _Root: JsonToken; var _Message: Text) RetValue: Boolean
    var
        lc_IC: Record "IMP Connection";
        lc_Cust: Record Customer;
        lc_Array: JsonArray;
        lc_Entry: JsonToken;
        lc_Token: JsonToken;
        lc_Value: JsonValue;
        lc_EntryName: Text;
        lc_List: List of [Text];
        lc_Abbreviation: Text;
    begin
        // Init
        RetValue := false;

        // Process
        lc_IC.Init();

        // Server
        lc_IC.Server := _IS.Name;

        // Environment
        if not _Root.SelectToken('environment', lc_Token) then begin
            _Message := 'Environment missing as token in services';
            exit;
        end else
            case BscMgmt.JsonGetTokenValue(lc_Token, 'environment').AsText().ToLower() of
                'server':
                    lc_IC.Environment := lc_IC.Environment::Service;
                'cloud':
                    lc_IC.Environment := lc_IC.Environment::Cloud;
                'docker':
                    lc_IC.Environment := lc_IC.Environment::Docker;
            end;

        // Environment type
        if not _Root.SelectToken('environmenttype', lc_Token) then begin
            _Message := 'Environmenttype missing as token in services';
            exit;
        end else
            case BscMgmt.JsonGetTokenValue(lc_Token, 'environmenttype').AsText().ToLower() of
                'onprem':
                    lc_IC."Environment Type" := lc_IC."Environment Type"::OnPrem;
                'sandbox':
                    lc_IC."Environment Type" := lc_IC."Environment Type"::Sandbox;
                'production':
                    lc_IC."Environment Type" := lc_IC."Environment Type"::Production;
            end;

        // Environment id
        if not _Root.SelectToken('environmentid', lc_Token) then begin
            _Message := 'Environmentid missing as token in container';
            exit;
        end else
            lc_IC."Environment Id" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentid').AsText(), 1, MaxStrLen(lc_IC."Environment Id"));

        // Environment name
        if not _Root.SelectToken('environmentname', lc_Token) then begin
            _Message := 'Environmentname missing as token in dockers';
            exit;
        end else
            lc_IC.Validate("Environment Name", CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentname').AsText(), 1, MaxStrLen(lc_IC."Environment Name")));

        // Environment state
        if not _Root.SelectToken('environmentstate', lc_Token) then begin
            _Message := 'Environmentstate missing as token in container';
            exit;
        end else
            lc_IC."Environment State" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'environmentstate').AsText(), 1, MaxStrLen(lc_IC."Environment State"));

        // Name
        if not _Root.SelectToken('name', lc_Token) then begin
            _Message := 'Name missing as token in services';
            exit;
        end else begin
            lc_IC."Service Name" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText(), 1, MaxStrLen(lc_IC."Service Name"));
            if (lc_IC."Service Name".Contains('-')) then begin
                lc_List := lc_IC."Service Name".Split('-');
                lc_Abbreviation := lc_List.Get(1).ToUpper();
                lc_Cust.Reset();
                lc_Cust.SetRange("IMP Abbreviation", lc_Abbreviation);
                if lc_Cust.FindFirst() then
                    lc_IC."Customer No." := lc_Cust."No.";
            end;
        end;

        // State
        if not _Root.SelectToken('state', lc_Token) then begin
            _Message := 'State missing as token in services';
            exit;
        end else
            lc_IC.Validate("Service State", BscMgmt.JsonGetTokenValue(lc_Token, 'state').AsText());

        // Status
        if lc_IC."Service Status" = lc_IC."Service Status"::None then
            lc_IC."Service Status" := lc_IC."Service Status"::Stopped;

        // Navision
        if not _Root.SelectToken('navision', lc_Token) then begin
            _Message := 'Navision missing as token in services';
            exit;
        end else
            lc_IC."Service NAV Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'navision').AsText(), 1, MaxStrLen(lc_IC."Service NAV Version"));

        // Version
        if not _Root.SelectToken('version', lc_Token) then begin
            _Message := 'Version missing as token in services';
            exit;
        end else
            lc_IC."Service Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText(), 1, MaxStrLen(lc_IC."Service Version"));

        // FullVersion
        if not _Root.SelectToken('fullversion', lc_Token) then begin
            _Message := 'Fullversion missing as token in services';
            exit;
        end else
            lc_IC."Service Full Version" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'fullversion').AsText(), 1, MaxStrLen(lc_IC."Service Full Version"));

        // Acount
        if not _Root.SelectToken('account', lc_Token) then begin
            _Message := 'Account missing as token in services';
            exit;
        end else
            lc_IC."Service Account" := CopyStr(BscMgmt.JsonGetTokenValue(lc_Token, 'account').AsText(), 1, MaxStrLen(lc_IC."Service Account"));

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
                        lc_IC.DatabaseServer := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_IC.DatabaseServer));
                    LowerCase('DatabaseInstance'):
                        lc_IC.DatabaseInstance := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_IC.DatabaseInstance));
                    LowerCase('DatabaseName'):
                        lc_IC.DatabaseName := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_IC.DatabaseName));
                    LowerCase('ManagementServicesPort'):
                        lc_IC.ManagementServicesPort := lc_Value.AsInteger();
                    LowerCase('ClientServicesPort'):
                        lc_IC.ClientServicesPort := lc_Value.AsInteger();
                    LowerCase('SOAPServicesPort'):
                        lc_IC.SOAPServicesPort := lc_Value.AsInteger();
                    LowerCase('ODataServicesPort'):
                        lc_IC.ODataServicesPort := lc_Value.AsInteger();
                    LowerCase('DeveloperServicesPort'):
                        lc_IC.DeveloperServicesPort := lc_Value.AsInteger();
                    LowerCase('ClientServicesCredentialType'):
                        lc_IC.ClientServicesCredentialType := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_IC.ClientServicesCredentialType));
                    LowerCase('ServicesCertificateThumbprint'):
                        lc_IC.ServicesCertificateThumbprint := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_IC.ServicesCertificateThumbprint));
                end;
            end;
        end;

        // Reset stored data
        case lc_IC.Environment of
            lc_IC.Environment::Service:
                begin
                    _Temp.SetRange("Service Name", lc_IC."Service Name");
                    if _Temp.FindFirst() then begin
                        lc_IC."No." := _Temp."No.";
                        if (_Temp."Customer No." <> '') then
                            lc_IC."Customer No." := _Temp."Customer No.";
                        lc_IC."Authorisation No." := _Temp."Authorisation No.";
                    end;
                    _Temp.SetRange("Service Name");
                end;
            lc_IC.Environment::Docker:
                begin
                    _Temp.SetRange("Environment Id", lc_IC."Environment Id");
                    if _Temp.FindFirst() then begin
                        lc_IC."No." := _Temp."No.";
                        if (_Temp."Customer No." <> '') then
                            lc_IC."Customer No." := _Temp."Customer No.";
                        lc_IC."Authorisation No." := _Temp."Authorisation No.";
                    end;
                    _Temp.SetRange("Environment Id");
                end;
        end;

        // Set listname
        lc_IC.SetListName();
        lc_IC.SetUrl();

        // Insert
        lc_IC.Insert(true);

        // Set return value
        RetValue := true;
    end;


    procedure ImportDockers(_Root: JsonObject; var _Response: Text) RetValue: Boolean
    var
        lc_IS: Record "IMP Server";
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
            "dockers":  []
        */

        #endregion Json syntax

        // Init
        RetValue := false;

        // Server
        if not _Root.Get('server', lc_Token) then begin
            _Response := 'Token server missing in json';
            exit;
        end else begin
            lc_Server := BscMgmt.JsonGetTokenValue(lc_Token, 'server').AsText();
            if not lc_IS.Get(lc_Server) then begin
                _Response := 'Server "' + lc_Server + '" missing in table ' + lc_IS.TableName();
                exit;
            end;
        end;

        // Version
        if not _Root.Get('version', lc_Token) then
            lc_Version := ''
        else
            lc_Version := BscMgmt.JsonGetTokenValue(lc_Token, 'version').AsText();

        // Dns
        if not _Root.SelectToken('dns', lc_Token) then begin
            _Response := 'Token dns missing in json';
            exit;
        end else begin
            lc_Dns := BscMgmt.JsonGetTokenValue(lc_Token, 'dns').AsText();
            if (lc_IS.Dns.ToLower() <> lc_Dns.ToLower()) then begin
                _Response := 'The dns "' + lc_Dns + '" dosen''t match with the server dns "' + lc_IS.Dns + '"';
                exit;
            end;
        end;

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
        lc_IC.SetRange(Environment, lc_IC.Environment::Docker);
        lc_IC.SetRange("Environment Name", lc_Server);
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
                if not ImportServerInstance(lc_ICTemp, lc_IS, lc_Token, _Response) then
                    exit;
        end;

        // Dockers
        if _Root.Get('dockers', lc_Token) then begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Token in lc_Array do
                if not ImportServerInstance(lc_ICTemp, lc_IS, lc_Token, _Response) then
                    exit;
        end;

        // Store data
        Commit();

        // Return
        RetValue := true;
    end;

    procedure NewRecord(var _BelowxRec: Boolean; _CustomerNo: Text; var _Rec: Record "IMP Connection") RetValue: Boolean
    var
        lc_CompInfo: Record "Company Information";
        lc_Cust: Record Customer;
        lc_IC: Record "IMP Connection";
        lc_IS: Record "IMP Server";
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

        // Get company info
        lc_CompInfo.Get();
        lc_CompInfo.TestField("IMP Basic Dns");

        // Select type
        lc_Type := StrMenu('Service,Docker,Cloud', 0, 'Select your type of service');
        if (lc_Type = 0) then
            exit;

        // Service
        if (lc_Type = 1) then begin
            Rec.Environment := Rec.Environment::Service;
            Rec."Environment Type" := Rec."Environment Type"::OnPrem;
            Rec."Environment State" := CopyStr(GetStatusToCreate(), 1, MaxStrLen(Rec."Environment State"));
            //Rec."Environment Name" := CopyStr(Rec.Server, 1, MaxStrLen(Rec."Environment Name"));
            Rec."Service State" := Rec."Environment State";
            Rec."Service Status" := Rec."Service Status"::ToCreate;
            Rec.Server := CopyStr(BscMgmt.System_GetCurrentComputerName(), 1, MaxStrLen(Rec.Server));
            lc_IS.Get(_Rec.Server);
        end;

        // Dockers 
        if (lc_Type = 2) then begin
            Rec.Environment := Rec.Environment::Docker;
            Rec."Environment State" := CopyStr(GetStatusToCreate(), 1, MaxStrLen(Rec."Environment State"));
            Error('Docker not possible yet!');
        end;

        // Cloud
        if (lc_Type = 3) then begin
            Rec.Environment := Rec.Environment::Cloud;
            Rec."Environment Type" := Rec."Environment Type"::Sandbox;
            lc_IS.Reset();
            lc_IS.SetRange(Type, lc_IS.Type::cloud);
            if lc_IS.FindFirst() then
                Rec.Server := lc_IS.Name;
        end;

        // Select version
        if (lc_Type = 1) then begin
            lc_TVersion := lc_IS.NAVVersionSelect();
            lc_ServicesCertificateThumbprint := lc_IS."Certificate Thumbprint";
        end;

        // Set version
        if (lc_Type <> 3) then begin
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
            Rec."Service Version" := CopyStr(lc_TVersion, 1, MaxStrLen(Rec."Service Version"));

            // set service account
            Rec."Service Account" := CopyStr(Rec.GetServiceAc(), 1, MaxStrLen(Rec."Service Account"));
        end;

        // set nav version
        if (Rec.Environment = Rec.Environment::Service) then
            if (lc_IVersion < 140) then
                Rec."Service NAV Version" := CopyStr('NAV' + lc_NVersion, 1, MaxStrLen(Rec."Service NAV Version"))
            else
                Rec."Service NAV Version" := CopyStr(lc_NVersion, 1, MaxStrLen(Rec."Service NAV Version"));

        // Select customer
        if not lc_Cust.Get(_CustomerNo) then
            if Page.RunModal(0, lc_Cust) <> Action::LookupOK then
                exit;

        // Check customer
        lc_Cust.TestField("IMP Abbreviation");

        // Set customer
        Rec."Customer No." := lc_Cust."No.";

        // Tenant
        if (Rec.Environment = Rec.Environment::Cloud) then
            Rec."Environment Id" := lc_Cust."IMP Tenant Id";

        // Name
        if (Rec.Environment = Rec.Environment::Service) then begin
            // Set name
            Rec."Service Name" := lc_Cust."IMP Abbreviation" + '-' + lc_NVersion + '-DEV1';

            // Validate name
            Rec.Validate("Service Name");

            // Set ports
            Rec.Validate(ManagementServicesPort, GetNextManagementServicesPort(Rec.Server, Rec."Service Name"));

            // Select login
            lc_Login := StrMenu('Windows,UserName,NavUserPassword', 3, 'Select your access type'); // AccessControlService
            if (lc_Login = 0) then
                exit;

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

            // Select Database Server
            if (Rec.DatabaseServer = '') then begin
                lc_IS.Reset();
                lc_IS.SetRange(Type, lc_IS.Type::Sql);
                if lc_IS.FindSet() then
                    if lc_IS.Count() > 1 then begin
                        if Page.RunModal(Page::"IMP Server List", lc_IS) = Action::LookupOK then
                            Rec.DatabaseServer := lc_IS.Name;
                    end else
                        Rec.DatabaseServer := lc_IS.Name;
            end;

            // Select Database Instance
            if (Rec.DatabaseInstance = '') then begin
                lc_IC.Reset();
                lc_IC.SetCurrentKey(Environment, "DatabaseServer", "DatabaseInstance", DatabaseName);
                lc_IC.SetRange(Environment, lc_IC.Environment::SQLInstance);
                if (Rec.DatabaseServer <> '') then
                    lc_IC.SetRange(DatabaseServer, Rec.DatabaseServer);
                if lc_IC.FindSet() then
                    if lc_IC.Count() > 1 then begin
                        if Page.RunModal(Page::"IMP Databases", lc_IC) = Action::LookupOK then
                            Rec.DatabaseInstance := lc_IC.DatabaseInstance;
                    end else
                        Rec.DatabaseInstance := lc_IC.DatabaseInstance;
            end;

            // Select Database Name
            if (Rec.DatabaseName = '') then begin
                lc_IC.Reset();
                lc_IC.SetCurrentKey(Environment, "DatabaseServer", "DatabaseInstance", DatabaseName);
                lc_IC.SetRange(Environment, lc_IC.Environment::SQLDatabase);
                if (Rec.DatabaseServer <> '') then
                    lc_IC.SetRange(DatabaseServer, Rec.DatabaseServer);
                if (Rec.DatabaseInstance <> '') then
                    lc_IC.SetRange(DatabaseInstance, Rec.DatabaseInstance);
                if lc_IC.FindSet() then
                    if lc_IC.Count() > 1 then begin
                        if Page.RunModal(Page::"IMP Databases", lc_IC) = Action::LookupOK then
                            Rec.DatabaseName := lc_IC.DatabaseName;
                    end else
                        Rec.DatabaseName := lc_IC.DatabaseName;
            end;
        end;
    end;

    procedure GetNextManagementServicesPort(_Computer: Text; _ServiceName: Text) RetValue:
                                                 Integer
    var
        lc_IC: Record "IMP Connection";
        lc_Int: Integer;
    begin
        // Init 
        RetValue := 0;
        lc_Int := 7145;

        // Set filter
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Environment, ManagementServicesPort, Server);
        lc_IC.SetRange(Environment, lc_IC.Environment::Service);

        // Find service on other servers
        lc_IC.SetFilter(Server, '<>%1', '@' + BscMgmt.System_GetCurrentComputerName());
        lc_IC.SetFilter("Service Name", '%1', '@' + _ServiceName);
        if lc_IC.FindFirst() then begin
            RetValue := lc_IC.ManagementServicesPort;
            exit;
        end;

        // Find last number
        lc_IC.SetRange(Server);
        lc_IC.SetRange("Service Name");
        repeat
            lc_IC.SetRange(ManagementServicesPort, lc_Int);
            if lc_IC.IsEmpty() then
                RetValue := lc_Int
            else
                lc_Int += 10;
        until RetValue <> 0;
    end;

    procedure GetStatusToCreate() RetValue: Text
    begin
        RetValue := 'To create';
    end;

    procedure GetStatusToRemove() RetValue: Text
    begin
        RetValue := 'To remove';
    end;

    procedure GetServiceUs() RetValue: Text
    begin
        RetValue := 'admin';
    end;

    procedure GetServiceAc() RetValue: Text
    begin
        RetValue := 'IMP\admin';
    end;

    procedure GetServicePs() RetValue: Text
    begin
        RetValue := 'C0nsultAdm1n$';
    end;

    procedure GetPS(var _IC: Record "IMP Connection"; var _IntVersion: Integer; var _Version: Text; var _AdminTool: Text; var _Computer: Text; var _Url: Text)
    var
        lc_List: List of [Text];
    begin
        // Set version
        lc_List := _IC."Service Version".Split('.');
        Evaluate(_IntVersion, (lc_List.Get(1) + lc_List.Get(2)));

        // Admin tool
        if (_IntVersion <= 110) then
            _AdminTool := 'C:\Program Files\Microsoft Dynamics NAV\' + Format(_IntVersion) + '\Service\NAVAdminTool.ps1'
        else
            _AdminTool := 'C:\Program Files\Microsoft Dynamics 365 Business Central\' + Format(_IntVersion) + '\Service\NAVAdminTool.ps1';

        // Set version
        if (_IntVersion < 100) then
            _Version := CopyStr(Format(_IntVersion), 1, 1) + '.' + CopyStr(Format(_IntVersion), 2, 1)
        else
            _Version := CopyStr(Format(_IntVersion), 1, 2) + '.' + CopyStr(Format(_IntVersion), 3, 1);

        // Get computer
        _Computer := BscMgmt.System_GetCurrentComputerName();

        // Set url
        _URL := _IC.GetUrlOdataIMPProd(CompanyName);
    end;

    procedure RefreshCloud()
    var
    Begin
        if (Rec."Environment Type" <> Rec."Environment Type"::Production) then
            exit;


    End;

    #endregion Methods Misc

    var
        BscMgmt: Codeunit "IMP Basic Management";
        DatMgmt: Codeunit "IMP Data Management";
}