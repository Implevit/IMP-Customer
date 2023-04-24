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
                if "Sales Header".GetFilters = '' then
                    Error(Text50000);
            end;

            trigger OnAfterGetRecord()
            begin
                ArchiveManagement.ArchiveSalesDocument("Sales Header");
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