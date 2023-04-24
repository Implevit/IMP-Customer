table 50015 "IMP Job Consulting InvHdr Cue"
{
    Caption = 'IMP Job Consulting InvHdr Cue';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Created My Actul Period"; integer)
        {
            Caption = 'Create My Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created), "Project Manager IMPL" = field("Created by User"), "Period Start Date" = field("Date Filter")));
        }
        field(30; "Checked My All Actul Period"; integer)
        {
            Caption = 'Checked My All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked), "Project Manager IMPL" = field("Created by User"), "Period Start Date" = field("Date Filter")));
        }
        field(40; "All My Actul Period"; integer)
        {
            Caption = 'All My Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where("Project Manager IMPL" = field("Created by User"), "Period Start Date" = field("Date Filter")));
        }
        field(50; "Created All Actul Period"; integer)
        {
            Caption = 'Create All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created), "Period Start Date" = field("Date Filter")));
        }
        field(60; "Checked All Actul Period"; integer)
        {
            Caption = 'Checked All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked), "Period Start Date" = field("Date Filter")));
        }
        field(70; "All Actul Period"; integer)
        {
            Caption = 'All Actul Period';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where("Period Start Date" = field("Date Filter")));
        }
        field(80; "Created All"; integer)
        {
            Caption = 'Create All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(created),"Period Start Date" = field("Date Filter YTD")));
        }
        field(90; "Checked All"; integer)
        {
            Caption = 'Checked All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where(Status = filter(checked),"Period Start Date" = field("Date Filter YTD")));
        }
        field(100; "All"; integer)
        {
            Caption = 'All';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("IMP Job Consulting Inv. Header" where("Period Start Date" = field("Date Filter YTD")));
        }

        field(110; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(120; "Created by User"; Code[50])
        {
            Caption = 'Created by User';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(130; "Date Filter YTD"; Date)
        {
            Caption = 'Date Filter YTD';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(140; "My Jobs - Open"; integer)
        {
            Caption = 'My Jobs Open';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(open),"IMP Project Manager IMPL" = field("Created by User")));
        }
        field(150; "My Jobs - Quote"; integer)
        {
            Caption = 'My Jobs Quote';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Quote),"IMP Project Manager IMPL" = field("Created by User")));
        }
        field(160; "My Jobs - Completed"; integer)
        {
            Caption = 'My Jobs Completed';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Completed),"IMP Project Manager IMPL" = field("Created by User")));
        }
        field(170; "My Jobs - Planning"; integer)
        {
            Caption = 'My Jobs Planning';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Planning),"IMP Project Manager IMPL" = field("Created by User")));
        }
         field(180; "All Jobs - Open"; integer)
        {
            Caption = 'Jobs Open';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(open)));
        }
        field(190; "All Jobs - Quote"; integer)
        {
            Caption = 'Jobs Quote';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Quote)));
        }
        field(200; "All Jobs - Completed"; integer)
        {
            Caption = 'Jobs Completed';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Completed)));
        }
        field(210; "All Jobs - Planning"; integer)
        {
            Caption = 'Jobs Planning';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where(Status = filter(Planning)));
        }
        field(220; "All Jobs"; integer)
        {
            Caption = 'All Jobs';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job");
        }
        field(230; "My Jobs"; integer)
        {
            Caption = 'My Jobs';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Job" where("IMP Project Manager IMPL" = field("Created by User")));
        }
        field(240; "Last Period Month Hours"; Decimal)
        {
            Caption = 'Month Hours';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = //sum("IMP Res. Job Work. Hrs. Month" where("No." = field("Created by User")));
            Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE("No." = FIELD("Created by User"),"Month Start" = FIELD("Date Filter"),"Job Type Code" = FILTER(<>'SOLL')));
        }
        field(250; "Last Period Month Target"; Decimal)
        {
            Caption = 'Month Target';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = //sum("IMP Res. Job Work. Hrs. Month" where("No." = field("Created by User")));
            Sum("IMP Job Res. Work. Hrs. Month".Quantity WHERE("No." = FIELD("Created by User"),"Month Start" = FIELD("Date Filter"),"Job Type Code" = FILTER('SOLL')));
            // WHERE("No." = FIELD("Created by User"),
            //                                                                "Month Start" = FIELD("Date Filter")));
        }
        field(260; "Date Filter Last Week"; Date)
        {
            Caption = 'Date Filter Last Week';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(270; "Last Period Week Hours"; Decimal)
        {
            Caption = 'Week Hours';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = //sum("IMP Res. Job Work. Hrs. Month" where("No." = field("Created by User")));
            Sum("IMP Job Res. Working Hours".Quantity WHERE("No." = FIELD("Created by User"),"Week Start" = FIELD("Date Filter Last Week"),"Job Type Code" = FILTER(<>'SOLL')));
        }
        field(280; "Last Period Week Target"; Decimal)
        {
            Caption = 'Week Target';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = //sum("IMP Res. Job Work. Hrs. Month" where("No." = field("Created by User")));
            Sum("IMP Job Res. Working Hours".Quantity WHERE("No." = FIELD("Created by User"),"Week Start" = FIELD("Date Filter Last Week"),"Job Type Code" = FILTER(='SOLL')));
            // WHERE("No." = FIELD("Created by User"),
            //                                                                "Month Start" = FIELD("Date Filter")));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}