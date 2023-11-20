// report 50123 "Posted Sale invoice Customer"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'REHANNN';
//     RDLCLayout = './ssssss.rdl';

//     dataset
//     {
//         dataitem("Sales Invoice Header"; "Sales Invoice Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             //Bill to
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Bill_to_City; "Bill-to City") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(customerBillGst; customer."GST Registration No.") { }

//             //Ship to
//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Ship_to_Address; "Ship-to Address") { }
//             column(Ship_to_City; "Ship-to City") { }

//             //Amount In Words
//             column(Amtinwrds; Amtinwrds) { }

//             //Columns
//             column(Order_No_; "Order No.") { }
//             column(DispatchedThrough; "Bill-to Contact") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Destination; "Bill-to City") { }

//             //Company
//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(companygst; company."GST Registration No.") { }
//             column(companycity; company.City) { }
//             column(companystatecode; company."State Code") { }
//             column(companyphoneno; company."Phone No.") { }
//             column(companyEmail; company."E-Mail") { }

//             //Company Bank Information
//             column(companybankname; company."Bank Name") { }
//             column(companybankaccountnumber; company."Bank Account No.") { }
//             column(companywsiftcode; company."SWIFT Code") { }
//             column(companybranchifsccode; company.IBAN) { }
//             column(companypanno; company."P.A.N. No.") { }








//             dataitem("Sales Invoice Line"; "Sales Invoice Line")
//             {
//                 DataItemLinkReference = "Sales Invoice Header";
//                 DataItemLink = "Document No." = FIELD("No.");
//                 column(Noooooo_; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Ratee; "Unit Price") { }
//                 column(Amount; "Line Amount") { }
//             }
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//             begin
//                 customer.Reset();
//                 customer.SetRange("No.", "Sell-to Customer No.");
//                 if customer.Find('-') then begin
//                     gstno := customer."GST Registration No.";

//                 end;


//                 ClearData();
//                 sales.Reset();
//                 sales.SetRange("Document No.", "Sales Invoice Header"."No.");
//                 if sales.FindSet() then
//                     repeat
//                         Total += sales.Amount;
//                     until sales.Next() = 0;
//                 AmountToVendor := Total;
//                 PostedVoucher.InitTextVariable();
//                 "Sales Invoice Header".CalcFields(Amount);
//                 PostedVoucher.FormatNoText(AmntinWords, Round(AmountToVendor), "Sales Invoice Header"."Currency Code");
//                 Amtinwrds := AmntinWords[1] + AmntinWords[2];





//             end;


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
//         company.get();
//     end;

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         sales.get();
//     end;




//     var
//         // "Document No":Code[20];
//         myInt: Integer;
//         gstno: Code[20];
//         customer: Record Customer;
//         company: Record "Company Information";
//         sales: Record "Sales Invoice Line";

//         PostedVoucher: Report "Posted Voucher";
//         AmountToVendor: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         Amtinwrds: Text;
//         AmntinWords: array[2] of Text;
//         CGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         IGSTtext: Text[10];
//         CGSTtext: Text[10];
//         IGSTRate: Decimal;
//         SGST: Decimal;
//         Total: Decimal;

//     local procedure ClearData()
//     begin
//         CGSTRate := 0;
//         IGSTRate := 0;
//         SGSTRate := 0;

//         TotalCGST := 0;
//         TotalIGST := 0;
//         TotalSGST := 0;


//         CGST := 0;
//         IGST := 0;
//         CGST := 0;

//     end;






// }