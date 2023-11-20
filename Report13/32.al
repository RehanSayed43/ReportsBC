// report 50102 "Purchasee"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption='OOSSEE';
//     RDLCLayout = 'purchaseoooo.rdl';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(TelePhoneno; TelePhoneno) { }
//             column(Pay_to_Contact; "Pay-to Contact") { }
//             column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
//             column(Pay_to_Post_Code; "Pay-to Post Code") { }
//             column(Pay_to_City; "Pay-to City") { }
//             column(Posting_Date; "Posting Date") { }

//             column(CompanyinfoNAME; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(Companyinfostatecode; Companyinfo."State Code") { }
//             column(Companyinfoemail; Companyinfo."E-Mail") { }
//             column(Companyinfopannoo; Companyinfo."P.A.N. No.") { }
//             column(CompanyinfoPhoneno; Companyinfo."Phone No.") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(Companyinfoswiftcode; Companyinfo."SWIFT Code") { }


//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Line_Amount; "Line Amount") { }

//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(Taxtotal; Taxtotal) { }
//                 column(GrandTotal; GrandTotal) { }
//                 column(AmntinWrds; AmntinWrds) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Vendor.Reset();
//                     Vendor.SetRange("No.", "Buy-from Vendor No.");
//                     if Vendor.Find('-') then begin
//                         TelePhoneno := Vendor."Phone No.";

//                     end;
//                     Cleardata();
//                     RecPurchase.Reset();
//                     RecPurchase.SetRange("Document No.", "Purchase Header"."No.");
//                     RecPurchase.SetRange("Document Type", "Purchase Header"."Document Type");
//                     RecPurchase.SetFilter("GST Group Code", '<>%1', '');
//                     if RecPurchase.FindSet() then
//                         repeat
//                             Taxrecordid := RecPurchase.RecordId;

//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Tax Record ID", Taxrecordid);
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxtransactionValue.FindSet() then begin
//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Tax Record ID", Taxrecordid);
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxtransactionValue.FindSet() then
//                                     IGSTRate := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;
//                                 TotalIGST += IGST;
//                             end;
//                             //         Total += RecPurchase.Amount;
//                             //     until RecPurchase.Next() = 0;
//                             // GrandTotal := Total + CGST + SGST + IGST;
//                             Total += RecPurchase.Amount;
//                         until RecPurchase.Next() = 0;
//                     GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                     // until RecPurchase.Next() = 0;

//                     PostedVoucher.InitTextVariable();
//                     "Purchase Header".CalcFields(Amount);
//                     PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), "Purchase Header"."Currency Code");
//                     AmntinWrds := Amountinwords[1] + Amountinwords[2];




//                 end;
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
//         Companyinfo: Record "Company Information";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         RecPurchase: Record "Purchase Line";
//         TelePhoneno: Text[30];
//         Taxrecordid: RecordId;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         Taxtotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
//         Amountinwords: array[2] of Text;
//         AmntinWrds: Text;



//     local procedure Cleardata()
//     var
//         myInt: Integer;
//     begin
//         CGST := 0;
//         SGST := 0;
//         IGST := 0;

//         CGSTRate := 0;
//         SGSTRate := 0;
//         IGSTRate := 0;

//         TotalCGST := 0;
//         TotalSGST := 0;
//         TotalIGST := 0;
//         Clear(Amountinwords);
//         GrandTotal := 0;

//     end;

// }