table 50005 "IMP AL Object Number"
{
    Caption = 'AL Object Number';
    DataClassification = ToBeClassified;
    DrillDownPageId = "IMP AL Object Numbers";
    LookupPageId = "IMP AL Object Numbers";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(2; "App No."; Integer)
        {
            Caption = 'App No.';
            DataClassification = CustomerContent;
            TableRelation = "IMP AL Object App";
        }
        field(3; "Parent Object Type"; Option)
        {
            Caption = 'Parent Object Type';
            DataClassification = CustomerContent;
            OptionCaption = ',Table,,,,,,,,,,,,,,Table Extension,Enum,Enum Extension,,';
            OptionMembers = "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber",,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension";
        }
        field(4; "Parent Object No."; Integer)
        {
            Caption = 'Parent Object No.';
            DataClassification = CustomerContent;
            TableRelation = Object.ID Where(Type = CONST(Table));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lc_Rec: Record "IMP AL Object Number";
                lc_Txt1_Txt: Label '%1 for %2 %3 already exists as %4';
            begin
                if (Rec."Parent Object No." = 0) then begin
                    if Rec.Delete() then;
                    exit;
                end;

                lc_Rec.Reset();
                lc_Rec.SetRange("Customer No.", Rec."Customer No.");
                lc_Rec.SetRange("App No.", Rec."App No.");
                lc_Rec.SetRange("Parent Object Type", Rec."Parent Object Type");
                lc_Rec.SetRange("Parent Object No.", Rec."Parent Object No.");
                lc_Rec.SetRange("Object Type", Rec."Object Type");
                lc_Rec.SetFilter("Object No.", '<>%1', Rec."Object No.");
                if lc_Rec.FindFirst() then begin
                    Message(lc_Txt1_Txt, Rec."Object Type", Rec."Parent Object Type", Rec."Parent Object No.", lc_Rec."Object No.");
                    Error('');
                end else
                    Rec."Object No." := GetNextNo(Rec."Customer No.", Rec."App No.", Rec."Parent Object Type", Rec."Parent Object No.", Rec."Object Type");
            end;
        }
        field(5; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = ',Table,,Report,,Codeunit,XML port,,Page,Query,,Field Number,,,Page Extension,Table Extension,Enum,Enum Extension,,';
            OptionMembers = "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber",,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension";
        }
        field(6; "Object No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Last Entry No."; Integer)
        {
            Caption = 'Last Entry No.';
            FieldClass = FlowField;
            CalcFormula = max("IMP AL Object Number"."Object No." where(
                                "Customer No." = field("Customer No."),
                                "App No." = field("App No."),
                                "Object Type" = field("Object Type"),
                                "Object No." = filter('<>0')
                                ));
            Editable = false;
        }
        field(11; "Last Field No."; Integer)
        {
            Caption = 'Last Field No.';
            FieldClass = FlowField;
            CalcFormula = max("IMP AL Object Number"."Object No." where(
                                "Customer No." = field("Customer No."),
                                "App No." = field("App No."),
                                "Object Type" = const(FieldNumber),
                                "Parent Object Type" = field("Object Type"),
                                "Parent Object No." = field("Object No.")
                                ));
            Editable = false;
        }
        field(20; "App Name"; Text[50])
        {
            Caption = 'App Name';
            FieldClass = FlowField;
            CalcFormula = lookup("IMP AL Object App".Name where("No." = field("App No.")));
            TableRelation = "IMP AL Object App";
            Editable = false;
        }
        field(30; "Object Name"; Text[30])
        {
            Caption = 'Entry Name';
            DataClassification = CustomerContent;
        }
        field(40; "Parent Object Name"; Text[30])
        {
            Caption = 'Parent Object Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "App No.", "Parent Object Type", "Parent Object No.", "Object Type", "Object No.")
        {
        }
    }

    #region Methodes

    procedure GetNextNo(_CustomerNo: Code[20]; _AppNo: Integer; _ParentObjectType: Option; _ParentObjectNo: Integer; _ObjectType: Option) RetValue: Integer
    var
        lc_Cust: Record Customer;
        lc_IAOA: Record "IMP AL Object App";
        lc_IAON: Record "IMP AL Object Number";
        lc_IAONParent: Record "IMP AL Object Number";
        lc_MenuObject_Txt: Label ',Table,,Report,,Codeunit,XML port,,Page,Query,,Field Number,,,Page Extension,Table Extension,Enum,Enum Extension,,';
    begin
        // Init
        RetValue := 0;

        // Get customer
        if not lc_Cust.Get(_CustomerNo) then begin
            lc_Cust.Reset();
            if Page.RunModal(0, lc_Cust) <> Action::LookupOK then
                exit
            else
                _CustomerNo := lc_Cust."No.";
        end;

        // Get app
        if not lc_IAOA.Get(_AppNo) then begin
            lc_IAOA.Reset();
            lc_IAOA.SetRange("Customer No.", _CustomerNo);
            if lc_IAOA.FindSet() then
                if Page.RunModal(Page::"IMP AL Object Apps", lc_IAOA) <> Action::LookupOK then
                    exit
                else
                    _AppNo := lc_IAOA."No.";
        end;

        // Get object type
        if (_ObjectType = 0) then begin
            _ObjectType := StrMenu(lc_MenuObject_Txt, 1);
            if (_ObjectType = 0) then
                exit
            else
                _ObjectType -= 1;
        end;

        // Find next entry
        lc_IAON.LockTable();
        lc_IAON.Reset();
        lc_IAON.SetRange("Customer No.", _CustomerNo);
        lc_IAON.SetRange("App No.", _AppNo);
        lc_IAON.SetRange("Object Type", _ObjectType);
        // Next field or enum entry
        if (_ObjectType = lc_IAON."Object Type"::FieldNumber) then begin
            lc_IAON.SetRange("Parent Object No.", _ParentObjectNo);
            lc_IAON.SetRange("Parent Object Type", _ParentObjectType);
            if lc_IAON.FindLast() then
                RetValue := lc_IAON."Object No." + 10
            else
                if (_ParentObjectType in [Rec."Object Type"::Table, Rec."Object Type"::Enum]) then
                    RetValue := 10
                else begin
                    lc_IAONParent.Reset();
                    lc_IAONParent.SetRange("Customer No.", _CustomerNo);
                    lc_IAONParent.SetRange("App No.", _AppNo);
                    lc_IAONParent.SetRange("Object Type", _ParentObjectType);
                    lc_IAONParent.SetRange("Object No.", _ParentObjectNo);
                    lc_IAONParent.FindFirst();
                    if ((lc_IAONParent."Parent Object No." >= lc_IAOA."No. Range From") and (lc_IAONParent."Parent Object No." <= lc_IAOA."No. Range To")) then
                        RetValue := 10
                    else
                        RetValue := lc_IAOA."No. Range From";
                end;
        end else begin
            // Set first object
            RetValue := lc_IAOA."No. Range From";
            // Set filter 
            lc_IAON.SetFilter("Object No.", '<>%1', 0);
            if lc_IAON.FindSet() then
                repeat
                    if (RetValue < lc_IAON."Object No.") then
                        // Free number found get last for exit loop
                        lc_IAON.Find('+')
                    else
                        // Show for next number
                        RetValue := lc_IAON."Object No." + 1;
                until lc_IAON.Next() = 0;
        end;
        // Save entry
        if not (_ObjectType in [Rec."Object Type"::"TableExtension", Rec."Object Type"::"PageExtension", Rec."Object Type"::"EnumExtension"]) then begin
            lc_IAON.Init();
            lc_IAON.Validate("Customer No.", _CustomerNo);
            lc_IAON.Validate("App No.", _AppNo);
            lc_IAON."Parent Object Type" := _ParentObjectType;
            lc_IAON."Parent Object No." := _ParentObjectNo;
            lc_IAON.Validate("Object Type", _ObjectType);
            lc_IAON.Validate("Object No.", RetValue);
            lc_IAON.Insert(true);
        end;
    end;

    #endregion Methodes

}

