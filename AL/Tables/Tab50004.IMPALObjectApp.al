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
                lc_Txt1_Txt: Label 'Appname has to start with the customer abbreviation %1';
            begin
                lc_Cust.Get("Customer No.");
                lc_Cust.Testfield("IMP Abbreviation");
                if not (Name.ToUpper().StartsWith(lc_Cust."IMP Abbreviation")) then
                    Error(lc_Txt1_Txt, lc_Cust."IMP Abbreviation")
                else
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
            Caption = 'Objects';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
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

    #region Methodes

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

    procedure GetCustomerRootPath() RetValue: Text
    begin
        RetValue := '\\impfps01\Daten\04_Entwicklung\Kunden\';
    end;

    procedure GetCustomerRootPath(_Abbreviation: Text) RetValue: Text
    begin
        RetValue := GetCustomerRootPath() + _Abbreviation.ToUpper() + '\Apps\';
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

    procedure ImportApps(_WithConfirm: Boolean; _WithMessage: Boolean)
    begin
        ImportApps(GetCustomerRootPath(), _WithConfirm, _WithMessage);
    end;

    procedure ImportApps(_CustomerNo: Code[20]; _WithConfirm: Boolean; _WithMessage: Boolean)
    var
        lc_Cust: Record Customer;
    begin
        lc_Cust.Get(_CustomerNo);
        lc_Cust.TestField("IMP Abbreviation");
        ImportApps(GetCustomerRootPath(lc_Cust."IMP Abbreviation"), _WithConfirm, _WithMessage);
    end;

    procedure ImportApps(_DefaultPath: Text; _WithConfirm: Boolean; _WithMessage: Boolean) RetValue: Boolean
    var
        lc_PrmMgmt: Codeunit "IMP Basic Prem Management";
        lc_Path: Text;
        lc_List: List of [Text];
        lc_Conf_Txt: Label 'Do you really want to import your selected apps?';
        lc_Msg0a_Txt: Label 'your apps have been successfully imported';
        lc_Msg0b_Txt: Label 'your apps import has terminated with error';
        lc_Txt0_Txt: Label 'Select your apps folders';
    begin
        // Init
        RetValue := false;

        // Get folders
        lc_PrmMgmt.GetServerDirectories(lc_Txt0_Txt, _DefaultPath, false, true, lc_List);

        // Exit 
        if (lc_List.Count() = 0) then
            exit;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(lc_Conf_Txt) then
                exit;

        // Read folders
        foreach lc_Path in lc_List do begin
            // Import app
            RetValue := ImportApp(lc_Path, false, false);
            // Exit at error
            if not RetValue then
                exit;
        end;

        // Show message
        if ((_WithMessage) and (GuiAllowed())) then
            if (RetValue) then
                Message(lc_Msg0a_Txt)
            else
                Message(lc_Msg0b_Txt)
    end;

    procedure ImportApp(_Path: Text; _WithConfirm: Boolean; _WithMessage: Boolean) RetValue: Boolean
    var
        lc_Cust: Record Customer;
        lc_IAOA: Record "IMP AL Object App";
        lc_PrmMgmt: Codeunit "IMP Basic Prem Management";
        lc_FileMgmt: Codeunit "File Management";
        lc_AppName: Text;
        lc_Abbreviation: Code[10];
        lc_Conf_Txt: Label 'Do you really want to import your selected app?';
        lc_Msg0a_Txt: Label 'your app have been successfully imported';
        lc_Msg0b_Txt: Label 'your app import has terminated with error';
        lc_Txt0_Txt: label 'Select your app folder';
        lc_Txt1_Txt: Label 'No customer with abbreviation %1 found!';
    begin
        // Init 
        RetValue := false;

        // Get path
        if (_Path = '') then
            _Path := lc_PrmMgmt.GetServerDirectory(lc_Txt0_Txt, GetCustomerRootPath(), false, true);

        // Exit with no path
        if (_Path = '') then
            exit;

        // Confirm
        if ((_WithConfirm) and (GuiAllowed())) then
            if not Confirm(lc_Conf_Txt) then
                exit;

        // Stip path
        lc_AppName := CopyStr(_Path, StrLen(lc_FileMgmt.GetDirectoryName(_Path).ToLower()) + 2);

        // Set abbreviation
        lc_Abbreviation := CopyStr(lc_AppName, 1, 3);

        // Get customer
        lc_Cust.Reset();
        lc_Cust.SetRange("IMP Abbreviation", lc_Abbreviation);
        if not lc_Cust.FindFirst() then
            Error(lc_Txt1_Txt, lc_Abbreviation);

        // Find app
        lc_IAOA.Reset();
        lc_IAOA.SetRange("Customer No.", lc_Cust."No.");
        lc_IAOA.SetFilter(Name, '%1', '@' + lc_AppName);
        if not lc_IAOA.FindSet() then begin
            // Create app
            clear(lc_IAOA);
            lc_IAOA.Init();
            lc_IAOA.Validate("Customer No.", lc_Cust."No.");
            lc_IAOA.Validate(Name, lc_AppName);
            if (lc_AppName.ToUpper().StartsWith('IMP')) then begin
                lc_IAOA."No. Range From" := 70000;
                lc_IAOA."No. Range To" := 79999;
            end;
            lc_IAOA.Insert(true);
        end;

        // Load objects
        RetValue := LoadObjects(lc_Cust."No.", lc_IAOA."No.", _Path);

        // Show message
        if ((_WithMessage) and (GuiAllowed())) then
            if (RetValue) then
                Message(lc_Msg0a_Txt)
            else
                Message(lc_Msg0b_Txt)
    end;

    local procedure LoadObjects(_CustomerNo: Code[20]; _AppNo: Integer; _Path: Text) RetValue: Boolean
    var
        lc_IAOA: Record "IMP AL Object App";
        lc_IAON: Record "IMP AL Object Number";
        lc_FileMgmt: Codeunit "File Management";
        lc_ALPath: Text;
        lc_Txt1_Txt: Label 'Folder %1 notfound!';
        lc_Txt2_Txt: Label 'App "%1" missing in %2';
    begin
        // Init
        RetValue := false;

        // Check path
        if not (_Path.EndsWith('\')) then
            _Path += '\';

        // Set path
        lc_ALPath := _Path + 'AL\';

        // Check an set al folder
        if not lc_FileMgmt.ServerDirectoryExists(lc_ALPath) then begin
            lc_FileMgmt.ServerCreateDirectory(lc_ALPath);
            if not lc_FileMgmt.ServerDirectoryExists(lc_ALPath) then
                Error(lc_Txt1_Txt, lc_ALPath);
        end;

        /*
        // Make sure all folders exists
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderCodeunits());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderTables());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderTablesExt());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderPages());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderPagesExt());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderEnums());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderEnumsExt());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderReports());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderQueries());
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + GetALFolderXmlPorts());
        */

        // Remove all current objects
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", _CustomerNo);
        lc_IAON.SetRange("App No.", _AppNo);
        if lc_IAON.FindSet() then
            lc_IAON.DeleteAll(true);

        // Get app
        if not lc_IAOA.Get(_AppNo) then
            Error(lc_Txt2_Txt, _AppNo, lc_IAOA.TableCaption());

        // Create base enties
        lc_IAOA.InitALNumbers();

        // Load objects
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Codeunit);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Table);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::TableExtension);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Page);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::PageExtension);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Enum);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::EnumExtension);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Report);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::Query);
        LoadObject(_CustomerNo, lc_ALPath, _AppNo, lc_IAON."Object Type"::XMLport);

        // Retrun
        RetValue := true;
    end;

    local procedure LoadObject(_CustomerNo: Code[20]; _Path: Text; _AppNo: Integer; _ObjectType: Integer) RetValue: Boolean
    var
        lc_Files: Record "Name/Value Buffer" temporary;
        lc_IAON: Record "IMP AL Object Number";
        lc_FileMgmt: Codeunit "File Management";
        lc_TempBlob: Codeunit "Temp Blob";
        lc_InStream: InStream;
        lc_Line: Text;
        lc_Object: Text;
        lc_No: Integer;
        lc_Name: Text;
        lc_Extends: Text;
        lc_ObjectType: Integer;
        lc_ObjectNo: Integer;
        lc_FileName: Text;
        lc_ObjectName: Text;
        lc_ExtNo: Integer;
        lc_Txt1_Txt: Label 'Folder %1 notfound!';
        lc_Txt2_Txt: Label 'Extension not found in "%1"';
        lc_Txt3_Txt: Label 'Filename "%1" and Object "%2" are different';
        lc_Txt4_Txt: Label 'Extension-Number "%1" and Object-Number "%2" in %3 are different';
        lc_Txt5_Txt: Label 'Unknown Object %1 in Line 1 of "%2"';
        lc_Txt6_Txt: Label 'Wrong object type in Line 1 of "%1"';
        lc_Txt7_Txt: Label 'Wrong object number in "%1"';
    begin
        // Init
        RetValue := false;

        // Set path
        case _ObjectType of
            lc_IAON."Object Type"::Codeunit:
                _Path += GetALFolderCodeunits() + '\';
            lc_IAON."Object Type"::Table:
                _Path += GetALFolderTables() + '\';
            lc_IAON."Object Type"::TableExtension:
                _Path += GetALFolderTablesExt() + '\';
            lc_IAON."Object Type"::Page:
                _Path += GetALFolderPages() + '\';
            lc_IAON."Object Type"::PageExtension:
                _Path += GetALFolderPagesExt() + '\';
            lc_IAON."Object Type"::Enum:
                _Path += GetALFolderEnums() + '\';
            lc_IAON."Object Type"::EnumExtension:
                _Path += GetALFolderEnumsExt() + '\';
            lc_IAON."Object Type"::Report:
                _Path += GetALFolderReports() + '\';
            lc_IAON."Object Type"::Query:
                _Path += GetALFolderQueries() + '\';
        end;

        // Create path
        //if not lc_FileMgmt.ServerDirectoryExists(_Path) then begin
        //    lc_FileMgmt.ServerCreateDirectory(_Path);
        if not lc_FileMgmt.ServerDirectoryExists(_Path) then
            Error(lc_Txt1_Txt, _Path);
        //end;

        // Get files from path
        lc_FileMgmt.GetServerDirectoryFilesList(lc_Files, _Path);

        // Read files
        if lc_Files.Find('-') then
            repeat
                // Init object
                clear(lc_IAON);
                lc_IAON.Init();
                lc_IAON."Customer No." := _CustomerNo;
                lc_IAON."App No." := _AppNo;

                // Import file in stream
                lc_FileMgmt.BLOBImportFromServerFile(lc_TempBlob, lc_Files.Name);
                lc_TempBlob.CreateInStream(lc_InStream, TextEncoding::UTF8);

                // Read first line from stream
                lc_InStream.ReadText(lc_Line);
                // Split header
                LoadObjectHeader(lc_Line, lc_Object, lc_No, lc_Name, lc_Extends);
                // Check number
                if (lc_No = 0) then
                    Error(lc_Txt7_Txt, lc_Files.Name);
                // Set name
                lc_IAON."Object Name" := CopyStr(lc_Name, 1, MaxStrLen(lc_IAON."Object Name"));
                // Set parent object name
                if (lc_Extends <> '') then
                    lc_IAON."Parent Object Name" := CopyStr(lc_Extends, 1, MaxStrLen(lc_IAON."Parent Object Name"));
                // Strip header
                lc_ObjectType := -1;
                case LowerCase(lc_Object) of
                    'codeunit':
                        lc_ObjectType := lc_IAON."Object Type"::Codeunit;
                    'table':
                        lc_ObjectType := lc_IAON."Object Type"::Table;
                    'tableextension':
                        begin
                            lc_ObjectType := lc_IAON."Object Type"::TableExtension;
                            lc_ObjectNo := GetExtNumber(lc_Name, 'tab');
                            lc_ExtNo := GetExtNumber2(lc_Name);
                            if lc_ObjectNo = 0 then
                                Error(lc_Txt2_Txt, lc_Name);
                            lc_ObjectName := LowerCase(CopyStr(lc_Name, 5));
                            lc_FileName := LowerCase(CopyStr(lc_Files.Value, 1, StrLen(lc_ObjectName)));
                            if (lc_ObjectName <> lc_FileName) then
                                Error(lc_Txt3_Txt, lc_Files.Name, lc_Name);
                            if (lc_ExtNo <> lc_No) then
                                Error(lc_Txt4_Txt, lc_No, lc_ExtNo, lc_Files.Name);
                            lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Table;
                            lc_IAON."Parent Object No." := lc_ObjectNo;
                        end;
                    'page':
                        lc_ObjectType := lc_IAON."Object Type"::Page;
                    'pageextension':
                        begin
                            lc_ObjectType := lc_IAON."Object Type"::PageExtension;
                            lc_ObjectNo := GetExtNumber(lc_Name, 'pag');
                            lc_ExtNo := GetExtNumber2(lc_Name);
                            if lc_ObjectNo = 0 then
                                Error(lc_Txt2_Txt, lc_Name);
                            lc_ObjectName := LowerCase(CopyStr(lc_Name, 5));
                            lc_FileName := LowerCase(CopyStr(lc_Files.Value, 1, StrLen(lc_ObjectName)));
                            if (lc_ObjectName <> lc_FileName) then
                                Error(lc_Txt3_Txt, lc_Files.Name, lc_Name);
                            if (lc_ExtNo <> lc_No) then
                                Error(lc_Txt4_Txt, lc_No, lc_ExtNo, lc_Files.Name);
                            lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Page;
                            lc_IAON."Parent Object No." := lc_ObjectNo;
                        end;
                    'enum':
                        lc_ObjectType := lc_IAON."Object Type"::Enum;
                    'enumextension':
                        begin
                            lc_ObjectType := lc_IAON."Object Type"::EnumExtension;
                            lc_ObjectNo := GetExtNumber(lc_Name, 'enu');
                            lc_ExtNo := GetExtNumber2(lc_Name);
                            if lc_ObjectNo = 0 then
                                Error(lc_Txt2_Txt, lc_Name);
                            lc_ObjectName := LowerCase(CopyStr(lc_Name, 5));
                            lc_FileName := LowerCase(CopyStr(lc_Files.Value, 1, StrLen(lc_ObjectName)));
                            if (lc_ObjectName <> lc_FileName) then
                                Error(lc_Txt3_Txt, lc_Files.Name, lc_Name);
                            if (lc_ExtNo <> lc_No) then
                                Error(lc_Txt4_Txt, lc_No, lc_ExtNo, lc_Files.Name);
                            lc_IAON."Parent Object Type" := lc_IAON."Parent Object Type"::Enum;
                            lc_IAON."Parent Object No." := lc_ObjectNo;
                        end;
                    'report':
                        lc_ObjectType := lc_IAON."Object Type"::Report;
                    'query':
                        lc_ObjectType := lc_IAON."Object Type"::Query;
                    'xmlport':
                        lc_ObjectType := lc_IAON."Object Type"::XMLport;
                end;

                // Check object type
                if lc_ObjectType < 0 then
                    Error(lc_Txt5_Txt, lc_Object, lc_Files.Name);

                // Validate obejct type
                if lc_ObjectType <> _ObjectType then
                    Error(lc_Txt6_Txt, lc_Files.Name);

                // Save object
                lc_IAON."Object Type" := lc_ObjectType;
                lc_IAON."Object No." := lc_No;
                if lc_IAON.Insert(true) then;

                // Load field numbers
                case _ObjectType of
                    lc_IAON."Object Type"::Table:
                        LoadObjectTable(_CustomerNo, _AppNo, lc_InStream, lc_IAON."Object No.", lc_IAON."Object Type", lc_IAON."Object Name");
                    lc_IAON."Object Type"::TableExtension:
                        LoadObjectTable(_CustomerNo, _AppNo, lc_InStream, lc_IAON."Object No.", lc_IAON."Object Type", lc_IAON."Object Name");
                    lc_IAON."Object Type"::Enum:
                        LoadObjectEnum(_CustomerNo, _AppNo, lc_InStream, lc_IAON."Object No.", lc_IAON."Object Type", lc_IAON."Object Name");
                    lc_IAON."Object Type"::EnumExtension:
                        LoadObjectEnum(_CustomerNo, _AppNo, lc_InStream, lc_IAON."Object No.", lc_IAON."Object Type", lc_IAON."Object Name");
                end;

            until lc_Files.Next() = 0;

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

    local procedure LoadObjectTable(_CustomerNo: Code[20]; _AppNo: Integer; _InStream: InStream; _ParentObjectNo: Integer; _ParentObjectType: Option; _ParentObjectName: Text)
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
            LoadObjectTableField(lc_Line, lc_No, lc_Name, lc_Size);
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

    local procedure LoadObjectTableField(_Line: Text; var _No: Integer; var _Name: Text; var _Size: Text) RetValue: Boolean
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

    local procedure LoadObjectEnum(_CustomerNo: Code[20]; _AppNo: Integer; _InStream: InStream; _ParentObjectNo: Integer; _ParentObjectType: Option; _ParentObjectName: Text)
    var
        lc_IAON: Record "IMP AL Object Number";
        lc_Line: Text;
        lc_No: Integer;
        lc_Name: Text;
    begin
        // Read instream
        while not _InStream.EOS do begin
            // Read line
            _InStream.ReadText(lc_Line);
            // Load enum
            LoadObjectEnumEntry(lc_Line, lc_No, lc_Name);
            // Save enum
            if lc_No <> 0 then begin
                clear(lc_IAON);
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

    local procedure LoadObjectEnumEntry(_Line: Text; var _No: Integer; var _Name: Text) RetValue: Boolean
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

    local procedure GetExtNumber(_Text: Text; _Type: Text) RetValue: Integer
    var
        lc_Length: Integer;
        lc_Number: Text;
    begin

        //XXX Tab70028-Ext70065

        // Init
        RetValue := 0;

        // Only with type in text
        if StrPos(LowerCase(_Text), LowerCase(_Type)) = 0 then
            exit;

        // Get number
        lc_Number := CopyStr(_Text, StrPos(LowerCase(_Text), LowerCase(_Type)) + StrLen(_Type));

        // Strip number
        if StrPos(lc_Number, '-') > 0 then begin
            lc_Length := StrPos(lc_Number, '-') - 1;
            lc_Number := CopyStr(lc_Number, 1, lc_Length);
        end;

        // Return number
        if Evaluate(RetValue, lc_Number) then;
    end;

    local procedure GetExtNumber2(_Text: Text) RetValue: Integer
    var
        lc_Number: Text;
    begin

        //IMP Tab70028-Ext70065

        // Init
        RetValue := 0;

        // Only with ext in text
        if StrPos(LowerCase(_Text), 'ext') = 0 then
            exit;

        // Set number
        lc_Number := CopyStr(_Text, StrPos(LowerCase(_Text), 'ext') + StrLen('ext'));

        // Return number
        if Evaluate(RetValue, lc_Number) then;
    end;

    /*
    procedure LoadObjectsCustomer()
    var
        lc_FileMgmt: Codeunit "File Management";
        lc_Base: Text;
        lc_Path: Text;
        lc_Abbreviation: Text;
        lc_AppName: Text;
        lc_IAON: Record "AL Object Numbers";
    begin
        lc_Base := '\\impfps01\Daten\04_Entwicklung\Kunden\';
        lc_Path := lc_FileMgmt.BrowseForFolderDialog('Select your app folder', lc_Base, false);

        if CopyStr(lc_Path, StrLen(lc_Path), 1) <> '\' then begin
            lc_Path += '\';
        end;

        if (lc_Path = '') or (lc_Path = lc_Base) then begin
            exit;
        end;

        if StrLen(lc_Path) <= StrLen(lc_Base) then begin
            Error('This is no customer folder');
        end;

        lc_Abbreviation := CopyStr(lc_Path, StrLen(lc_Base) + 1, 3);

        lc_IAON.Reset;
        lc_IAON.SetRange(Company, lc_Abbreviation);
        if lc_IAON.FindSet then begin
            lc_IAON.DeleteAll;
        end;

        LoadObjects(lc_Abbreviation, lc_Abbreviation + '-customer', lc_Path + lc_Abbreviation + '-customer\');
        LoadObjects(lc_Abbreviation, lc_Abbreviation + '-support', lc_Path + lc_Abbreviation + '-support\');

        Message('Object import of customer apps done!');
    end;

    procedure ImportCustomerObjects()
    var
        lc_FileMgmt: Codeunit "File Management";
        lc_Base: Text;
        lc_Path: Text;
        lc_ALPath: Text;
        lc_Files: Record "Name/Value Buffer" temporary;
        lc_TempBlob: Record TempBlob temporary;
        lc_Abbreviation: Text;
        lc_AppName: Text;
        lc_App: Integer;
        lc_IAON: Record "AL Object Numbers";
        lc_ALImpObj: Record "AL IMP Object Numbers";
        lc_InStream: InStream;
        lc_Line: Text;
        lc_Object: Text;
        lc_No: Text;
        lc_Name: Text;
        lc_Extends: Text;
        lc_ObjectType: Integer;
        lc_ObjectNo: Integer;
        lc_FileName: Text;
        lc_ObjectName: Text;
        lc_ExtNo: Text;
        lc_Pref: Text;
        lc_Subf: Text;
        lc_TargetPath: Text;
        lc_Counter: Integer;
    begin
        lc_Base := '\\impfps01\Daten\04_Entwicklung\Kunden\';
        lc_Path := lc_FileMgmt.BrowseForFolderDialog('Select your app folder', lc_Base, false);

        if CopyStr(lc_Path, StrLen(lc_Path), 1) <> '\' then begin
            lc_Path += '\';
        end;

        if (lc_Path = '') or (lc_Path = lc_Base) then
            exit;

        lc_Abbreviation := CopyStr(lc_Path, StrLen(lc_Base) + 1, 3);
        lc_AppName := GetAppName(CopyStr(lc_Path, 1, StrLen(lc_Path) - 1));

        lc_ALPath := lc_Path + 'AL\';

        if not lc_FileMgmt.ServerDirectoryExists(lc_ALPath) then begin
            lc_FileMgmt.ServerCreateDirectory(lc_ALPath);
            if not lc_FileMgmt.ServerDirectoryExists(lc_ALPath) then begin
                Error('Folder %1 notfound!', lc_ALPath);
            end;
        end;

        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Codeunits');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Tables');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\TablesExt');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Pages');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\PagesExt');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Enums');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\EnumsExt');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Reports');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\Queries');
        lc_FileMgmt.ServerCreateDirectory(lc_ALPath + '\XmlPorts');

        if lc_App < 0 then begin
            lc_IAON.Reset;
            lc_IAON.SetRange(Company, lc_Abbreviation);
            if lc_IAON.FindSet then begin
                lc_IAON.DeleteAll;
            end;
        end;

        lc_Counter := 0;

        lc_FileMgmt.GetServerDirectoryFilesList(lc_Files, lc_Path);
        if lc_Files.Find('-') then begin
            repeat
                if LowerCase(CopyStr(lc_Files.Name, StrLen(lc_Files.Name) - 2)) = '.al' then begin
                    lc_FileMgmt.BLOBImportFromServerFile(lc_TempBlob, lc_Files.Name);
                    lc_TempBlob.Blob.CreateInStream(lc_InStream, TEXTENCODING::UTF8);

                    lc_InStream.ReadText(lc_Line);
                    LoadObjectHeader(lc_Line, lc_Object, lc_No, lc_Name, lc_Extends);

                    lc_ObjectType := -1;
                    case LowerCase(lc_Object) of
                        'codeunit':
                            begin
                                lc_TargetPath := lc_ALPath + 'Codeunits\';
                                lc_ObjectType := lc_IAON."Object Type"::Codeunit;
                                lc_Pref := 'Cod';
                                lc_Subf := '';
                            end;
                        'table':
                            begin
                                lc_TargetPath := lc_ALPath + 'Tables\';
                                lc_ObjectType := lc_IAON."Object Type"::Table;
                                                                             lc_Pref := 'Tab';
                                                                             lc_Subf := '';
                            end;
                        'tableextension':
                            begin
                                lc_TargetPath := lc_ALPath + '\TablesExt\';
                                lc_ObjectType := lc_IAON."Object Type"::TableExtension;
                                                                             lc_Pref := 'Tab';
                                                                             lc_Subf := '-Ext';
                            end;
                        'page':
                            begin
                                lc_TargetPath := lc_ALPath + 'Pages\';
                                lc_ObjectType := lc_IAON."Object Type"::Page;
                                                                             lc_Pref := 'Pag';
                                                                             lc_Subf := '';
                            end;
                        'pageextension':
                            begin
                                lc_TargetPath := lc_ALPath + 'PagesExt\';
                                lc_ObjectType := lc_IAON."Object Type"::PageExtension;
                                                                             lc_Pref := 'Pag';
                                                                             lc_Subf := '-Ext';
                            end;
                        'enum':
                            begin
                                lc_TargetPath := lc_ALPath + 'Enums\';
                                lc_ObjectType := lc_IAON."Object Type"::Enum;
                                                                             lc_Pref := 'Enu';
                                                                             lc_Subf := '';
                            end;
                        'enumextension':
                            begin
                                lc_TargetPath := lc_ALPath + 'EnumsExt\';
                                lc_ObjectType := lc_IAON."Object Type"::EnumExtension;
                                                                             lc_Pref := 'Enu';
                                                                             lc_Subf := '-Ext';
                            end;
                        'report':
                            begin
                                lc_TargetPath := lc_ALPath + 'Reports\';
                                lc_ObjectType := lc_IAON."Object Type"::Report;
                                                                             lc_Pref := 'Rep';
                                                                             lc_Subf := '';
                            end;
                        'query':
                            begin
                                lc_TargetPath := lc_ALPath + 'Queries\';
                                lc_ObjectType := lc_IAON."Object Type"::Query;
                                                                             lc_Pref := 'Qry';
                                                                             lc_Subf := '';
                            end;
                        'xmlport':
                            begin
                                lc_TargetPath := lc_ALPath + 'XmlPorts\';
                                lc_ObjectType := lc_IAON."Object Type"::XMLport;
                                                                             lc_Pref := 'Xml';
                                                                             lc_Subf := '';
                            end;
                    end;

                    if lc_ObjectType < 0 then begin
                        Error('Unknown Object %1 in Line 1 of "%2"', lc_Object, lc_Files.Name);
                    end;

                    // Save AL Object
                    lc_IAON.Reset;
                    lc_IAON.SetRange(Company, lc_Abbreviation);
                    lc_IAON.SetRange("Object Type", lc_ObjectType);
                    if lc_IAON.FindLast then begin
                        if Format(lc_IAON."Object No.") < lc_No then begin
                            Evaluate(lc_IAON."Object No.", lc_No);
                            if lc_IAON.Modify(true) then;
                        end;
                    end else begin
                        lc_IAON.Init;
                        lc_IAON.Company := lc_Abbreviation;
                        lc_IAON."Object Type" := lc_ObjectType;
                        Evaluate(lc_IAON."Object No.", lc_No);
                        if lc_IAON.Insert(true) then;
                    end;

                    lc_FileName := lc_Pref + lc_No + lc_Subf + '.' + lc_Files.Value + '.al';

                    lc_FileMgmt.CopyServerFile(lc_Files.Name, lc_TargetPath + lc_FileName, true);
                    if lc_FileMgmt.ServerFileExists(lc_TargetPath + lc_FileName) then begin
                        lc_Counter += 1;
                    end;
                    //lc_FileMgmt.DeleteServerFile(lc_Files.Name);
                end;
            until lc_Files.Next = 0;
        end;

        Message('%1 Objects imported!', lc_Counter);
    end;
    */

    #endregion Methodes
}