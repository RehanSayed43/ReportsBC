// report 50143 "Purchase_Invoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'qw';
//     RDLCLayout = 'Purchaseinvoices546.rdl';

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
//             column(EncodeStr; EncodeStr) { }
//             column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Due_Date; "Due Date") { }
//             column(Pay_to_Contact; "Pay-to Contact") { }
//             column(Companyname; Company.Name) { }
//             column(Companyaddress; Company.Address) { }
//             column(CompanyCity; Company.City) { }
//             column(CompanyGstno; Company."GST Registration No.") { }
//             column(CompanyPanno; Company."P.A.N. No.") { }
//             column(CompanyStatecode; Company."State Code") { }
//             column(Companybankname; Company."Bank Name") { }
//             column(CompanyAccno; Company."Bank Account No.") { }
//             column(Companybranchno; Company."Bank Branch No.") { }
//             column(CompanySwiftcode; Company."SWIFT Code") { }

//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(Totalcgst; Totalcgst) { }
//                 column(Totalsgst; Totalsgst) { }
//                 column(Totaligst; Totaligst) { }
//                 column(AmntinWrds; AmntinWrds) { }
//                 column(AmounttoVendor; AmounttoVendor) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     BarSym: Enum "Barcode Symbology 2D";
//                     BarcodeProvider: Interface "Barcode Font Provider 2D";


//                 begin
//                     EncodeStr := "No.";
//                     BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
//                     BarSym := Enum::"Barcode Symbology 2D"::"QR-Code";
//                     EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarSym);

//                     Purchaseline.Reset();
//                     Purchaseline.SetRange("Document No.", "Purchase Header"."No.");
//                     Purchaseline.SetRange("Document Type", "Purchase Header"."Document Type");
//                     if Purchaseline.FindSet() then
//                         repeat
//                             TaxRecordid := "Purchase Line".RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGST := TaxTransactionValue.Amount;
//                                 IGSTRate := TaxTransactionValue.Percent;
//                             end;
//                             Total += Purchaseline.Amount;

//                             AmounttoVendor := Total + CGST + SGST + IGST;
//                         until Purchaseline.Next() = 0;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(Amountinwords, Round(AmounttoVendor), "Purchase Header"."Currency Code");
//                     AmntinWrds := Amountinwords[1] + Amountinwords[2];


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
//         Company.get();
//     end;



//     var
//         myInt: Integer;
//         EncodeStr: Text;
//         Vendor: Record Vendor;
//         Purchaseline: Record "Purchase Line";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         Totalcgst: Decimal;
//         Totalsgst: Decimal;
//         Totaligst: Decimal;
//         AmounttoVendor: Decimal;
//         Total: Decimal;
//         TaxTotal: Decimal;
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
//         TaxRecordid: RecordId;
//         Company: Record "Company Information";
// }