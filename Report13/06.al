// report 50127 "Practice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'PR';
//     RDLCLayout = './rsayed.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Bill_to_City; "Bill-to City") { }
//             column(Location_Code; "Location Code") { }
//             column(customergst; customer."GST Registration No.") { }

//             column(comapanyname; comapany.Name) { }
//             column(comapanyaddress; comapany.Address) { }
//             column(comapanygstno; comapany."GST Registration No.") { }
//             column(comapanycity; comapany.City) { }
//             column(comapanystatecode; comapany."State Code") { }

//             dataitem("Sales Line"; "Sales Line")
//             {
//                 column(Nosss; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Amount; "Line Amount") { }
//             }


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
//     trigger OnInitReport()
//     var
//         myInt: Integer;
//     begin
//         comapany.get();
//     end;

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin


//     end;

//     var
//         myInt: Integer;
//         comapany: Record "Company Information";
//         customer: Record Customer;
//         PostedVoucher: Report "Posted Voucher";
//         AmountinVendors: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         TaxTransactionValue: Record "Tax Transaction Value";

//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         Amntinwrds: Text;
//         AmountinWords: array[2] of Text;
//         CGST: Decimal;
//         IGST: Decimal;
//         SGST: Decimal;

//         CGSTRate: Decimal;
//         IGSTRate: Decimal;
//         SGSTRate: Decimal;

//         TotalIGST: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;

//         IGSTtxt: Text[10];
//         SGSTtxt: Text[10];
//         CGSTtxt: Text[10];
//         Total: Decimal;
//         GrandTotal: Decimal;
//         TaxTotal: Decimal;


//         RecState: Record State;
//         CmpStateName: Text;
//         BankAcc: Record "Bank Account";
//         BankBrach: Text;
//         SWIFTCode: Code[20];
//         NoLbl: Label 'SR No.';
//         DesLbl: Label 'Product Description';
//         HSNLbl: Label 'HSN Code';
//         DueLbl: Label 'Due On';
//         qtyLbl: Label 'Qty';
//         RateLbl: Label 'Rate';
//         AmtLbl: Label 'Amount';
//         DisLbl: Label 'Discount';
//         TaxValLbl: Label 'Taxable Value';
//         TotLbl: Label 'Total';

//         Notext: array[2] of Text;


//     local procedure ClearMyData()
//     begin
//         IGSTRate := 0;
//         CGSTRate := 0;
//         SGSTRate := 0;

//         TotalCGST := 0;
//         TotalIGST := 0;
//         TotalSGST := 0;

//         IGST := 0;
//         CGST := 0;
//         SGST := 0;

//     end;
// }