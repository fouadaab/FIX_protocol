import re
from query import Query
import helper

"""
TODO:
Add check on corrupt/good message (bit lengths of attributes n°9/10, process w/ regex?)
Only insert in draft, add upsert, bulk insert
Logger for failed messages -> Store in FS for DEV
Set up job to automate run (Airflow DAG, CRON,.. ?)
"""

re_clean_log = lambda x: re.sub(r"(^.*) (8=FIX.*)", r"\2", x)
re_clean_date = lambda x: re.sub(r"(\d{8})(-)(\d{2}:\d{2}:\d{2})", r"\1 \3", x)
re_msg_type = lambda x: re.sub(r"(.*\|35=)(\w)(.*)", r"\2", x)

if __name__ == "__main__":
    with open('FIX_logs.txt') as f:
        lines = f.readlines() # list containing lines of file
        query = Query()

        for line in lines:
            fields = re_clean_log(line)
            fields = re_clean_date(line)
            msg_type = re_msg_type(line)
            current = dict()

            sub_fields = fields.split('|')
            for split in sub_fields:
                if '=' not in split:
                    continue
                col,val = split.split('=')
                current[col] = val
            
            query.insert_row(
                table=helper.TableNames.ORDER,
                columns=tuple(helper.order_columns_mapper.values()),
                values=(current['49'], current['11'], current['38'], current['54'], current['55'], current['207']),
            )

            query.insert_row(
                table=helper.TableNames.TRANSACTION,
                columns=tuple(helper.transaction_columns_mapper.values()),
                values=(current['49'], current['56'], current['34'], current['35'], current['52'], current['11']),
            )

            if 'D' in msg_type:
                query.insert_row(
                    table=helper.TableNames.MESSAGETYPED,
                    columns=tuple(helper.messagetyped_columns_mapper.values()),
                    values=(current['49'], current['56'], current['34'], current['59'], current['115']),
                )

            elif '8' in msg_type:
                query.insert_row(
                    table=helper.TableNames.MESSAGETYPE8,
                    columns=tuple(helper.messagetype8_columns_mapper.values()),
                    values=(current['49'], current['56'], current['34'], current['14'], current['39']),
                )

            elif 'F' in msg_type:
                query.insert_row(
                    table=helper.TableNames.MESSAGETYPEF,
                    columns=tuple(helper.messagetypef_columns_mapper.values()),
                    values=(current['49'], current['56'], current['34'], current['37'], current['41']),
                )