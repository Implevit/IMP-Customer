page 50008 "IMP AL Object Numbers"
{
    Caption = 'AL Object Numbers';
    PageType = List;
    SourceTable = "IMP AL Object Number";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Visible = ShowCustomer;
                }
                field("App No."; Rec."App No.")
                {
                    ApplicationArea = All;
                    Visible = ShowApp;
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                    Visible = ShowApp;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    Enabled = EnabledObjectType;

                    trigger OnDrillDown()
                    begin
                        if (Level = 2) then
                            ShowFields()
                        else
                            ShowObjects();
                    end;
                }
                field("Parent Object Type"; Rec."Parent Object Type")
                {
                    ApplicationArea = All;
                    Visible = ShowParentObject;
                    Enabled = EnabledParentObjectType;
                }
                field("Parent Object No."; Rec."Parent Object No.")
                {
                    ApplicationArea = All;
                    Visible = ShowParentObject;
                }
                field("Parent Object Name"; Rec."Parent Object Name")
                {
                    ApplicationArea = All;
                    Visible = ShowParentObject;
                }
                field("Last Entry No."; Rec."Last Entry No.")
                {
                    ApplicationArea = All;
                    Visible = ShowLastEntryNo;

                    trigger OnDrillDown()
                    begin
                        ShowObjects();
                    end;
                }
                field("Object No."; Rec."Object No.")
                {
                    ApplicationArea = All;
                    Visible = ShowEntryNo;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    Visible = ShowEntryNo;
                }
                field("Last Field No."; Rec."Last Field No.")
                {
                    ApplicationArea = All;
                    Visible = ShowLastFieldNo;

                    trigger OnDrillDown()
                    begin
                        ShowFields();
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ActRefresh)
            {
                Caption = 'Refresh';
                ApplicationArea = All;
                Image = Refresh;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowRefresh;

                trigger OnAction()
                begin
                    RefreshPage();
                end;
            }
            action(ActNewObjectNumber)
            {
                Caption = 'New Object';
                Image = CreateSerialNo;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = EnableActionNewObjectNumber;
                Visible = not HideActionNewObjectNumber;

                trigger OnAction()
                begin
                    NewObject();
                end;
            }
            action(ActNewFieldNumber)
            {
                Caption = 'New Field';
                Image = CreateSerialNo;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = EnableActionNewFieldNumber;
                Visible = not HideActionNewFieldNumber;

                trigger OnAction()
                begin
                    NewField();
                end;
            }
        }
    }

    #region Triggers

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Customer No." := CurrCustomerNo;
        Rec."App No." := CurrAppNo;
        Rec."Object Type" := CurrObjectType;
        Rec."Parent Object Type" := CurrParentObjectType;
    end;

    trigger OnOpenPage()
    begin
        if (Level = 0) then
            SetLevel0();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        EnableActionNewObjectNumber := true; // not (Rec."Object Type" in [Rec."Object Type"::"TableExtension", Rec."Object Type"::"PageExtension", Rec."Object Type"::"EnumExtension"]);
        EnableActionNewFieldNumber := ((Rec."Object No." <> 0) and (Rec."Object Type" in [Rec."Object Type"::FieldNumber, Rec."Object Type"::"Table", Rec."Object Type"::"TableExtension", Rec."Object Type"::"Enum", Rec."Object Type"::"EnumExtension"]));
    end;

    trigger OnDeleteRecord(): Boolean
    var
        lc_Conf_Txt: Label 'Do you really want to delete the selected entries?\\This will delete all linked objects as well!';
    begin
        if (Rec."Object No." = 0) then
            if not Confirm(lc_Conf_Txt) then
                Error('');
    end;

    #endregion Triggers

    #region Methodes

    local procedure RefreshPage()
    var
        lc_IAOA: Record "IMP AL Object App";
    begin
        if lc_IAOA.Get(CurrAppNo) then begin
            lc_IAOA.InitALNumbers();
            CurrPage.Update(false);
        end;
    end;

    local procedure ShowObjects()
    var
        lc_Page: Page "IMP AL Object Numbers";
    begin
        if (Level = 1) then begin
            case Rec."Object Type" of
                Rec."Object Type"::"TableExtension":
                    lc_Page.SetLevel2(Rec."Customer No.", Rec."App No.", Rec."Object Type", Rec."Parent Object Type"::Table);
                Rec."Object Type"::"PageExtension":
                    lc_Page.SetLevel2(Rec."Customer No.", Rec."App No.", Rec."Object Type", Rec."Parent Object Type"::Page);
                Rec."Object Type"::"EnumExtension":
                    lc_Page.SetLevel2(Rec."Customer No.", Rec."App No.", Rec."Object Type", Rec."Parent Object Type"::Enum);
                else
                    lc_Page.SetLevel2(Rec."Customer No.", Rec."App No.", Rec."Object Type", 0);
            end;
            lc_Page.Run();
        end;
    end;

    local procedure NewObject()
    var
        lc_Cust: Record Customer;
        lc_Rec: Record "IMP AL Object Number";
        lc_Toolbox: Page "IMP Toolbox";
        lc_NewEntry: Integer;
        lc_Text: Text;
        lc_Int: Integer;
        lc_ObjectName: Text;
        lc_FileName: Text;
        lc_Txt1_Txt: Label '%1 is no standard object so we need the object number!';
        lc_Txt2_Txt: Label 'New %1 %2';
    begin
        lc_Cust.Get(Rec."Customer No.");
        if (Rec."Object Type" in [Rec."Object Type"::"TableExtension", Rec."Object Type"::"PageExtension", Rec."Object Type"::"EnumExtension"]) then begin
            // Get value
            lc_Toolbox.SetText('VALUE', lc_Text);
            if lc_Toolbox.RunModal() <> Action::OK then
                exit;
            // Init object
            lc_Rec.Init();
            lc_Rec."Customer No." := Rec."Customer No.";
            lc_Rec."App No." := Rec."App No.";
            lc_Rec."Object Type" := Rec."Object Type";
            case lc_Rec."Object Type" of
                lc_Rec."Object Type"::"TableExtension":
                    lc_Rec."Parent Object Type" := lc_Rec."Parent Object Type"::Table;
                lc_Rec."Object Type"::"PageExtension":
                    lc_Rec."Parent Object Type" := lc_Rec."Parent Object Type"::Page;
                lc_Rec."Object Type"::"EnumExtension":
                    lc_Rec."Parent Object Type" := lc_Rec."Parent Object Type"::Enum;
            end;
            // Validate parent object
            lc_Text := lc_Toolbox.GetText();
            if Evaluate(lc_Int, lc_Text) then
                lc_Rec.Validate("Parent Object No.", lc_Int)
            else begin
                lc_Rec.Validate("Parent Object Name", lc_Text);
                if (lc_Rec."Parent Object No." = 0) then begin
                    Message(lc_Txt1_Txt, lc_Text);
                    exit;
                end;
            end;
            // Insert object
            lc_Rec.Insert(true);
            Commit();
            // Set level
            if (Level = 0) then
                SetLevel0();
            if (Level = 1) then
                SetLevel1(CurrCustomerNo, CurrAppNo, Rec."Object Type");
            // Create reponse 
            case lc_Rec."Object Type" of
                lc_Rec."Object Type"::"TableExtension":
                    begin
                        lc_ObjectName := lc_Cust."IMP Abbreviation" + ' Tab' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.");
                        lc_FileName := 'Tab' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.") + '.' + lc_Cust."IMP Abbreviation" + lc_Rec."Parent Object Name".Replace(' ', '').Replace('/', '') + '.al';
                    end;
                lc_Rec."Object Type"::"PageExtension":
                    begin
                        lc_ObjectName := lc_Cust."IMP Abbreviation" + ' Pag' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.");
                        lc_FileName := 'Pag' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.") + '.' + lc_Cust."IMP Abbreviation" + lc_Rec."Parent Object Name".Replace(' ', '').Replace('/', '') + '.al';
                    end;
                lc_Rec."Object Type"::"EnumExtension":
                    begin
                        lc_ObjectName := lc_Cust."IMP Abbreviation" + ' Enu' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.");
                        lc_FileName := 'Enu' + Format(lc_Rec."Parent Object No.") + '-Ext' + Format(lc_Rec."Object No.") + '.' + lc_Cust."IMP Abbreviation" + lc_Rec."Parent Object Name".Replace(' ', '').Replace('/', '') + '.al';
                    end;
            end;
            lc_Text := Format(lc_Rec."Parent Object Type") + ' ' + Format(lc_Rec."Parent Object No.") + ' "' + lc_Rec."Parent Object Name" + '",';
            lc_Text += lc_ObjectName + ',';
            lc_Text += lc_FileName + ',';
            // Show response
            lc_Int := StrMenu(lc_Text, 1, StrSubstNo(lc_Txt2_Txt, lc_Rec."Object Type", lc_Rec."Object No."));
        end else begin
            lc_NewEntry := Rec.GetNextNo(Rec."Customer No.", Rec."App No.", Rec."Parent Object Type", Rec."Parent Object No.", Rec."Object Type");
            Commit();
            CurrPage.Update(false);
            // Create reponse 
            case Rec."Object Type" of
                Rec."Object Type"::Table:
                    lc_FileName := 'Tab';
                Rec."Object Type"::Page:
                    lc_FileName := 'Pag';
                Rec."Object Type"::Enum:
                    lc_FileName := 'Enu';
                Rec."Object Type"::Report:
                    lc_FileName := 'Rep';
                Rec."Object Type"::XMLport:
                    lc_FileName := 'Xml';
                Rec."Object Type"::Query:
                    lc_FileName := 'Qry';
            end;
            lc_ObjectName := lc_Cust."IMP Abbreviation" + ' <objectname>';
            lc_FileName += Format(lc_NewEntry) + '.' + lc_Cust."IMP Abbreviation" + '<objectname>.al';
            lc_Text := lc_ObjectName + ',';
            lc_Text += lc_FileName + ',';
            // Show response
            lc_Int := StrMenu(lc_Text, 1, StrSubstNo(lc_Txt2_Txt, Rec."Object Type", lc_NewEntry));
        end;
    end;

    local procedure ShowFields()
    var
        lc_Page: Page "IMP AL Object Numbers";
    begin
        if (Level = 2) then begin
            lc_Page.SetLevel3(Rec."Customer No.", Rec."App No.", Rec."Object Type"::FieldNumber, Rec."Object Type", Rec."Object No.");
            lc_Page.Run();
        end;
    end;

    local procedure NewField()
    var
        lc_NewEntry: Integer;
    begin
        lc_NewEntry := Rec.GetNextNo(Rec."Customer No.", Rec."App No.", Rec."Object Type", Rec."Object No.", Rec."Object Type"::FieldNumber);
        CurrPage.Update(false);
        Message(Format(lc_NewEntry));
    end;

    procedure SetLevel0()
    begin
        Rec.Reset();
        if Rec.FindSet() then;
        ShowCustomer := true;
        ShowRefresh := false;
        ShowApp := true;
        ShowParentObject := true;
        ShowEntryNo := true;
        ShowLastEntryNo := true;
        EnabledObjectType := true;
        EnabledParentObjectType := true;
        ShowLastFieldNo := true;
        HideActionNewObjectNumber := false;
        HideActionNewFieldNumber := false;
    end;

    procedure SetLevel1(_CustomerNo: Code[20]; _AppNo: Integer; _ObjectType: Option)
    begin
        CurrCustomerNo := _CustomerNo;
        CurrAppNo := _AppNo;
        Rec.Reset();
        Rec.SetRange("Customer No.", _CustomerNo);
        Rec.SetRange("App No.", _AppNo);
        Rec.SetRange("Object No.", 0);
        if (_ObjectType <> 0) then
            Rec.SetRange("Object Type", _ObjectType);
        if Rec.FindSet() then;
        Rec.SetRange("Object Type");
        ShowCustomer := false;
        ShowRefresh := true;
        ShowApp := false;
        ShowParentObject := false;
        ShowEntryNo := false;
        ShowLastEntryNo := true;
        ShowLastFieldNo := false;
        HideActionNewObjectNumber := false;
        HideActionNewFieldNumber := true;
        Level := 1;
    end;

    procedure SetLevel2(_CustomerNo: Code[20]; _AppNo: Integer; _ObjectType: Option; _ParentObjectType: Option)
    begin
        CurrCustomerNo := _CustomerNo;
        CurrAppNo := _AppNo;
        CurrObjectType := _ObjectType;
        CurrParentObjectType := _ParentObjectType;
        Rec.Reset();
        Rec.SetRange("Customer No.", _CustomerNo);
        Rec.SetRange("App No.", _AppNo);
        Rec.SetRange("Object Type", _ObjectType);
        if (_ParentObjectType <> 0) then
            Rec.SetRange("Parent Object Type", _ParentObjectType);
        Rec.SetFilter("Object No.", '<>%1', 0);
        if Rec.FindSet() then;
        ShowCustomer := false;
        ShowRefresh := false;
        ShowApp := false;
        ShowParentObject := (_ParentObjectType <> 0); // (_ObjectType in [Rec."Object Type"::"TableExtension", Rec."Object Type"::"PageExtension", Rec."Object Type"::"EnumExtension"]);
        ShowEntryNo := true;
        ShowLastEntryNo := false;
        ShowLastFieldNo := (_ObjectType in [Rec."Object Type"::"Table", Rec."Object Type"::"TableExtension", Rec."Object Type"::"Enum", Rec."Object Type"::"EnumExtension"]);
        EnabledObjectType := false;
        EnabledParentObjectType := false;
        HideActionNewObjectNumber := false;
        HideActionNewFieldNumber := false;
        Level := 2;
    end;

    procedure SetLevel3(_CustomerNo: Code[20]; _AppNo: Integer; _ObjectType: Option; _ParentObjectType: Option; _ParentObjectNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Customer No.", _CustomerNo);
        Rec.SetRange("App No.", _AppNo);
        Rec.SetRange("Parent Object Type", _ParentObjectType);
        Rec.SetRange("Parent Object No.", _ParentObjectNo);
        Rec.SetRange("Object Type", _ObjectType);
        if Rec.FindSet() then;
        ShowCustomer := false;
        ShowApp := false;
        ShowParentObject := false;
        ShowEntryNo := true;
        ShowLastEntryNo := false;
        ShowLastFieldNo := false;
        HideActionNewObjectNumber := true;
        HideActionNewFieldNumber := false;
        Level := 3;
    end;

    #endregion Methodes

    var
        EnableActionNewObjectNumber: Boolean;
        EnableActionNewFieldNumber: Boolean;
        HideActionNewObjectNumber: Boolean;
        HideActionNewFieldNumber: Boolean;
        ShowCustomer: Boolean;
        ShowRefresh: Boolean;
        ShowApp: Boolean;
        ShowParentObject: Boolean;
        ShowEntryNo: Boolean;
        ShowLastEntryNo: Boolean;
        ShowLastFieldNo: Boolean;
        EnabledParentObjectType: Boolean;
        EnabledObjectType: Boolean;
        Level: Integer;
        CurrCustomerNo: Code[20];
        CurrAppNo: Integer;
        CurrObjectType: Option;
        CurrParentObjectType: Option;
}

