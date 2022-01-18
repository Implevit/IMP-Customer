table 50006 "IMP Server"
{
    Caption = 'Server';
    DataCaptionFields = "Name";
    LookupPageID = "IMP Server List";
    DrillDownPageId = "IMP Server List";

    fields
    {
        field(1; Name; Code[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(10; Type; Enum IMPServerType)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec.Type <> xRec.Type) then
                    SetDsn();
            end;
        }
        field(20; "NAV Versions"; Text[250])
        {
            Caption = 'Navision Versions';
            DataClassification = CustomerContent;
        }
        field(30; "Location"; Option)
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            OptionMembers = local,remote,cloud;
            OptionCaption = 'local,remote,cloud';

            trigger OnValidate()
            begin
                if (Rec.Location <> xRec.Location) then
                    SetDsn();
            end;
        }
        field(40; "SSL"; Boolean)
        {
            Caption = 'SSL';
            DataClassification = CustomerContent;
        }
        field(50; Connections; Integer)
        {
            Caption = 'Connections';
            FieldClass = FlowField;
            CalcFormula = count("IMP Connection" where(Server = field(Name)));
            TableRelation = "IMP Connection";
            Editable = false;
        }
        field(60; Dns; Text[100])
        {
            Caption = 'Dns';
            DataClassification = CustomerContent;
        }
        field(70; "Certificate Thumbprint"; Text[50])
        {
            Caption = 'Certificate Thumbprint';
            DataClassification = CustomerContent;
        }
        field(71; "Certificate Expiration Date"; Date)
        {
            Caption = 'Certificate Expiration Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Name")
        {
        }
    }

    #region Methods

    local procedure SetDsn()
    var
        lc_CompInfo: Record "Company Information";
    begin
        // Only if empty
        if (Rec.Dns <> '') then
            exit;

        // Set local
        if (Rec.Location = Rec.Location::local) then begin
            lc_CompInfo.Get();
            lc_CompInfo.TestField("IMP Basic Dns");
            Rec.Dns := CopyStr(LowerCase(Rec.Name + '.' + lc_CompInfo."IMP Basic Dns"), 1, MaxStrLen(Rec.Dns));
        end;

        // Set cloud
        if (Rec.Location = Rec.Location::cloud) then
            Rec.Dns := CopyStr(BscMgmt.System_GetBaseUriBC(), 1, MaxStrLen(Rec.Dns));
    end;

    procedure NAVVersionAdd(_Version: Text)
    begin
        if not NAVVersionConatins(_Version) then begin
            if (Rec."NAV Versions" <> '') then
                Rec."NAV Versions" += NAVVersionSeparator();
            Rec."NAV Versions" += _Version;
        end;
    end;

    procedure NAVVersionConatins(_Version: Text) RetValue: Boolean
    var
        lc_List: List of [Text];
        lc_Entry: Text;
    begin
        // Init
        RetValue := false;

        // Get list
        lc_List := Rec."NAV Versions".Split(NAVVersionSeparator());

        // Find entry
        foreach lc_Entry in lc_List do
            if lc_Entry.ToLower() = _Version.ToLower() then begin
                RetValue := true;
                exit;
            end;
    end;

    procedure NAVVersionSelect(var _Version: Text) RetValue: Boolean
    var
        lc_List: List of [Text];
    begin
        // Init
        RetValue := false;

        // Get list
        lc_List := NAVVersionsSelect(true);

        // Set list
        if lc_List.Count() = 0 then
            exit
        else
            _Version := lc_List.Get(1);

        // Return
        RetValue := true;
    end;

    procedure NAVVersionSelect() RetValue: Text
    var
        lc_List: List of [Text];
    begin
        // Init
        RetValue := '';

        // Get list
        lc_List := NAVVersionsSelect(true);

        // Return
        if lc_List.Count() = 0 then
            exit
        else
            RetValue := lc_List.Get(1);
    end;

    procedure NAVVersionsSelect(_SingleEntry: Boolean) RetValue: List of [Text];
    var
        lc_List: Record "Name/Value Buffer" temporary;
        lc_Version: List of [Text];
        lc_Fields: List of [Integer];
        lc_Text: Text;
        lc_Int: Integer;
        lc_Txt1_Txt: Label 'Load first version list from server';
    begin
        // Init
        lc_Int := 0;
        Clear(RetValue);

        // Check entry
        if (Rec."NAV Versions" = '') then
            Error(lc_Txt1_Txt);

        // Clear list
        lc_List.Reset();
        lc_List.DeleteAll(true);

        // Load selection
        lc_Version := Rec."NAV Versions".Split(Rec.NAVVersionSeparator());
        foreach lc_Text in lc_Version do begin
            lc_Int += 1;
            lc_List.Init();
            lc_List.ID := lc_Int;
            lc_List.Name := CopyStr(lc_Text, 1, MaxStrLen(lc_List.Name));
            lc_List.Value := CopyStr(NAVVersionName(lc_Text), 1, MaxStrLen(lc_List.Value));
            if lc_List.Insert(true) then;
        end;

        // Set fields to visible
        lc_Fields.Add(lc_List.FieldNo(Name));
        lc_Fields.Add(lc_List.FieldNo(Value));

        // Raise selection event
        if not ImpMgmt.SelectEntry(lc_List, lc_Fields, _SingleEntry) then
            exit;

        // Set return
        if lc_List.Find('-') then
            repeat
                RetValue.Add(lc_List.Name);
            until lc_List.Next() = 0;
    end;

    procedure NAVVersionsImport(_Root: JsonObject; var _Response: JsonObject) RetValue: Boolean
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
            // Import sorted result
            Rec."NAV Versions" := '';
            for lc_Int := lc_Min to lc_Max do
                if (lc_VList[lc_Int] <> '') then
                    Rec.NAVVersionAdd(lc_VList[lc_Int]);
        end;

        // Save data
        if not Rec.Modify(true) then begin
            _Response.Add('error', 'Couldn''t save versions in ' + Rec.TableCaption());
            exit;
        end;

        // Store data
        Commit();

        // Set response
        _Response.Add('response', 'Thank you for sending version list');

        // Return
        RetValue := true;
    end;

    procedure NAVVersionSeparator() RetValue: Text
    begin
        RetValue := ',';
    end;

    procedure GetBaseUrl() RetValue: Text
    begin
        if (Rec.SSL) then
            RetValue := 'https://'
        else
            RetValue := 'http://';
    end;

    procedure GetClientUrl() RetValue: Text
    begin
        case Rec.Type of
            Rec.Type::App:
                RetValue := GetBaseUrl() + Rec.Name;
            Rec.Type::cloud:
                RetValue := GetBaseUrl() + Rec.Dns;
        end;
    end;

    procedure GetDnsUrl() RetValue: Text
    begin
        RetValue := GetBaseUrl() + 'api.' + Rec.Dns;
    end;

    procedure NAVVersionName(_Version: Text) RetValue: Text
    begin
        case _Version.ToLower() of
            '7.1':
                RetValue := 'NAV2013R2';
            '8.0':
                RetValue := 'NAV2015';
            '9.0':
                RetValue := 'NAV2016';
            '10.0':
                RetValue := 'NAV2017';
            '11.0':
                RetValue := 'NAV2018';
            else
                RetValue := 'BC' + _Version.Replace('.', '');
        end;
    end;

    #endregion Methods

    var
        BscMgmt: Codeunit "IMP Basic Management";
        ImpMgmt: Codeunit "IMP Management";
}
