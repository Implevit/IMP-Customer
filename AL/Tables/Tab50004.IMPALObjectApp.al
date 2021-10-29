table 50004 "IMP AL Object App"
{
    Caption = 'AL Object App';
    DataClassification = ToBeClassified;
    LookupPageId = "IMP AL Object Apps";
    DrillDownPageId = "IMP AL Object Apps";

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Cust: Record Customer;
                lc_Txt1_Txt: Label 'Appname should start with the customer abbreviation "%1"!\\Do you still want to use the name "%2"?';
            begin
                lc_Cust.Get("Customer No.");
                lc_Cust.Testfield("IMP Abbreviation");
                if not (Name.ToUpper().StartsWith(lc_Cust."IMP Abbreviation")) then
                    if not Confirm(StrSubstNo(lc_Txt1_Txt, lc_Cust."IMP Abbreviation", Rec.Name)) then
                        Error('');
                // Set name
                Rec.Name := Rec.Name.ToLower();
            end;
        }
        field(30; "No. Range From"; Integer)
        {
            Caption = 'No. Range From';
            DataClassification = CustomerContent;
            InitValue = 50000;
        }
        field(31; "No. Range To"; Integer)
        {
            Caption = 'No. Range To';
            DataClassification = CustomerContent;
            InitValue = 59999;
        }
        field(40; "Objects"; Integer)
        {
            Caption = 'Objects';
            FieldClass = FlowField;
            CalcFormula = count("IMP AL Object Number" where("Customer No." = field("Customer No."), "App No." = field("No."), "Object No." = const(0)));
            Editable = false;
        }
        field(50; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(60; Dependencies; Text[1024])
        {
            Caption = 'Dependencies';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Customer No.")
        {
        }
    }

    #region Triggers

    trigger OnInsert()
    begin
        Rec.TestField("Customer No.");
        Rec."No." := GetNextEntryNo();
        Rec.InitALNumbers();
    end;

    trigger OnDelete()
    var
        lc_IAON: Record "IMP AL Object Number";
    begin
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", Rec."Customer No.");
        lc_IAON.SetRange("App No.", Rec."No.");
        if lc_IAON.FindSet() then
            lc_IAON.DeleteAll(true);
    end;

    #endregion Triggers

    #region Methods Misc

    procedure GetNextEntryNo() RetValue: Integer
    var
        lc_Rec: Record "IMP AL Object App";
    begin
        lc_Rec.Reset();
        if lc_Rec.FindLast() then
            RetValue := lc_Rec."No." + 1
        else
            RetValue := 1;
    end;

    procedure IsInRange(_EntryNo: Integer; _WithError: Boolean) RetValue: Boolean
    var
        lc_Txt1_Txt: Label 'Number %1 is not in range of %2 and %3';
    begin
        if ((_EntryNo <= Rec."No. Range To") and (_EntryNo >= Rec."No. Range From")) then
            RetValue := true
        else begin
            RetValue := false;
            if (_WithError) then
                Error(lc_Txt1_Txt);
        end;

    end;

    procedure InitALNumbers()
    var
        lc_IAON: Record "IMP AL Object Number";
    begin
        // Table
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Table;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // Reports
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Report;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // Codeunit
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Codeunit;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // Page
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Page;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // Query
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Query;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // PageExtension
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::"PageExtension";
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // TableExtension
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::"TableExtension";
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // Enum
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::Enum;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
        // EnumExtension
        lc_IAON.Init();
        lc_IAON."Customer No." := REC."Customer No.";
        lc_IAON."App No." := Rec."No.";
        lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::TableData;
        lc_IAON."Parent Object No." := 0;
        lc_IAON."Object Type" := lc_IAON."Object Type"::EnumExtension;
        lc_IAON."Object No." := 0;
        if lc_IAON.Insert(true) then;
    end;

    procedure CreateLicensePermissionCsv(_CustomerNo: Code[20]; _AppNo: Integer; _Separator: Text[1]) RetValue: Boolean
    var
        lc_Temp: Record "CSV Buffer" temporary;
        lc_IAON: Record "IMP AL Object Number";
        lc_TempBlob: Codeunit "Temp Blob";
        lc_InStream: InStream;
        lc_LineNo: Integer;
        lc_FileName: Text;
    begin
        // Init
        RetValue := false;
        lc_LineNo := 0;
        lc_FileName := 'ObjectPermissionsExport.csv';

        // Get numbers
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", _CustomerNo);
        if (_AppNo <> 0) then
            lc_IAON.SetRange("App No.", _AppNo);
        lc_IAON.SetFilter("Object Type", '<>%1', lc_IAON."Object Type"::FieldNumber);
        lc_IAON.SetFilter("Object No.", '<>%1', 0);
        lc_IAON.FindSet();

        // Clear
        lc_Temp.Reset();
        lc_Temp.DeleteAll(true);

        // Create header
        lc_LineNo += 1;
        lc_Temp.InsertEntry(lc_LineNo, 1, 'ObjectType');
        lc_Temp.InsertEntry(lc_LineNo, 2, 'FromObjectID');
        lc_Temp.InsertEntry(lc_LineNo, 3, 'ToObjectID');
        lc_Temp.InsertEntry(lc_LineNo, 4, 'Read');
        lc_Temp.InsertEntry(lc_LineNo, 5, 'Insert');
        lc_Temp.InsertEntry(lc_LineNo, 6, 'Modify');
        lc_Temp.InsertEntry(lc_LineNo, 7, 'Delete');
        lc_Temp.InsertEntry(lc_LineNo, 8, 'Execute');
        lc_Temp.InsertEntry(lc_LineNo, 9, 'AvailableRange');
        lc_Temp.InsertEntry(lc_LineNo, 10, 'Used');
        lc_Temp.InsertEntry(lc_LineNo, 11, 'ObjectTypeRemaining');
        lc_Temp.InsertEntry(lc_LineNo, 12, 'CompanyObjectPermissionID');

        // Create lines
        repeat
            lc_LineNo += 1;
            if (lc_IAON."Object Type" = lc_IAON."Object Type"::Table) then
                lc_Temp.InsertEntry(lc_LineNo, 1, Format(lc_IAON."Object Type"::TableData))
            else
                lc_Temp.InsertEntry(lc_LineNo, 1, Format(lc_IAON."Object Type"));
            lc_Temp.InsertEntry(lc_LineNo, 2, Format(lc_IAON."Object No."));
            lc_Temp.InsertEntry(lc_LineNo, 3, Format(lc_IAON."Object No."));
            lc_Temp.InsertEntry(lc_LineNo, 4, 'Direct');
            lc_Temp.InsertEntry(lc_LineNo, 5, 'Direct');
            lc_Temp.InsertEntry(lc_LineNo, 6, 'Direct');
            lc_Temp.InsertEntry(lc_LineNo, 7, 'Direct');
            lc_Temp.InsertEntry(lc_LineNo, 8, 'Direct');
            lc_Temp.InsertEntry(lc_LineNo, 9, ''); //50000 - 99999');
            lc_Temp.InsertEntry(lc_LineNo, 10, ''); //1');
            lc_Temp.InsertEntry(lc_LineNo, 11, ''); //29');
            lc_Temp.InsertEntry(lc_LineNo, 12, ''); //3770342');
        until lc_IAON.Next() = 0;

        // Export file
        lc_Temp.SaveDataToBlob(lc_TempBlob, _Separator);
        lc_TempBlob.CreateInStream(lc_InStream, TextEncoding::UTF8);
        DownloadFromStream(lc_Instream, '', '', '', lc_FileName);
    end;

    procedure IsDependentOf(_Name: Text) RetValue: Boolean
    var
        lc_List: List of [Text];
        lc_Entry: Text;
    begin
        RetValue := false;
        lc_List := Rec.Dependencies.Split(',');
        foreach lc_Entry in lc_List do
            if (lc_Entry.ToLower() = _Name.ToLower()) then begin
                RetValue := true;
                exit;
            end;
    end;

    #endregion Methods Misc

    #region Methods Path and folders

    procedure GetCustomerRootPath() RetValue: Text
    begin
        RetValue := '\\impfps01\Daten\04_Entwicklung\Kunden\';
    end;

    procedure GetCustomerRootPath(_Abbreviation: Text) RetValue: Text
    begin
        RetValue := GetCustomerRootPath() + _Abbreviation.ToUpper() + '\Apps\';
    end;

    procedure GetALFolder(_ObjectType: Option) RetValue: Text;
    var
        lc_IAON: Record "IMP AL Object Number";
    begin
        case _ObjectType of
            lc_IAON."Object Type"::Codeunit:
                RetValue := GetALFolderCodeunits();
            lc_IAON."Object Type"::Enum:
                RetValue := GetALFolderEnums();
            lc_IAON."Object Type"::EnumExtension:
                RetValue := GetALFolderEnumsExt();
            lc_IAON."Object Type"::Table:
                RetValue := GetALFolderTables();
            lc_IAON."Object Type"::"TableExtension":
                RetValue := GetALFolderTablesExt();
            lc_IAON."Object Type"::Page:
                RetValue := GetALFolderPages();
            lc_IAON."Object Type"::"PageExtension":
                RetValue := GetALFolderPagesExt();
            lc_IAON."Object Type"::Report:
                RetValue := GetALFolderReports();
            lc_IAON."Object Type"::Query:
                RetValue := GetALFolderQueries();
            lc_IAON."Object Type"::XMLport:
                RetValue := GetALFolderXmlPorts();
            else
                RetValue := '';
        end;
    end;

    procedure GetALFolderCodeunits() RetValue: Text
    begin
        RetValue := 'Codeunits';
    end;

    procedure GetALFolderTables() RetValue: Text
    begin
        RetValue := 'Tables';
    end;

    procedure GetALFolderTablesExt() RetValue: Text
    begin
        RetValue := 'TablesExt';
    end;

    procedure GetALFolderPages() RetValue: Text
    begin
        RetValue := 'Pages';
    end;

    procedure GetALFolderPagesExt() RetValue: Text
    begin
        RetValue := 'PagesExt';
    end;

    procedure GetALFolderEnums() RetValue: Text
    begin
        RetValue := 'Enums';
    end;

    procedure GetALFolderEnumsExt() RetValue: Text
    begin
        RetValue := 'EnumsExt';
    end;

    procedure GetALFolderReports() RetValue: Text
    begin
        RetValue := 'Reports';
    end;

    procedure GetALFolderQueries() RetValue: Text
    begin
        RetValue := 'Queries';
    end;

    procedure GetALFolderXmlPorts() RetValue: Text
    begin
        RetValue := 'XmlPorts';
    end;

    #endregion Methods Path and folders

    #region Methods Import Apps

    procedure ImportApps(_CustomerNo: Code[20]; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_Cust: Record Customer;
    begin
        lc_Cust.Get(_CustomerNo);
        lc_Cust.TestField("IMP Abbreviation");
        ImportApps(_CustomerNo, GetCustomerRootPath(lc_Cust."IMP Abbreviation"), _WithConfirm, _WithMessage);
    end;

    procedure ImportApps(_CustomerNo: Code[20]; _DefaultPath: Text; _WithConfirm: Boolean; _WithMessage: Boolean) RetValue: Boolean
    var
        lc_PrmMgmt: Codeunit "IMP Basic Prem Management";
        lc_Path: Text;
        lc_List: List of [Text];
        lc_Counter: Integer;
        lc_Conf_Txt: Label 'Do you really want to import your selected apps?';
        lc_Msg0a_Txt: Label 'your apps have been successfully imported';
        lc_Msg0b_Txt: Label 'your apps import has terminated with error';
        lc_Txt0_Txt: Label 'Select your apps folders';
        lc_Dia_Txt: Label '#1####################################################\#2####################################################\#3####################################################';
    begin
        // Init
        RetValue := false;
        lc_Counter := 0;

        // Get folders
        lc_PrmMgmt.GetServerDirectories(lc_Txt0_Txt, _DefaultPath, false, true, lc_List);

        // Exit 
        if (lc_List.Count() = 0) then
            exit;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(lc_Conf_Txt) then
                exit;

        // Open dia
        if (GuiAllowed()) then
            ImportDia.Open(lc_Dia_Txt);

        // Read folders
        foreach lc_Path in lc_List do begin
            lc_Counter += 1;
            RetValue := ImportApp(_CustomerNo, lc_Path, (lc_List.Count() + 1 - lc_Counter));
            // Exit at error
            if not RetValue then
                exit;
        end;

        // Close dia
        if (GuiAllowed()) then
            ImportDia.Close();

        // Show message
        if ((_WithMessage) and (GuiAllowed())) then
            if (RetValue) then
                Message(lc_Msg0a_Txt)
            else
                Message(lc_Msg0b_Txt);
    end;

    local procedure ImportApp(_CustomerNo: Code[20]; _Path: Text; _Counter: Integer) RetValue: Boolean
    var
        lc_IAOA: Record "IMP AL Object App";
        lc_BscMgmt: Codeunit "IMP Basic Management";
        lc_Json: JsonObject;
        lc_Token: JsonToken;
        lc_Entry: JsonToken;
        lc_Dependencies: JsonArray;
        lc_AppName: Text;
        lc_SubAppName: Text;
        lc_SubPublisher: Text;
        lc_idRanges: JsonArray;
        lc_Text: Text;
        lc_Select: Integer;
        lc_DependenciesText: Text;
        lc_Dia1_Txt: Label 'App (%1) : %2';
        lc_Txt1_Txt: Label 'App folder may not be empty';
        lc_Txt2_Txt: Label 'No app.json found in folder "%1"';
        lc_Txt3_Txt: Label 'Token "%1" is mandatory in app.json';
        lc_Txt4_Txt: Label 'Token "%1" has to be an array';
        lc_Txt5_Txt: Label 'Import app %1 first!';
        lc_Txt6_Txt: Label 'Select your id range';
    begin
        // Init 
        RetValue := false;

        // Exit with no path
        if (_Path = '') then
            Error(lc_Txt1_Txt);

        // Load app.json
        if not ImportAppJson(_Path, lc_Json) then
            Error(lc_Txt2_Txt, _Path);

        // Read name
        if not lc_Json.Get('name', lc_Token) then
            Error(lc_Txt3_Txt, 'name')
        else
            lc_AppName := lc_Token.AsValue().AsText();

        // Read dependencies
        if not lc_Json.Get('dependencies', lc_Token) then
            Error(lc_Txt3_Txt, 'dependencies');

        // Get dependencies
        if not lc_Token.IsArray() then
            Error(lc_Txt4_Txt, 'dependencies')
        else
            lc_Dependencies := lc_Token.AsArray();

        // Check dependencies
        lc_DependenciesText := '';
        lc_IAOA.Reset();
        lc_IAOA.SetRange("Customer No.", _CustomerNo);
        foreach lc_Entry in lc_Dependencies do begin
            // Get publisher
            if not lc_Entry.AsObject().SelectToken('publisher', lc_Token) then
                Error(lc_Txt3_Txt, 'dependencies.publisher')
            else
                lc_SubPublisher := lc_BscMgmt.JsonGetTokenValue(lc_Token, 'publisher').AsText();
            // Check implevit dependencies
            if (lc_SubPublisher.ToLower().Contains('implevit')) then begin
                // Get name
                if not lc_Entry.AsObject().SelectToken('name', lc_Token) then
                    Error(lc_Txt3_Txt, 'dependencies.name')
                else
                    lc_SubAppName := lc_BscMgmt.JsonGetTokenValue(lc_Token, 'name').AsText().ToLower();
                // Find alreday imported app
                lc_IAOA.SetFilter(Name, '%1', '@' + lc_SubAppName);
                if not lc_IAOA.FindSet() then
                    Error(lc_Txt5_Txt, lc_SubAppName);
                // Add
                if (lc_DependenciesText <> '') then
                    lc_DependenciesText += ',';
                lc_DependenciesText += lc_SubAppName;
            end;
        end;

        // Read idRanges
        if not lc_Json.Get('idRanges', lc_Token) then
            Error(lc_Txt3_Txt, 'idRanges');

        // Get idRanges
        if not lc_Token.IsArray() then
            Error(lc_Txt4_Txt, 'idRanges')
        else
            lc_idRanges := lc_Token.AsArray();

        // Show dia
        if (GuiAllowed()) then
            ImportDia.Update(1, StrSubstNo(lc_Dia1_Txt, _Counter, lc_AppName));

        // Find app
        lc_IAOA.Reset();
        lc_IAOA.SetRange("Customer No.", _CustomerNo);
        lc_IAOA.SetFilter(Name, '%1', '@' + lc_AppName);
        if not lc_IAOA.FindSet() then begin
            // Create app
            clear(lc_IAOA);
            lc_IAOA.Init();
            lc_IAOA.Validate("Customer No.", _CustomerNo);
            lc_IAOA.Validate(Name, lc_AppName);
            // Select idRange
            if lc_idRanges.Count() = 1 then
                lc_Select := 1
            else begin
                foreach lc_Entry in lc_idRanges do begin
                    if (lc_Text <> '') then
                        lc_Text += ',';
                    if lc_Entry.AsObject().SelectToken('from', lc_Token) then
                        lc_Text += lc_Token.AsValue().AsText();
                    if lc_Entry.AsObject().SelectToken('to', lc_Token) then
                        lc_Text += ' - ' + lc_Token.AsValue().AsText();
                end;
                lc_Select := StrMenu(lc_Text, 1, lc_Txt6_Txt);
            end;
            // Load idRange
            if (lc_Select <> 0) then begin
                lc_idRanges.Get((lc_Select - 1), lc_Entry);
                if lc_Entry.AsObject().SelectToken('from', lc_Token) then
                    lc_IAOA."No. Range From" := lc_Token.AsValue().AsInteger();
                if lc_Entry.AsObject().SelectToken('to', lc_Token) then
                    lc_IAOA."No. Range To" := lc_Token.AsValue().AsInteger();
            end;
            // Save app
            lc_IAOA.Insert(true);
        end;

        // Set dependencies
        lc_IAOA.Dependencies := CopyStr(lc_DependenciesText, 1, MaxStrLen(lc_IAOA.Dependencies));

        // Save app
        lc_IAOA.Modify(true);

        // Load objects
        RetValue := LoadObjects(_CustomerNo, lc_IAOA."No.", _Path);
    end;

    procedure ImportAppJson(_Path: Text; var _Json: JsonObject) RetValue: Boolean
    var
        lc_FileMgmt: Codeunit "File Management";
        lc_ImpMgmt: Codeunit "IMP Management";
        lc_Json: Text;
    begin
        // Init
        RetValue := false;

        // Check path
        if not (_Path.EndsWith('\')) then
            _Path += '\';

        // Check file
        if not lc_FileMgmt.ServerFileExists(_Path + 'app.json') then
            exit;

        // Import file
        lc_Json := lc_ImpMgmt.ImportFile(_Path + 'app.json', TextEncoding::UTF8, false);

        // Transfer to json
        RetValue := _Json.ReadFrom(lc_Json);
    end;

    local procedure LoadObjects(_CustomerNo: Code[20]; _AppNo: Integer; _Path: Text) RetValue: Boolean
    var
        lc_IAOA: Record "IMP AL Object App";
        lc_IAON: Record "IMP AL Object Number";
        lc_Files: Record "Name/Value Buffer" temporary;
        lc_FileMgmt: Codeunit "File Management";
        lc_ObjectTypes: list of [Integer];
        lc_ObjectTypesText: list of [Text];
        lc_ObjectType: Integer;
        lc_Counter: Integer;
        lc_Dia1_Txt: Label 'Object Type (%1) : %2';
        lc_Txt1_Txt: Label 'No files in folder %1 found!';
        lc_Txt2_Txt: Label 'App "%1" missing in %2';
    begin
        // Init
        RetValue := false;
        lc_Counter := 0;

        // Get all files
        lc_FileMgmt.GetServerDirectoryFilesListInclSubDirs(lc_Files, _Path);

        // Check files
        if not lc_Files.Find('-') then
            Error(lc_Txt1_Txt, _Path);

        // Get app
        if not lc_IAOA.Get(_AppNo) then
            Error(lc_Txt2_Txt, _AppNo, lc_IAOA.TableCaption());

        // Remove all current objects
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", _CustomerNo);
        lc_IAON.SetRange("App No.", _AppNo);
        if lc_IAON.FindSet() then
            lc_IAON.DeleteAll(true);

        // Create base enties
        lc_IAOA.InitALNumbers();

        // Create setup
        lc_ObjectTypes.Add(lc_IAON."Object Type"::Enum);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::Enum));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::EnumExtension);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::EnumExtension));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::Table);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::Table));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::TableExtension);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::TableExtension));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::Page);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::Page));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::PageExtension);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::PageExtension));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::Codeunit);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::Codeunit));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::Query);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::Query));
        lc_ObjectTypes.Add(lc_IAON."Object Type"::XMLport);
        lc_ObjectTypesText.Add(Format(lc_IAON."Object Type"::XMLport));

        // Process obect types
        foreach lc_ObjectType in lc_ObjectTypes do begin
            lc_Counter += 1;
            // Show dia
            if (GuiAllowed()) then
                ImportDia.Update(2, StrSubstNo(lc_Dia1_Txt, (lc_ObjectTypes.Count() + 1 - lc_Counter), lc_ObjectTypesText.Get(lc_Counter)));
            // Read files
            if lc_Files.Find('-') then
                repeat
                    if (lc_FileMgmt.GetExtension(lc_Files.Name).ToLower() = 'al') then
                        LoadObject(_CustomerNo, _AppNo, lc_ObjectType, _Path, lc_Files);
                until lc_Files.Next() = 0;
        end;

        // Retrun
        RetValue := true;
    end;

    local procedure LoadObject(_CustomerNo: Code[20]; _AppNo: Integer; _ObjectType: Option; _Path: Text; var _File: Record "Name/Value Buffer") RetValue: Boolean
    var
        lc_IAON: Record "IMP AL Object Number";
        lc_FileMgmt: Codeunit "File Management";
        lc_TempBlob: Codeunit "Temp Blob";
        lc_InStream: InStream;
        lc_Line: Text;
        lc_ObjectType: Text;
        lc_ObjectNo: Integer;
        lc_Name: Text;
        lc_Extends: Text;
        lc_Dia1_Txt: Label 'File : %1';
    begin
        // Init
        RetValue := false;

        // Init object
        clear(lc_IAON);
        lc_IAON.Init();
        lc_IAON."Customer No." := _CustomerNo;
        lc_IAON."App No." := _AppNo;
        lc_IAON."Object File Name" := CopyStr(CopyStr(_File.Name, StrLen(_Path) + 1), 1, MaxStrLen(lc_IAON."Object File Name"));

        // Import file in stream
        lc_FileMgmt.BLOBImportFromServerFile(lc_TempBlob, _File.Name);
        lc_TempBlob.CreateInStream(lc_InStream, TextEncoding::UTF8);

        // Read first line from stream
        lc_InStream.ReadText(lc_Line);

        // Split header
        LoadObjectHeader(lc_Line, lc_ObjectType, lc_ObjectNo, lc_Name, lc_Extends);

        // Check object type
        case LowerCase(lc_ObjectType) of
            'codeunit':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Codeunit;
            'table':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Table;
            'tableextension':
                begin
                    lc_IAON."Object Type" := lc_IAON."Object Type"::TableExtension;
                    lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Table;
                    lc_IAON."Parent Object Name" := CopyStr(lc_Extends, 1, MaxStrLen(lc_IAON."Parent Object Name"));
                end;
            'page':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Page;
            'pageextension':
                begin
                    lc_IAON."Object Type" := lc_IAON."Object Type"::PageExtension;
                    lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Page;
                    lc_IAON."Parent Object Name" := CopyStr(lc_Extends, 1, MaxStrLen(lc_IAON."Parent Object Name"));
                end;
            'enum':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Enum;
            'enumextension':
                begin
                    lc_IAON."Object Type" := lc_IAON."Object Type"::EnumExtension;
                    lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Enum;
                    lc_IAON."Parent Object Name" := CopyStr(lc_Extends, 1, MaxStrLen(lc_IAON."Parent Object Name"));
                end;
            'report':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Report;
            'query':
                lc_IAON."Object Type" := lc_IAON."Object Type"::Query;
            'xmlport':
                lc_IAON."Object Type" := lc_IAON."Object Type"::XMLport;
            else
                lc_IAON."Object Type" := 0;
        end;

        // Skip all other types
        if (lc_IAON."Object Type" <> _ObjectType) then
            exit;

        // Check object type
        if lc_IAON."Object Type" <= 0 then
            exit;

        // Show dia
        if (GuiAllowed()) then
            ImportDia.Update(3, StrSubstNo(lc_Dia1_Txt, lc_FileMgmt.GetFileName(_File.Name)));

        // Setup extension
        if (lc_IAON."Object Type" in [lc_IAON."Object Type"::TableExtension, lc_IAON."Object Type"::PageExtension, lc_IAON."Object Type"::EnumExtension]) then
            GetParentObjectNo(_CustomerNo, _AppNo, lc_IAON."Parent Object Type", lc_IAON."Parent Object Name", lc_IAON."Parent Object No.");

        // Save object
        lc_IAON."Object No." := lc_ObjectNo;
        lc_IAON."Object Name" := CopyStr(lc_Name, 1, MaxStrLen(lc_IAON."Object Name"));
        if lc_IAON.Insert(true) then;

        // Load field numbers
        if (lc_IAON."Object Type" in [lc_IAON."Object Type"::Table, lc_IAON."Object Type"::TableExtension, lc_IAON."Object Type"::Enum, lc_IAON."Object Type"::EnumExtension]) then
            LoadObjectEntries(_CustomerNo, _AppNo, lc_InStream, lc_IAON."Object No.", lc_IAON."Object Type", lc_IAON."Object Name");

        // Return
        RetValue := true;
    end;

    local procedure LoadObjectHeader(_Line: Text; var _Object: Text; var _No: Integer; var _Name: Text; var _Extense: Text) RetValue: Boolean
    var
        lc_Int: Integer;
        lc_Entry: Text;
        lc_Start: Boolean;
        lc_No: Text;
    begin
        // Init
        RetValue := false;
        _Object := '';
        _No := 0;
        _Name := '';
        _Extense := '';
        lc_Start := false;

        // Strip line
        for lc_Int := 1 to StrLen(_Line) do
            if CopyStr(_Line, lc_Int, 1) <> ' ' then begin
                if CopyStr(_Line, lc_Int, 1) = '"' then begin
                    if lc_Start then begin
                        if _Name = '' then
                            _Name := lc_Entry
                        else
                            _Extense := lc_Entry;
                        lc_Start := false;
                        lc_Entry := '';
                    end else
                        lc_Start := true;
                end else
                    lc_Entry += CopyStr(_Line, lc_Int, 1);
            end else
                if lc_Start then
                    lc_Entry += CopyStr(_Line, lc_Int, 1)
                else begin
                    if _Object = '' then
                        _Object := lc_Entry
                    else
                        if lc_No = '' then
                            lc_No := lc_Entry
                        else
                            if _Name = '' then
                                _Name := lc_Entry
                            else
                                _Extense := lc_Entry;
                    lc_Entry := '';
                end;

        // Strip entry
        if lc_Entry <> '' then
            if _Object = '' then
                _Object := lc_Entry
            else
                if lc_No = '' then
                    lc_No := lc_Entry
                else
                    if _Name = '' then
                        _Name := lc_Entry
                    else
                        _Extense := lc_Entry;

        // Set number
        RetValue := Evaluate(_No, lc_No);
    end;

    local procedure GetParentObjectNo(_CustomerNo: Code[20]; _AppNo: Integer; _ObjectType: Option; var _ObjectName: Text[30]; var _ObjectNo: Integer) RetValue: Boolean
    var
        lc_Object: Record AllObj;
        lc_IAON: Record "IMP AL Object Number";
    begin
        // Init
        RetValue := false;
        _ObjectNo := 0;

        // Find object
        lc_Object.Reset();
        lc_Object.SetRange("Object Type", _ObjectType);
        lc_Object.SetFilter("Object Name", '%1', '@' + _ObjectName);
        if lc_Object.FindSet() then
            if (lc_Object.Count() = 1) then begin
                _ObjectNo := lc_Object."Object ID";
                _ObjectName := lc_Object."Object Name";
                exit;
            end;

        // Find number
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", _CustomerNo);
        lc_IAON.SetRange("App No.", _AppNo);
        lc_IAON.SetRange("Object Type", _ObjectType);
        lc_IAON.SetFilter("Object Name", '%1', '@' + _ObjectName);
        if lc_IAON.FindSet() then
            if (lc_IAON.Count() = 1) then begin
                _ObjectNo := lc_IAON."Object No.";
                _ObjectName := lc_IAON."Object Name";
                exit;
            end;
    end;

    local procedure LoadObjectEntries(_CustomerNo: Code[20]; _AppNo: Integer; _InStream: InStream; _ParentObjectNo: Integer; _ParentObjectType: Option; _ParentObjectName: Text)
    var
        lc_IAON: Record "IMP AL Object Number";
        lc_Line: Text;
        lc_No: Integer;
        lc_Name: Text;
        lc_Size: Text;
    begin
        // Read instream
        while not _InStream.EOS do begin
            // Read line
            _InStream.ReadText(lc_Line);
            // Load field
            if (_ParentObjectType in [lc_IAON."Parent Object Type"::Table, lc_IAON."Parent Object Type"::"TableExtension"]) then
                LoadObjectEntriesField(lc_Line, lc_No, lc_Name, lc_Size);
            // Load enum
            if (_ParentObjectType in [lc_IAON."Parent Object Type"::Enum, lc_IAON."Parent Object Type"::EnumExtension]) then
                LoadObjectEntriesEnum(lc_Line, lc_No, lc_Name);
            // Save field
            if lc_No <> 0 then begin
                lc_IAON.Init();
                lc_IAON."Customer No." := _CustomerNo;
                lc_IAON."App No." := _AppNo;
                lc_IAON."Parent Object Type" := _ParentObjectType;
                lc_IAON."Parent Object No." := _ParentObjectNo;
                lc_IAON."Parent Object Name" := CopyStr(_ParentObjectName, 1, MaxStrLen(lc_IAON."Parent Object Name"));
                lc_IAON."Object Type" := lc_IAON."Object Type"::FieldNumber;
                lc_IAON."Object No." := lc_No;
                lc_IAON."Object Name" := CopyStr(lc_Name, 1, MaxStrLen(lc_IAON."Object Name"));
                lc_IAON.Insert(true);
            end;
        end;
    end;

    local procedure LoadObjectEntriesField(_Line: Text; var _No: Integer; var _Name: Text; var _Size: Text) RetValue: Boolean
    var
        lc_No: Text;
        lc_List: List of [Text];
    begin

        // field(1; "No."; Code[20])

        // Init
        RetValue := false;
        _No := 0;
        _Name := '';
        _Size := '';
        lc_No := '';

        // Prepaire line
        _Line := _Line.Trim();

        // Strip only field
        if not (_Line.ToLower().StartsWith('field(')) then
            exit;

        // Split
        lc_List := _Line.Split(';');
        if (lc_List.Count() < 3) then
            exit;

        // No
        lc_No := lc_List.Get(1);
        lc_No := CopyStr(lc_No, StrPos(lc_No, '('));
        lc_No := lc_No.Replace('(', '').Trim();

        // Name
        _Name := lc_List.Get(2).Replace('"', '').Trim();

        // Size
        _Size := lc_List.Get(3).Replace(')', '').Trim();

        // Set number
        RetValue := Evaluate(_No, lc_No);
    end;

    local procedure LoadObjectEntriesEnum(_Line: Text; var _No: Integer; var _Name: Text) RetValue: Boolean
    var
        lc_No: Text;
        lc_List: List of [Text];
    begin

        //value(70000; None) { Caption = ' '; }

        // Init
        RetValue := false;
        _No := 0;
        _Name := '';
        lc_No := '';

        // Prepaire line
        _Line := _Line.Trim();

        // Only entry with value
        if StrPos(_Line.ToLower(), 'value(') = 0 then
            exit;

        // Split
        lc_List := _Line.Split(';');
        if (lc_List.Count() < 2) then
            exit;

        // No
        lc_No := lc_List.Get(1);
        lc_No := CopyStr(lc_No, StrPos(lc_No, '('));
        lc_No := lc_No.Replace('(', '').Trim();

        // Name
        _Name := lc_List.Get(2);
        _Name := CopyStr(_Name, 1, StrPos(_Name, ')'));
        _Name := _Name.Replace(')', '').Replace('"', '').Trim();

        // Set number
        RetValue := Evaluate(_No, lc_No);
    end;

    #endregion Methods Import Apps

    var
        ImportDia: Dialog;
}