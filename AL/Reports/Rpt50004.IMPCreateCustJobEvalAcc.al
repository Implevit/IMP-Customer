report 50004 "IMP Create Cust. Job Eval.Acc."
{
    Caption = 'Create Evaluation';
    UsageCategory = History;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JobInvoiceHeader; "IMP Cust. Cons. Inv. Header")
        {
            trigger OnAfterGetRecord()
            var
                l_Customer: Record Customer;
                l_Job: Record Job;
                l_JobTask: Record "Job Task";
                l_JobJnlLine: Record "Job Journal Line";
                l_tmp_JobEvalLine: Record "IMP Job Evaluation Line" temporary;
                l_JobLine: Record "IMP Cust. Job Cons. Inv. Line";
                l_JobPlanning: Record "Job Planning Line";
                l_tmp_JobEvalLine3: Record "IMP Job Evaluation Line" temporary;
            begin
                
                l_Customer.get("Customer No.");
                SetPeriod(Month, Year);
                l_Job.SetRange("Bill-to Customer No.","Customer No.");
                if l_Job.FindSet() then
                repeat

                l_JobTask.SETRANGE("Job No.", l_Job."No.");
                //l_JobTask.SETRANGE(l_JobTask."Job Task No.",'80180');
                //l_JobTask.SETRANGE(l_JobTask.Closed,FALSE);
                IF l_JobTask.FINDSET THEN
                    REPEAT
                        IF NOT l_tmp_JobEvalLine.GET(l_JobTask."Job No.", Month, Year, l_JobTask."Job Task No.", '') THEN BEGIN
                            l_tmp_JobEvalLine.INIT;
                            l_tmp_JobEvalLine."Customer No." := "Customer No.";
                            l_tmp_JobEvalLine."Job No." := l_Job."No.";
                            l_tmp_JobEvalLine.Month := Month;
                            l_tmp_JobEvalLine.Year := Year;
                            l_tmp_JobEvalLine."Job Task No." := l_JobTask."Job Task No.";
                            l_tmp_JobEvalLine."Resource No." := '';
                            l_tmp_JobEvalLine."Job Task Type" := l_JobTask."Job Task Type";
                            l_tmp_JobEvalLine.Totaling := l_JobTask.Totaling;
                            l_tmp_JobEvalLine.INSERT;


                            l_JobPlanning.SETRANGE("Job No.", l_JobTask."Job No.");
                            l_JobPlanning.SETRANGE("Job Task No.", l_JobTask."Job Task No.");
                            IF l_JobPlanning.FINDSET THEN
                                REPEAT
                                    l_tmp_JobEvalLine.Budget := l_tmp_JobEvalLine.Budget + l_JobPlanning.Quantity;
                                    l_tmp_JobEvalLine.MODIFY;
                                UNTIL l_JobPlanning.NEXT = 0;
                        END;

                    UNTIL l_JobTask.NEXT = 0;


                l_JobTask.RESET;
                //l_JobJnlLine.SETRANGE("Job Task No.",'80180');
                l_JobJnlLine.SETRANGE("Job No.", l_Job."No.");
                IF l_JobJnlLine.FINDSET THEN
                    REPEAT
                        IF l_JobTask.GET(l_Job."No.", l_JobJnlLine."Job Task No.") THEN BEGIN
                            IF NOT l_tmp_JobEvalLine.GET(l_Job."No.", Month, Year, l_JobJnlLine."Job Task No.", '') THEN BEGIN
                                l_tmp_JobEvalLine.INIT;
                                l_tmp_JobEvalLine."Job No." := l_Job."No.";
                                l_tmp_JobEvalLine.Month := Month;
                                l_tmp_JobEvalLine.Year := Year;
                                l_tmp_JobEvalLine."Job Task No." := l_JobJnlLine."Job Task No.";
                                l_tmp_JobEvalLine."Resource No." := '';
                                l_tmp_JobEvalLine."Job Task Type" := l_JobTask."Job Task Type";
                                l_tmp_JobEvalLine.Totaling := l_JobTask.Totaling;
                                l_tmp_JobEvalLine.INSERT;


                                l_JobPlanning.SETRANGE("Job No.", l_Job."No.");
                                l_JobPlanning.SETRANGE("Job Task No.", l_JobTask."Job Task No.");
                                IF l_JobPlanning.FINDSET THEN
                                    REPEAT
                                        l_tmp_JobEvalLine.Budget := l_tmp_JobEvalLine.Budget + l_JobPlanning.Quantity;
                                        l_tmp_JobEvalLine.MODIFY;
                                    UNTIL l_JobPlanning.NEXT = 0;
                            END;
                            IF l_JobLine.GET(l_Job."No.", Year, Month, l_JobJnlLine."Journal Template Name", l_JobJnlLine."Journal Batch Name", l_JobJnlLine."Line No.")
                            THEN BEGIN
                                IF (l_JobLine.Year <> Year) OR (l_JobLine.Month <> Month) THEN BEGIN
                                    l_tmp_JobEvalLine."Quantity (prev. Periods)" := l_tmp_JobEvalLine."Quantity (prev. Periods)" + l_JobLine."Quantity to Invoice";
                                    l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" := l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" + l_JobLine."Quantity not to Invoice";
                                    l_tmp_JobEvalLine.MODIFY;
                                END ELSE BEGIN
                                    l_tmp_JobEvalLine."Quantity (act. Period)" := l_tmp_JobEvalLine."Quantity (act. Period)" + l_JobLine."Quantity to Invoice";
                                    l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" := l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" + l_JobLine."Quantity not to Invoice";
                                    l_tmp_JobEvalLine.MODIFY;
                                END;
                            END ELSE BEGIN
                                IF l_JobJnlLine."Posting Date" < g_ValidFrom THEN BEGIN
                                    l_tmp_JobEvalLine."Quantity (prev. Periods)" := l_tmp_JobEvalLine."Quantity (prev. Periods)" + l_JobJnlLine."IMP Hours to invoice";
                                    l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" := l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" + l_JobJnlLine."IMP Hours not to invoice";
                                    l_tmp_JobEvalLine.MODIFY;
                                END;
                                IF (l_JobJnlLine."Posting Date" >= g_ValidFrom) AND (l_JobJnlLine."Posting Date" <= g_ValidTo) THEN BEGIN
                                    l_tmp_JobEvalLine."Quantity (act. Period)" := l_tmp_JobEvalLine."Quantity (act. Period)" + l_JobJnlLine."IMP Hours to invoice";
                                    l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" := l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" + l_JobJnlLine."IMP Hours not to invoice";
                                    l_tmp_JobEvalLine.MODIFY;
                                END;
                            END;
                        END;
                    UNTIL l_JobJnlLine.NEXT = 0;

                l_tmp_JobEvalLine.FINDSET;
                REPEAT
                    l_tmp_JobEvalLine3.INIT;
                    l_tmp_JobEvalLine3.TRANSFERFIELDS(l_tmp_JobEvalLine);
                    l_tmp_JobEvalLine3.INSERT;
                UNTIL l_tmp_JobEvalLine.NEXT = 0;


                l_tmp_JobEvalLine.SETFILTER(Totaling, '<>%1', '');
                IF l_tmp_JobEvalLine.FINDSET THEN
                    REPEAT
                        l_tmp_JobEvalLine3.SETFILTER("Job Task No.", l_tmp_JobEvalLine.Totaling);
                        IF l_tmp_JobEvalLine3.FINDSET THEN
                            REPEAT
                                l_tmp_JobEvalLine.Budget := l_tmp_JobEvalLine.Budget + l_tmp_JobEvalLine3.Budget;
                                l_tmp_JobEvalLine."Quantity (act. Period)" := l_tmp_JobEvalLine."Quantity (act. Period)" + l_tmp_JobEvalLine3."Quantity (act. Period)";
                                l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" := l_tmp_JobEvalLine."Not Inv. Qty. (act. Period)" + l_tmp_JobEvalLine3."Not Inv. Qty. (act. Period)";
                                l_tmp_JobEvalLine."Quantity (prev. Periods)" := l_tmp_JobEvalLine."Quantity (prev. Periods)" + l_tmp_JobEvalLine3."Quantity (prev. Periods)";
                                l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" := l_tmp_JobEvalLine."Not Inv. Qty. (prev. Periods)" + l_tmp_JobEvalLine3."Not Inv. Qty. (prev. Periods)";
                                l_tmp_JobEvalLine.MODIFY;
                            UNTIL l_tmp_JobEvalLine3.NEXT = 0;
                    UNTIL l_tmp_JobEvalLine.NEXT = 0;

                l_tmp_JobEvalLine.RESET;
                PAGE.RUNMODAL(PAGE::"IMP Job Cons. Inv. Ev. List", l_tmp_JobEvalLine);


            until l_Job.Next = 0;
            end;

        }
    }
    procedure SetPeriod(p_Month: Option January,February,March,April,May,June,July,August,September,October,November,December; p_Year: integer);
    begin
        g_Month := p_Month;
        g_Year := p_Year;

        IF g_Month = g_Month::January THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 1, g_Year);
            g_ValidTo := DMY2DATE(31, 1, g_Year);
        END;

        IF g_Month = g_Month::February THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 2, g_Year);
            IF g_Year IN [2020, 2024, 2028, 2032] THEN
                g_ValidTo := DMY2DATE(29, 2, g_Year)
            ELSE
                g_ValidTo := DMY2DATE(28, 2, g_Year)

        END;

        IF g_Month = g_Month::March THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 3, g_Year);
            g_ValidTo := DMY2DATE(31, 3, g_Year);
        END;

        IF g_Month = g_Month::April THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 4, g_Year);
            g_ValidTo := DMY2DATE(30, 4, g_Year);
        END;

        IF g_Month = g_Month::May THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 5, g_Year);
            g_ValidTo := DMY2DATE(31, 5, g_Year);
        END;

        IF g_Month = g_Month::June THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 6, g_Year);
            g_ValidTo := DMY2DATE(30, 6, g_Year);
        END;

        IF g_Month = g_Month::July THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 7, g_Year);
            g_ValidTo := DMY2DATE(31, 7, g_Year);
        END;

        IF g_Month = g_Month::August THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 8, g_Year);
            g_ValidTo := DMY2DATE(31, 8, g_Year);
        END;

        IF g_Month = g_Month::September THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 9, g_Year);
            g_ValidTo := DMY2DATE(30, 9, g_Year);
        END;

        IF g_Month = g_Month::October THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 10, g_Year);
            g_ValidTo := DMY2DATE(31, 10, g_Year);
        END;

        IF g_Month = g_Month::November THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 11, g_Year);
            g_ValidTo := DMY2DATE(30, 11, g_Year);
        END;

        IF g_Month = g_Month::December THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 12, g_Year);
            g_ValidTo := DMY2DATE(31, 12, g_Year);
        END;

    end;

    var

        g_ValidFrom: Date;
        g_ValidTo: Date;
        g_Month: Option January,February,March,April,May,June,July,August,September,October,November,December;
        g_Year: Integer;



}