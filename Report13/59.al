// report 50128 "Fixed Asset12"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'fixedasset.rdl';
//     Caption = 'HP';


//     dataset
//     {
//         dataitem("FA Posting Group"; "FA Posting Group")
//         {
//             DataItemTableView = sorting(Code);
//             RequestFilterFields = Code;

//             column(Code; Code) { }
//             column(Acquisition_Cost_Account; "Acquisition Cost Account") { }
//             column(Accum__Depreciation_Account; "Accum. Depreciation Account") { }
//             column(Acq__Cost_Acc__on_Disposal; "Acq. Cost Acc. on Disposal") { }
//             column(Accum__Depr__Acc__on_Disposal; "Accum. Depr. Acc. on Disposal") { }
//             column(Gains_Acc__on_Disposal; "Gains Acc. on Disposal") { }
//             column(Losses_Acc__on_Disposal; "Losses Acc. on Disposal") { }
//             column(Maintenance_Bal__Acc_; "Maintenance Bal. Acc.") { }
//             column(Acquisition_Cost_Bal__Acc_; "Acquisition Cost Bal. Acc.") { }
//             column(Depreciation_Expense_Acc_; "Depreciation Expense Acc.") { }
//             column(companyinfoName; companyinfo.Name) { }

//             dataitem("G/L Account"; "G/L Account")
//             {
//                 DataItemLinkReference = "FA Posting Group";
//                 RequestFilterFields = "No.";
//                 //DataItemLink = "No." = field("Acquisition Cost Account");
//                 column(Net_Change; "Net Change") { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Glacc.SetRange("No.", Fa."Acquisition Cost Account");
//                     Glacc.SetFilter(Balance, Fa."Acquisition Cost Account");
//                 end;

//             }


//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(OPTIONS)
//                 {
//                     field(DeprBookCode; DeprBookCode)
//                     {
//                         ApplicationArea = FixedAssetsGroups;
//                         Caption = 'Depreciation Book';
//                         TableRelation = "Depreciation Book";
//                         ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';
//                     }
//                     field(StartingDate; StartingDate)
//                     {
//                         ApplicationArea = FixedAssetsGroups;
//                         Caption = 'Starting Date';
//                         ToolTip = 'Specifies the date when you want the report to start.';
//                     }
//                     field(EndingDate; EndingDate)
//                     {
//                         ApplicationArea = FixedAssetsGroups;
//                         Caption = 'Ending Date';
//                         ToolTip = 'Specifies the date when you want the report to end.';
//                     }
//                     field(PrintDetails; PrintDetails)
//                     {
//                         ApplicationArea = FixedAssetGroups;
//                         Caption = 'Print per Fixed Asset';
//                         ToolTip = 'Specifies if you want the report to print information separately for each fixed asset.';
//                     }

//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//         }

//     }

//     trigger OnInitReport()
//     var
//         myInt: Integer;
//     begin
//         companyinfo.get();

//     end;



//     var
//         myInt: Integer;
//         Fa: Record "FA Posting Group";
//         Gl: Record "G/L Entry";
//         Glacc: Record "G/L Account";
//         FixedAsset: Record "Fixed Asset";
//         Fasetup: Record "FA Setup";
//         depbook: Record "Depreciation Book";
//         StartingDate: Date;
//         EndingDate: Date;
//         DeprBookCode: Code[10];


//         DeprBook: Record "Depreciation Book";
//         FADeprBook: Record "FA Depreciation Book";
//         PrintDetails: Boolean;
//         BudgetReport: Boolean;
//         BeforeAmount: Decimal;
//         EndingAmount: Decimal;
//         companyinfo: Record "Company Information";


// }