report 50005 "IMP Export Consulting Invoices"
{
    Caption = 'Export Consulting Invoices';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JobConsultingInvoiceHeader; "IMP Job Consulting Inv. Header")
        {
            trigger OnPreDataItem()
            begin
                g_ConsExpInvHeader.DELETEALL;
                g_ConsExpInvLine.DELETEALL;

                SETRANGE(Year, g_Year);
                SETRANGE(Month, g_Month);
                SetPeriod(g_Month, g_Year);
                SETFILTER(Status, '%1', Status::created);
                IF COUNT() > 0 THEN
                    ERROR(STRSUBSTNO(Text50002, g_Year, g_Month, COUNT));
                SETFILTER(Status, '%1|%2', Status::checked, Status::signed);
            end;
            trigger OnAfterGetRecord()
        var
            l_Customer: Record Customer;
            l_Job: Record Job;
            l_JobConsInvLine: Record "IMP Job Consulting Inv. Line";
            l_Ressource: Record Resource;
            l_JobTask: Record "Job Task";
            l_JobTaskResQty: Decimal;
            l_ExpInvLine: Record "Sales Line";
            l_JobTaskResTravelQty: Decimal;
            l_JobTaskResTravelKM: Decimal;
            l_RessourceName: Text[50];
        begin
            IF l_Job.GET("Job No.") THEN BEGIN

                IF l_Job."IMP Internal Job" = l_Job."IMP Internal Job"::" " THEN BEGIN

                    IF NOT l_Customer.GET("Bill-to Customer No.") THEN BEGIN
                        IF l_Customer."Our Account No." = '' THEN BEGIN
                            ERROR(STRSUBSTNO(Text50000, l_Customer."No.", l_Customer.Name, l_Job."No."));
                        END;
                    END;

                    l_Job.GET("Job No.");

                    //g_ConsExpInvHeader."No." := "Job Consulting Invoice Header"."Job No.";
                    g_ConsExpInvHeader."No." := COPYSTR(FORMAT(g_Year), 3, 2) + '-' + FORMAT(DATE2DMY(g_ValidFrom, 2)) + '-' + "Job No.";
                    g_ConsExpInvHeader."Document Type" := g_ConsExpInvHeader."Document Type"::Quote;
                    g_ConsExpInvHeader.INSERT;
                    g_ConsExpInvHeader."External Document No." := FORMAT(g_Year) + '/' + FORMAT(g_Month);
                    g_ConsExpInvHeader."Sell-to Customer Templ. Code" := 'CH';
                    g_ConsExpInvHeader."Bill-to Customer Templ. Code" := 'CH';
                    g_ConsExpInvHeader."Sell-to Customer No." := l_Customer."Our Account No.";
                    g_ConsExpInvHeader."Bill-to Customer No." := l_Customer."Our Account No.";
                    g_ConsExpInvHeader."Bill-to Name" := l_Customer.Name;
                    g_ConsExpInvHeader."Bill-to Name 2" := l_Customer."Name 2";
                    g_ConsExpInvHeader."Bill-to Address" := l_Customer.Address;
                    g_ConsExpInvHeader."Bill-to Address 2" := l_Customer."Address 2";
                    g_ConsExpInvHeader."Bill-to City" := l_Customer.City;
                    g_ConsExpInvHeader."Bill-to Contact" := l_Customer.Contact;
                    g_ConsExpInvHeader."Your Reference" := '';
                    g_ConsExpInvHeader."Ship-to Code" := '';
                    g_ConsExpInvHeader."Ship-to Name" := '';
                    g_ConsExpInvHeader."Ship-to Name 2" := '';
                    g_ConsExpInvHeader."Ship-to Address" := '';
                    g_ConsExpInvHeader."Ship-to Address 2" := '';
                    g_ConsExpInvHeader."Ship-to City" := '';
                    g_ConsExpInvHeader."Ship-to Contact" := '';
                    g_ConsExpInvHeader."Order Date" := "Document Date";
                    g_ConsExpInvHeader."Posting Date" := "Document Date";
                    g_ConsExpInvHeader."Shipment Date" := "Document Date";
                    g_ConsExpInvHeader."Posting Description" := COPYSTR(STRSUBSTNO(Text50001, Month, Year, l_Customer.Name), 1, 50);
                    g_ConsExpInvHeader."Payment Terms Code" := '30T';
                    g_ConsExpInvHeader."Due Date" := CALCDATE('30T', "Document Date");
                    g_ConsExpInvHeader."Payment Discount %" := 0;
                    g_ConsExpInvHeader."Pmt. Discount Date" := 0D;
                    g_ConsExpInvHeader."Shipment Method Code" := '';
                    g_ConsExpInvHeader."Location Code" := '';
                    g_ConsExpInvHeader."Shortcut Dimension 1 Code" := '';
                    g_ConsExpInvHeader."Shortcut Dimension 2 Code" := '';
                    g_ConsExpInvHeader."Customer Posting Group" := 'DEB';
                    g_ConsExpInvHeader."Currency Code" := '';
                    g_ConsExpInvHeader."Currency Factor" := 0;
                    g_ConsExpInvHeader."Customer Price Group" := '';
                    g_ConsExpInvHeader."Prices Including VAT" := FALSE;
                    g_ConsExpInvHeader."Invoice Disc. Code" := l_Customer."Our Account No.";
                    g_ConsExpInvHeader."Customer Disc. Group" := '';
                    g_ConsExpInvHeader."Language Code" := '';

                    g_ConsExpInvHeader."Salesperson Code" := l_Job."IMP Project Manager IMPL";
                    
                    g_ConsExpInvHeader."No. Printed" := 0;
                    g_ConsExpInvHeader."On Hold" := '';
                    //g_ConsExpInvHeader."Applies-to Doc. Type" :=
                    //g_ConsExpInvHeader."Applies-to Doc. No." :=
                    //g_ConsExpInvHeader."Bal. Account No." :=
                    //g_ConsExpInvHeader."VAT Registration No." :=
                    //g_ConsExpInvHeader."Reason Code" :=
                    g_ConsExpInvHeader."Gen. Bus. Posting Group" := 'CH';
                    //g_ConsExpInvHeader."EU 3-Party Trade" :=
                    //g_ConsExpInvHeader."Transaction Type" :=
                    //g_ConsExpInvHeader."Transport Method" :=
                    //g_ConsExpInvHeader."VAT Country/Region Code" :=
                    g_ConsExpInvHeader."Sell-to Customer Name" := l_Customer.Name;
                    g_ConsExpInvHeader."Sell-to Customer Name 2" := l_Customer."Name 2";
                    g_ConsExpInvHeader."Sell-to Address" := l_Customer.Address;
                    g_ConsExpInvHeader."Sell-to Address 2" := l_Customer."Address 2";
                    g_ConsExpInvHeader."Sell-to City" := l_Customer.City;
                    g_ConsExpInvHeader."Sell-to Contact" := l_Customer.Contact;
                    g_ConsExpInvHeader."Bill-to Post Code" := l_Customer."Post Code";
                    g_ConsExpInvHeader."Bill-to County" := l_Customer.County;
                    g_ConsExpInvHeader."Bill-to Country/Region Code" := l_Customer."Country/Region Code";
                    g_ConsExpInvHeader."Sell-to Post Code" := l_Customer."Post Code";
                    g_ConsExpInvHeader."Sell-to County" := l_Customer.County;
                    g_ConsExpInvHeader."Sell-to Country/Region Code" := l_Customer."Country/Region Code";
                    g_ConsExpInvHeader."Ship-to Post Code" := '';
                    g_ConsExpInvHeader."Ship-to County" := '';
                    g_ConsExpInvHeader."Ship-to Country/Region Code" := '';
                    //g_ConsExpInvHeader."Bal. Account Type" :=
                    //g_ConsExpInvHeader."Exit Point" :=
                    //g_ConsExpInvHeader."Correction" :=
                    g_ConsExpInvHeader."Document Date" := "Document Date";
                    //g_ConsExpInvHeader."External Document No." :=
                    //g_ConsExpInvHeader."Area" :=
                    //g_ConsExpInvHeader."Transaction Specification" :=
                    //g_ConsExpInvHeader."Payment Method Code" :=
                    //g_ConsExpInvHeader."Shipping Agent Code" :=
                    //g_ConsExpInvHeader."Package Tracking No." :=
                    
                    
                    //g_ConsExpInvHeader."Order No. Series" :=
                    
                    g_ConsExpInvHeader."Assigned User ID" := USERID;
                    
                    //g_ConsExpInvHeader."Tax Area Code" := '';
                    //g_ConsExpInvHeader."Tax Liable" := '';
                    g_ConsExpInvHeader."VAT Bus. Posting Group" := 'INLAND';
                    //g_ConsExpInvHeader."VAT Base Discount %" :=
                    //g_ConsExpInvHeader."Prepayment No. Series" :=
                    //g_ConsExpInvHeader."Prepayment" :=
                    //g_ConsExpInvHeader."Prepayment Order No." :=
                    //g_ConsExpInvHeader."Quote No." :=
                    //g_ConsExpInvHeader."Credit Card No." :=
                    //g_ConsExpInvHeader."Campaign No." :=
                    //g_ConsExpInvHeader."Sell-to Contact No." :=
                    //g_ConsExpInvHeader."Bill-to Contact No." :=
                    //g_ConsExpInvHeader."Responsibility Center" :=
                    g_ConsExpInvHeader."IMP Job Accounting Description" := "Job Accounting Description";
                    g_ConsExpInvHeader."IMP Accounting Description" := "Accounting Description";
                    g_ConsExpInvHeader.Modify();

                    Exported := TRUE;
                    "Exported by User" := USERID;
                    "Exported Time" := CREATEDATETIME(TODAY, TIME);
                    MODIFY;

                    g_LineNo := 0;

                    l_JobTask.SETRANGE("Job No.", "Job No.");
                    //l_JobTask.SETRANGE("Job Task No.",'SUPP');
                    l_JobTask.FINDSET;
                    BEGIN
                        REPEAT
                            l_Ressource.FINDSET;
                            BEGIN
                                REPEAT
                                    l_RessourceName := COPYSTR(l_Ressource."No.", 1, 1) + '. ' + COPYSTR(l_Ressource.Name, STRPOS(l_Ressource.Name, ' ') + 1);
                                    l_JobConsInvLine.SETRANGE("Job No.", "Job No.");
                                    l_JobConsInvLine.SETRANGE(Year, Year);
                                    l_JobConsInvLine.SETRANGE(Month, Month);
                                    l_JobConsInvLine.SETRANGE("Resource No.", l_Ressource."No.");
                                    l_JobConsInvLine.SETRANGE("Job Task No.", l_JobTask."Job Task No.");
                                    IF l_JobConsInvLine.FINDSET THEN BEGIN
                                        l_JobTaskResQty := 0;
                                        l_JobTaskResTravelQty := 0;
                                        l_JobTaskResTravelKM := 0;
                                        REPEAT
                                            l_JobTaskResQty := l_JobTaskResQty + l_JobConsInvLine."Quantity to Invoice";
                                            l_JobTaskResTravelQty := l_JobTaskResTravelQty + l_JobConsInvLine."Travel Time Quantity";
                                            l_JobTaskResTravelKM := l_JobTaskResTravelKM + l_JobConsInvLine."Distance KM Quantity";
                                        UNTIL l_JobConsInvLine.NEXT = 0;
                                        IF l_JobTaskResQty > 0 THEN BEGIN
                                            g_LineNo := g_LineNo + 10000;
                                            g_ConsExpInvLine.INIT;
                                            g_ConsExpInvLine."Document Type" := g_ConsExpInvLine."Document Type"::Quote;
                                            g_ConsExpInvLine."Document No." := g_ConsExpInvHeader."No.";
                                            g_ConsExpInvLine."Line No." := g_LineNo;
                                            g_ConsExpInvLine.Type := g_ConsExpInvLine.Type::Item;
                                            //g_ConsExpInvLine."No." := l_Ressource."No.";
                                            g_ConsExpInvLine.validate("No.",l_Ressource."No.");
                                            g_ConsExpInvLine.Description := COPYSTR(l_RessourceName + ' - ' + l_JobTask.Description, 1, 50);
                                            //pauschales Kennzeichen
                                            IF l_JobTask."IMP all inclusive" THEN
                                                g_ConsExpInvLine.Description := COPYSTR(l_RessourceName + ' - [X] ' + l_JobTask.Description, 1, 50);
                                            //g_ConsExpInvLine.Quantity := l_JobTaskResQty;
                                            g_ConsExpInvLine.validate(Quantity,l_JobTaskResQty);
                                            g_ConsExpInvLine.INSERT;
                                        END;
                                        IF l_JobTaskResTravelQty > 0 THEN BEGIN
                                            g_LineNo := g_LineNo + 10000;
                                            g_ConsExpInvLine.INIT;
                                            g_ConsExpInvLine."Document Type" := g_ConsExpInvLine."Document Type"::Quote;
                                            g_ConsExpInvLine."Document No." := g_ConsExpInvHeader."No.";
                                            g_ConsExpInvLine."Line No." := g_LineNo;
                                            g_ConsExpInvLine.Type := g_ConsExpInvLine.Type::Resource;
                                            g_ConsExpInvLine."No." := l_Ressource."No." + '-REIS';
                                            g_ConsExpInvLine.Description := COPYSTR('Reisezeit - ' + l_RessourceName, 1, 50);
                                            g_ConsExpInvLine.Quantity := l_JobTaskResTravelQty;
                                            g_ConsExpInvLine.INSERT;
                                        END;
                                        IF l_JobTaskResTravelKM > 0 THEN BEGIN
                                            g_LineNo := g_LineNo + 10000;
                                            g_ConsExpInvLine.INIT;
                                            g_ConsExpInvLine."Document Type" := g_ConsExpInvLine."Document Type"::Quote;
                                            g_ConsExpInvLine."Document No." := g_ConsExpInvHeader."No.";
                                            g_ConsExpInvLine."Line No." := g_LineNo;
                                            g_ConsExpInvLine.Type := g_ConsExpInvLine.Type::Item;
                                            g_ConsExpInvLine."No." := 'DL-REIS-KM';
                                            g_ConsExpInvLine.Description := COPYSTR('Reisespesen km - ' + l_RessourceName, 1, 50);
                                            g_ConsExpInvLine.Quantity := l_JobTaskResTravelKM;
                                            g_ConsExpInvLine.INSERT;
                                        END;
                                    END;
                                UNTIL l_Ressource.NEXT = 0;
                            END;
                        UNTIL l_JobTask.NEXT = 0;
                    END;
                END;
            END;

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

        g_ConsExpInvHeader: Record "Sales Header";
        g_ConsExpInvLine: Record "Sales Line";
        g_RessouceFilter: Code[100];
        g_LineNo: Integer;
        Text50000: Label 'Keine externe Kundennummer gefunden für Debitor %1, %2; Projekt Nr. %3';
        Text50001: Label 'Rech. %1/%2, %3';
        Text50002: Label 'Es existieren in der aktuellen Abrechnungsperiode %1/%2 noch %3 Abrechnungen im Status erstellt.';
}