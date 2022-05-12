import enum

class EnumBase(str, enum.Enum):
    pass
    def __str__(self):
        return self.value

class TableNames(EnumBase):
    LOCATION = 'Location'
    COMPANY = 'Company'
    ORDER = 'Order'
    TRANSACTION = 'Transaction'
    MESSAGETYPE8 = 'MessageType8'
    MESSAGETYPED = 'MessageTypeD'
    MESSAGETYPEF = 'MessageTypeF'

order_columns_mapper = {
	49: 'SenderCompID',
	11: 'ClOrdId',
	38: 'OrderQty',
	54: 'Side',
	55: 'Symbol',
	207: 'SecurityExchange',
}

transaction_columns_mapper = {
	49: 'SenderCompID',
    56: 'TargetCompId',
    34: 'MsgSeQnum',
    35: 'MsgType',
    52: 'SendingTime',
    # 60: 'TransactTime',
    11: 'ClOrdId',
}

messagetyped_columns_mapper = {
    49: 'SenderCompID',
    56: 'TargetCompID',
    34: 'MsgSeqNum',
    59: 'TimeInForce',
    115: 'OnBehalfOfCompID',
}

messagetype8_columns_mapper = {
    49: 'SenderCompID',
    56: 'TargetCompID',
    34: 'MsgSeqNum',
    14: 'CumQty',
    39: 'OrdStatus',
}

messagetypef_columns_mapper = {
    49: 'SenderCompID',
    56: 'TargetCompID',
    34: 'MsgSeqNum',
    37: 'OrderId',
    41: 'ClOrdID',
}