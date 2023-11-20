// report 50149 "PURCHASE REPORTssssss"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './rehannn.rdl';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Companyinfoname;Companyinfo.Name){}
//             column(Companyinfoaddress;Companyinfo.Address){}
//             column(Companyinfogst;Companyinfo."GST Registration No."){}
//             column(Companyinfostatecode;Companyinfo."State Code"){}

//             dataitem("Purchase Line";"Purchase Line"){
//                 column(No;"No."){}
//                 column(Description;Description){}
//                 column(Quantity;Quantity){}
//                 column(HSN_SAC_Code;"HSN/SAC Code"){}
//                 column(CGST;CGST){}
//                 column(SGST;SGST){}
//                 column(IGST;IGST){}
//                 column(CGSTRate;CGSTRate){}
//                 column(SGSTRate;SGSTRate){}
//                 column(IGSTRate;IGSTRate){}
//                 column(Taxtotal;Taxtotal){}
//                 column(Amntinwrds;Amntinwrds){}
//                 column(AmountToVendors;AmountToVendors){}

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
//         vendor: Record Vendor;
//         Companyinfo:Record "Company Information";
//         Taxtransaxtionvalue: record "Tax Transaction Value";
//         Taxrecordid: Recordid;
//         Postedvoucher: Report "Posted Voucher";
//         Amount: decimal;
//         WholeAmount: decimal;
//         FractionalAmount: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: decimal;
//         IGSTRate: Decimal;

//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         ToatlIGST: Decimal;
//         AmountinWords:array[2] of Text;
//         Amntinwrds:Text;

//         Taxtotal: Decimal;
//         AmountToVendors: Decimal;


// }