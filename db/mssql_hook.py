import pymssql
from datetime import date, datetime
import decimal
import pandas as pd


class DB(object):

    def __init__(self,server,username,pw,db):
        self.db = self.createDBconnection(server=server,user=username,pw=pw,db=db)

    def json_serial(self, obj):
        if isinstance(obj, (datetime, date)):
            return obj.isoformat()
        elif isinstance(obj, decimal.Decimal):
            return float(obj)

    def createDBconnection(self,server,user,pw,db):
        db = pymssql.connect(server=server,user=user,password=pw,database=db) #server, user, password, database
        return db

    def rowselectFromDB(self,command):
        try:
            data=pd.read_sql_query(command, self.db)
            json_data = list()
            for _,row in data.iterrows():
                json_data.append( eval(row.tolist()[0])[0] )
        except Exception as e:
            print(e)
            json_data = None
        return json_data

    def selectFromDB(self,command):
        try:
            json_data=pd.read_sql_query(command, self.db)
        except Exception as e:
            print(e)
            json_data = None
        return json_data

    def insertUpdateDB(self,commandString, close=True):
        try:
            cursor = self.db.cursor()
            cursor.execute(commandString)
            self.db.commit()
        except Exception as e:
            print(e)

    def closeDBconnection(self) -> None:
        self.db.close()
