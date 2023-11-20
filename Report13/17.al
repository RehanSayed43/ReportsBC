// report 50131 "Purchase Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'SOOOOOOO';
//     RDLCLayout = './purchaseorderrrr.rdl';

//     dataset
//     {
//         //PURCHASE ORDER REPORT
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Posting_Date; "Posting Date") { }
//             column(States; States) { }
//             column(PostCode; PostCode) { }
//             //  column(AmntinWrds; AmntinWrds) { }


//             column(companyinfoname; companyinfo.Name) { }
//             column(companyinfoAddress; companyinfo.Address) { }
//             column(companyinfoGst; companyinfo."GST Registration No.") { }
//             column(companyinfostate; companyinfo.City) { }
//             column(companyinfoEmail; companyinfo."E-Mail") { }
//             column(companyinfoPhone; companyinfo."Phone No.") { }
//             column(companyinfobankname; companyinfo."Bank Name") { }
//             column(companyinfobankacno; companyinfo."Bank Account No.") { }
//             column(companyinfoiffsccode; companyinfo."Bank Branch No.") { }
//             column(companyinfoswiftcode; companyinfo."SWIFT Code") { }



//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Rate; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(Txatotal; Txatotal) { }
//                 column(GrandTotal; GrandTotal) { }
//                 column(Amtinwrds; Amtinwrds) { }

//                 column(AmountToVendor; AmountToVendor) { }



//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Buy-from Vendor No.");
//                     if customer.Find('-') then begin
//                         States := customer.City;
//                         PostCode := customer."Post Code";
//                         if "Purchase Header"."Currency Code" <> '' then begin
//                             Currency := "Purchase Header"."Currency Code";
//                         end else begin
//                             Currency := 'INR';
//                         end;

//                     end;
//                     //Naveen
//                     ClearData;
//                     // RecRef.OPEN(DATABASE::"Purchase Line");
//                     // RecRef.SetTable(RecPurchaseLine);


//                     RecPurchaseLine.Reset();
//                     RecPurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
//                     RecPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
//                     RecPurchaseLine.SetFilter("GST Group Code", '<>%1', '');
//                     if RecPurchaseLine.FindSet() then
//                         repeat
//                             TaxRecordID := RecPurchaseLine.RecordId();//tk
//                                                                       // PurchaseHeaderRecordID := RecPurchaseLine.RecordId();
//                                                                       //Message('%1', PurchHeaderRecordID);
//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//tk
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxTransactionValue.FindSet() then begin
//                                 //repeat
//                                 //Message('%1  %2  %3', TaxTransval.ID, TaxTransval.Amount, TaxTransval.Percent);
//                                 // IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                                 CGST += TaxTransactionValue.Amount;
//                                 SGST += TaxTransactionValue.Amount;
//                                 //Message('%1--', SGST);
//                                 SGSTtxt := 'SGST';
//                                 CGSTtxt := 'CGST';
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//tk
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST += TaxTransactionValue.Amount;
//                                 IGSTtxt := 'IGST';
//                                 TotalIGST += IGST;
//                                 /* END ELSE
//                                      IF ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
//                                          IGSTRate := TaxTransactionValue.Percent;
//                                          IGST := TaxTransactionValue.Amount;
//                                          IGSTtxt := 'IGST';
//                                          //Message('%1--', IGST);*/
//                             END;
//                             // until TaxTransactionValue.Next() = 0;
//                             //TotalCGST += CGST;
//                             //TotalSGST += SGST;
//                             //TotalIGST += IGST;
//                             Total += RecPurchaseLine.Amount;
//                         //TotalIGST + TotalCGST + TotalSGST;
//                         until RecPurchaseLine.Next() = 0;
//                     AmountToVendor := Total + CGST + SGST + IGST;
//                     //Naveen--
//                     PostedVoucher.InitTextVariable();
//                     "Purchase Header".CalcFields(Amount);
//                     // PostedVoucher.FormatNoText(AmountinWords, Round("Purchase Header".Amount), "Purchase Header"."Currency Code");
//                     PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
//                     Amtinwrds := AmountinWords[1] + AmountinWords[2];
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
//         companyinfo.get();
//     end;



//     var
//         myInt: Integer;
//         customer: Record Vendor;
//         RecPurchaseLine: Record "Purchase Line";
//         sales: Record "Purchase Line";
//         AmountToVendor: Decimal;
//         IGSTtxt: text[10];
//         CGSTtxt: text[10];
//         SGSTtxt: text[10];
//         States: Text[30];
//         PostCode: Code[20];
//         companyinfo: Record "Company Information";
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         Amtinwrds: Text;
//         FractionalAmount: Decimal;
//         AmountinWords: array[2] of Text;
//         // AmntinWrds: Text;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
//         Currency: Code[20];
//         PostedVoucher: Report "Posted Voucher";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         TaxRecordId: RecordId;

//         Txatotal: Decimal;


//     local procedure ClearData()
//     Begin
//         IGSTRate := 0;
//         SGSTRate := 0;
//         CGSTRate := 0;
//         SGSTtxt := '';
//         CGSTtxt := '';
//         TotalCGST := 0;
//         TotalSGST := 0;
//         TotalIGST := 0;
//         CGSTtxt := '';
//         IGSTtxt := '';

//         IGST := 0;
//         CGST := 0;
//         SGST := 0;
//         Clear(AmountinWords);
//         AmountToVendor := 0;

//     End;

// }