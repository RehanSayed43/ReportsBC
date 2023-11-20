// report 50129 "Purchase Order Excel Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = Excel;
//     Caption = 'AASSOO';
//     ExcelLayout = 'Puchase.xlsx';

//     dataset
//     {
//         dataitem(Vendor; Vendor)
//         {
//             column(No_; "No.") { }
//             column(Name; Name) { }
//             column(Address; Address) { }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {

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


//     var
//         myInt: Integer;
// }