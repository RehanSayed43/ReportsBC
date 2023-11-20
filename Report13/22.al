// report 50139 "Sales Cr Memo"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'ZZZZZZZZZZZAA';
//     RDLCLayout = './salescreditmemo123.rdl';

//     dataset
//     {
//         //Posted Sales Credit memo
//         dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Customer_GST_Reg__No_; "Customer GST Reg. No.") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(Companyinfo; Companyinfo."State Code") { }

//             dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
//             {
//                 DataItemLinkReference = "Sales Cr.Memo Header";
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
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(AmntinWrds; AmntinWrds) { }
//                 column(Total; Total) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(GrandTotal; GrandTotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Sales.Reset();
//                     Sales.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
//                     Sales.SetFilter("GST Group Code", '<>%1', '');
//                     if Sales.FindSet() then
//                         repeat
//                             TaxRecordId := Sales.RecordId;

//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             IF TaxtransactionValue.FindSet() then begin
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;
//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;
//                                 TotalCGST += CGST;
//                             end else begin
//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxtransactionValue.FindSet() then
//                                     IGSTRate := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;
//                                 TotalIGST += IGST;

//                             end;
//                             Total := Total + Sales.Amount;
//                             TaxTotal := TotalCGST + TotalSGST + TotalIGST;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until Sales.Next() = 0;


//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Cr.Memo Header"."Currency Code");
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
//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         Sales: Record "Sales Cr.Memo Line";
//         PostedVoucher: Report "Posted Voucher";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
//         TaxRecordId: RecordId;
//         Amount: Decimal;
//         Currency: Code[20];
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
//         TaxTotal: Decimal;
//         GrandTotal: Decimal;


// }