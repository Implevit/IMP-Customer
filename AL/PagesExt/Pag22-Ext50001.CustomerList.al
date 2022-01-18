pageextension 50001 "IMP Pag22-Ext50001" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("IMP Abbreviation"; Rec."IMP Abbreviation")
            {
                ApplicationArea = All;
            }
            field("IMP Apps"; Rec."IMP Apps")
            {
                ApplicationArea = All;
            }
            field("IMP Connections"; Rec."IMP Connections")
            {
                ApplicationArea = All;
                Visible = ShowConnections;
            }
            field("IMP Authorisations"; Rec."IMP Authorisations")
            {
                ApplicationArea = All;
                Visible = ShowConnections;
            }
        }
        addafter(City)
        {
            field("IMP Tenant Id"; Rec."IMP Tenant Id")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowConnections := ((UserId.ToLower() = 'impl')); // or (UserId.ToLower() = 'imp\r.meurer'));
    end;

    var
        ShowConnections: Boolean;
}