table 50003 "IMP Job Consulting Inv. Line"
{
    Caption = 'Job Accounting Line';
    DrillDownPageID = "IMP Job Consulting Inv. Lines";
    LookupPageID = "IMP Job Consulting Inv. Lines";

    Fields
    {
        Field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Job;
        }
        Field(2; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(3; Month; Option)
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        Field(4; "Job Journal Template"; Code[10])
        {
            Caption = 'Job Journal Template';
            DataClassification = CustomerContent;
            TableRelation = "Job Journal Template";
        }
        Field(5; "Job Journal Batch"; Code[10])
        {
            Caption = 'Job Journal Batch';
            DataClassification = CustomerContent;
            TableRelation = "Job Journal Batch".Name;
        }
        Field(6; "Job Journal Line No."; Integer)
        {
            Caption = 'Job Journal Line No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Journal Line" Where("Journal Template Name" = Field("Job Journal Template"),
                                                      "Journal Batch Name" = Field("Job Journal Batch"),
                                                      "Job No." = Field("Job No."));
        }
        Field(10; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." Where("Job No." = Field("Job No."));
        }
        Field(20; "Source Quantity"; Decimal)
        {
            Caption = 'Source Quantity';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(30; "Source Quantity to Invoice"; Decimal)
        {
            Caption = 'Source Quantity to Invoice';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(40; "Source Quantity not to Invoice"; Decimal)
        {
            Caption = 'Source Quantity not to Invoice';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(50; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Validate("Quantity to Invoice", Quantity);
                Validate("Quantity not to Invoice", 0);
            end;
        }
        Field(60; "Quantity to Invoice"; Decimal)
        {
            Caption = 'Quantity to Invoice';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Quantity not to Invoice" := Quantity - "Quantity to Invoice";
            end;
        }
        Field(70; "Quantity not to Invoice"; Decimal)
        {
            Caption = 'Quantity not to Invoice';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Quantity to Invoice" := Quantity - "Quantity not to Invoice";
            end;
        }
        Field(80; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        Field(90; "Resource No."; Code[10])
        {
            Caption = 'Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource;
        }
        Field(100; Check; Boolean)
        {
            Caption = 'Check';
            DataClassification = CustomerContent;
        }
        Field(110; "Job Task Description"; Text[100])
        {
            Caption = 'Job Task Description';
            FieldClass = FlowField;
            CalcFormula = Lookup("Job Task".Description Where("Job No." = Field("Job No."),
                                                               "Job Task No." = Field("Job Task No.")));
        }
        Field(120; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        Field(130; "Source Travel Time Quantity"; Decimal)
        {
            Caption = 'Source Travel Time Quantity';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(140; "Source Distance KM Quantity"; Decimal)
        {
            Caption = 'Source Distance KM Quantity';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(150; "Travel Time Quantity"; Decimal)
        {
            Caption = 'Travel Time Quantity';
            DataClassification = CustomerContent;
        }
        Field(160; "Distance KM Quantity"; Decimal)
        {
            Caption = 'Distance KM Quantity';
            DataClassification = CustomerContent;
        }
        Field(170; "Ticket No."; Text[50])
        {
            Caption = 'Ticket No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Job Journal Line"."IMP Ticket No." Where("Journal Template Name" = Field("Job Journal Template"),
                                                                        "Journal Batch Name" = Field("Job Journal Batch"),
                                                                        "Line No." = Field("Job Journal Line No.")));
        }
        Field(180; "All inclusive"; Boolean)
        {
            Caption = 'All inclusive';
            DataClassification = CustomerContent;
        }
        Field(190; "All inclusive Original"; Boolean)
        {
            Caption = 'All inclusive Original';
            FieldClass = FlowField;
            CalcFormula = Lookup("Job Journal Line"."IMP All inclusive" Where("Journal Template Name" = Field("Job Journal Template"),
                                                                           "Journal Batch Name" = Field("Job Journal Batch"),
                                                                           "Line No." = Field("Job Journal Line No.")));
        }
        Field(200; Mark; Code[10])
        {
            Caption = 'Mark';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job No.", Year, Month, "Job Journal Template", "Job Journal Batch", "Job Journal Line No.")
        {
        }
    }
}

