// report 50120 "Purchase Order Customer"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'FRR';
//     RDLCLayout = './srehann.rdl';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";

//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Pay_to_City; "Pay-to City") { }

//             column(Location_GST_Reg__No_; "Location GST Reg. No.") { }


//             //Company
//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(companyaddressgst; company."GST Registration No.") { }
//             column(companycity; company.City) { }
//             column(companystatecode; company."State Code") { }

//             //Column
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Posting_Date; "Posting Date") { }

//             column(Amtinwrds; Amtinwrds) { }



//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = FIELD("No.");
//                 column(Srnoo; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Per; "Unit of Measure Code") { }
//                 column(Rate; "Direct Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//             }
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//             begin
//                 ClearData;
//                 sales.Reset();
//                 sales.SetRange("Document No.", "Purchase Header"."No.");
//                 // sales.SetRange(doc);
//                 if sales.FindSet() then
//                     repeat
//                         Total += sales.Amount;
//                     until sales.Next() = 0;
//                 AmountToVendor := Total;
//                 PostedVoucher.InitTextVariable();
//                 "Purchase Header".CalcFields(Amount);
//                 PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
//                 Amtinwrds := AmountinWords[1] + AmountinWords[2];

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



//     var
//         myInt: Integer;
//         vendor: Record Vendor;
//         company: Record "Company Information";
//         sales: Record "Purchase Line";
//         PostedVoucher: Report "Posted Voucher";
//         AmountToVendor: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionAmount: Decimal;
//         Amtinwrds: Text;
//         AmountinWords: array[2] of Text;
//         CGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         IGSTtxt: text[10];
//         CGSTtxt: text[10];
//         IGSTRate: Decimal;
//         SGST: Decimal;
//         Total: Decimal;

//     local procedure ClearData()
//     Begin
//         IGSTRate := 0;
//         SGSTRate := 0;
//         CGSTRate := 0;

//         // TotalCGST := 0;
//         // TotalSGST := 0;
//         // TotalIGST := 0;

//         IGST := 0;
//         CGST := 0;
//         SGST := 0;
//         Clear(AmountinWords);

//     End;

// }