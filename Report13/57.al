// report 50123 Credit_Memo
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'PurchaseCreditMemo111.rdl';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Pay_to_Contact; "Pay-to Contact") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(CompanyinfoAddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(CompanyinfoStateCode; Companyinfo."State Code") { }
//             column(CompanyinfoBankname; Companyinfo."Bank Name") { }
//             column(CompanyinfoAccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftcode; Companyinfo."SWIFT Code") { }
//             column(Companyinfopanno; Companyinfo."P.A.N. No.") { }

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
//                 column(CGSTRATE; CGSTRATE) { }
//                 column(SGSTRATE; SGSTRATE) { }
//                 column(IGSTRATE; IGSTRATE) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(AmounttoVendor; AmounttoVendor) { }

//                 // trigger OnAfterGetRecord()
//                 // var
//                 //     myInt: Integer;
//                 // // begin
//                 //     Purchaseline.Reset();
//                 //     Purchaseline.SetRange("Document Type", "Purchase Header"."Document Type");
//                 //     Purchaseline.SetRange("Document No.", "Purchase Header"."No.");
//                 //     if "Purchase Line".FindSet() then
//                 //         repeat
//                 //             TaxRecordId := "Purchase Line".RecordId;

//                 //             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                 //             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                 //             TaxTransactionValue.SetRange("Visible on Interface", true);
//                 //             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                 //             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                 //             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                 //             if TaxTransactionValue.FindSet() then begin
//                 //                 CGSTRATE := TaxTransactionValue.Percent;
//                 //                 SGSTRATE := TaxTransactionValue.Percent;
//                 //                 CGST := TaxTransactionValue.Amount;
//                 //                 SGST := TaxTransactionValue.Amount;
//                 //                 TotalCGST += CGST;
//                 //                 TotalSGST += SGST;
//                 //             end else begin
//                 //                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                 //                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                 //                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                 //                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                 //                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                 //                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                 //                 if TaxTransactionValue.FindSet() then
//                 //                     IGSTRATE := TaxTransactionValue.Percent;
//                 //                 IGST := TaxTransactionValue.Amount;
//                 //                 TotalIGST += IGST;
//                 //             end;
//                 //             Total := Total + Purchaseline.Amount;
//                 //         until Purchaseline.Next() = 0;
//                 //     AmounttoVendor := Total + CGST + SGST + IGST;

//                 //     PostedVoucher.InitTextVariable();
//                 //     PostedVoucher.FormatNoText(Amountinwords, Round(AmounttoVendor), "Purchase Header"."Currency Code");
//                 //     AmntinWrds := Amountinwords[1] + Amountinwords[2];
//                 // end;
//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin


//                     PurchaseLine.Reset();
//                     PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
//                     "Purchase Line".SetRange("Document Type", "Purchase Header"."Document Type");
//                     if PurchaseLine.FindSet() then
//                         repeat
//                             TaxRecordId := PurchaseLine.RecordId;
//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             IF TaxtransactionValue.FindSet() then begin
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;

//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;


//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 IF TaxtransactionValue.FindSet() then
//                                     IGSTRate := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;

//                                 TotalIGST += IGST;
//                             end;
//                             Total := Total + PurchaseLine.Amount;
//                         until PurchaseLine.Next() = 0;
//                     AmounttoVendor := Total + CGST + SGST + IGST;

//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(AmounttoVendor), "Purchase Header"."Currency Code");
//                     AmntinWrds := AmountinWords[1] + AmountinWords[2];
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
//         Companyinfo.get();
//     end;



//     var
//         myInt: Integer;
//         Vendor: Record Vendor;
//         CGSTRate: Decimal;

//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         Companyinfo: Record "Company Information";
//         Purchaseline: Record "Purchase Line";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         Amountinwords: array[2] of Text;
//         AmntinWrds: Text;
//         TaxRecordId: RecordId;



//         TaxTotal: Decimal;
//         Total: Decimal;
//         AmounttoVendor: Decimal;
// }