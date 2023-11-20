// report 50107 "ExcelPurchase"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'excelpurchase';
//     DefaultLayout = Excel;
//     ExcelLayout = 'excelp.xlsx';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             column(No_; "No.")
//             {

//             }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
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