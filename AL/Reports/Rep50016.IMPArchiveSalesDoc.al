report 50016 "IMP Archive Sales Document"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Archive Sales Document';
    ProcessingOnly = True;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")

        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                
                SetFilter("no.",'*NAVI*');
                SetRange("Document Type","Document Type"::Quote);
            end;

            trigger OnAfterGetRecord()
            begin
                ArchiveManagement.ArchiveSalesDocument("Sales Header");
                Delete(true);                
            end;
        }
    }

    requestpage
    {


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        Text50000: Label 'Filter needed!';
        ArchiveManagement: Codeunit ArchiveManagement;
}