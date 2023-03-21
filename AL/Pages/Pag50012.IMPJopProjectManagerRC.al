/// <summary>
/// Page IMP Job Project Manager Rollencenter (ID 50011).
/// </summary>
page 50012 "IMP Job Project Manager RC"
{
    Caption = 'IMP Project Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control102; "Headline RC Project Manager")
            {
                ApplicationArea = Jobs;
            }
            part(Control33; "Project Manager Activities")
            {
                ApplicationArea = Jobs;
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control34; "My Jobs")
            {
                ApplicationArea = Jobs;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = Jobs;
            }
            part("Power BI Report Spinner Part"; "Power BI Report Spinner Part")
            {
                AccessByPermission = TableData "Power BI User Configuration" = I;
                ApplicationArea = Basic, Suite;
            }
            part(Control21; "My Job Queue")
            {
                ApplicationArea = Jobs;
            }
            part(Control31; "Report Inbox Part")
            {
                ApplicationArea = Jobs;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Jobs;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(JobSettlements)
            {
                ApplicationArea = All;
                Caption = 'Job Settlements';
                Image = Job;
                RunObject = Page "IMP Job Consulting Inv. Hdrs";
            }
             action(CustSettlements)
            {
                ApplicationArea = All;
                Caption = 'Customer Settlements';
                Image = Job;
                RunObject = Page "IMP Cust. Consulting Inv. Hdrs";
            }
            action(Jobs)
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                Image = Job;
                RunObject = Page "Job List";
            }
            action(JobsOnOrder)
            {
                ApplicationArea = Jobs;
                Caption = 'Open';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Open));
                ToolTip = 'Open the card for the selected record.';
            }
            action(JobsPlannedAndQuoted)
            {
                ApplicationArea = Jobs;
                Caption = 'Planned and Quoted';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Quote | Planning));
                ToolTip = 'View all planned and quoted jobs.';
            }
            action(JobsCompleted)
            {
                ApplicationArea = Jobs;
                Caption = 'Completed';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Completed));
                ToolTip = 'View all completed jobs.';
            }
            action(JobsUnassigned)
            {
                ApplicationArea = Jobs;
                Caption = 'Unassigned';
                RunObject = Page "Job List";
                RunPageView = WHERE("Person Responsible" = FILTER(''));
                ToolTip = 'View all unassigned jobs.';
            }
            action(Customers)
            {
                ApplicationArea = Jobs;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Items)
            {
                ApplicationArea = Jobs;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Resources)
            {
                ApplicationArea = Jobs;
                Caption = 'Resources';
                RunObject = Page "Resource List";
            }

        }
        area(sections)
        {
            group("Sales")
            {
                Caption = 'Sales';
                action("Customer")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Customer';
                    Image = Customer;
                    RunObject = Page "Customer List";

                }

                action("Sales Quotes")
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Quotes';
                    RunObject = Page "Sales Quotes";
                }
            }
            group(Action2)
            {
                Caption = 'Jobs';
                Image = Job;
                ToolTip = 'Create, plan, and execute tasks in project management. ';
                action(Action90)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Jobs';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job List";
                    ToolTip = 'Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.';
                }
                action(Open)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Open';
                    RunObject = Page "Job List";
                    RunPageView = WHERE(Status = FILTER(Open));
                    ToolTip = 'Open the card for the selected record.';
                }
                action(JobsPlannedAndQuotd)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Planned and Quoted';
                    RunObject = Page "Job List";
                    RunPageView = WHERE(Status = FILTER(Quote | Planning));
                    ToolTip = 'Open the list of all planned and quoted jobs.';
                }
                action(JobsComplet)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Completed';
                    RunObject = Page "Job List";
                    RunPageView = WHERE(Status = FILTER(Completed));
                    ToolTip = 'Open the list of all completed jobs.';
                }
                action(JobsUnassign)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Unassigned';
                    RunObject = Page "Job List";
                    RunPageView = WHERE("Person Responsible" = FILTER(''));
                    ToolTip = 'Open the list of all unassigned jobs.';
                }
                action(Action3)
                {
                    ApplicationArea = Suite;
                    Caption = 'Job Tasks';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Task List";
                    ToolTip = 'Open the list of ongoing job tasks. Job tasks represent the actual work that is performed in a job, and they enable you to set up job planning lines and to post consumption to the job.';
                }
                action("Job Planning Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Planning Lines';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Planning Lines";
                    ToolTip = 'Open the list of ongoing job planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).';
                }
                action(JobJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Journals';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Record job expenses or usage in the job ledger, either by reusing job planning lines or by manual entry.';
                }


            }
            group(Action91)
            {
                Caption = 'Resources';
                Image = Journals;
                ToolTip = 'Manage the people or machines that are used to perform job tasks. ';
                action(Action93)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resources';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource List";
                    ToolTip = 'Manage your resources'' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.';
                }
                 action(ResJobWork)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Job Work. Hrs. Month';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "IMP Res. Job Work. Hrs. Month";
                    ToolTip = 'Manage your resources'' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.';
                }
                
                action("Resource Groups")
                {
                    ApplicationArea = Suite;
                    Caption = 'Resource Groups';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Groups";
                    ToolTip = 'Organize resources in groups, such as Consultants, for easier assignment of common values and to analyze financial figures by groups.';
                }
            }
            group(SetupAndExtensions)
            {
                Caption = 'Setup & Extensions';
                Image = Setup;
                ToolTip = 'Overview and change system and application settings, and manage extensions and services';
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                ObsoleteTag = '18.0';
                action("Assisted Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Assisted Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Assisted Setup";
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                    ObsoleteTag = '18.0';
                }
                action("Manual Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Manual Setup';
                    RunObject = Page "Manual Setup";
                    ToolTip = 'Define your company policies for business departments and for general activities by filling setup windows manually.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                    ObsoleteTag = '18.0';
                }
                action("Service Connections")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service Connections';
                    Image = ServiceTasks;
                    RunObject = Page "Service Connections";
                    ToolTip = 'Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                    ObsoleteTag = '18.0';
                }
                action(Extensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Extensions';
                    Image = NonStockItemSetup;
                    RunObject = Page "Extension Management";
                    ToolTip = 'Install Extensions for greater functionality of the system.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                    ObsoleteTag = '18.0';
                }
                action(Workflows)
                {
                    ApplicationArea = Suite;
                    Caption = 'Workflows';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Workflows;
                    ToolTip = 'Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'The new common entry points to all Settings is introduced in the app bar''s cogwheel menu (aligned with the Office apps).';
                    ObsoleteTag = '18.0';
                }
            }
        }
    }
}

