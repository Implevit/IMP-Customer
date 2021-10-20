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
                    var
                        lc_Page: Page "IMP AL Object Numbers";
                    begin
                        if (Level = 2) then begin
                            lc_Page.SetLevel3(Rec."Customer No.", Rec."App No.", Rec."Object Type"::FieldNumber, Rec."Object Type", Rec."Object No.");
                            lc_Page.Run();
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                var
                    lc_NewEntry: Integer;
                begin
                    lc_NewEntry := Rec.GetNextNo(Rec."Customer No.", Rec."App No.", Rec."Parent Object Type", Rec."Parent Object No.", Rec."Object Type");
                    CurrPage.Update(false);
                    Message(Format(lc_NewEntry));
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
                var
                    lc_NewEntry: Integer;
                begin
                    lc_NewEntry := Rec.GetNextNo(Rec."Customer No.", Rec."App No.", Rec."Object Type", Rec."Object No.", Rec."Object Type"::FieldNumber);
                    CurrPage.Update(false);
                    Message(Format(lc_NewEntry));
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
        EnableActionNewObjectNumber := not (Rec."Object Type" in [Rec."Object Type"::"TableExtension", Rec."Object Type"::"PageExtension", Rec."Object Type"::"EnumExtension"]);
        EnableActionNewFieldNumber := ((Rec."Object No." <> 0) and (Rec."Object Type" in [Rec."Object Type"::FieldNumber, Rec."Object Type"::"Table", Rec."Object Type"::"TableExtension", Rec."Object Type"::"Enum", Rec."Object Type"::"EnumExtension"]));
    end;

    #endregion Triggers

    #region Methodes

    procedure SetLevel0()
    begin
        Rec.Reset();
        if Rec.FindSet() then;
        ShowCustomer := true;
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

    procedure SetLevel1(_CustomerNo: Code[20]; _AppNo: Integer)
    begin
        CurrCustomerNo := _CustomerNo;
        CurrAppNo := _AppNo;
        Rec.Reset();
        Rec.SetRange("Customer No.", _CustomerNo);
        Rec.SetRange("App No.", _AppNo);
        Rec.SetRange("Object No.", 0);
        if Rec.FindSet() then;
        ShowCustomer := false;
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

