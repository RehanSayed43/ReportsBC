// report 50114 "PostedSalesInvoice 13/03"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'salesinvoice03.rdl';

//     dataset
//     {
//         dataitem("Sales Invoice Header"; "Sales Invoice Header")
//         {
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }

//             column(Location_State_Code; "Location State Code") { }
//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Ship_to_Address; "Ship-to Address") { }

//             column(Companyinfoname; Companyinfo.Name) { }
//             column(CompanyinfoAddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfoaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(Companyinfoswiftcode; Companyinfo."SWIFT Code") { }


//             column(Location_State_Codes; "Location State Code") { }

//             dataitem("Sales Invoice Line"; "Sales Invoice Line")
//             {
//                 column(No; "No.") { }
//                 column(Description; Description) { }

//             }

//             // column(){}

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
//         Gstno: Code[20];
//         City: Text[30];
//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         AmouninWords: Text;
//         AmninWrds: array[2] of text;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;





// }