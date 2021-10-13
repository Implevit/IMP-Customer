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
    ModifyAllowed = false;

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
                    Visible = ValueLongIsVisible;
                }
            }
        }
    }


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
    end;

    procedure SetFields(_Fields: List of [Integer]; _Editable: Boolean; _SingleSelection: Boolean)
    var
        lc_Field: Integer;
    begin
        // Set selection
        SingleSelection := _SingleSelection;

        // Set fields
        foreach lc_Field in _Fields do
            case lc_Field of
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
            end;
    end;

    procedure SetData(var _Rec: Record "Name/Value Buffer")
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if _Rec.find('-') then
            repeat
                Rec.Init();
                Rec.TransferFields(_Rec);
                Rec.Insert();
            until _Rec.Next() = 0;
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

    #endregion Methodes

    var
        IdIsEditable: Boolean;
        IdIsVisible: Boolean;
        NameIsEditable: Boolean;
        NameIsVisible: Boolean;
        ValueIsEditable: Boolean;
        ValueIsVisible: Boolean;
        ValueLongIsEditable: Boolean;
        ValueLongIsVisible: Boolean;
        SingleSelection: Boolean;
}