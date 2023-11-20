// report 50119 "Posted Sales Invoices"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './postedsaleinvoice.rdl';

//     dataset
//     {
//         dataitem("Sales Invoice Header"; "Sales Invoice Header")
//         {
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddres; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoStateCode; Companyinfo."State Code") { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(gstno; gstno) { }
//             column(Statet; Statet) { }
//             column(CompanyinfoBankname; Companyinfo."Bank Name") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(Companyinfoswiftcode; Companyinfo."SWIFT Code") { }
//             column(Companyinfopanno; Companyinfo."P.A.N. No.") { }

//             dataitem("Sales Invoice Line"; "Sales Invoice Line")
//             {
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(AmntinWrds; AmntinWrds) { }
//                 column(Taxtotal; Taxtotal) { }
//                 column(Total; Total) { }
//                 column(GrandTotal; GrandTotal) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         gstno := customer."GST Registration No.";
//                         Statet := customer.City;
//                     end;
//                     ClearData();
//                     sales.Reset();
//                     sales.SetRange("Document No.", "Sales Invoice Header"."No.");
//                     sales.SetFilter("GST Group Code", '<>%1', '');
//                     if sales.FindSet() then
//                         repeat
//                             TaxRecordId := sales.RecordId;

//                             Taxtransactionvalue.Reset();
//                             Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordId);
//                             Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                             Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                             Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                             Taxtransactionvalue.SetRange("Visible on Interface", true);
//                             Taxtransactionvalue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             IF Taxtransactionvalue.FindSet() then begin
//                                 CGSTRate := Taxtransactionvalue.Percent;
//                                 SGSTRate := Taxtransactionvalue.Percent;
//                                 CGST := Taxtransactionvalue.Amount;
//                                 SGST := Taxtransactionvalue.Amount;
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 Taxtransactionvalue.Reset();
//                                 Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordId);
//                                 Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                                 Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                                 Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                                 Taxtransactionvalue.SetRange("Visible on Interface", true);
//                                 Taxtransactionvalue.SetFilter("Value ID", '%1', 3);
//                                 IF Taxtransactionvalue.FindSet() then
//                                     IGSTRate := Taxtransactionvalue.Percent;
//                                 IGST := Taxtransactionvalue.Amount;
//                                 TotalIGST += IGST;
//                             end;
//                             Total := Total + sales.Amount;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until sales.Next() = 0;

//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Invoice Header"."Currency Code");
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
//         gstno: Code[20];
//         currency: Code[20];
//         Statet: Text[30];
//         TaxRecordId: RecordId;
//         Taxtransactionvalue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         sales: Record "Sales Invoice Line";

//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
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


//     local procedure ClearData()
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

//     end;

// }