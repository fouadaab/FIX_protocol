from db.mssql_hook import DB as hook
from typing import List, Tuple, Any

class Query():

    def __init__(self):
        self.username = 'trading'
        self.pw='Pictet123'
        self.db = 'FIX'
        self.schema = 'FIX.4.2'  # Collect schema value from FIX messages (simplistic version management)
        self.server = 'localhost'
        self.con = hook(self.server, self.username, self.pw, self.db)

##############  GET ############################
    def get_all(self, table: str) -> List:
        query = f"select * from {self.schema}.{table} for JSON AUTO"
        result = self.con.rowselectFromDB(query)
        return result

##############  INSERT ##########################
    def insert_row(self, table: str, columns: Tuple[str], values: Tuple[Any]) -> None:
        column_string = ''
        for col in columns[:1]:
            column_string += f'"{col}"'
        for col in columns[1:]:
            column_string += f',"{col}"'
        query = f"""insert into [{self.schema}].[{table}] ({column_string}) values {values}"""
        print(query)
        self.con.insertUpdateDB(query)
        return None