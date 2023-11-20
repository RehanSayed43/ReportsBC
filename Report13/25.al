// report 50140 "SALES REPORTSSSSSS"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './salesorder4s.rdl';

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
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(Companyinfo; Companyinfo."Location Code") { }

//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(totalIGST; totalIGST) { }
//                 column(TotaLSGST; TotaLSGST) { }
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

//                     sales.Reset();
//                     sales.SetRange("Document No.", "Sales Header"."No.");
//                     sales.SetRange("Document Type", "Sales Header"."Document Type");
//                     sales.SetFilter("GST Group Code", '<>%1', '');
//                     if sales.FindSet() then
//                         repeat
//                             TaxRecordId := sales.RecordId;

//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxtransactionValue.FindSet() then begin
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;
//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;
//                                 TotaLSGST := SGST;

//                                 TotalCGST += CGST;

//                             end else begin
//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);

//                             end;
//                             Total := Total + sales.Amount;
//                         until sales.Next() = 0;
//                     Taxtotal += TotalCGST + TotaLSGST + totalIGST;
//                     GrandTotal := Total + Taxtotal;


//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWord, Round(GrandTotal), "Sales Header"."Currency Code");
//                     Amntinwrds := AmountinWord[1] + AmountinWord[2];






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
//         PostedVoucher: Report "Posted Voucher";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         AmountinWord: array[2] of text;
//         Amntinwrds: Text;
//         sales: Record "Sales Line";
//         TaxRecordId: RecordId;
//         Currency: Code[20];
//         Gstno: Code[20];
//         Amount: Decimal;
//         GrandAmount: Decimal;
//         Fractionalmaount: Decimal;
//         CGST: Decimal;
//         SGST: DecimaL;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotaLSGST: Decimal;
//         totalIGST: Decimal;
//         Taxtotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;

// }