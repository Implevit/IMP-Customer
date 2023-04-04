pageextension 50010 "IMP Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Disable Search by Name")
        {
            field("Our Account No.";"Our Account No.")
            {
                ApplicationArea = all;
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        
}