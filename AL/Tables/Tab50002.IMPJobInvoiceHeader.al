table 50002 "IMP Job Consulting Inv. Header"
{
    Caption = 'Job Accounting';
    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
    LookupPageID = "IMP Job Consulting Inv. Hdrs";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job;

            trigger OnValidate()
            var
                lc_Job: Record Job;
            begin
                if lc_Job.Get("Job No.") then
                    //Validate("Sell-to Customer No.", lc_Job."Sell-to Customer No.");
                    Validate("Bill-to Customer No.", lc_Job."Bill-to Customer No.")
                else begin
                    Validate("Sell-to Customer No.", '');
                    Validate("Bill-to Customer No.", '');
                end;
            end;
        }
        field(2; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
        field(3; Month; Option)
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        

        field(10; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
            DataClassification = CustomerContent;
        }
        field(20; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(30; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(40; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'created,checked,signed';
            OptionMembers = created,checked,signed;
        }
        field(50; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(60; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(70; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(80; "Created by User"; Code[20])
        {
            Caption = 'Created by User';
            DataClassification = CustomerContent;
            TableRelation = User;
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                            Month = FIELD(Month),
                                                                            Year = FIELD(Year),
                                                                            "Posting Date" = FIELD("Date Filter"),
                                                                            "Resource No." = FIELD("Resource Filter"),
                                                                            "Job Task No." = FIELD("Job Task Filter")));
        }
        field(100; "Quantity to Invoice"; Decimal)
        {
            Caption = 'Quantity to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Quantity to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                         Month = FIELD(Month),
                                                                                         Year = FIELD(Year),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Resource No." = FIELD("Resource Filter"),
                                                                                         "Job Task No." = FIELD("Job Task Filter")));
        }
        field(110; "Quantity not to Invoice"; Decimal)
        {
            Caption = 'Quantity not to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Quantity not to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                                    Month = FIELD(Month),
                                                                                                    Year = FIELD(Year),
                                                                                                    "Posting Date" = FIELD("Date Filter"),
                                                                                                    "Resource No." = FIELD("Resource Filter"),
                                                                                                    "Job Task No." = FIELD("Job Task Filter")));
        }
        field(120; "Source Quantity"; Decimal)
        {
            Caption = 'Source Quantity';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                     Month = FIELD(Month),
                                                                                     Year = FIELD(Year),
                                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                                     "Resource No." = FIELD("Resource Filter"),
                                                                                     "Job Task No." = FIELD("Job Task Filter")));
        }
        field(130; "Source Quantity to Invoice"; Decimal)
        {
            Caption = 'Source Quantity to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Quantity to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                                Month = FIELD(Month),
                                                                                                Year = FIELD(Year),
                                                                                                "Posting Date" = FIELD("Date Filter"),
                                                                                                "Resource No." = FIELD("Resource Filter"),
                                                                                                "Job Task No." = FIELD("Job Task Filter")));
        }
        field(140; "Source Quantity not to Invoice"; Decimal)
        {
            Caption = 'Source Quantity not to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Quantity not to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                                    Month = FIELD(Month),
                                                                                                    Year = FIELD(Year),
                                                                                                    "Posting Date" = FIELD("Date Filter"),
                                                                                                    "Resource No." = FIELD("Resource Filter"),
                                                                                                    "Job Task No." = FIELD("Job Task Filter")));
        }
        field(150; "Project Manager IMPL"; Code[20])
        {
            Caption = 'Project Manager IMPL';
            FieldClass = FlowField;
            CalcFormula = Lookup(Job."IMP Project Manager IMPL" WHERE("No." = FIELD("Job No.")));
        }
        field(160; "Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(170; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(180; "Job Task Filter"; Code[20])
        {
            Caption = 'Job Task Filter';
            FieldClass = FlowFilter;
            TableRelation = "Job Task";
        }
        field(190; "Filter Quantity"; Decimal)
        {
            Caption = 'Filter Quantity';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                            Month = FIELD(Month),
                                                                            Year = FIELD(Year),
                                                                            "Posting Date" = FIELD("Date Filter"),
                                                                            "Job Task No." = FIELD("Job Task Filter"),
                                                                            "Resource No." = FIELD("Resource Filter")));
        }
        field(200; "Filter Quantity to Invoice"; Decimal)
        {
            Caption = 'Filter Quantity to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Quantity to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                         Month = FIELD(Month),
                                                                                         Year = FIELD(Year),
                                                                                         "Resource No." = FIELD("Resource Filter"),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Job Task No." = FIELD("Job Task Filter")));
        }
        field(210; "Filter Quantity not to Invoice"; Decimal)
        {
            Caption = 'Filter Quantity not to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Quantity not to Invoice" WHERE("Job No." = FIELD("Job No."),
                                                                                             Month = FIELD(Month),
                                                                                             Year = FIELD(Year),
                                                                                             "Resource No." = FIELD("Resource Filter"),
                                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                                             "Job Task No." = FIELD("Job Task Filter")));
        }
        field(220; "Source Quantity Travel Time"; Decimal)
        {
            Caption = 'Source Quantity Travel Time';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Travel Time Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                 Month = FIELD(Month),
                                                                                                 Year = FIELD(Year),
                                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                                 "Resource No." = FIELD("Resource Filter"),
                                                                                                 "Job Task No." = FIELD("Job Task Filter")));
        }
        field(230; "Source Quantity Km"; Decimal)
        {
            Caption = 'Source Quantity Km';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Source Distance KM Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                 Month = FIELD(Month),
                                                                                                 Year = FIELD(Year),
                                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                                 "Resource No." = FIELD("Resource Filter"),
                                                                                                 "Job Task No." = FIELD("Job Task Filter")));
        }
        field(240; "Quantity Travel Time"; Decimal)
        {
            Caption = 'Quantity Travel Time';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Travel Time Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                          Month = FIELD(Month),
                                                                                          Year = FIELD(Year),
                                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                                          "Resource No." = FIELD("Resource Filter"),
                                                                                          "Job Task No." = FIELD("Job Task Filter")));
        }
        field(250; "Quantity Km"; Decimal)
        {
            Caption = 'Quantity Km';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Consulting Inv. Line"."Distance KM Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                          Month = FIELD(Month),
                                                                                          Year = FIELD(Year),
                                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                                          "Resource No." = FIELD("Resource Filter"),
                                                                                          "Job Task No." = FIELD("Job Task Filter")));
        }
        field(260; "Modified after creation"; Boolean)
        {
            Caption = 'Modified after creation';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(270; "Modified by User"; Code[20])
        {
            Caption = 'Modified by User';
            DataClassification = CustomerContent;
        }
        field(280; "Modified at Time"; DateTime)
        {
            Caption = 'Modified at Time';
            DataClassification = CustomerContent;
        }
        field(290; Exported; Boolean)
        {
            Caption = 'Exported';
            DataClassification = CustomerContent;
        }
        field(300; "Exported by User"; Code[40])
        {
            Caption = 'Exported by User';
            DataClassification = CustomerContent;
        }
        field(310; "Exported Time"; DateTime)
        {
            Caption = 'Exported Time';
            DataClassification = CustomerContent;
        }
        field(320; "Job Accounting Description"; Text[80])
        {
            Caption = 'Job Accounting Description';
            DataClassification = CustomerContent;
        }
        field(330; "Accounting Description"; Text[80])
        {
            Caption = 'Accounting Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job No.", Year, Month)
        {
        }
    }

    #region Triggers

    trigger OnDelete()
    var
        lc_JobInvLine: Record "IMP Job Consulting Inv. Line";
    begin
        lc_JobInvLine.SetRange("Job No.", Rec."Job No.");
        lc_JobInvLine.SetRange(Month, Rec.Month);
        lc_JobInvLine.SetRange(Year, Rec.Year);
        lc_JobInvLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        Rec."Creation Date" := WorkDate();
        Rec."Document Date" := WorkDate();
        Rec."Created by User" := CopyStr(UserId(), 1, MaxStrLen(Rec."Created by User"));
    end;

    #endregion Triggers

    #region Methodes

    procedure SetPeriods(_Month: Option January,February,March,April,May,June,July,August,September,October,November,December; _Year: Integer; var _ValidFrom: Date; var _ValidTo: Date)
    begin

        if _Month = _Month::January then begin
            _ValidFrom := DMY2Date(1, 1, _Year);
            _ValidTo := DMY2Date(31, 1, _Year);
        end;

        if _Month = _Month::February then begin
            _ValidFrom := DMY2Date(1, 2, _Year);
            if _Year in [2020, 2024, 2028, 2032] then
                _ValidTo := DMY2Date(29, 2, _Year)
            else
                _ValidTo := DMY2Date(28, 2, _Year)
        end;

        if _Month = _Month::March then begin
            _ValidFrom := DMY2Date(1, 3, _Year);
            _ValidTo := DMY2Date(31, 3, _Year);
        end;

        if _Month = _Month::April then begin
            _ValidFrom := DMY2Date(1, 4, _Year);
            _ValidTo := DMY2Date(30, 4, _Year);
        end;

        if _Month = _Month::May then begin
            _ValidFrom := DMY2Date(1, 5, _Year);
            _ValidTo := DMY2Date(31, 5, _Year);
        end;

        if _Month = _Month::June then begin
            _ValidFrom := DMY2Date(1, 6, _Year);
            _ValidTo := DMY2Date(30, 6, _Year);
        end;

        if _Month = _Month::July then begin
            _ValidFrom := DMY2Date(1, 7, _Year);
            _ValidTo := DMY2Date(31, 7, _Year);
        end;

        if _Month = _Month::August then begin
            _ValidFrom := DMY2Date(1, 8, _Year);
            _ValidTo := DMY2Date(31, 8, _Year);
        end;

        if _Month = _Month::September then begin
            _ValidFrom := DMY2Date(1, 9, _Year);
            _ValidTo := DMY2Date(30, 9, _Year);
        end;

        if _Month = _Month::October then begin
            _ValidFrom := DMY2Date(1, 10, _Year);
            _ValidTo := DMY2Date(31, 10, _Year);
        end;

        if _Month = _Month::November then begin
            _ValidFrom := DMY2Date(1, 11, _Year);
            _ValidTo := DMY2Date(30, 11, _Year);
        end;

        if _Month = _Month::December then begin
            _ValidFrom := DMY2Date(1, 12, _Year);
            _ValidTo := DMY2Date(31, 12, _Year);
        end;
    end;

    procedure GetRes() "code": Code[20]
    var
        lc_UserSetup: Record "User Setup";
    begin
        lc_UserSetup.SetRange(lc_UserSetup."User ID", UserId());
        if lc_UserSetup.FindFirst() then
            exit(lc_UserSetup."IMP Job Resource No.");
    end;

    #endregion Methodes
}