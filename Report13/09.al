// report 50106 "Posted Sales Credit Memos"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './sayeddd123.rdl';

//     dataset
//     {
//         dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
//         {
//             //BILL TO
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Customer_GST_Reg__No_; "Customer GST Reg. No.") { }
//             column(Bill_to_City; "Bill-to City") { }
//             column(Location_State_Code; "Location State Code") { }

//             // SHIP TO
//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Ship_to_Address; "Ship-to Address") { }


//             //COMPANY
//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(companygstno; company."GST Registration No.") { }
//             column(companypanno; company."P.A.N. No.") { }
//             column(companycity; company.City) { }
//             column(companystatecode; company."State Code") { }

//             //COMPANY BANK ACCOUNT
//             column(companyBanksname; company."Bank Name") { }
//             column(companyaccountno; company."Bank Account No.") { }
//             column(companySwiftcode; company."SWIFT Code") { }
//             column(company; company.IBAN) { }

//             //COLUMN
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Bill_to_Contact; "Bill-to Contact") { }



//             dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
//             {
//                 column(No; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Per; "Unit of Measure Code") { }
//                 column(Rate; "Unit Cost (LCY)") { }
//                 column(Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(DueDatess; "Shipment Date") { }
//             }
//             //Code to Get the amount in numbers to words
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//             begin
//                 cleardata();
//                 sales.Reset();
//                 sales.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
//                 if sales.FindSet() then
//                     repeat
//                         Total += sales.Amount;
//                     until sales.Next() = 0;
//                 AmountToVendors := Total;
//                 PostedVoucher.InitTextVariable();
//                 "Sales Cr.Memo Header".CalcFields(Amount);
//                 PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendors), "Sales Cr.Memo Header"."Currency Code");
//                 Amntinwrds := AmountinWords[1] + AmountinWords[2];


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
//                     ApplicationArea = all;

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
//         myInt: Integer;
//         company: Record "Company Information";
//         PostedVoucher: Report "Posted Voucher";
//         sales: Record "Sales Cr.Memo Line";
//         AmountToVendors: Decimal;
//         TextAmount: Text;
//         NumberWrds: Text;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         AmountinWords: array[2] of Text;
//         Amntinwrds: Text;
//         IGST: Decimal;
//         SGST: Decimal;
//         CGST: Decimal;
//         IGSTRate: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         Total: Decimal;

//     local procedure cleardata()
//     begin
//         CGST := 0;
//         SGST := 0;
//         IGST := 0;

//         TotalIGST := 0;
//         TotalSGST := 0;
//         TotalCGST := 0;

//         CGSTRate := 0;
//         SGSTRate := 0;
//         IGSTRate := 0;
//     end;

// }