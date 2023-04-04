table 50009 "IMP Job Working Hours Month"
{
    Caption = 'IMP Job Working Hours Month';



    fields
    {
        field(1; Year; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';

        }
        field(2; "Month Start"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month Start';

        }
        field(3; "Month End"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month End';

        }
        field(4; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';

        }
        field(5; "External Job Total"; Decimal)
        {
            Caption = 'External Job Total';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('JOB-EXT'), "No." = FIELD("No.")));

        }
        field(6; "External Job to Invoice"; Decimal)
        {
            Caption = 'External Job to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month"."Quantity to Invoice" WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('JOB-EXT'), "No." = FIELD("No.")));

        }
        field(7; "External Job not to Invoice"; Decimal)
        {
            Caption = 'External Job to Invoice';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month"."Quantity not to Invoice" WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('JOB-EXT'), "No." = FIELD("No.")));

        }
        field(8; "Admin"; Decimal)
        {
            Caption = 'Admin';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('ADMIN'), "No." = FIELD("No.")));

        }
        field(9; "Education"; Decimal)
        {
            Caption = 'Education';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('AUSBILDUNG'), "No." = FIELD("No.")));

        }
        field(10; "Vacation"; Decimal)
        {
            Caption = 'Vacation';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('FERIEN'), "No." = FIELD("No.")));

        }
        field(11; "Illness"; Decimal)
        {
            Caption = 'Illness';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('MILITÄR'), "No." = FIELD("No.")));

        }
        field(12; "Acquisition"; Decimal)
        {
            Caption = 'Acquisition';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('AKQUISE'), "No." = FIELD("No.")));

        }
        field(13; "Internal Job"; Decimal)
        {
            Caption = 'Internal Job';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "Job Type Code" = CONST('JOB-INT'), "No." = FIELD("No.")));
        }
        field(14; Total; Decimal)
        {
            Caption = 'Total';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "No." = FIELD("No."), "Job Type Code" = FILTER(<> 'SOLL')));
        }
        field(15; Assignment; Decimal)
        {
            Caption = 'Assignment';
            FieldClass = Normal;

        }
        field(16; "Target Time"; Decimal)
        {
            Caption = 'Target Time';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE(Year = FIELD(Year), "Month Start" = FIELD("Month Start"), "No." = FIELD("No."), "Job Type Code" = CONST('SOLL')));
        }
        field(17; "Assignment Hours"; Decimal)
        {
            Caption = 'Assignment Hours';
            FieldClass = Normal;

        }
        field(18; "Assignment Vacation"; Decimal)
        {
            Caption = 'Assignment Vacation';
            FieldClass = Normal;

        }
        field(19; "Vacation YTD"; Decimal)
        {
            Caption = 'Vacation YTD';
            FieldClass = FlowField;
            CalcFormula = Sum("IMP Job Working Hours Month".Vacation WHERE(Year = FIELD(Year), "No." = FIELD("No.")));

        }
        field(20; "Closed"; Boolean)
        {
            Caption = 'Closed';
            FieldClass = Normal;
            


        }
        field(21; "Period Closed"; Boolean)
        {
            Caption = 'Closed';
            FieldClass = FlowField;
            CalcFormula = -Exist("IMP Job Res. Work. Hrs. Month" WHERE (Year=FIELD(Year),"Month Start"=FIELD("Month Start"),"No."=FIELD("No."),Status=FILTER(Open)));


        }
    }
    
    keys
    {
        key(Key1; Year,"Month Start","No.")
        {
            Clustered = true;
        }
    }
    
    var
        myInt: Integer;
    
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