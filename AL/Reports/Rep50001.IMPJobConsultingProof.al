report 50001 "IMP Job Consulting Proof"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/Rep50001.IMPJobConsultingProof.rdlc';
    Caption = 'IMP Consulting proof';
    //DefaultRenderingLayout = LayoutName;

    dataset
    {

        dataitem(JCIH; "IMP Job Consulting Inv. Header")
        {
            RequestFilterFields = "Job No.";

            column(JCIH_JobNo; JCIH."Job No.")
            {
            }
            column(JCIH_Month; JCIH.Month)
            {
            }
            column(JCIH_Year; JCIH.Year)
            {
            }
            column(JCIH_CreationDate; JCIH."Creation Date")
            {
            }
            column(Ressource_ProjectManager; RessourceProjectRec.Name)
            {
            }
            dataitem(JCIL; "IMP Job Consulting Inv. Line")
            {
                DataItemLinkReference = JCIH;
                DataItemLink = "Job No." = FIELD("Job No."), Month = FIELD(Month), Year = FIELD(Year);
                column(JCIL_PostDate;
                JCIL."Posting Date")
                {

                }
                column(JCIL_JobNo; JCIL."Job No.")
                {


                }
                column(JCIL_No; JCIL."Resource No.")
                {


                }
                column(JCIL_Descr; JCIL.Description)
                {


                }
                column(JCIL_HrToInv; JCIL."Quantity to Invoice")
                {


                }
                column(JCIL_TravelTime; JCIL."Travel Time Quantity")
                {


                }
                column(JCIL_km; JCIL."Distance KM Quantity")
                {


                }
                column(JCIL_HrNotToInv; JCIL."Quantity not to Invoice")
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
                column(Customer_Name; JobRec."Bill-to Name")
                {


                }
                column(JCIL_TicketNo; JCIL."Ticket No.")
                {


                }
                column(JCIL_AllInclusive; JCIL."all inclusive")
                {


                }
                column(CustomerLbl; CustomerLbl)
                {


                }
                column(ProjectLbl; ProjectLbl)
                {


                }
                column(PeriodLbl; PeriodLbl)
                {


                }
                column(EmployeeLbl; EmployeeLbl)
                {


                }
                column(PostDateLbl; PostDateLbl)
                {


                }
                column(DescrLbl; DescrLbl)
                {


                }
                column(HrInvLbl; HrInvLbl)
                {


                }
                column(TravelTimelbl; TravelTimelbl)
                {


                }
                column(KmLbl; KmLbl)
                {


                }
                column(TotalInvLbl; TotalInvLbl)
                {


                }
                column(GoodwillLbl; GoodwillLbl)
                {


                }
                column(TicketLbl; TicketLbl)
                {


                }
                column(SignaturLbl; SignaturLbl)
                {


                }
                column(TotalLbl; TotalLbl)
                {


                }
                column(ProjecttaskLbl; ProjecttaskLbl)
                {


                }
                column(ReportNameLbl; ReportNameLbl)
                {


                }
                column(FtrName; CompInfoRec.Name)
                {


                }
                column(FtrAddress; CompInfoRec.Address)
                {


                }
                column(FtrCity; 'CH-' + CompInfoRec."Post Code" + ' ' + CompInfoRec.City)
                {


                }
                column(FtrEmail; CompInfoRec."E-Mail")
                {


                }
                column(FtrHomePage; CompInfoRec."Home Page")
                {


                }
                column(FtrPhoneNo; PhoneLbl + ' ' + CompInfoRec."Phone No.")
                {


                }
                column(FtrFaxNo; FaxLbl + ' ' + CompInfoRec."Fax No.")
                {


                }
                column(FtrText1; FtrText01)
                {


                }
                column(FtrText2; FtrText02)
                {


                }
                trigger OnPreDataItem()
                begin
                    FilterText := GETFILTER("Posting Date");
                end;

                trigger OnAfterGetRecord()
                begin
                    IF ((NOT AllInclusiveBool) AND ("all inclusive")) THEN
                        CurrReport.SKIP;

                    IF JobTaskRec.GET("Job No.", "Job Task No.") THEN BEGIN

                        JCIL.CALCFIELDS("Job Task Description");
                        IF JobTaskRec."imp all inclusive" = TRUE AND JCIL."all inclusive" = FALSE THEN BEGIN
                            ERROR(Error001, JCIL."Posting Date", JCIL.Description, JCIL."Job Task No.", JCIL."Job Task Description");
                        END;
                    END;

                    IF RessourceRec.GET("Resource No.") THEN;
                    ImplAdrText := STRSUBSTNO('%1 - %2 %3-%4 %5 %6 %7 %8', CompInfoRec.Name, CompInfoRec.Address, CompInfoRec."Country/Region Code",
                          CompInfoRec.City, Text1, CompInfoRec."Phone No.", '', '');
                    Totfakt := JCIL."Quantity to Invoice" + JCIL."Travel Time Quantity";
                end;



            }
            trigger OnAfterGetRecord()
            begin
                JCIH.CALCFIELDS("Project Manager IMPL");
                IF RessourceProjectRec.GET(JCIH."Project Manager IMPL") THEN;

                IF JobRec.GET("Job No.") THEN;

                IF ((JobRec."imp Internal Job" <> 0)) THEN
                    CurrReport.SKIP;

                IF ConsultingProofBool = FALSE THEN BEGIN
                    IF JobRec."IMP No Settlement Statement" = TRUE THEN
                        CurrReport.SKIP;
                END ELSE BEGIN
                    IF JobRec."IMP No Settlement Statement" = FALSE THEN
                        CurrReport.SKIP;
                END;

                IF CustomerRec.GET(JobRec."Bill-to Customer No.") THEN;

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
                    field(CustomerWithoutAccProof; ConsultingProofBool)
                    {
                        ApplicationArea = All;

                    }
                    field(AddAllInclTasks; AllInclusiveBool)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

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
        RessourceRec: Record Resource;
        RessourceProjectRec: Record Resource;
        JobRec: Record Job;
        Totfakt: decimal;
        FilterText: text;
        Gesamt: Decimal;
        JobTaskRec: Record "Job Task";
        CompInfoRec: Record "Company Information";
        ImplAdrText: Text;
        CustomerRec: Record Customer;
        ConsultingProofBool: Boolean;
        AllInclusiveBool: Boolean;

        Text1: Label 'Telefon';
        Text2: Label 'Fax';
        Text3: Label 'Dieser Report kann nur mit einer Ressource(Nr.) ausgeführt werden.';
        ReportNameLbl: Label 'Abrechnungsnachweis';
        PostDateLbl: Label 'Datum';
        TicketNoLbl: Label 'Ticket Nr.';
        EmployeeLbl: Label 'Projektleitung';
        DescrLbl: Label 'Beschreibung';
        HrInvLbl: Label 'Std.';
        TravelTimelbl: Label 'Fahrzeit';
        KmLbl: Label 'km';
        TotalInvLbl: Label 'Total Fakt.';
        ProjectLbl: Label 'Projekt';
        ProjecttaskLbl: Label 'Projektaufgabe';
        TotalLbl: Label 'Total';
        SignaturLbl: Label 'Unterschrift des Beraters';
        TotalStdKmLbl: Label 'Total Std / Km';
        CustomerLbl: Label 'Kunde';
        GoodwillLbl: Label 'Nicht fakturierte Leistungen';
        PeriodLbl: Label 'Zeitraum';
        TicketLbl: Label 'Ticket';
        FaxLbl: Label 'Fax:';
        PhoneLbl: Label 'Tel:';
        FtrText01: Label '';
        FtrText02: Label '';
        Error001: Label 'Die Abbrechnungszeile %1  %2  darf nicht pauschal false sein wenn Projektaufgabe %3 - %4  pauschal true';

    trigger OnInitReport()
    begin
        CompInfoRec.GET();
        CompInfoRec.CALCFIELDS(Picture);

    end;
}