
table 50013 "IMP Job Res. Working Hours"
{
    Caption = 'Job Res. Working Hours';
    //TODO Evaluation Pages
    //DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
    //LookupPageID = "IMP Job Consulting Inv. Hdrs";


    fields
    {
       
        field(1; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
        field(2; "Week Start"; Date)
        {
            Caption = 'Week Start';
            DataClassification = CustomerContent;
        }
        field(3; "Week End"; Date)
        {
            Caption = 'Week End';
            DataClassification = CustomerContent;
        }

        Field(4; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = Resource;
        }
        Field(5; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            DataClassification = CustomerContent;
            //TableRelation = Resource;
        }
        Field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        Field(7; "Quantity to Invoice"; Decimal)
        {
            Caption = 'Quantity to Invoice';
            DataClassification = CustomerContent;
        }
        Field(8; "Quantity not to Invoice"; Decimal)
        {
            Caption = 'Quantity not to Invoice';
            DataClassification = CustomerContent;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            
             DataClassification = CustomerContent;
            OptionCaption = 'Open,Fixed';
            OptionMembers = Open,Fixed;
        }
        
        



    }
    
    keys
    {
        key(Key1; Year,"Week Start","No.","Job Type Code")
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