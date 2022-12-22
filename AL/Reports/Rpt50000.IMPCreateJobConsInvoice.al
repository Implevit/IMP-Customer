report 50000 "IMP Create Job Cons. Invoice"
{
    Caption = 'Create Job Cons. Invoice';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "Status", "IMP Project Manager IMPL";

            dataitem(JobJnlLine; "Job Journal Line")
            {
                DataItemLinkReference = Job;
                DataItemLink = "Job No." = FIELD("No.");
                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", DMY2Date(1, 1, 2022), g_ValidTo);
                end;

                trigger OnAfterGetRecord()
                var
                    l_JobInvLine: Record "IMP Job Consulting Inv. Line";
                    l_JobInvHeader: Record "IMP Job Consulting Inv. Header";

                begin
                    IF NOT l_JobInvHeader.GET(Job."No.", g_Year, g_Month) THEN BEGIN
                        l_JobInvHeader.INIT;
                        l_JobInvHeader.VALIDATE("Job No.", "Job No.");
                        l_JobInvHeader.VALIDATE(Year, g_Year);
                        l_JobInvHeader.VALIDATE(Month, g_Month);
                        l_JobInvHeader.Description := STRSUBSTNO('Abrechnung %1/%2', g_Month, g_Year);
                        l_JobInvHeader."Job Accounting Description" := Job."imp Accounting Description";
                        l_JobInvHeader."Created by User" := USERID;
                        l_JobInvHeader."Creation Date" := WORKDATE;
                        l_JobInvHeader.INSERT(TRUE);
                    END;



                    l_JobInvLine.SETRANGE("Job No.", "Job No.");
                    l_JobInvLine.SETRANGE("Job Journal Template", "Journal Template Name");
                    l_JobInvLine.SETRANGE("Job Journal Batch", "Journal Batch Name");
                    l_JobInvLine.SETRANGE("Job Journal Line No.", "Line No.");
                    IF l_JobInvLine.FINDSET THEN
                        CurrReport.SKIP;

                    l_JobInvHeader.GET(Job."No.", g_Year, g_Month);

                    l_JobInvLine.RESET;

                    l_JobInvLine.INIT;
                    l_JobInvLine."Job No." := "Job No.";
                    l_JobInvLine."Job Journal Template" := "Journal Template Name";
                    l_JobInvLine."Job Journal Batch" := "Journal Batch Name";
                    l_JobInvLine."Job Journal Line No." := "Line No.";
                    l_JobInvLine."Job Task No." := "Job Task No.";
                    l_JobInvLine.Year := g_Year;
                    l_JobInvLine.Month := g_Month;
                    l_JobInvLine."Source Quantity" := Quantity;
                    l_JobInvLine."Source Quantity to Invoice" := "Imp Hours to invoice";
                    l_JobInvLine."Source Quantity not to Invoice" := "Imp Hours not to invoice";
                    IF Quantity <> ("Imp Hours to invoice" + "Imp Hours not to invoice") THEN
                        l_JobInvLine.Check := TRUE;
                    l_JobInvLine.Quantity := Quantity;
                    l_JobInvLine."Quantity to Invoice" := "Imp Hours to invoice";
                    l_JobInvLine."Quantity not to Invoice" := "Imp Hours not to invoice";
                    l_JobInvLine."Source Travel Time Quantity" := "JobJnlLine"."imp Travel Time";
                    l_JobInvLine."Source Distance KM Quantity" := "JobJnlLine"."imp km";
                    l_JobInvLine."Travel Time Quantity" := "JobJnlLine"."Imp Travel Time";
                    l_JobInvLine."Distance KM Quantity" := "JobJnlLine"."Imp km";
                    l_JobInvLine.Description := "JobJnlLine".Description;
                    l_JobInvLine."Resource No." := "No.";
                    l_JobInvLine."Posting Date" := "Posting Date";
                    l_JobInvLine."all inclusive" := "JobJnlLine"."Imp all inclusive";
                    l_JobInvLine.INSERT;
                    g_i := g_i + 1;
                end;

                trigger OnPostDataItem()
                begin

                end;

            }
            trigger OnPreDataItem()
            var
                l_Job: Record job;

            begin
                l_Job.SETRANGE("imp Internal Job", l_Job."imp Internal Job"::" ");
                l_Job.SETFILTER(Status, '%1|%2|%3', l_Job.Status::Open, l_Job.Status::Planning, l_Job.Status::Quote);
                l_Job.SETFILTER("Bill-to Customer No.", '<>%1', '');
                l_Job.FINDSET;
                REPEAT
                    IF NOT (l_Job."IMP Project Manager IMPL" IN ['JHE', 'YMA', 'DED', 'FST', 'RWI']) THEN
                        ERROR(STRSUBSTNO(Text50002, l_Job."No.", l_Job."Bill-to Name"));
                UNTIL l_Job.NEXT = 0;

                SETRANGE("imp Internal Job", "Imp Internal Job"::" ");

            end;

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPostDataItem()
            begin
                IF NOT CONFIRM(STRSUBSTNO(Text50000, g_i)) THEN
                    ERROR(Text50001)

            end;


        }



    }



    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(Year; g_Year)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Year';
                        trigger OnValidate()
                        begin
                            ValidateReqPageInsert();
                        end;
                    }
                    field(Month; g_Month)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Month';
                        trigger OnValidate()
                        begin
                            ValidateReqPageInsert();
                        end;
                    }
                }

            }
        }
        trigger OnOpenPage()
        var
            l_Date: Date;
        begin
            IF g_Year = 0 THEN BEGIN
                l_Date := CALCDATE('<-1M>', WORKDATE);
                SetPeriod(DATE2DMY(l_Date, 2) - 1, DATE2DMY(l_Date, 3));
            end;
        end;
    }
    procedure SetPeriod(p_Month: Option Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember; p_Year: Integer);
    begin
        IF p_Year = 0 THEN BEGIN
            g_Year := DATE2DMY(WORKDATE, 3);
            g_Month := DATE2DMY(WORKDATE, 2) - 1;
        END ELSE BEGIN
            g_Month := p_Month;
            g_Year := p_Year;
        END;

        IF g_Month = g_Month::Januar THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 1, g_Year);
            g_ValidTo := DMY2DATE(31, 1, g_Year);
        END;

        IF g_Month = g_Month::Februar THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 2, g_Year);
            IF g_Year IN [2020, 2024, 2028, 2032, 2036] THEN
                g_ValidTo := DMY2DATE(29, 2, g_Year)
            ELSE
                g_ValidTo := DMY2DATE(28, 2, g_Year)

        END;

        IF g_Month = g_Month::März THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 3, g_Year);
            g_ValidTo := DMY2DATE(31, 3, g_Year);
        END;

        IF g_Month = g_Month::April THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 4, g_Year);
            g_ValidTo := DMY2DATE(30, 4, g_Year);
        END;

        IF g_Month = g_Month::Mai THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 5, g_Year);
            g_ValidTo := DMY2DATE(31, 5, g_Year);
        END;

        IF g_Month = g_Month::Juni THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 6, g_Year);
            g_ValidTo := DMY2DATE(30, 6, g_Year);
        END;

        IF g_Month = g_Month::Juli THEN BEGIN
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

        IF g_Month = g_Month::Oktober THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 10, g_Year);
            g_ValidTo := DMY2DATE(31, 10, g_Year);
        END;

        IF g_Month = g_Month::November THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 11, g_Year);
            g_ValidTo := DMY2DATE(30, 11, g_Year);
        END;

        IF g_Month = g_Month::Dezember THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 12, g_Year);
            g_ValidTo := DMY2DATE(31, 12, g_Year);
        END;


    end;

    procedure ValidateReqPageInsert();
    begin
        IF g_Month = g_Month::Januar THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 1, g_Year);
            g_ValidTo := DMY2DATE(31, 1, g_Year);
        END;

        IF g_Month = g_Month::Februar THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 2, g_Year);
            IF g_Year IN [2020, 2024, 2028, 2032, 2036] THEN
                g_ValidTo := DMY2DATE(29, 2, g_Year)
            ELSE
                g_ValidTo := DMY2DATE(28, 2, g_Year)

        END;

        IF g_Month = g_Month::"März" THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 3, g_Year);
            g_ValidTo := DMY2DATE(31, 3, g_Year);
        END;

        IF g_Month = g_Month::April THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 4, g_Year);
            g_ValidTo := DMY2DATE(30, 4, g_Year);
        END;

        IF g_Month = g_Month::Mai THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 5, g_Year);
            g_ValidTo := DMY2DATE(31, 5, g_Year);
        END;

        IF g_Month = g_Month::Juni THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 6, g_Year);
            g_ValidTo := DMY2DATE(30, 6, g_Year);
        END;

        IF g_Month = g_Month::Juli THEN BEGIN
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

        IF g_Month = g_Month::Oktober THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 10, g_Year);
            g_ValidTo := DMY2DATE(31, 10, g_Year);
        END;

        IF g_Month = g_Month::November THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 11, g_Year);
            g_ValidTo := DMY2DATE(30, 11, g_Year);
        END;

        IF g_Month = g_Month::Dezember THEN BEGIN
            g_ValidFrom := DMY2DATE(1, 12, g_Year);
            g_ValidTo := DMY2DATE(31, 12, g_Year);
        END;
    end;

    var
        g_ValidTo: Date;
        g_ValidFrom: date;
        g_i: Integer;
        g_Month: Option Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember;
        g_Year: Integer;
        Text50001: Label 'Abbruch durch den Anwender!';
        Text50000: Label 'Sie haben %1 Projektabrechnungszeilen angelegt. Möchten Sie die Änderungen anwenden?';
        Text50002: Label 'Projektnr. %1 für %2 hat keinen gültigen Projektleiter. Bitte erfassen Sie einen gültigen Projektleiter.';

}