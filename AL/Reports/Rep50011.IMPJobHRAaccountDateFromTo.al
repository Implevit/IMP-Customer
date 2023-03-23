report 50011 "IMP Job Account - Date From-To"
{

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/Rep50011.IMPJobHRAaccountDateFromTo.rdlc';
    Caption = 'IMP Hour Account - Date From To';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(JobJournLine; "Job Journal Line")
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Job No.", "Posting Date";
            column(JobJournLine_PostDate; JobJournLine."Posting Date")
            {
            }
            column(JobJournLine_No; JobJournLine."No.")
            {
            }
            column(JobJournLine_ProjectNo; JobJournLine."Job No.")
            {
            }
            column(JobJournLine_Descr; JobJournLine.Description)
            {
            }
            column(JobJournLine_Time1from; JobJournLine."IMP Time 1 from")
            {
            }
            column(JobJournLine_Time1to; JobJournLine."IMP Time 1 to")
            {
            }
            column(JobJournLine_Time2from; JobJournLine."IMP Time 2 from")
            {
            }
            column(JobJournLine_Time2to; JobJournLine."IMP Time 2 to")
            {
            }
            column(JobJournLine_Time3from; JobJournLine."IMP Time 3 from")
            {
            }
            column(JobJournLine_Time3to; JobJournLine."IMP Time 3 to")
            {
            }
            column(JobJournLine_TotalFromTo; JobJournLine."IMP Total from/to")
            {
            }
            column(JobJournLine_HrBillable; JobJournLine."IMP Hours to invoice")
            {
            }
            column(JobJournLine_HrNotBillable; JobJournLine."IMP Hours not to invoice")
            {
            }
            column(FaktTot; FaktTot)
            {
            }
            column(NFaktNet; NFaktNet)
            {
            }
            column(FaktNfakt; FaktNfakt)
            {
            }
            column(FilterText; FilterText)
            {
            }
            column(TodayDate; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompanyNameDB; COMPANYNAME)
            {
            }
            column(UserIDDB; USERID)
            {
            }

            trigger OnPreDataItem()
            var
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get(UserId) then
                    if not UserSetup."IMP Job Jnl. changes allowed" then
                        JobJournLine.SetRange("No.", UserSetup."IMP Job Resource No.");

                FaktNetGT := 0;
                FaktTotGT := 0;
                NfaktNetGT := 0;
                FaktNfaktGT := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                FilterText := CopyStr(GetFilters, 1, 250);

                FaktNet := JobJournLine."IMP Hours to invoice";
                FaktTot := FaktNet + JobJournLine."IMP Travel Time";
                NFaktNet := JobJournLine."IMP Hours not to invoice";
                FaktNfakt := FaktTot + NFaktNet;

                FaktNetTot := FaktNetTot + FaktNet;
                FaktTotTot := FaktTotTot + FaktTot;
                NFaktNetTot := NFaktNetTot + NFaktNet;
                FaktNfaktTot := FaktNfaktTot + FaktNfakt;

                FaktNetGT := FaktNetGT + FaktNet;
                FaktTotGT := FaktTotGT + FaktTot;
                NfaktNetGT := NfaktNetGT + NFaktNet;
                FaktNfaktGT := FaktNfaktGT + FaktNfakt;
            end;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        EmployeeCodeLbl = 'MA Code';
        TotalfuerLbl = 'Total für';
        ReportNameLbl = 'Stundenabrechnung - Nach Datum von/bis';
        FaktTotLbl = 'Total Fakt.';
        NFaktNetLbl = 'Total N-fakt.';
        FaktNfaktLbl = 'Gesamt Total';
        PostDateLbl = 'Buchungsdatum';
        ProjektnoLbl = 'Projektnr.';
        DescrLbl = 'Beschreibung';
        TotalfromtoLbl = 'Total von/bis';
        HrBillableLbl = 'Std. fakt.bar';
        OverInvoiceLbl = 'Ueber Fakt.';
        TravelTimeLbl = 'Fahrzeit';
        HrNotBillableLbl = 'Std. N-fakt.bar';
        OverNotInvoiceLbl = 'Ueber N-fakt.';
        NoLbl = 'MA';
        Time1fromLbl = 'Zeit 1 von';
        Time1ToLbl = 'Zeit 1 bis';
        Time2fromLbl = 'Zeit 2 von';
        Time2ToLbl = 'Zeit 2 bis';
        Time3fromLbl = 'Zeit 3 von';
        Time3ToLbl = 'Zeit 3 bis';
    }

    trigger OnInitReport()
    begin
    end;

    var
        FaktNet: Decimal;
        FaktTot: Decimal;
        NFaktNet: Decimal;
        FaktNfakt: Decimal;
        FaktNetTot: Decimal;
        FaktTotTot: Decimal;
        NFaktNetTot: Decimal;
        FaktNfaktTot: Decimal;
        FaktNetGT: Decimal;
        FaktTotGT: Decimal;
        NfaktNetGT: Decimal;
        FaktNfaktGT: Decimal;
        FilterText: Text[250];
}
