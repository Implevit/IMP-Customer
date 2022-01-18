pageextension 50002 "IMP Pag21-Ext50002" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(GrpIMPGeneral)
            {
                Caption = 'Implevit';

                field("IMP Abbreviation"; Rec."IMP Abbreviation")
                {
                    ApplicationArea = All;
                }
                field("IMP Tenant Id"; Rec."IMP Tenant Id")
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
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action(ActFunctionGetLicensePersmissions)
            {
                Caption = 'Get License Permission';
                ApplicationArea = All;
                Image = Permission;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lc_IAOA: Record "IMP AL Object App";
                begin
                    lc_IAOA.CreateLicensePermissionCsv(Rec."No.", 0, ',');
                end;
            }
        }
    }

    #region Triggers

    trigger OnOpenPage()
    begin
        ShowConnections := ((UserId.ToLower() = 'impl')); // or (UserId.ToLower() = 'imp\r.meurer'));
    end;

    #endregion Triggers

    var
        ShowConnections: Boolean;
}