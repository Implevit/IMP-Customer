table 50012 "IMP Job Evaluation Line"
{
    Caption = 'Job Evaluation';
    //TODO Evaluation Pages
    //DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
    //LookupPageID = "IMP Job Consulting Inv. Hdrs";


    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }

        field(2; Month; Option)
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
        Field(4; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." Where("Job No." = Field("Job No."));
        }
        Field(5; "Resource No."; Code[10])
        {
            Caption = 'Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource;
        }
        field(6; "Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Konto,Überschrift,Summe,Von-Summe,Bis-Summe';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }

        field(7; Totaling; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        Field(8; Budget; Decimal)
        {
            Caption = 'Budget';
            DataClassification = CustomerContent;
        }
        Field(9; "Quantity (prev. Periods)"; Decimal)
        {
            Caption = 'Quantity (prev. Periods)';
            DataClassification = CustomerContent;
        }
        Field(10; "Quantity (act. Period)"; Decimal)
        {
            Caption = 'Quantity (act. Period)';
            DataClassification = CustomerContent;
        }
        Field(11; "Job Task Description"; text[100])
        {
            Caption = 'Job Tast Description';            
            FieldClass = FlowField;
            CalcFormula = Lookup("Job Task".Description WHERE ("Job No."=FIELD("Job No."),"Job Task No."=FIELD("Job Task No.")));

        }
        Field(12; "Not Inv. Qty. (prev. Periods)"; Decimal)
        {
            Caption = 'Not Inv. Qty. (prev. Periods)';
            DataClassification = CustomerContent;
        }
        Field(13; "Not Inv. Qty. (act. Period)"; Decimal)
        {
            Caption = 'Not Inv. Qty. (act. Period)';
            DataClassification = CustomerContent;
        }
        Field(14; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }


        



    }
    
    keys
    {
        key(Key1; "Job No.",Month,Year,"Job Task No.","Resource No.")
        {
            Clustered = true;
        }
    }
    
    var
       
    
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}