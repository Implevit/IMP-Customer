table 50007 "IMP Job Res. Work. Hrs. Month"
{
    Caption = 'Job Res. Work. Hrs. Month"';
    //DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
    //LookupPageID = "IMP Job Consulting Inv. Hdrs";

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
            TableRelation = Resource;
        }

        field(5; "Job Type Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Type Code';
            TableRelation = "IMP Job Types";
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';
            //TODO TableRelation = Resource;
        }
        field(7; "Quantity to Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity to Invoice';
            //TODO TableRelation = Resource;
        }
        field(8; "Quantity not to Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity to Invoice';
            //TODO TableRelation = Resource;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity to Invoice';
            OptionMembers = Open,Fixed;
            OptionCaption = 'Open,Fixed';
        }
	


	


    }
    
    keys
    {
        key(Key1; Year,"Month Start","No.","Job Type Code")
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