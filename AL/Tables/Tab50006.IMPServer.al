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
        }
        field(40; "SSL"; Boolean)
        {
            Caption = 'SSL';
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

    procedure NAVVersionAdd(_Version: Text)
    begin
        if (Rec."NAV Versions" <> '') then
            Rec."NAV Versions" += NAVVersionSeparator();
        if not NAVVersionConatins(_Version) then
            Rec."NAV Versions" += _Version;
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
        lc_IC: Record "IMP Connection";
        lc_List: Record "Name/Value Buffer" temporary;
        lc_Version: List of [Text];
        lc_Fields: List of [Integer];
        lc_Text: Text;
        lc_Int: Integer;
        lc_Server: Text;
        lc_Txt1_Txt: Label 'Load first version list from server';
    begin
        // Init
        lc_Int := 0;
        Clear(RetValue);

        // Get computer
        lc_Server := ImpAdmn.GetCurrentComputerName();

        // Find version list
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Environment, "Environment Name", "Environment Id");
        lc_IC.SetRange(Environment, lc_IC.Environment::Server);
        lc_IC.SetRange("Environment Name", lc_Server);
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
            // Create list
            for lc_Int := lc_Min to lc_Max do
                if (lc_VList[lc_Int] <> '') then begin
                    if (lc_Versions <> '') then
                        lc_Versions += ',';
                    lc_Versions += lc_VList[lc_Int];
                    Rec.NAVVersionAdd(lc_VList[lc_Int]);
                end;
        end;

        // Save data
        /*
        lc_IC.Reset();
        lc_IC.SetCurrentKey(Environment, "Environment Name", "Environment Id");
        lc_IC.SetRange(Environment, lc_IC.Environment::Server);
        lc_IC.SetRange("Environment Name", lc_Server);
        if not lc_IC.FindFirst() then begin
            lc_IC.Init();
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
        */
        // Modify 
        //Rec."NAV Versions" := CopyStr(lc_Versions, 1, MaxStrLen(Rec."NAV Versions"));
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

    #endregion Methods

    var
        BscMgmt: Codeunit "IMP Basic Management";
        ImpAdmn: Codeunit "IMP Administration";
        ImpMgmt: Codeunit "IMP Management";
}
