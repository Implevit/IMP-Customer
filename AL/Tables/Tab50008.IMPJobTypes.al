table 50008 "IMP Job Types"
{
    DataClassification = ToBeClassified;
    Caption = 'Job Type';
    
    fields
    {
        field(1;"Job Type Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Type Code';            
        }
        field(2;"Job Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Type Description';            
        }
        field(3;"Filter Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Type';            
            OptionMembers = "Internal Type","Job No. Filter","Target Time";
            OptionCaption = 'Intern,Projekt Nr. Filter,Sollzeit';
        }
        field(4;"Internal Filter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Filter';            
        }
        field(5;"Job No. Filter"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job No. Filter';            
        }

	


    }
    
    keys
    {
        key(Key1; "Job Type Code")
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