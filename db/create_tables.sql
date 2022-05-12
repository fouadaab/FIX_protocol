USE [FIX];
go

-- Drop Tables --

-- Drop first tables that have Foreign Key References
drop table if exists [FIX].[FIX.4.2].[MessageTypeD];
drop table if exists [FIX].[FIX.4.2].[MessageType8];
drop table if exists [FIX].[FIX.4.2].[MessageTypeF];
drop table if exists [FIX].[FIX.4.2].[Transaction];
drop table if exists [FIX].[FIX.4.2].[Order];
drop table if exists [FIX].[FIX.4.2].[Company];
drop table if exists [FIX].[FIX.4.2].[Location];
go

-- Define Tables --

DECLARE @mockloc VARCHAR(20) = 'Location1'

-- FIX.4.2.Location table
create table [FIX].[FIX.4.2].[Location] (
    LocationId VARCHAR(100) NOT NULL,  -- FIX_id=283
    Address VARCHAR(100) DEFAULT NULL,
	PRIMARY KEY (LocationId),
)

-- Mock Insert
INSERT INTO [FIX].[FIX.4.2].[Location] (LocationId, Address) VALUES (@mockloc,'Zurich')

-- FIX.4.2.Company table
create table [FIX].[FIX.4.2].[Company] (
    CompId VARCHAR(100) NOT NULL,  -- FIX_id=49 or FIX_id=56
    LocationId VARCHAR(100) DEFAULT NULL,  -- FIX_id=283
	PRIMARY KEY (CompId),
	CONSTRAINT FK_Company_LocationID
	    FOREIGN KEY (LocationId)
	    REFERENCES [FIX].[FIX.4.2].[Location] (LocationId)
	    ON DELETE CASCADE,
)

-- Mock Insert
INSERT INTO [FIX].[FIX.4.2].[Company] (CompId, LocationId) VALUES ('ABC_DEFG01', @mockloc)
INSERT INTO [FIX].[FIX.4.2].[Company] (CompId, LocationId) VALUES ('CCG', @mockloc)
INSERT INTO [FIX].[FIX.4.2].[Company] (CompId, LocationId) VALUES ('LEH_LZJ02', @mockloc);
go

-- FIX.4.2.Order table
create table [FIX].[FIX.4.2].[Order] (
	SenderCompID VARCHAR(100) NOT NULL,  -- FIX_id=49
	ClOrdId VARCHAR(100) NOT NULL, -- FIX_id=11
	OrderQty INT NOT NULL, -- FIX_id=38
	Side INT NOT NULL, -- FIX_id=54
	Symbol VARCHAR(100) NOT NULL, -- FIX_id=55
	SecurityExchange VARCHAR(10) NOT NULL, -- FIX_id=207	
    
	PRIMARY KEY CLUSTERED (SenderCompID, ClOrdId),
	
	CONSTRAINT FK_Order_SenderID
	    FOREIGN KEY (SenderCompID)
	    REFERENCES [FIX].[FIX.4.2].[Company] (CompId)
	    ON DELETE CASCADE,
);
go

-- FIX.4.2.Transaction table
create table [FIX].[FIX.4.2].[Transaction] (
	SenderCompID VARCHAR(100) NOT NULL,  -- FIX_id=49
	TargetCompID VARCHAR(100) NOT NULL,  -- FIX_id=56
	MsgSeqNum INT NOT NULL,  -- FIX_id=34
	MsgType CHAR NOT NULL,  -- FIX_id=35
	SendingTime datetime NOT NULL,  -- FIX_id=52
	TransactTime datetime DEFAULT NULL, -- FIX_id=60
	ClOrdId VARCHAR(100) NOT NULL, -- FIX_id=11
    	
  	CONSTRAINT PK_Transaction_TransactionID
    	PRIMARY KEY CLUSTERED (SenderCompID, TargetCompID, MsgSeqNum),
	
	CONSTRAINT FK_Transaction_TargetID
	    FOREIGN KEY (TargetCompID)
	    REFERENCES [FIX].[FIX.4.2].[Company] (CompId)
	    ON DELETE NO ACTION,
	
    CONSTRAINT FK_Transaction_OrderID
	    FOREIGN KEY (SenderCompID, ClOrdId)
	    REFERENCES [FIX].[FIX.4.2].[Order] (SenderCompID, ClOrdId)
	    ON DELETE CASCADE,
);
go

-- FIX.4.2.MessageTypeD table
create table [FIX].[FIX.4.2].[MessageTypeD] (
	SenderCompID VARCHAR(100) NOT NULL,  -- FIX_id=49
    TargetCompID VARCHAR(100) NOT NULL,  -- FIX_id=56
    MsgSeqNum INT NOT NULL,  -- FIX_id=34
    TimeInForce INT DEFAULT NULL,  -- FIX_id=59
    OnBehalfOfCompID VARCHAR(100) DEFAULT NULL,  -- FIX_id=115
    CONSTRAINT FK_msgd_id
	    FOREIGN KEY (SenderCompID, TargetCompID, MsgSeqNum)
	    REFERENCES [FIX].[FIX.4.2].[Transaction] (SenderCompID, TargetCompID, MsgSeqNum)
	    ON DELETE CASCADE,
	PRIMARY KEY CLUSTERED (SenderCompID, TargetCompID, MsgSeqNum),
);
go

-- FIX.4.2.MessageType8 table
create table [FIX].[FIX.4.2].[MessageType8] (
	SenderCompID VARCHAR(100) NOT NULL,  -- FIX_id=49
    TargetCompID VARCHAR(100) NOT NULL,  -- FIX_id=56
    MsgSeqNum INT NOT NULL,  -- FIX_id=34
    CumQty INT DEFAULT NULL,  -- FIX_id=14
    OrdStatus CHAR DEFAULT NULL,  -- FIX_id=39
    CONSTRAINT FK_msg8_id
    	FOREIGN KEY (SenderCompID, TargetCompID, MsgSeqNum)
	    REFERENCES [FIX].[FIX.4.2].[Transaction] (SenderCompID, TargetCompID, MsgSeqNum)
	    ON DELETE CASCADE,
    PRIMARY KEY CLUSTERED (SenderCompID, TargetCompID, MsgSeqNum),
);
go

-- FIX.4.2.MessageTypeF table
create table [FIX].[FIX.4.2].[MessageTypeF] (
	SenderCompID VARCHAR(100) NOT NULL,  -- FIX_id=49
    TargetCompID VARCHAR(100) NOT NULL,  -- FIX_id=56
    MsgSeqNum INT NOT NULL,  -- FIX_id=34
    OrderId VARCHAR(100) DEFAULT NULL,  -- FIX_id=37
    ClOrdID VARCHAR(100) DEFAULT NULL,  -- FIX_id=41
    CONSTRAINT FK_msgf_id
    	FOREIGN KEY (SenderCompID, TargetCompID, MsgSeqNum)
	    REFERENCES [FIX].[FIX.4.2].[Transaction] (SenderCompID, TargetCompID, MsgSeqNum)
	    ON DELETE CASCADE,
    PRIMARY KEY CLUSTERED (SenderCompID, TargetCompID, MsgSeqNum),
);
go
