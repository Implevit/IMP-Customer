pageextension 50000 "IMP Pag1-Ext50000" extends "Company Information"
{
    actions
    {
        addafter(ActImplBasic)
        {
            group(ActImplCustomer)
            {
                Caption = 'Customer';

                action(DoImplCustomerDeeplUsageShow)
                {
                    Caption = 'DeepL show usage';
                    ApplicationArea = All;
                    Image = Action;

                    trigger OnAction()
                    begin
                        BscMgmt.DeeplUsageShow();
                    end;
                }
                action(DoImplCustomerDeeplTranslate)
                {
                    Caption = 'DeepL translate xlf-file';
                    ApplicationArea = All;
                    Image = Action;

                    trigger OnAction()
                    begin
                        ImpMgmt.TranslateXlfFile(true, true);
                    end;
                }

            }
        }
    }

    var
        BscMgmt: Codeunit "IMP Basic Management";
        ImpMgmt: Codeunit "IMP Management";
}
