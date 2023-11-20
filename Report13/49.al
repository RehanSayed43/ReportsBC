// report 50119 "Sales Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'salesorder1289.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoCodess; Companyinfo."State Code") { }

//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftcode; Companyinfo."SWIFT Code") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }

//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
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
//                 column(TaxTotal; TaxTotal) { }
//                 column(Total; Total) { }
//                 column(GrandTotal; GrandTotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         Gstno := customer."GST Registration No.";
//                     end;
//                     Saleslines.Reset();
//                     Saleslines.SetRange("Document No.", "Sales Header"."No.");
//                     Saleslines.SetRange("Document Type", "Sales Header"."Document Type");
//                     Saleslines.SetFilter("GST Group Code", '<>%1', '');
//                     if Saleslines.FindSet() then
//                         repeat
//                             Taxrecordid := Saleslines.RecordId;


//                             TaxtransactionValue.Reset();
//                             ;
//                             TaxtransactionValue.SetRange("Tax Record ID", Taxrecordid);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxtransactionValue.FindSet() then begin
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;

//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;

//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin

//                                 TaxtransactionValue.Reset();
//                                 ;
//                                 TaxtransactionValue.SetRange("Tax Record ID", Taxrecordid);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxtransactionValue.FindSet() then
//                                     IGSTRate := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;

//                                 TotalIGST += IGST;
//                             end;
//                             Total += Total + Saleslines.Amount;
//                             GrandTotal := Total;
//                         until Saleslines.Next() = 0;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
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



//     var
//         myInt: Integer;
//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         Saleslines: Record "Sales Line";
//         Taxrecordid: RecordId;
//         Gstno: Code[20];

//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         Amount: Decimal;
//         FractionalAmount: Decimal;
//         WholeAmount: Decimal;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
// }