from twilio.rest import TwilioRestClient
import os
from time import strftime
import argparse

ap = argparse.ArgumentParser()
ap.add_argument("-m", "--message", help = "message to send as a text message",required=True)
ap.add_argument("-t", "--to", help = "number to send the text to", default='+12406788175', required=False)

args = vars(ap.parse_args())

message = args["message"]
to_number = args["to"]

# returns 'None' if the key doesn't exist
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN  = os.environ.get('TWILIO_AUTH_TOKEN')

twilio_number= '+12405586304'
my_number = '+12406788175'

client = TwilioRestClient(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    
client.messages.create(
    to=to_number,
    from_=twilio_number,
    body=message
)
