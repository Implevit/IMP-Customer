report 50009 "IMPL Consulting proof IMPL"
{

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/Rep50009.IMPConsultingProofIMPL.rdlc';
    Caption = 'IMP Consulting proof IMPL';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(JobJournLine; "Job Journal Line")
        {
            DataItemTableView = sorting("Job No.", "Job Task No.", "No.", "Posting Date");
            RequestFilterFields = "No.", "Posting Date", "Job No.", "Job Task No.";

            column(JobJournLine_LineNo; JobJournLine."Line No.")
            {
            }
            column(JobJournLine_PostDate; JobJournLine."Posting Date")
            {
            }
            column(JobJournLine_JobNo; JobJournLine."Job No.")
            {
            }
            column(JobJournLine_No; JobJournLine."No.")
            {
            }
            column(JobJournLine_Descr; JobJournLine.Description)
            {
            }
            column(JobJournLine_HrToInv; JobJournLine."IMP Hours to invoice")
            {
            }
            column(JobJournLine_TravelTime; JobJournLine."IMP Travel Time")
            {
            }
            column(JobJournLine_km; JobJournLine."IMP km")
            {
            }
            column(JobJournLine_HrNotToInv; JobJournLine."IMP Hours not to invoice")
            {
            }
            column(JobJournLine_Ticket; JobJournLine."IMP Ticket No.")
            {
            }
            column(Totfakt; Totfakt)
            {
            }
            column(TodayDate; FORMAT(TODAY, 0, 4))
            {
            }
            column(UserIDDB; USERID)
            {
            }
            column(CompInfo_Picture; CompInfoRec.Picture)
            {
            }
            column(FilterText; FilterText)
            {
            }
            column(CompInfo_ImplAdrText; ImplAdrText)
            {
            }
            column(Job_Descr; JobRec.Description)
            {
            }
            column(JobTask_JobTaskNo; JobTaskRec."Job Task No.")
            {
            }
            column(JobTask_JobTaskDescr; JobTaskRec.Description)
            {
            }
            column(Ressource_Name; RessourceRec.Name)
            {
            }
            column(Customer_No; CustomerRec."No.")
            {
            }
            column(Customer_Name; CustomerRec.Name)
            {
            }

            trigger OnPreDataItem()
            var
                UserSetup: Record "User Setup";
            begin
                FilterText := CopyStr(GetFilter("Posting Date"), 1, 250);

                if UserSetup.Get(UserId) then
                    if not UserSetup."IMP Job Jnl. changes allowed" then
                        JobJournLine.SetRange("No.", UserId);
            end;

            trigger OnAfterGetRecord()
            var
                SubStr1_Lbl: Label '%1 - %2 %3-%4 %5 %6 %7 %8';
            begin
                CompInfoRec.GET();
                CompInfoRec.CALCFIELDS(Picture);


                if GETFILTER("No.") = '' then
                    Error(Text3);

                if ((AllInclusiveBool = false) and (JobJournLine."IMP All Inclusive" = true)) then
                    CurrReport.Skip();

                if JobRec.GET("Job No.") then;
                if ((JobRec."IMP Internal Job" <> 0)) then
                    CurrReport.Skip();

                if CustomerRec.GET(JobRec."Bill-to Customer No.") then;

                if JobTaskRec.GET("Job No.", "Job Task No.") then;

                if RessourceRec.GET("No.") then;

                ImplAdrText := STRSUBSTNO(SubStr1_Lbl, CompInfoRec.Name, CompInfoRec.Address, CompInfoRec."Country/Region Code",
                                          CompInfoRec.City, Text1, CompInfoRec."Phone No.", '', '');

                Totfakt := JobJournLine."IMP Hours to invoice" + JobJournLine."IMP Travel Time";

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Optionen)
                {
                    field(AllInclusiveBoolOpt; AllInclusiveBool)
                    {
                        Caption = 'Pauschale Projektaufgaben anzeigen';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportNameLbl = 'Beratungsnachweis';
        PostDateLbl = 'Datum';
        TicketNoLbl = 'Ticket Nr.';
        EmployeeLbl = 'Mitarbeiter';
        DescrLbl = 'Beschreibung';
        HrInvLbl = 'Std. fakt.bar';
        TravelTimelbl = 'Fahrzeit';
        KmLbl = 'km';
        TotalInvLbl = 'Total Fakt.';
        ProjectLbl = 'Projekt';
        ProjecttaskLbl = 'Projektaufgabe';
        TotalLbl = 'Total';
        SignaturLbl = 'Unterschrift des Beraters';
        TotalStdKmLbl = 'Total hr / km';
        CustomerLbl = 'Customer';
        GoodwillLbl = 'Nicht fakturierte Leistungen / in Kulanz';
        PeriodLbl = 'Zeitraum';
        TicketLbl = 'Ticket';
    }

    var
        CustomerRec: Record Customer;
        RessourceRec: Record Resource;
        JobRec: Record Job;
        JobTaskRec: Record "Job Task";
        CompInfoRec: Record "Company Information";
        Totfakt: Decimal;
        FilterText: Text[250];
        ImplAdrText: Text[250];
        Text1: Label 'Telefon';
        Text3: Label 'This report can''t start without a resource (No.").';
        AllInclusiveBool: Boolean;
}

