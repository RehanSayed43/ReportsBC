report 50113 "SalesReport"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout=RDLC;
    RDLCLayout='./rehannsayedd.rdl';
    
    dataset
    {
        //SAMPLE REPORT
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView=sorting("No.");
            RequestFilterFields="No.";
            column(No_;"No."){}
            column(Bill_to_Name;"Bill-to Name"){}
            column(Bill_to_Address;"Bill-to Address"){}
            column(Location_State_Code;"Location State Code"){}
            column(companyinfoname;companyinfo.Name){}
            column(companyinfoaddress;companyinfo.Address){}
            column(companyinfogstno;companyinfo."GST Registration No."){}
            column(companyinfoCity;companyinfo.City){}
            column(companyinfo;companyinfo."State Code"){}
            
            dataitem("Sales Line";"Sales Line"){
                DataItemLinkReference="Sales Header";
                DataItemLink="Document No."=field("No.");
                column(No;"No."){}
                column(Description;Description){}
                column(HSN_SAC_Code;"HSN/SAC Code"){}
                column(Quantity;Quantity){}
                column(Unit_of_Measure_Code;"Unit of Measure Code"){}
                column(Unit_Cost;"Unit Cost"){}
                column(Line_Amount;"Line Amount"){}


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    customer.Reset();
                    customer.SetRange("No.","Sell-to Customer No.");
                    if customer.Find('-') then 
                    begin
                     gstno:=customer."GST Registration No.";

                          
                    end;

                    sales.Reset();
                    sales.SetRange("Document Type","Sales Header"."Document Type");
                    sales.SetFilter("Document No.","Sales Header"."No.");
                    sales.SetFilter("GST Group Code",'<>%1','GST');
                    if sales.FindSet() then
                    repeat
                    TaxRecordId:=sales.RecordId;

                    Taxtransactionvalue.Reset();
                    Taxtransactionvalue.SetRange("Tax Record ID",TaxRecordId);
                    Taxtransactionvalue.SetRange("Value Type",Taxtransactionvalue."Value Type");
                    Taxtransactionvalue.SetFilter("Tax Type",'=%1','');
                    Taxtransactionvalue.SetFilter(Percent,'<>%1',0);
                    Taxtransactionvalue.SetRange("Visible on Interface",true);
                    Taxtransactionvalue.SetFilter("Value ID",'%1|%2',6,2);
                    IF Taxtransactionvalue.FindSet() then
                    begin
                        CGST:=Taxtransactionvalue.Amount;
                        SGST:=Taxtransactionvalue.Amount;

                        CGSTRate:=Taxtransactionvalue.Percent;
                        SGSTRate:=Taxtransactionvalue.Percent;

                         CGST:=TotalCGST;
                         SGST:=TotaLSGST;

                    end;
                    Taxtransactionvalue.Reset();
                    Taxtransactionvalue.SetRange("Tax Record ID",TaxRecordId);
                    Taxtransactionvalue.SetRange("Value Type",Taxtransactionvalue."Value Type");
                    Taxtransactionvalue.SetRange("Value Type",Taxtransactionvalue."Value Type");
                    Taxtransactionvalue.SetFilter("Tax Type",'=%1','');
                    Taxtransactionvalue.SetFilter(Percent,'<>%1',0);
                    Taxtransactionvalue.SetRange("Visible on Interface",true);
                    Taxtransactionvalue.SetFilter("Value ID",'%1',3);

                    IF  Taxtransactionvalue.FindSet() then
                    IGSTRate:=Taxtransactionvalue.Percent;
                    IGST:=Taxtransactionvalue.Amount;
                    TotalIGST:=IGST;
                    TaxTotal+=TotalCGST+TotaLSGST+TotalIGST;
                    Total:=sales.Amount;
                    until sales.Next()=0;
                    GrandTotal+=Total+TaxTotal;
                    PostedVoucher.InitTextVariable();
                    PostedVoucher.FormatNoText(AmountinWords,GrandTotal,"Sales Header"."Currency Code");
                    Amountinwrds:=AmountinWords[1]+AmountinWords[2];
                    
                end;
            }
        }
    }
    
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    
                }
            }
        }
    
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    
                }
            }
        }
    }
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        companyinfo.get();
    end;
    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        sales.get();
    end;
    
    
    
    var
        myInt: Integer;
        gstno:Code[20];
        customer:Record Customer;
        sales:Record "Sales Line";
        companyinfo:Record "Company Information";
        Taxtransactionvalue:Record "Tax Transaction Value";
        PostedVoucher:Report "Posted Voucher";
        TaxRecordId:RecordId;
        Amount:Decimal;
        WholeAmount:Decimal;
        FractionalAmount:Decimal;
        CGST:Decimal;
        SGST:Decimal;
        IGST:Decimal;
        CGSTRate:Decimal;
        SGSTRate:Decimal;
        IGSTRate:Decimal;
        TotalCGST:Decimal;
        TotaLSGST:Decimal;
        TotalIGST:Decimal;
        TaxTotal:Decimal;
        AmountinWords:array [2] of Text;
        Amountinwrds:Text;
        Total:Decimal;
        GrandTotal:Decimal;
        
          
}