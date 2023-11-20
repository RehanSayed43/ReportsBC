// report 50129 "Posted Purchase Invoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'Caaaaaaa';
//     RDLCLayout = './ccitttt.rdl';


//     dataset
//     {
//         dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.", "Buy-from Vendor No.";
//             RequestFilterHeading = 'Posted purchase Invoice';
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Pay_to_City; "Pay-to City") { }
//             column(Pay_to_Contact; "Pay-to Contact") { }

//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Posting_Date; "Posting Date") { }


//             column(companyName; company.Name) { }
//             column(companyAddress; company.Address) { }
//             column(companyGstno; company."GST Registration No.") { }
//             column(companyCity; company.City) { }
//             column(companyStateCode; company."State Code") { }



//             column(AmountinWrds; AmountinWrds) { }


//             dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
//             {
//                 // DataItemLinkReference = "Purch. Inv. Header";
//                 DataItemTableView = sorting("Document No.", "Line No.");
//                 DataItemLinkReference = "Purch. Inv. Header";
//                 //DataItemLink = do==
//                 //RequestFilterFields = "No.","Buy-from Vendor No.";
//                 // RequestFilterHeading = 'Posted purchase Invoice';
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Per; "Unit of Measure Code") { }
//                 column(Direct_Unit_Cost; "Direct Unit Cost") { }
//                 // column(Unit_Price__LCY_; "Unit Price (LCY)") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(CGST; CGST) { }
//                 column(IGST; IGST) { }
//                 column(SGST; SGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(Total; Total) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(GrandTotal; GrandTotal) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Buy-from Vendor No.");
//                     if customer.Find('-') then begin
//                         Panno := customer."P.A.N. No.";
//                     end;



//                     clearMydata();
//                     sales.Reset();
//                     sales.SetRange("Document No.", "Purch. Inv. Header"."No.");
//                     sales.SetFilter("GST Group Code", '<>%1', '');
//                     if sales.FindSet() then
//                         repeat
//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;

//                             end

//                             else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;

//                             end;


//                             Total += sales.Amount;
//                         until TaxTransactionValue.Next() = 0;
//                     GrandTotal := Total + CGST + SGST + IGST;
//                     PostedVoucher.InitTextVariable();
//                     "Purch. Inv. Header".CalcFields(Amount);
//                     PostedVoucher.FormatNoText(Amountinwords, Round(AmountinVendors), "Purch. Inv. Header"."Currency Code");
//                     AmountinWrds := Amountinwords[1] + Amountinwords[2];





//                     // sales.SetRange("Document No.", "Purch. Inv. Header"."No.");
//                     // if sales.FindSet() then
//                     //     repeat
//                     //         Total += sales.Amount;
//                     //     until sales.Next() = 0;
//                     // Total += sales.Amount;
//                     // AmountinVendors := Total;
//                     // PostedVoucher.InitTextVariable();
//                     // "Purch. Inv. Header".CalcFields(Amount);
//                     // PostedVoucher.FormatNoText(Amountinwords, Round(AmountinVendors), "Purch. Inv. Header"."Currency Code");
//                     // AmountinWrds := Amountinwords[1] + Amountinwords[2];



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
//         customer: Record Vendor;
//         company: Record "Company Information";
//         sales: Record "Purch. Inv. Line";
//         PostedVoucher: Report "Posted Voucher";


//         AmountinVendors: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         Amount: Decimal;
//         TaxRecordId: RecordId;
//         WholeAmount: Decimal;
//         Panno: Code[20];
//         FractionalAmount: Decimal;
//         TaxTransactionValue: Record "Tax Transaction Value";
//         AmountinWrds: Text;
//         Amountinwords: array[2] of Text;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         TaxTotal: Decimal;
//         GrandTotal: Decimal;
//         Total: Decimal;

//     local procedure clearMydata()

//     begin
//         CGST := 0;
//         IGST := 0;
//         SGST := 0;

//         CGSTRate := 0;
//         IGSTRate := 0;
//         SGSTRate := 0;

//         TotalCGST := 0;
//         TotalSGST := 0;
//         TotalIGST := 0;


//     end;


// }