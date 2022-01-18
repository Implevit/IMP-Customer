page 50003 "IMP Selection List"
{
    Caption = 'Selection';
    PageType = List;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    //ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Editable = IdIsEditable;
                    Visible = IdIsVisible;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = NameIsEditable;
                    Visible = NameIsVisible;
                    StyleExpr = Style;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Editable = ValueIsEditable;
                    Visible = ValueIsVisible;
                }
                field("Value Long"; Rec."Value Long")
                {
                    ApplicationArea = All;
                    Editable = ValueLongIsEditable;
                    Enabled = ValueLongIsEditable;
                    Visible = ValueLongIsVisible;
                    StyleExpr = Style;

                    trigger OnValidate()
                    begin
                        DoValidate();
                    end;
                }
                field("IMP Value Long 2"; Rec."IMP Value Long 2")
                {
                    ApplicationArea = All;
                    Editable = ValueLong2IsEditable;
                    Enabled = ValueLong2IsEditable;
                    Visible = ValueLong2IsVisible;
                    StyleExpr = Style;
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActProcessUpdate)
            {
                Caption = 'Update';
                ApplicationArea = All;
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowUpdate;

                trigger OnAction()
                begin
                    Target.Reset();
                    if Confirm(Format(Target.Count)) then;
                    AdmMgmt.CallServiceUpdate(IC, Target, true, true);
                    CurrPage.Close();
                end;
            }
            action(ActProcessShow)
            {
                Caption = 'Filter';
                ApplicationArea = All;
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowFilter;

                trigger OnAction()
                begin
                    if (Rec.GetFilter(Value) <> '') then
                        Rec.SetRange(Value)
                    else
                        Rec.SetFilter(Value, '<>%1', '');
                    if Rec.Find('-') then;
                end;
            }
        }
    }

    #region Triggers

    trigger OnOpenPage()
    begin
        Source.DeleteAll();
        Target.DeleteAll();
        if (Rec.Find('-')) then
            repeat
                Source.TransferFields(Rec);
                Source.Insert();
            until Rec.Next() = 0;
        IF (Rec.Find('-')) then;
    end;

    trigger OnAfterGetRecord()
    begin
        Style := 'Standard';

        if (ValueLong2IsVisible) then
            if (Rec.Value <> '') then
                Style := 'Unfavorable'
            else
                if (Rec.Value <> '') then
                    Style := 'StrongAccent';
    end;
    #endregion Triggers

    #region Methodes

    procedure HideAllEntries()
    begin
        IdIsEditable := false;
        IdIsVisible := false;
        NameIsEditable := false;
        NameIsVisible := false;
        ValueIsEditable := false;
        ValueIsVisible := false;
        ValueLongIsEditable := false;
        ValueLongIsVisible := false;
        ValueLong2IsEditable := false;
        ValueLong2IsVisible := false;
    end;

    procedure SetFields(_Fields: List of [Integer]; _Editable: Boolean; _SingleSelection: Boolean)
    var
        lc_Field: Integer;
    begin
        // Set selection
        SingleSelection := _SingleSelection;

        // Set fields
        foreach lc_Field in _Fields do
            SetEditable(lc_Field, _Editable);
    end;

    procedure SetEditable(_FieldNo: Integer; _Editable: Boolean)
    begin
        case _FieldNo of
            Rec.FieldNo(ID):
                begin
                    IdIsEditable := _Editable;
                    IdIsVisible := true;
                end;
            Rec.FieldNo(Name):
                begin
                    NameIsEditable := _Editable;
                    NameIsVisible := true;
                end;
            Rec.FieldNo(Value):
                begin
                    ValueIsEditable := _Editable;
                    ValueIsVisible := true;
                end;
            Rec.FieldNo("Value Long"):
                begin
                    ValueLongIsEditable := _Editable;
                    ValueLongIsVisible := true;
                end;
            Rec.FieldNo("IMP Value Long 2"):
                begin
                    ValueLong2IsEditable := _Editable;
                    ValueLong2IsVisible := true;
                end;
        end;
    end;

    procedure SetData(_TableNo: Integer; var _Rec: Record "Name/Value Buffer")
    begin
        // Init;
        TableNo := _TableNo;
        ShowUpdate := false;
        ShowFilter := false;
        Clear(IC);

        // Set
        Rec.Reset();
        Rec.DeleteAll();
        if _Rec.find('-') then begin
            ValueLong2IsVisible := (_Rec."IMP Value Long 2" <> '');
            repeat
                Rec.Init();
                Rec.TransferFields(_Rec);
                if (_TableNo = Database::"IMP Connection") then begin
                    if (_Rec.Name = 'entryno') then begin
                        IC.Get(Rec."Value Long");
                        ShowUpdate := (not ValueLong2IsVisible);
                        ShowFilter := true;
                    end else
                        Rec.Insert();
                end else
                    Rec.Insert();
            until _Rec.Next() = 0;
            // Set to top
            if Rec.Find('-') then;
        end;
    end;

    procedure GetValue(_FieldNo: Integer) RetValue: Variant
    begin
        case _FieldNo of
            Rec.FieldNo(ID):
                RetValue := Rec.ID;
            Rec.FieldNo(Name):
                RetValue := Rec.Name;
            Rec.FieldNo(Value):
                RetValue := Rec.Value;
            Rec.FieldNo("Value Long"):
                RetValue := Rec."Value Long";
            else
                clear(RetValue);
        end;
    end;

    procedure GetSelection(var _Rec: Record "Name/Value Buffer")
    begin
        _Rec.DeleteAll(true);
        if (SingleSelection) then begin
            _Rec.Init();
            _Rec.TransferFields(Rec);
            _Rec.Insert(true);
        end else begin
            CurrPage.SetSelectionFilter(Rec);
            if Rec.Find('-') then
                repeat
                    _Rec.Init();
                    _Rec.TransferFields(Rec);
                    _Rec.Insert(true);
                until Rec.Next() = 0;
        end;
    end;

    local procedure Changed() RetValue: Boolean
    var
        lc_Txt1_Txt: Label 'Change of %1 is not possible';
    begin
        // Init
        RetValue := true;

        // Only for connections
        if (TableNo = Database::"IMP Connection") then
            case Rec.Name of
                'environment':
                    RetValue := false;
                'environmentid':
                    RetValue := false;
                'environmenttype':
                    RetValue := false;
                'environmentname':
                    RetValue := false;
                'environmentstate':
                    RetValue := false;
                'name':
                    RetValue := false;
                'version':
                    RetValue := false;
                'state':
                    RetValue := false;
                'fullversion':
                    RetValue := false;
                'navision':
                    RetValue := false;
                else
                    RetValue := true;
            end;

        // Show message
        if not RetValue then begin
            Message(lc_Txt1_Txt, Rec.Name);
            Rec."Value Long" := xRec."Value Long";
        end;
    end;

    local procedure DoValidate()
    begin
        if Changed() then
            if (TableNo = Database::"IMP Connection") then
                if (Rec."Value Long" <> xRec."Value Long") then begin
                    Target.SetRange(ID, Rec.ID);
                    if not Target.Find('-') then begin
                        Target.Init();
                        Target.TransferFields(Rec);
                        Target.ID := Rec.ID;
                        Target.Insert();
                        Rec.Value := 'x';
                    end else begin
                        Source.SetRange(ID, Rec.ID);
                        if Source.Find('-') then
                            if (Rec."Value Long" = Source."Value Long") then begin
                                Target.Delete();
                                Rec.Value := '';
                            end else begin
                                Target."Value Long" := Rec."Value Long";
                                Target.Modify();
                                Rec.Value := 'x';
                            end;
                    end;
                    Rec.Modify();
                    CurrPage.Update(false);
                end;
    end;

    #endregion Methodes

    var
        Source: Record "Name/Value Buffer" temporary;
        Target: Record "Name/Value Buffer" temporary;
        IC: Record "IMP Connection";
        AdmMgmt: Codeunit "IMP Administration";
        TableNo: Integer;
        IdIsEditable: Boolean;
        IdIsVisible: Boolean;
        NameIsEditable: Boolean;
        NameIsVisible: Boolean;
        ValueIsEditable: Boolean;
        ValueIsVisible: Boolean;
        ValueLongIsEditable: Boolean;
        ValueLongIsVisible: Boolean;
        ValueLong2IsEditable: Boolean;
        ValueLong2IsVisible: Boolean;
        SingleSelection: Boolean;
        ShowUpdate: Boolean;
        ShowFilter: Boolean;
        [InDataSet]
        Style: Text;
}