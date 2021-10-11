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
            OptionMembers = " ",Server,Docker,Cloud;
            OptionCaption = ',Server,Docker,Cloud';

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
        field(70; DatabaseServer; Text[30])
        {
            Caption = 'SQL Server';
            DataClassification = CustomerContent;
        }
        field(71; DatabaseInstance; Text[30])
        {
            Caption = 'SQL Instance';
            DataClassification = CustomerContent;
        }
        field(72; DatabaseName; Text[30])
        {
            Caption = 'DB Name';
            DataClassification = CustomerContent;
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
            Rec.Environment::Server:
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
            Rec.Environment::Server:
                RetValue := _BaseUrl + Rec.Computer + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/api';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'api.businesscentral.dynamics.com/' + _Version + '/' + Rec."Environment Id" + '/Production/api/' + _Version;
        end;
    end;

    procedure GetUrlOdata() RetValue: Text
    begin
        RetValue := GetUrlOdata(GetUrlBase())
    end;

    procedure GetUrlOdata(_BaseUrl: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Server:
                RetValue := _BaseUrl + Rec.Dns + ':' + Format(Rec.ODataServicesPort) + '/' + Rec."Service Name" + '/';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'api.businesscentral.dynamics.com/v2.0/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure GetUrlSOAP() RetValue: Text
    begin
        RetValue := GetUrlSOAP(GetUrlBase())
    end;

    procedure GetUrlSOAP(_BaseUrl: Text) RetValue: Text
    begin
        RetValue := '';
        case Rec.Environment of
            Rec.Environment::Server:
                RetValue := _BaseUrl + Rec.Dns + ':' + Format(Rec.SOAPServicesPort) + '/' + Rec."Service Name" + '/WS';
            Rec.Environment::Docker:
                RetValue := _BaseUrl + Rec."Environment Name" + '/' + Rec."Service Name" + '/';
            REc.Environment::Cloud:
                RetValue := _BaseUrl + 'businesscentral.dynamics.com/' + Rec."Environment Id" + '/' + Rec."Environment Name";
        end;
    end;

    procedure SetListName()
    var
        lc_Cust: Record Customer;
    begin
        if (Rec.Environment = Rec.Environment::Server) then
            Rec."List Name" := Rec."Service Name";
        if (Rec.Environment = Rec.Environment::Docker) then
            Rec."List Name" := Rec."Environment Name";
        if (Rec.Environment = Rec.Environment::Cloud) then
            if lc_Cust.Get(Rec."Customer No.") then begin
                lc_Cust.TestField("IMP Abbreviation");
                Rec."List Name" := CopyStr(lc_Cust."IMP Abbreviation" + ' ' + Rec."Environment Name", 1, MaxStrLen(Rec."List Name"));
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

    procedure LoadFromServer(_ServerName: Text)
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
            'serverinstance':
                if ImportServerInstances(lc_Temp, lc_ResponseJson, lc_Message) then
                    Commit()
                else
                    Error(lc_Message);
            else
                Error('Data "%1" is no valid entry', BscMgmt.JsonGetTokenValue(lc_Data, 'data').AsText());
        end;
    end;

    procedure ImportServerInstances(var _Temp: Record "IMP Connection"; _Root: JsonObject; var _Response: Text) RetValue: Boolean
    var
        lc_Token: JsonToken;
        lc_Array: JsonArray;
        lc_Server: Text;
        lc_Dns: Text;
    begin

        #region Json syntax

        /*
        {
            "data":  "ServerInstance",
            "server":  "IMPENT01",
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

        // Services
        if _Root.Get('services', lc_Token) then begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Token in lc_Array do
                if not ImportServerInstance(_Temp, lc_Server, lc_Dns, lc_Token, _Response) then
                    exit;
        end;

        // Dockers
        if _Root.Get('dockers', lc_Token) then begin
            lc_Array := lc_Token.AsArray();
            foreach lc_Token in lc_Array do
                if not ImportServerInstance(_Temp, lc_Server, lc_Dns, lc_Token, _Response) then
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
                    lc_ISI.Environment := lc_ISI.Environment::Server;
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
                    LowerCase('ClientServicesCredentialType'):
                        lc_ISI.ClientServicesCredentialType := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.ClientServicesCredentialType));
                    LowerCase('ServicesCertificateThumbprint'):
                        lc_ISI.ServicesCertificateThumbprint := CopyStr(lc_Value.AsText(), 1, MaxStrLen(lc_ISI.ServicesCertificateThumbprint));
                end;
            end;
        end;

        // Reset stored data
        case lc_ISI.Environment of
            lc_ISI.Environment::Server:
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

    #endregion Methodes

    var
        BscMgmt: Codeunit "IMP Basic Management";
        DatMgmt: Codeunit "IMP Data Management";
}